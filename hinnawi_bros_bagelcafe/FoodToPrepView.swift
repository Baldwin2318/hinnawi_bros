import SwiftUI

/*________________________________________ Main Tab__________________________________________*/
struct FoodToPrepView: View {
    @State private var showingSavePDFAlert = false
    @State private var showingResetPDFAlert = false
    @State private var selectedInventory = 0
    
    @State private var animateLeftChevron = false
    @State private var animateRightChevron = false
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    
    @EnvironmentObject var viewModel_FTP: FoodToPrepViewModel // Use EnvironmentObject
    
    // Assuming 'days' array is static, define it here. Adjust as needed.
    let days = ["Preps For Monday", "Preps For Tuesday", "Preps For Wednesday",
                "Preps For Thursday", "Preps For Friday", "Preps For Saturday", "Preps For Sunday"]

    let inv_type = ["For Monday","For Tuesday","For Wednesday","For Thursday","For Friday","For Saturday","For Sunday" /*add as you wish*/]
    
    // Define the items
    let items = [
        "Bacon", "Eggs", "Veggie patty", "Chicken", "Tofu", "Smoked Meat", "Turkey", "Salmon", "Mix Vege",
        "Onions", "Cucumber", "Pepper", "Tomatoes", "Lettuce", "Cream Cheese", "Butter",
        "Bacon Jam", "Potatoes", "Mayo", "Spicy Mayo", "Dijon Mustard", "Honey Mustard",
        "Canola Oil", "Lemon Squeezed in a Bottle", "Hinnawi Cream Cheese", "Olive Oil"
    ]
    
    var body: some View {
         VStack {
             Text("*** THIS FEATURE IS UNDER DEVELOPMENT.        -Baldwin ***")
                 .foregroundColor(.red)
                 .italic()
             controlButtons
             contentTabs
         
         }
        
     }
    
    private var controlButtons: some View {
        HStack {
            Button(action: {

                saveAsPDF()
            }) {
                Text("Save")
                    .frame(width: 90, height: 50)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    .alert(isPresented: $showingSavePDFAlert) {
                        Alert(title: Text("Saved"), message: Text("Images saved to Photos"), dismissButton: .default(Text("OK")))
                    }
            }
            Button(action: {
                // This will only show the alert for confirmation
                showingResetPDFAlert = true
            }) {
                Text("Clear")
                    .frame(width: 90, height: 50)
                    .foregroundColor(.white)
                    .background(Color.orange.opacity(0.8))
                    .cornerRadius(10)
            }
            .alert(isPresented: $showingResetPDFAlert) {
                Alert(
                    title: Text("Clear All Data"),
                    message: Text("This will remove all inputs and cannot be undone. Are you sure you want to clear the data?"),
                    primaryButton: .destructive(Text("Yes")) {
                        viewModel_FTP.resetValues() // Reset the data on confirmation
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
            Spacer()
            Text("Preparation List").bold()
                .foregroundColor(.blue)
                .font(.system(size: 30, weight: .heavy)) // Customize font size and weight
//                            TabView(selection: $selectedInventory) {
//                                ForEach(0..<inv_type.count) { index in
//                                    Text(self.inv_type[index])
//                                        .frame(width: 200, height: 50) // Specify the frame for content, not the tab itself
//                                        .tag(index)
//                                }
//                            }
//                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                            .frame(width: 240, height: 50)
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(10)
//                            .font(.headline)
            Spacer()
            Button("X") {
                
                self.presentationMode.wrappedValue.dismiss()
            }
            .frame(width: 60, height: 60)
            .font(.system(size: 50))
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(20)
            .accessibilityLabel("Exit Inventory Grid View")
            
        }
        .padding() // Add horizontal padding to the HStack, not the button
    }
    // Tab view for FoodToPrepTab and PastriesInvTab
    private var contentTabs: some View {
        TabView(selection: $selectedInventory) {
            FoodToPrepTab()
                    .tag(0) // Corresponds to "FOOD INVENTORY"
                    .tabItem {
                        Text(inv_type[0])
                    }
            }
        .environmentObject(viewModel_FTP)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Makes the TabView swipeable
        .animation(.default, value: selectedInventory)
                   .gesture(
                       DragGesture().onEnded { gesture in
                           // Determine swipe direction
                           if gesture.translation.width < 0 && selectedInventory < inv_type.count - 1 {
                               // Swiped left, go to next view
                               selectedInventory += 1
                           } else if gesture.translation.width > 0 && selectedInventory > 0 {
                               // Swiped right, go to previous view
                               selectedInventory -= 1
                           }
                       }
                   )
    }
            func saveAsPDF() {
                let pdfData = generatePDFData()
                
                // Convert PDF data to UIImage
                if let images = pdfDataToImages(pdfData: pdfData) {
                    for image in images {
                        // Save each image to the Photos app
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                    
                    // Show an alert or some UI to indicate success
                    showingSavePDFAlert = true
                }
            }
            func generatePDFData() -> Data {
                let pageWidth: CGFloat = 612
                let pageHeight: CGFloat = 792
                let margin: CGFloat = 50
                let contentWidth = pageWidth - (margin * 2)
                let rowHeight: CGFloat = 20
                let columnWidths = [contentWidth * 0.4, contentWidth * 0.2, contentWidth * 0.2, contentWidth * 0.2]
                let headers = ["Item", "To Prep", "To Bring Upstairs"]
                let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
                
                let data = pdfRenderer.pdfData { context in
                    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
                    let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
                    
                    // Start drawing bagel inventory data after inventory data
                           context.beginPage() // Optionally start a new page for clarity
                           
                    var yPosition: CGFloat = margin

                    var xPosition = margin

                   
                    for (index, header) in headers.enumerated() {
                        let columnRect = CGRect(x: xPosition, y: yPosition, width: columnWidths[index], height: rowHeight)
                        header.draw(in: columnRect, withAttributes: headerAttributes)
                        xPosition += columnWidths[index]
                    }
                    yPosition += rowHeight
                    
                    // Draw the line below headers
                    context.cgContext.move(to: CGPoint(x: margin, y: yPosition))
                    context.cgContext.addLine(to: CGPoint(x: pageWidth - margin, y: yPosition))
                    context.cgContext.strokePath()
                    
                    // Draw Table Rows
                    for itemName in items { // Assuming items is an array of item names
                        let itemCount = viewModel_FTP.itemCounts[itemName, default: 0]
                        let datesString = viewModel_FTP.formattedDatesString(for: itemName)
                        let dateLines = datesString.split(separator: "\n").count
                        let currentRowHeight = max(rowHeight, CGFloat(dateLines) * rowHeight)
                        
                        // Setup for drawing multiline text
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = .left
                        paragraphStyle.minimumLineHeight = rowHeight
                        paragraphStyle.maximumLineHeight = rowHeight
                        
                        let drawingAttributes: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 12),
                            .paragraphStyle: paragraphStyle
                        ]
                        
                        xPosition = margin
                        
                        let formattedItemCount = itemCount.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(itemCount))" : String(format: "%.1f", itemCount)
                        
                        let contents = [
                            itemName,
                            formattedItemCount,
                            datesString.isEmpty ? "   0" : datesString
                        ]
                        
                        for (index, content) in contents.enumerated() {
                            //drawLineVertical(from: CGPoint(x: 240, y: 50), to: CGPoint(x: 240, y: yPosition+30))
                            let columnRect = CGRect(x: xPosition, y: yPosition, width: columnWidths[index], height: currentRowHeight)
                            if index == 2 { // The dates column
                                // Draw multiline dates
                                content.draw(with: columnRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: drawingAttributes, context: nil)
                            } else {
                                // For other columns, vertically center the text in the cell
                                let textSize = content.size(withAttributes: drawingAttributes)
                                let textRect = CGRect(x: xPosition, y: yPosition + (currentRowHeight - textSize.height) / 2, width: columnWidths[index], height: textSize.height)
                                content.draw(in: textRect, withAttributes: drawingAttributes)
                            }
                            xPosition += columnWidths[index]
                        }
                        if yPosition + currentRowHeight > pageHeight - margin { // Check if new page is needed
                            context.beginPage() // Start a new page
                            yPosition = margin // Reset y position to top of the new page
                        }
                        
                        yPosition += currentRowHeight
                        // Draw a horizontal line after the row
                        context.cgContext.move(to: CGPoint(x: margin, y: yPosition))
                        context.cgContext.addLine(to: CGPoint(x: pageWidth - margin, y: yPosition))
                        context.cgContext.strokePath()
                    }
             
                    
                }
                
                return data
            }
            
            func pdfDataToImages(pdfData: Data) -> [UIImage]? {
                guard let provider = CGDataProvider(data: pdfData as CFData),
                      let pdfDocument = CGPDFDocument(provider) else {
                    return nil
                }
                
                var images = [UIImage]()
                for pageNumber in 1...pdfDocument.numberOfPages {
                    guard let page = pdfDocument.page(at: pageNumber) else { continue }
                    let pageRect = page.getBoxRect(.mediaBox)
                    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
                    let image = renderer.image { context in
                        context.cgContext.saveGState()
                        context.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                        context.cgContext.scaleBy(x: 1.0, y: -1.0)
                        context.cgContext.drawPDFPage(page)
                        context.cgContext.restoreGState()
                    }
                    images.append(image)
                }
                
                return images
            }
            
            func drawLineVertical(from startPoint: CGPoint, to endPoint: CGPoint) {
                let path = UIBezierPath()
                path.move(to: startPoint)
                path.addLine(to: endPoint)
                path.stroke()
            }
}

struct FoodToPrepTab: View {
    @EnvironmentObject var viewModel_FTP: FoodToPrepViewModel
    
    var body: some View {
        // Your FoodToPrepGridView here
        FoodToPrepGridView()
            .environmentObject(viewModel_FTP) // Make sure to pass the ViewModel
    }
}
/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Main Tab ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/


/****************************************************     FOOD INVENTORY      *******************************************************************/
struct SwipeGestureDemonstrationUpDown_FTP: View {
    @Binding var selectedItem: String
    var items: [String]
    @State private var isAnimating: Bool = false

    var body: some View {
        ZStack() { // Adjusted for vertical spacing

            // Next Item Button (Now Down)
            Button(action: moveToNextItem) {
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 20, height: 5)
                    .foregroundColor(.black)
                    .offset(y: isAnimating ? -30 : -40) // Adjusted for vertical animation
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }

    private func moveToPreviousItem() {

    }

    private func moveToNextItem() {

    }
}

struct SwipeGestureDemonstration_FTP: View {
    @Binding var selectedItem: String
    var items: [String]
    @State private var isAnimating: Bool = false

    var body: some View {
        
        HStack(spacing: 500) { // Use spacing to add space between buttons if needed
            // Previous Item Button
            Button(action: moveToPreviousItem) {
                Image(systemName: "arrow.left.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray.opacity(0.5))
                    .offset(x:isAnimating ? 5 : -5, y: 0)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
            }

            // Next Item Button
            Button(action: moveToNextItem) {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray.opacity(0.5))
                    .offset(x: isAnimating ? 5 : -5, y: 0)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
        .padding(.horizontal, 20) // Add some padding to ensure the buttons don't touch the screen edges
        .position(x:350, y: 150)
    }

    private func moveToPreviousItem() {
        if let currentIndex = items.firstIndex(of: selectedItem), currentIndex > 0 {
            selectedItem = items[currentIndex - 1]
        }
    }

    private func moveToNextItem() {
        if let currentIndex = items.firstIndex(of: selectedItem), currentIndex < items.count - 1 {
            selectedItem = items[currentIndex + 1]
        }
    }
}


struct CustomStepper_FTP: View {
    @Binding var value: Double // Changed to Double to support fractional values
    var range: ClosedRange<Double> // Changed to Double range
    var onValueChanged: (Double) -> Void // Adjusted to Double

    var body: some View {
        HStack {
            // Decrement by 1/2 Button
            Button(action: {
                if value > range.lowerBound {
                    value -= 0.5
                    onValueChanged(value)
                }
            }) {
                Text("- 1/2")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(50)
            }
            
            // Decrement Button
            Button(action: {
                if value > range.lowerBound {
                    value -= 1
                    onValueChanged(value)
                }
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .frame(width: 90, height: 90)
                    .background(Color.red)
                    .cornerRadius(50)
            }

            // Value Display
            Text(value.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(value))" : String(format: "%.1f", value))
                .font(.system(size: 40))
                .foregroundColor(.black)
                .frame(width: 80, alignment: .center)

            // Increment Button
            Button(action: {
                if value < range.upperBound {
                    value += 1
                    onValueChanged(value)
                }
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .frame(width: 90, height: 90)
                    .background(Color.green)
                    .cornerRadius(50)
            }
            
            // Increment by 1/2 Button
            Button(action: {
                if value < range.upperBound {
                    value += 0.5
                    onValueChanged(value)
                }
            }) {
                Text("+ 1/2")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(50)
            }
        }.environment(\.colorScheme, .light)
    }
}


struct FoodToPrepGridView: View {
    // Define the column headers
    let headers = ["Item", "To Prep", "To Bring Upstairs"]
    
    // Define the items
    let items = [
        "Bacon", "Eggs", "Veggie patty", "Chicken", "Tofu", "Smoked Meat", "Turkey", "Salmon", "Mix Vege",
        "Onions", "Cucumber", "Pepper", "Tomatoes", "Lettuce", "Cream Cheese", "Butter",
        "Bacon Jam", "Potatoes", "Mayo", "Spicy Mayo", "Dijon Mustard", "Honey Mustard",
        "Canola Oil", "Lemon Squeezed in a Bottle", "Hinnawi Cream Cheese", "Olive Oil"
    ]
    
    // Define the columns
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    @State private var value: Int = 0
    @State private var itemCounts: [String: Int] = [:] // Track item counts
    @State private var selectedItem: String = "" // Track selected item
    @EnvironmentObject var viewModel_FTP: FoodToPrepViewModel // Use EnvironmentObject
    
    @State private var showingDatePickers = false
    @State private var selectedDates: [Date] = []
    @State private var generatedImage: UIImage? // To hold the generated image
    @State private var selectedDatesByItem: [String: Date] = [:]

    @State private var selectedImageIndex: Int = 0 // Track the index of the selected image

    @State private var showingSavePDFAlert = false
    @State private var showingResetPDFAlert = false
    @State private var tappedItem: String? = nil
    @State private var tappedItem2: String? = nil
    
    @Environment(\.presentationMode) var presentationMode
    
    let days = ["Preps For Monday", "Preps For Tuesday", "Preps For Wednesday", "Preps For Thursday", "Preps For Friday", "Preps For Saturday", "Preps For Sunday"]
    @State private var selectedDay = 0
    
    let lineHeight: CGFloat = 20.0 // Height for each date line
    let padding: CGFloat = 20.0 // Padding above and below the text

    init() {
        _selectedItem = State(initialValue: items.first ?? "") // Initialize with the first item
    }
    
    let images = [
        "Bacon", "Eggs", "Veggie patty", "Chicken", "Tofu", "Smoked Meat", "Turkey", "Salmon", "Mix Vege",
        "Onions", "Cucumber", "Pepper", "Tomatoes", "Lettuce", "Cream Cheese", "Butter",
        "Bacon Jam", "Potatoes", "Mayo", "Spicy Mayo", "Dijon Mustard", "Honey Mustard",
        "Canola Oil", "Lemon Squeezed in a Bottle", "Hinnawi Cream Cheese", "Olive Oil"
    ]
    var body: some View {
        VStack {

            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        // Create header row
                        ForEach(headers, id: \.self) { header in
                            Text(header)
                                .font(.headline)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                .background(Color.gray)
                                .foregroundColor(.white)
                        }
                        
                        // Create rows for items
                        ForEach(items, id: \.self) { item in
                            let rowHeight = calculateRowHeight(for: item)
                            
                            Text(item)
                                .id(item)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: rowHeight)
                                .background(item == selectedItem ? Color.green : Color.gray.opacity(0.3)) // Conditional background color
                                .foregroundColor(item == selectedItem ? Color.white : Color.white) // Conditional foreground color
                                .cornerRadius(10)
                                .scaleEffect(tappedItem == item ? 1.1 : 1.0) // Scale up the text if it is the tapped item
                                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: tappedItem) // Animate the scaling effect
                                .onTapGesture {
                                    tappedItem = item // Set the tapped item
                                    selectedItem = item
                                    // Reset the tapped item after a delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        tappedItem = nil
                                    }
                                }
                            Text(viewModel_FTP.itemCounts[item, default: 0].truncatingRemainder(dividingBy: 1) == 0 ?
                                 "\(Int(viewModel_FTP.itemCounts[item, default: 0]))" :
                                    String(format: "%.1f", viewModel_FTP.itemCounts[item, default: 0]))
                            
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: rowHeight)
                            .background(Color .green.opacity(0.1))
                                  .foregroundColor(.black)
                            Button(action: {
                                // Check if dates are already available, if not, initialize them
                                if let existingDates = viewModel_FTP.itemDates[item], existingDates.count == Int(viewModel_FTP.itemCounts[item, default: 0]) {
                                    self.selectedDates = existingDates
                                } else {
                                    self.selectedDates = Array(repeating: Date(), count: Int(viewModel_FTP.itemCounts[item, default: 0]))
                                }
                                self.selectedItem = item  // Set the selected item
                                self.showingDatePickers = true
                            }) {
                                // This Text will be the content of the Button
                                if viewModel_FTP.itemCounts[item, default: 0] > 0 {
                                    Text(viewModel_FTP.formattedDatesString(for: item))
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                } else {
                                    Text("0")
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .background(Color.blue.opacity(0.1))
                                }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: rowHeight)
                            
                            .disabled(viewModel_FTP.itemCounts[item, default: 0] == 0) // Disable the button if itemCount is 0
                            .background(Color .white)
                        }
                    }
                    .padding()
                    .background(Color .gray.opacity(0.1))
                }
                .onChange(of: selectedItem) { _ in
                                    // Check if the selected item is not visible, then scroll to it
                                    withAnimation {
                                        scrollViewProxy.scrollTo(selectedItem, anchor: .center)
                                    }
                                }
            }.frame(height: 500, alignment: .topLeading).environment(\.colorScheme, .light)
            VStack {
                  //  .frame(height: 50) // Adjust the frame as needed

            }.environment(\.colorScheme, .light)
            VStack {
                Text("Number of Container to Prep")
                    .foregroundColor(.blue)
                    .bold()
                CustomStepper_FTP(value: Binding<Double>(
                    get: {
                        // Convert the itemCount to Double
                        Double(self.viewModel_FTP.itemCounts[self.selectedItem, default: 0])
                    },
                    set: { newValue in
                        // Update the itemCount, converting newValue back to Int if necessary
                        // This step assumes you've changed itemCounts to store Double values
                        self.viewModel_FTP.itemCounts[self.selectedItem] = Double(newValue)
                        // If you decide to keep itemCount as Int, you'll need to round or otherwise adjust the newValue to make sense for your application
                    }
                ), range: 0...10) { newValue in
                    // Handle the new value, which is now a Double
                    viewModel_FTP.updateItemCount(for: selectedItem, newValue: Double(newValue))
                }

                .padding()
            }.environment(\.colorScheme, .light)
                .frame(width: 650)
                .border(Color.green.opacity(0.3), width: 1)
                .background(Color.green.opacity(0.1))
                .padding()
            VStack {
                Text("Number of Container to Bring Upstairs")
                    .bold()
                    .foregroundColor(.blue)
                CustomStepper_FTP(value: Binding<Double>(
                    get: {
                        // Convert the itemCount to Double
                        Double(self.viewModel_FTP.itemCounts[self.selectedItem, default: 0])
                    },
                    set: { newValue in
                        // Update the itemCount, converting newValue back to Int if necessary
                        // This step assumes you've changed itemCounts to store Double values
                        self.viewModel_FTP.itemCounts[self.selectedItem] = Double(newValue)
                        // If you decide to keep itemCount as Int, you'll need to round or otherwise adjust the newValue to make sense for your application
                    }
                ), range: 0...10) { newValue in
                    // Handle the new value, which is now a Double
                    viewModel_FTP.updateItemCount(for: selectedItem, newValue: Double(newValue))
                }

                .padding()
            }.environment(\.colorScheme, .light)
                .frame(width: 650)
                .background(Color.blue.opacity(0.1))
                .border(Color.blue.opacity(0.3), width: 1)
            Spacer()
//            Button(action: {
//                // Action to open settings
//            }) {
//                Image(systemName: "gearshape")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 50, height: 50) // Adjust size as needed
//            }
//            Text("Add/Remove item")


            // Display the generated image (for testing)
                       if let generatedImage = generatedImage {
                           Image(uiImage: generatedImage)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 300, height: 400)
                       }
        }
    }
    func calculateRowHeight(for item: String) -> CGFloat {
        // Retrieve the number of dates for the item
        let numberOfDates = viewModel_FTP.itemDates[item]?.count ?? 0
        
        // Calculate the total height
        let totalHeight = (CGFloat(numberOfDates) * lineHeight) + (padding * 2)
        
        // Ensure there's a minimum height, in case there are no dates
        return max(totalHeight, lineHeight + (padding * 2))
    }
}


class FoodToPrepViewModel: ObservableObject {
    @Published var itemCounts: [String: Double] = [:]
    @Published var itemDates: [String: [Date]] = [:]
    @Published var bagelQuantities: [String: String] = [:]

    func resetValues() {
        // Reset all counts to 0
        for (item, _) in itemCounts {
            itemCounts[item] = 0
        }
        
        // Clear all dates
        for (item, _) in itemDates {
            itemDates[item] = []
        }
        
        // Alternatively, if you want to completely clear the dictionaries:
        itemCounts.removeAll()
        itemDates.removeAll()
    }
    
    func updateItemCount(for item: String, newValue: Double) {
        objectWillChange.send() // Explicitly notify about the change
        itemCounts[item] = newValue

        // Update the dates for the item
        if let existingDates = itemDates[item] {
            if newValue > Double(existingDates.count) {
                // If the new value is greater, add more dates to the existing array
                itemDates[item] = existingDates + Array(repeating: Date(), count: Int(Double(newValue) - Double(existingDates.count)))
            } else {
                // If the new value is less or equal, just keep the array up to the new value
                itemDates[item] = Array(existingDates.prefix(Int(newValue)))
            }
        } else {
            // If there are no existing dates for the item, create a new array
            itemDates[item] = Array(repeating: Date(), count: Int(newValue))
        }

        print("Item: \(item), New Value: \(newValue)") // Debugging
    }
    
    // Function to get a formatted string of dates for an item
    func formattedDatesString(for item: String) -> String {
        guard let dates = itemDates[item], !dates.isEmpty else {
            return "    -"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dates
            .map { dateFormatter.string(from: $0) }
            .joined(separator: "\n")
    }



    // ... other properties if needed
}
/*********************************************************************FOOD INVENTORY *******************************************************/

struct FoodToPrepView_Previews: PreviewProvider {
    static var previews: some View {
        FoodToPrepView()
    }
}

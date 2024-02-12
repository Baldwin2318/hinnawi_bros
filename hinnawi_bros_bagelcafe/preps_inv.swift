import SwiftUI


struct MainTabView: View {
    @State private var showingSavePDFAlert = false
    @State private var showingResetPDFAlert = false
    @State private var selectedInventory = 0
    
    @State private var animateLeftChevron = false
    @State private var animateRightChevron = false
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    
    @EnvironmentObject var viewModel: InventoryViewModel // Use EnvironmentObject
    
    // Assuming 'days' array is static, define it here. Adjust as needed.
    let days = ["Preps For Monday", "Preps For Tuesday", "Preps For Wednesday",
                "Preps For Thursday", "Preps For Friday", "Preps For Saturday", "Preps For Sunday"]

    let inv_type = ["FOOD INVENTORY", "BAGEL INVENTORY", "PASTRIES INVENTORY"]
    
    // Define the items
    let items = [
        "Bacon", "Eggs", "Veggie patty", "Chicken", "Tofu", "Smoked Meat", "Turkey", "Salmon", "Mix Vege",
        "Onions", "Cucumber", "Pepper", "Tomatoes", "Lettuce", "Cream Cheese", "Butter",
        "Bacon Jam", "Potatoes", "Mayo", "Spicy Mayo", "Dijon Mustard", "Honey Mustard",
        "Canola Oil", "Lemon Squeezed in a Bottle", "Hinnawi Cream Cheese", "Olive Oil"
    ]
    
    var body: some View {
         VStack {
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
                        viewModel.resetValues() // Reset the data on confirmation
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
            Spacer()
            Button(action: {
                // Go to previous day
                if selectedInventory > 0 {
                    selectedInventory -= 1
                } else {
                    selectedInventory = inv_type.count - 1 // Loop back to the last day
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                    .offset(x:0, y:0)
                    .frame(width: 20)
                    .offset(x: animateLeftChevron ? -5 : 0) // Move left and right
                        .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateLeftChevron)
                        .onAppear {
                            self.animateLeftChevron = true
                        }
            }
                            TabView(selection: $selectedInventory) {
                                ForEach(0..<inv_type.count) { index in
                                    Text(self.inv_type[index])
                                        .frame(width: 200, height: 50) // Specify the frame for content, not the tab itself
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(width: 240, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .font(.headline)
            Button(action: {
                // Go to next day
                if selectedInventory < inv_type.count - 1 {
                    selectedInventory += 1
                } else {
                    selectedInventory = 0 // Loop back to the first day
                }
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.blue)
                    .offset(x:0, y:0)
                    .frame(width: 20)
                    .opacity(animateRightChevron ? 0.5 : 1) // Change opacity to indicate animation
                    .offset(x: animateRightChevron ? 0 : 5) // Move left and right
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateRightChevron)
                    .onAppear {
                        self.animateRightChevron = true
                    }
            }
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
    // Tab view for InventoryTab and PastriesInvTab
    private var contentTabs: some View {
        TabView(selection: $selectedInventory) {
                InventoryTab()
                    .tag(0) // Corresponds to "FOOD INVENTORY"
                    .tabItem {
                        Text(inv_type[0])
                    }

                BagelInvTab()
                    .tag(1) // Corresponds to "BAGEL INVENTORY"
                    .tabItem {
                        Text(inv_type[1])
                    }

                PastriesInvTab()
                    .tag(2) // Corresponds to "PASTRIES INVENTORY"
                    .tabItem {
                        Text(inv_type[2])
                    }
            }
        .environmentObject(viewModel)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Makes the TabView swipeable
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
                let headers = ["Item", "# of Contnr.", "Date", "To Prep"]
                let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
                
                let data = pdfRenderer.pdfData { context in
                    context.beginPage()
                    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
                    let headerAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
                    
                    var yPosition: CGFloat = margin
                    
                    // Draw Headers
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
                        let itemCount = viewModel.itemCounts[itemName, default: 0]
                        let datesString = viewModel.formattedDatesString(for: itemName)
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
                            datesString.isEmpty ? "   -" : datesString
                        ]
                        
                        for (index, content) in contents.enumerated() {                   drawLineVertical(from: CGPoint(x: 240, y: 50), to: CGPoint(x: 240, y: yPosition+30))
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

struct InventoryTab: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    
    var body: some View {
        // Your InventoryGridView here
        InventoryGridView()
            .environmentObject(viewModel) // Make sure to pass the ViewModel
    }
}
struct PastriesInvTab: View {
    var body: some View {
        // Customize this view as per your second tab's needs
        Text("Content for Pastries Inventory tab")
    }
}

struct BagelInvTab: View {
    var body: some View {
        BagelInventory()
    }
}

struct BagelInventory: View {
    let imageNames = [
        "Sesame Bagel", "Everything Bagel", "Plain Bagel", "Poppy Seed Bagel", "Multigrain Bagel",
        "Cheese Bagel", "Rosemary Bagel", "Cinnamon Sugar Bagel", "Cinnamon Raisin Bagel",
        "Blueberry Bagel"
    ]

    @State private var rotationAngle: Double = 0
    @State private var quantities = Array(repeating: 0, count: 10)

    var body: some View {
        HStack {
            // Quantities display
            BagelQuantitiesView(imageNames: imageNames, quantities: $quantities)
                .position(x:900, y:170)
            GeometryReader { geometry in
                let baseRadius = min(geometry.size.width, geometry.size.height) / 2 - 250
                ZStack {
                    ForEach(imageNames.indices, id: \.self) { index in
                        self.bagelImage(at: index, with: baseRadius, in: geometry.size, quantity: $quantities[index])
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            self.handleSwipe(value.translation.width)
                        }
                )
            }
            .frame(width: 1800, height: 1800)
        }
        
    }

    private func bagelImage(at index: Int, with baseRadius: CGFloat, in size: CGSize, quantity: Binding<Int>) -> some View {
        let angle = computeAngle(for: index, size: size)
        let xOffset: CGFloat = 750
        let yOffset: CGFloat = 1400
        let x = cos(angle) * baseRadius + xOffset
        let y = sin(angle) * baseRadius + yOffset

        return BagelImage(name: imageNames[index], x: x, y: y, quantity: quantity)
    }

    private func computeAngle(for index: Int, size: CGSize) -> Double {
        return (2 * .pi / Double(imageNames.count)) * Double(index) + rotationAngle - (.pi / 2)
    }

    private func handleSwipe(_ width: CGFloat) {
        let rotationDelta = 2 * .pi / Double(imageNames.count)
        withAnimation {
            rotationAngle += width < 0 ? -rotationDelta : rotationDelta
        }
    }
}

struct BagelImage: View {
    let name: String
    let x: CGFloat
    let y: CGFloat
    @Binding var quantity: Int // Bind quantity to enable updates

    var body: some View {
        VStack {
            Image(name) // Display the bagel image
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .background(Circle().fill(Color.secondary.opacity(0.3)))

            Text(name)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Text("Quantity: \(quantity)") // Display the current quantity

            HStack(spacing: 20) {
                // Minus button
                Button(action: {
                    if self.quantity > 0 { // Prevent quantity from going negative
                        self.quantity -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.red)
                }

                // Plus button
                Button(action: {
                    self.quantity += 1 // Increment the quantity
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.green)
                }
            }
        }
        .offset(x: x, y: y) // Position the image and buttons
    }
}


struct BagelQuantitiesView: View {
    let imageNames: [String]
    @Binding var quantities: [Int]

    var body: some View {
        // Define the columns for the grid
        let columns: [GridItem] = [
            GridItem(.flexible(), spacing: 20), // Column for bagel names
            GridItem(.flexible(), spacing: 20)  // Column for quantities
        ]

        // Filter the bagels with quantities of 1 or more
        let filteredBagels = imageNames.indices.filter { quantities[$0] >= 1 }
            .map { (index: $0, name: imageNames[$0], quantity: quantities[$0]) }

        // Use a ScrollView for vertical scrolling if the content exceeds the view's height
        ScrollView {
            // Create a LazyVGrid with the defined columns
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(filteredBagels, id: \.index) { item in
                    Text(item.name) // Display the bagel name
                        .font(.headline) // Customize the font as needed
                        .padding(.vertical, 10) // Add padding for better readability
                    
                    Text("\(item.quantity)") // Display the quantity
                        .font(.body) // Customize the font as needed
                        .padding(.vertical, 10) // Add padding for better readability
                }
            }
            .padding(.horizontal) // Add horizontal padding to the grid
        }
        .frame(width: 1000, height: 300) // Set the frame size as needed
    }
}



/******************************************     FOOD INVENTORY      *******************************************************************/
struct SwipeGestureDemonstrationUpDown: View {
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

struct SwipeGestureDemonstration: View {
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



class InventoryViewModel: ObservableObject {
    @Published var itemCounts: [String: Double] = [:]
    @Published var itemDates: [String: [Date]] = [:]
    
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

struct DatePickerModalView: View {
    var itemCount: Int
    var itemName: String  // Add this line
    var imageName: String // Add this line
    @Binding var dates: [Date]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
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
            .padding()

            }

            Text(itemName)
                .font(.system(size: 80))
              Image(imageName)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 400, height: 400) // Adjust the size as needed

        }.environment(\.colorScheme, .light)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<itemCount, id: \.self) { index in
                        ZStack {
                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { self.dates.indices.contains(index) ? self.dates[index] : Date() },
                                    set: { self.dates[index] = $0 }
                                ),
                                displayedComponents: .date
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden() // Hide labels if you prefer
                            .frame(width: 200) // Adjust the width for each DatePicker
                            .padding(.horizontal, 100) // Add some padding
                            
                            .padding()
                            .border(Color.yellow, width: 20)
                            // Overlay View to hide the year part of the DatePicker
                            .cornerRadius(10)
                            Rectangle()
                                .fill(Color.yellow ) // Match the color with the background
                                .frame(width: 160, height: 248) // Adjust size to cover the year
                                .offset(x: 130) // Adjust the position to cover the year correctly
                            Text(" \(index + 1) ")
                            
                                .font(.system(size: 58)) // Set your desired font size here Adjust the font as needed
                                                    .foregroundColor(.black) // Text color
                                                    .offset(x: 135, y: 15) // Adjust the position to fit within the rectangle
                                          
                        }
                    }
                }
            }.padding(100).environment(\.colorScheme, .light)
            .frame(height: 250) // Adjust the height of the ScrollView
        Text("Swipe left or right to navigate through multiple containers")
            .italic() // Make the text italic
            .foregroundColor(.red) // Set the text color to red
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center) // Optional: Adjust alignment and width as needed
            .padding() // Optional: Add some padding around the text

    }
}



struct CustomStepper: View {
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


struct InventoryGridView: View {
    // Define the column headers
    let headers = ["Item", "No. Container", "Date"]
    
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
    @EnvironmentObject var viewModel: InventoryViewModel // Use EnvironmentObject
    
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
                                .background(item == selectedItem ? Color.yellow : Color.gray.opacity(0.3)) // Conditional background color
                                .foregroundColor(item == selectedItem ? Color.black : Color.white) // Conditional foreground color
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
                            Text(viewModel.itemCounts[item, default: 0].truncatingRemainder(dividingBy: 1) == 0 ?
                                 "\(Int(viewModel.itemCounts[item, default: 0]))" :
                                    String(format: "%.1f", viewModel.itemCounts[item, default: 0]))
                            
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: rowHeight)
                                  .background(Color .white)
                            Button(action: {
                                // Check if dates are already available, if not, initialize them
                                if let existingDates = viewModel.itemDates[item], existingDates.count == Int(viewModel.itemCounts[item, default: 0]) {
                                    self.selectedDates = existingDates
                                } else {
                                    self.selectedDates = Array(repeating: Date(), count: Int(viewModel.itemCounts[item, default: 0]))
                                }
                                self.selectedItem = item  // Set the selected item
                                self.showingDatePickers = true
                            }) {
                                // This Text will be the content of the Button
                                if viewModel.itemCounts[item, default: 0] > 0 {
                                    Text(viewModel.formattedDatesString(for: item))
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                } else {
                                    Text("-")
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                            }   
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: rowHeight)
                            
                            .disabled(viewModel.itemCounts[item, default: 0] == 0) // Disable the button if itemCount is 0
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
//                ZStack{
//                    Image(systemName: "arrow.right.circle.fill") // Using SF Symbol for demonstration. You can use your own image.
//                        .resizable()
//                        .position(x:220, y:160)
//                        .frame(width: 70, height: 70)
//                        .foregroundColor(.yellow)
//                    Image(systemName: "arrow.left.circle.fill") // Using SF Symbol for demonstration. You can use your own image.
//                        .resizable()
//                        .position(x:-220, y:160)
//                        .frame(width: 70, height: 70)
//                        .foregroundColor(.yellow)
//                }
                SwipeGestureDemonstration(selectedItem: $selectedItem, items: images)
                ZStack{
                    SwipeGestureDemonstrationUpDown(selectedItem: $selectedItem, items: images)}
                  //  .frame(height: 50) // Adjust the frame as needed
                VStack {
                    TabView (selection: $selectedItem){
                        ForEach(Array(zip(images, items)), id: \.0) {
                            
                            (imageName, item) in
                            Image(imageName)
                                .resizable()
                           
                                .scaleEffect(tappedItem2 == item ? 1.1 : 1.0) // Scale up the text if it is the tapped item
                                            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: tappedItem2) // Animate the scaling effect
                                            .onTapGesture {
                                                tappedItem2 = item;
                                                selectedItem = item // Set the selected item when the image is tapped
                                         if viewModel.itemCounts[item, default: 0] > 0 {
                                                        // Show the date picker only if the value from the stepper is greater than 0
                                                        if let selectedDate = selectedDatesByItem[item] {
                                                            self.selectedDates = [selectedDate]
                                                        } else {
                                                            self.selectedDates = [Date()]
                                                        }
                                                        self.showingDatePickers = true
                                                    } else {
                                                        // Handle the case where the value from the stepper is 0 (no date picker)
                                                        // You can show an alert or handle it as needed
                                                    }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                    tappedItem2 = nil
                                                }
                                            }
                                .scaledToFit()
                                .frame(width: 500, height: 180) // Set width and height
                                .clipped() // Clip the image to the frame
                                .cornerRadius(10) // Optional: make the corners rounded
                                .tag(imageName) // Assign a unique tag for each image
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                     
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Set the tab view style
                    .frame(width: 300, height: 180) // Set width and height for the TabView
                    
                }.environment(\.colorScheme, .light)
                Text(selectedItem) // Display the name of the selected item
                    .font(.largeTitle)
            }.environment(\.colorScheme, .light)
            VStack {
                CustomStepper(value: Binding<Double>(
                    get: {
                        // Convert the itemCount to Double
                        Double(self.viewModel.itemCounts[self.selectedItem, default: 0])
                    },
                    set: { newValue in
                        // Update the itemCount, converting newValue back to Int if necessary
                        // This step assumes you've changed itemCounts to store Double values
                        self.viewModel.itemCounts[self.selectedItem] = Double(newValue)
                        // If you decide to keep itemCount as Int, you'll need to round or otherwise adjust the newValue to make sense for your application
                    }
                ), range: 0...10) { newValue in
                    // Handle the new value, which is now a Double
                    viewModel.updateItemCount(for: selectedItem, newValue: Double(newValue))
                }

                .padding()
            }.environment(\.colorScheme, .light)
            
            .sheet(isPresented: $showingDatePickers) {
                if let datesBinding = Binding($viewModel.itemDates[selectedItem]) {
                    // Pass the selected item's name and image name to DatePickerModalView
                    DatePickerModalView(itemCount: Int(viewModel.itemCounts[selectedItem, default: 0]),
                                        itemName: selectedItem,
                                        imageName: selectedItem, // Assuming the image name is same as the item name
                                        dates: datesBinding)
                }
            }


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
        let numberOfDates = viewModel.itemDates[item]?.count ?? 0
        
        // Calculate the total height
        let totalHeight = (CGFloat(numberOfDates) * lineHeight) + (padding * 2)
        
        // Ensure there's a minimum height, in case there are no dates
        return max(totalHeight, lineHeight + (padding * 2))
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

import SwiftUI

struct SwipeGestureDemonstration: View {
    @State private var moveDistance: CGFloat = 0
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "arrow.right") // Using SF Symbol for demonstration. You can use your own image.
                .resizable()
                .position(x:-10, y:150)
                .frame(width: 20, height: 20)
                .foregroundColor(.yellow)
                .offset(x: moveDistance, y: 0)
                .onAppear {
                    let width = geometry.size.width * 0.3 // Adjust the swipe distance based on the size of the parent view
                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        moveDistance = width
                    }
                }
            Image(systemName: "arrow.left") // Using SF Symbol for demonstration. You can use your own image.
                .resizable()
                .position(x:715, y:150)
                .frame(width: 20, height: 20)
                .foregroundColor(.yellow)
                .offset(x: -moveDistance, y: 0)
                .onAppear {
                    let width = geometry.size.width * 0.3 // Adjust the swipe distance based on the size of the parent view
                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        moveDistance = width
                    }
                }
        }
    }
}
struct InventoryTablePDFView: View {
    @ObservedObject var viewModel: InventoryViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Item")
                Text("No. Container")
                Text("Date")
                Text("To Prep")
            }
            ForEach(viewModel.items, id: \.self) { item in
                HStack {
                    Text(item)
                    Text("\(viewModel.itemCounts[item, default: 0])")
                    Text(viewModel.formattedDatesString(for: item))
                    Text("To Prep Info") // Add your actual prep info here
                }
            }
        }.environment(\.colorScheme, .light)
    }
}

class InventoryViewModel: ObservableObject {
    @Published var itemCounts: [String: Int] = [:]
    @Published var itemDates: [String: [Date]] = [:] // Store dates for each item
    @Published var items: [String] = ["Bacon", "Eggs"   ] // your items here

    func updateItemCount(for item: String, newValue: Int) {
        objectWillChange.send() // Explicitly notify about the change
        itemCounts[item] = newValue

        // Update the dates for the item
        if let existingDates = itemDates[item] {
            if newValue > existingDates.count {
                // If the new value is greater, add more dates to the existing array
                itemDates[item] = existingDates + Array(repeating: Date(), count: newValue - existingDates.count)
            } else {
                // If the new value is less or equal, just keep the array up to the new value
                itemDates[item] = Array(existingDates.prefix(newValue))
            }
        } else {
            // If there are no existing dates for the item, create a new array
            itemDates[item] = Array(repeating: Date(), count: newValue)
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

    var body: some View {
        VStack {
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
    @Binding var value: Int // Bind to the specific value for the current item
    var range: ClosedRange<Int>
    var onValueChanged: (Int) -> Void // Callback when value changes
    
    var body: some View {
        HStack {
            // Decrement Button
            Button(action: {
                if value > range.lowerBound {
                    value -= 1
                    onValueChanged(value) // Notify about decrement
                }
            }) {
                Image(systemName: "minus")
                    .font(.title) // Large size for the "-" icon
                    .foregroundColor(.white)
                    .frame(width: 90, height: 90) // Larger frame for the button
                    .background(Color.gray)
                    .cornerRadius(50)
            }
            
            // Value Display
            Text("\(value)")
                .font(.title)
                .frame(width: 80, alignment: .center)
            
            // Increment Button
            Button(action: {
                if value < range.upperBound {
                    value += 1
                    onValueChanged(value) // Notify about decrement
                    print("Decremented to \(value)") // Debugging
                }
            }) {
                Image(systemName: "plus")
                    .font(.title) // Large size for the "+" icon
                    .foregroundColor(.black)
                    .frame(width: 90, height: 90) // Larger frame for the button
                    .background(Color.yellow)
                    .cornerRadius(50)
            }
        }.environment(\.colorScheme, .light)
    }
}

struct InventoryGridView: View {
    // Define the column headers
    let headers = ["Item", "No. Container", "Date", "To Prep"]
    
    // Define the items
    let items = [
        "Bacon", "Eggs", "Veggies", "Chicken", "Tofu", "Smoked Meat", "Turkey", "Mix Vege",
        "Onions", "Cucumber", "Pepper", "Tomatoes", "Lettuce", "Cream Cheese", "Butter",
        "Bacon Jam", "Potatoes", "Mayo", "Spicy Mayo", "Dijon Mustard", "Honey Mustard",
        "Canola Oil", "Lemon Squeezed in a Bottle", "Hinnawi Cream Cheese", "Olive Oil"
    ]
    
    // Define the columns
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    @State private var value: Int = 0
    @State private var itemCounts: [String: Int] = [:] // Track item counts
    @State private var selectedItem: String = "" // Track selected item
    @StateObject private var viewModel = InventoryViewModel()
    
    @State private var showingDatePickers = false
    @State private var selectedDates: [Date] = []
    @State private var generatedImage: UIImage? // To hold the generated image
    @State private var selectedDatesByItem: [String: Date] = [:]

    @State private var selectedImageIndex: Int = 0 // Track the index of the selected image

    @State private var showingSavePDFAlert = false
    
    init() {
        _selectedItem = State(initialValue: items.first ?? "") // Initialize with the first item
    }
    
    let images = [
        "Bacon", "Eggs", "Veggies", "Chicken", "Tofu", "Smoked Meat", "Turkey", "Mix Vege",
        "Onions", "Cucumber", "Pepper", "Tomatoes", "Lettuce", "Cream Cheese", "Butter",
        "Bacon Jam", "Potatoes", "Mayo", "Spicy Mayo", "Dijon Mustard", "Honey Mustard",
        "Canola Oil", "Lemon Squeezed in a Bottle", "Hinnawi Cream Cheese", "Olive Oil"]

    var body: some View {
        VStack {
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
                        Text(item)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .onTapGesture {
                                                            selectedItem = item // Set the selected item when text is tapped
                                                        }
                        Text("\(viewModel.itemCounts[item, default: 0])") // Bind to viewModel's itemCounts
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        Button(action: {
                             // Check if dates are already available, if not, initialize them
                             if let existingDates = viewModel.itemDates[item], existingDates.count == viewModel.itemCounts[item, default: 0] {
                                 self.selectedDates = existingDates
                             } else {
                                 self.selectedDates = Array(repeating: Date(), count: viewModel.itemCounts[item, default: 0])
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
                         .disabled(viewModel.itemCounts[item, default: 0] == 0) // Disable the button if itemCount is 0
                   
                        Text("To Prep")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                    }
                }
                .padding()
                
            }.frame(height: 500, alignment: .topLeading).environment(\.colorScheme, .light)
            VStack {
                SwipeGestureDemonstration()
                    .frame(height: 50) // Adjust the frame as needed
                VStack {
                    TabView (selection: $selectedItem){
                        ForEach(Array(zip(images, items)), id: \.0) {
                            
                            (imageName, item) in
                            Image(imageName)
                                .resizable()
                                .onTapGesture {
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
                                       }
                                
                                .scaledToFit()
                                .frame(width: 500, height: 200) // Set width and height
                                .clipped() // Clip the image to the frame
                                .cornerRadius(10) // Optional: make the corners rounded
                                .tag(imageName) // Assign a unique tag for each image
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Set the tab view style
                    .frame(width: 600, height: 200) // Set width and height for the TabView
                    
                }.environment(\.colorScheme, .light)
                Text(selectedItem) // Display the name of the selected item
                    .font(.largeTitle)
            }.environment(\.colorScheme, .light)
            VStack {
                CustomStepper(value: Binding(
                    get: { self.viewModel.itemCounts[self.selectedItem, default: 0] },
                    set: { self.viewModel.itemCounts[self.selectedItem] = $0 }
                ), range: 0...10) { newValue in
                    viewModel.updateItemCount(for: selectedItem, newValue: newValue)
                }
                .padding()
            }.environment(\.colorScheme, .light)
            
            .sheet(isPresented: $showingDatePickers) {
                if let datesBinding = Binding($viewModel.itemDates[selectedItem]) {
                    // Pass the selected item's name and image name to DatePickerModalView
                    DatePickerModalView(itemCount: viewModel.itemCounts[selectedItem, default: 0],
                                        itemName: selectedItem,
                                        imageName: selectedItem, // Assuming the image name is same as the item name
                                        dates: datesBinding)
                }
            }
            Button("Save to Photos") {
                 saveAsPDF()
             }
             .alert(isPresented: $showingSavePDFAlert) {
                 Alert(title: Text("Saved"), message: Text("Images saved to Photos"), dismissButton: .default(Text("OK")))
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



    private func generatePDFData() -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        let contentWidth = pageWidth - (margin * 2)
        let rowHeight: CGFloat = 20
        let columnWidths = [contentWidth * 0.4, contentWidth * 0.2, contentWidth * 0.2, contentWidth * 0.2]
        let headers = ["Item", "No. Container", "Date", "To Prep"]
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
                           let contents = [
                               itemName,
                               "\(itemCount)",
                               datesString.isEmpty ? "   -" : datesString, // Check if datesString is empty
                               "To Prep Info" // Use actual prep info here if available
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


struct InventoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryGridView()
    }
}

import SwiftUI

struct SwipeGestureDemonstration: View {
    @State private var moveDistance: CGFloat = 0
    @State private var animate = false

    var body: some View {
        GeometryReader { geometry in
            Image(systemName: "arrow.left") // Using SF Symbol for demonstration. You can use your own image.
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.yellow)
                .offset(x: moveDistance, y: 0)
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
        }
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
        guard let dates = itemDates[item] else {
            return "-"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd" // Format the date to show abbreviated month and day
        return dates.map { dateFormatter.string(from: $0) }.joined(separator: "\n")
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

        }
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
            }.padding(100)
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
        }
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
                
            }.frame(height: 500, alignment: .topLeading)
            VStack {            
                SwipeGestureDemonstration()
                    .frame(height: 50) // Adjust the frame as needed
                VStack {
                    TabView (selection: $selectedItem){
                        ForEach(Array(zip(images, items)), id: \.0) { (imageName, item) in
                            Image(imageName)
                                .resizable()
                                .onTapGesture {
                                                                    selectedItem = item // Set the selected item when the image is tapped
                                                                }
                                
                                .scaledToFit()
                                .frame(width: 500, height: 200) // Set width and height
                                .clipped() // Clip the image to the frame
                                .cornerRadius(10) // Optional: make the corners rounded
                                .tag(imageName) // Assign a unique tag for each image
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Set the tab view style
                    .frame(width: 600, height: 200) // Set width and height for the TabView
                    
                }
                Text(selectedItem) // Display the name of the selected item
                    .font(.largeTitle)
            }
            VStack {
                CustomStepper(value: Binding(
                    get: { self.viewModel.itemCounts[self.selectedItem, default: 0] },
                    set: { self.viewModel.itemCounts[self.selectedItem] = $0 }
                ), range: 0...10) { newValue in
                    viewModel.updateItemCount(for: selectedItem, newValue: newValue)
                }
                .padding()
            }
            
            .sheet(isPresented: $showingDatePickers) {
                if let datesBinding = Binding($viewModel.itemDates[selectedItem]) {
                    // Pass the selected item's name and image name to DatePickerModalView
                    DatePickerModalView(itemCount: viewModel.itemCounts[selectedItem, default: 0],
                                        itemName: selectedItem,
                                        imageName: selectedItem, // Assuming the image name is same as the item name
                                        dates: datesBinding)
                }
            }
//            Button("Generate PDF and Convert to Image") {
//                          let pdfSize = CGSize(width: 595, height: 842) // A4 size in points
//                createPDF(fromSwiftUIView: AnyView(InventoryTablePDFView(viewModel: InventoryViewModel())), size: pdfSize) { pdfData in
//                    DispatchQueue.main.async { // Ensure UI updates are on the main thread
//                        if let pdfData = pdfData {
//                            print("PDF Data generated successfully.")
//                            // Convert PDF data to image
//                            if let image = self.pdfToImage(pdfData: pdfData) {
//                                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                                print("Image saved to Photos")
//                                self.generatedImage = image
//                                // Do something with the image (e.g., save it or share it)
//                                // For example, save to Photos Album (make sure to handle permissions)
//                            } else {
//                                print("Failed to convert PDF to image.")
//                            }
//                        } else {
//                            print("Failed to generate PDF.")
//                        }
//                    }
//                }
//
//                      }
            // Display the generated image (for testing)
                       if let generatedImage = generatedImage {
                           Image(uiImage: generatedImage)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 300, height: 400)
                       }
        }
    }
    
    func createPDF(fromSwiftUIView swiftUIView: AnyView, size: CGSize, completion: @escaping (Data?) -> Void) {
        DispatchQueue.main.async {
            let hostingController = UIHostingController(rootView: swiftUIView)
            hostingController.view.frame = CGRect(origin: .zero, size: size)

            // Force view update and layout
            hostingController.view.setNeedsUpdateConstraints()
            hostingController.view.updateConstraintsIfNeeded()
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()

            let pdfPageBounds = CGRect(origin: .zero, size: size)
            let pdfData = NSMutableData()
            UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            
            guard let pdfContext = UIGraphicsGetCurrentContext() else {
                print("Could not get PDF context")
                completion(nil)
                return
            }

            hostingController.view.layer.render(in: pdfContext)
            UIGraphicsEndPDFContext()
            
            // Convert NSMutableData to Data
            let data = Data(referencing: pdfData)
            if data.isEmpty {
                print("Generated PDF data is empty.")
                completion(nil)
            } else {
                completion(data)
            }

            // Save the PDF for debugging
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let pdfFilePath = paths[0].appendingPathComponent("debug_output.pdf")
            do {
                try pdfData.write(to: pdfFilePath, options: .atomicWrite)
                print("PDF debug file saved at: \(pdfFilePath)")
            } catch {
                print("Could not write the PDF debug file to disk: \(error)")
            }
        }
    }





    func pdfToImage(pdfData: Data) -> UIImage? {
        if pdfData.isEmpty {
            print("PDF data is empty.")
            return nil
        }
        
        guard let provider = CGDataProvider(data: pdfData as CFData) else {
            print("Failed to create CGDataProvider.")
            return nil
        }
        
        guard let pdfDocument = CGPDFDocument(provider) else {
            print("Failed to create CGPDFDocument.")
            return nil
        }
        
        guard let page = pdfDocument.page(at: 1) else {
            print("Failed to get the first page of the PDF.")
            return nil
        }
        
        let pageRect = page.getBoxRect(.mediaBox)
        UIGraphicsBeginImageContextWithOptions(pageRect.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to get graphics context.")
            UIGraphicsEndImageContext()
            return nil
        }

        context.saveGState()
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))

        // Print the current page bounds and context information for debugging
        print("Page Bounds: \(pageRect)")
        print("Context: \(context)")
        
        context.drawPDFPage(page)
        context.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image == nil {
            print("Failed to get image from context.")
        }
        return image
    }



}

struct InventoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryGridView()
    }
}

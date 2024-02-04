import SwiftUI

class InventoryViewModel: ObservableObject {
    @Published var itemCounts: [String: Int] = [:]

    func updateItemCount(for item: String, newValue: Int) {
        objectWillChange.send() // Explicitly notify about the change
        itemCounts[item] = newValue
        print("Item: \(item), New Value: \(newValue)") // Debugging
    }
    // ... other properties if needed
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
                        Text("\(viewModel.itemCounts[item, default: 0])") // Bind to viewModel's itemCounts
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        Text("Date")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        Text("To Prep")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                    }
                }
                .padding()
                
            }.frame(height: 500, alignment: .topLeading)
            VStack {
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
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Set the tab view style
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

        }
    }
}

struct InventoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryGridView()
    }
}

import SwiftUI

struct CustomStepper: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            // Decrement Button
            Button(action: {
                if value > range.lowerBound {
                    value -= 1
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
        "Bacon", "Eggs", "Veggie", "Chicken", "Tofu", "Smoked Meat", "Turkey", "Mix Vege",
        "Onions", "Cucumber", "Pepper", "Tomatoes", "Lettuce", "Cream Cheese", "Butter",
        "Bacon Jam", "Potatoes", "Mayo", "Spicy Mayo", "Dijon Mustard", "Honey Mustard",
        "Canola Oil", "Lemon Squeezed in a Bottle", "Hinnawi Cream Cheese", "Olive Oil"
    ]
    
    // Define the columns
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    @State private var value: Int = 0
    
    let images = ["bagel", "veggie", "dessert"]

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
                        Text("No. Container")
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
                    TabView {
                        ForEach(images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable() // Make the image resizable
                                .scaledToFill() // Fill the frame of the parent view
                                .frame(width: 200, height: 200) // Set width and height
                                .clipped() // Clip the image to the frame
                                .cornerRadius(10) // Optional: make the corners rounded
                                .padding(.horizontal) // Optional: add padding on the sides
                                .tag(imageName) // Assign a unique tag for each image
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Set the tab view style
                    .frame(width: 300, height: 300) // Set width and height for the TabView
                    
                }
            }
            VStack {
                CustomStepper(value: $value, range: 0...100)
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

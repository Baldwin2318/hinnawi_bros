import SwiftUI

struct ButtonData {
    let symbolName: String
    let title: String
    let isSystemIcon: Bool // True for SF Symbols, false for custom icons
    let action: () -> Void
}


struct ContentView: View {
    @State private var buttonCount = 0
    @State private var showStoreInvView = false
    @State private var selectedTabIndex = 0  // Add this line to track the current tab index
    @State private var itemQuantities: [[String]] = Array(repeating: Array(repeating: "", count: 100), count: 6)  // Adjust numbers as needed
     
    
    private var buttons: [ButtonData] {
        [
            ButtonData(symbolName: "checklist", title: "To Do List", isSystemIcon: true, action: incrementButtonCount),
            ButtonData(symbolName: "cart", title: "Store Inventory", isSystemIcon: true, action: gotoInventory),
            ButtonData(symbolName: "cup.and.saucer", title: "Coffee", isSystemIcon: true, action: customAction),
            ButtonData(symbolName: "bagel", title: "Sandwich", isSystemIcon: false, action: customAction),
            ButtonData(symbolName: "veggie", title: "Preps", isSystemIcon: false, action: customAction),
            ButtonData(symbolName: "dessert", title: "Pastry", isSystemIcon: false, action: customAction),
            ButtonData(symbolName: "person", title: "Policy", isSystemIcon: true, action: customAction),
            ButtonData(symbolName: "questionmark.circle", title: "Help", isSystemIcon: true, action: customAction),
            // ... add other buttons data
        ]
    }
 
    // Define the columns for your grid
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        // Add more GridItem for more columns
    ]

    var body: some View {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(buttons.indices, id: \.self) { index in
                    Button(action: buttons[index].action) {
                        VStack {
                            if buttons[index].isSystemIcon {
                                            // Use SF Symbol
                                            Image(systemName: buttons[index].symbolName)
                                                .resizable()
                                                .scaledToFit().foregroundColor(.black)
                                        } else {
                                            // Use custom icon
                                            Image(buttons[index].symbolName) // Ensure the image is added to your asset catalog
                                                .resizable()
                                                .scaledToFit()
                                        }

                            Text(buttons[index].title) // Button title
                                .font(.caption)
                                .foregroundColor(.black) // Set the text color
                        }
                        .frame(width: 100, height: 120) // Set the frame size (width and height)
                        .padding()
                        .background(Color.yellow) // Set the background color of the button
                        .cornerRadius(10) // Make the corners of the button rounded
                    }
                }
            }
            .padding(.horizontal) // Add horizontal padding

            .toolbar {
                ToolbarItem(placement: .principal) { // Use .principal to center the item in the toolbar
                    Image("logo_hinnawi") // Replace "yourImageName" with your actual image file name
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40) // Adjust the size as needed.
                
            }
        }
        .environment(\.colorScheme, .light)
        .sheet(isPresented: $showStoreInvView) {
            StoreInvView(selectedTab: $selectedTabIndex, itemQuantities: $itemQuantities) // Pass the binding to the item quantities
        }
    }

    // Function to increment button count
    private func incrementButtonCount() {
        buttonCount += 1
    }

    // Function for custom action
    private func gotoInventory() {
        showStoreInvView = true
    }
    // Function for custom action
    private func customAction() {
        //do nothing
    }
}

struct StoreInvView: View {
    @Binding var selectedTab: Int // Accept the binding here
    @Binding var itemQuantities: [[String]]  // Add this line
    
    var body: some View {
        store_inv(selectedTab: $selectedTab, itemQuantities: $itemQuantities) // Pass the binding
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

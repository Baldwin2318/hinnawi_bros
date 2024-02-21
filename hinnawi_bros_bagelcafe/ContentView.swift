import SwiftUI

struct ButtonData {
    let symbolName: String
    let title: String
    let isSystemIcon: Bool // True for SF Symbols, false for custom icons
    let action: () -> Void
}


struct ContentView: View {
    @State private var buttonCount = 0
    @State private var selectedTabIndex = 0  // Add this line to track the current tab index
    @State private var itemQuantities: [[String]] = Array(repeating: Array(repeating: "", count: 100), count: 6)  // Adjust numbers as needed
    
    @State private var showStoreInvView = false
    @State private var showPrepsInvView = false
    @State private var showPastryToPrepInvView = false
    
    @StateObject private var viewModel = InventoryViewModel() // Create a single instance

    private var buttons: [ButtonData] {
        [
            ButtonData(symbolName: "checklist", title: "To Do List", isSystemIcon: true, action: incrementButtonCount),
            ButtonData(symbolName: "cart", title: "Store Inventory", isSystemIcon: true, action: gotoInventory),
            ButtonData(symbolName: "leaf.arrow.triangle.circlepath", title: "Food To Prep", isSystemIcon: true, action: incrementButtonCount),
            //ButtonData(symbolName: "bagel", title: "Sandwich", isSystemIcon: false, action: customAction),
            ButtonData(symbolName: "veggie", title: "Food Inventory", isSystemIcon: false, action: gotoInventoryPreps),
            ButtonData(symbolName: "tray", title: "Pasty To Prep", isSystemIcon: true, action: gotoPastryToPreps),
            //ButtonData(symbolName: "person", title: "Policy", isSystemIcon: true, action: customAction),
            //ButtonData(symbolName: "questionmark.circle", title: "Help", isSystemIcon: true, action: customAction),
            // ... add other buttons data
        ]
    }
 
    // Define the columns for your grid
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),

        // Add more GridItem for more columns
    ]

    var body: some View {
        VStack {
            Image("logo_hinnawi") // Replace "logo_hinnawi" with your actual image file name
                .resizable()
                .scaledToFit()
                .frame(height: 200) // Adjust the size as needed.
                .padding(50)
        }

            LazyVGrid(columns: columns, spacing: 50) {
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
        .environment(\.colorScheme, .light)
        .sheet(isPresented: $showStoreInvView) {
            StoreInvView(selectedTab: $selectedTabIndex, itemQuantities: $itemQuantities) // Pass the binding to the item quantities
        }
        .sheet(isPresented: $showPrepsInvView) {
            PrepsInvView()
                .environmentObject(viewModel) // Inject the environment object
        }
        .sheet(isPresented: $showPastryToPrepInvView) {
            PastryToPrepInView()
        }
        .environmentObject(viewModel) // Inject the environment object
        
    }

    // Function to increment button count
    private func incrementButtonCount() {
        buttonCount += 1
    }

    // Function for custom action
    private func gotoInventory() {
        showStoreInvView = true
    }
    private func gotoInventoryPreps() {
        showPrepsInvView = true
    }
    // Function for custom action
    private func gotoPastryToPreps() {
        showPastryToPrepInvView = true
    }
}

struct StoreInvView: View {
    @Binding var selectedTab: Int // Accept the binding here
    @Binding var itemQuantities: [[String]]  // Add this line
    
    var body: some View {
        store_inv(selectedTab: $selectedTab, itemQuantities: $itemQuantities) // Pass the binding
    }
}
struct PrepsInvView: View {
    var body: some View {
        MainTabView()
     
    }
}
struct PastryToPrepInView: View {
    var body: some View {
        PastryToPepView()
     
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

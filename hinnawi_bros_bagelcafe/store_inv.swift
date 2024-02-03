//
//  store_inv.swift
//  hinnawi_bros_bagelcafe
//
//  Created by Baldwin Kiel Malabanan on 2024-01-29.
//

import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct InventoryItem: Identifiable {
    let id = UUID()
    var name: String
    var quantity: String
}

struct store_inv: View {
    @State private var itemQuantitiesTable1: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesTable2: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesTable3: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesTable4: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesTable5: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesTable6: [String] = Array(repeating: "", count: 100)
    
    @Binding var selectedTab: Int  // Use the binding to control the tab selection
    @Binding var itemQuantities: [[String]]  // Add this line

    @State private var showDocumentPicker = false
    @State private var documentURL: URL?
    @State private var isLoading = false // For indicating PDF generation progress

    // Hard coded item tables
    let itemsTable1 = ["Salted Butter", "Unsalted Butter", "Cream Cheese Philadelphia", "Hinnawi Creamcheese", "Canola Oil", "Olive oil", "White Vinegar", "Apple Cider Vinegar", "Veggie burger", "Ketchup", "Tabasco", "Soya Sauce", "Maple Syrup", "Eggs", "Capers", "Cajun", "Garlic Powder", "Onion Powder", "Pepper", "Salt", "Paprika", "Oregano", "Honey squeeze bottle for clients", "Cinnamon sticks", "Sparkling water", "San Pellagrino Aranciata", "San Pellagrino Arcianta Rossa", "San Pellagrino Limonata", "Coke", "Diet Coke", "Nestea", "Eau Eska", "7up", "Ginger ale", "Orange juice", "Apple juice", "Gloves large", "Paper Péche", "Honey large size", "Ham for CK (1339666)","Turkey for CK", "Cheddar for CK", "Mozzerella for CK", "Clear bagel bags (5*3*15)"] // Up to 10 items
    let itemsTable2 = ["Almond milk", "Soy milk", "Coconut milk", "Macadamia milk", "Oat milk", "Vanilla syrup", "Caramel syrup", "Chocolate sauce", "Eggs per dozen/15 doz (one box)", "Tofu", "Sucre blanc sachets", "Sucre brun sachets", "Gutsy Flamboyan", "Gutsy remontant", "Gutsy Vitalité" ,"Gutsy digestif", "Garbage bags", "Small cups SQ", "Medium cups", "Large cups", "Lids for both cups", "Grill cleaner", "Liquid floor degreaser", "Salt buster", "Desinfectant bleach", "Mop heads", "Metal scrub", "Thermal rolls for cash", "Thermal rolls for debit machine", "Blue rags", "Desinfectant", "Urnex poweder for espresso machine", "Sanitizer", "Spray bottles", "Yogurt vaniller Astro", "Chocolate powder", "Brown paper", "Diswashing soap", "Hand soap", "Bon Ami glass cleaner", "Red basket wax paper (for CK)", "Black basket wax paper (for CK)", "Magic eraser", "Javel", "Stainless steel cleaner", "Yellow and green sponges", "Vanilla", "Walnuts", "Chocolate chips (milk chocolate)", "Chocolate chips (dark chocolate)", "Fresh salmon for Kai", "Smoked meat"  /*...*/] // Up to 20 items
    let itemsTable3 = ["Eggs", "Bacon maple leaf", "Bacon for bacon jam", "Tofu", "Salmon grizzly", "Veggie burger", "Mayonaise", "Dijon", "Sriratcha", "Capers", "Brown sugar", "White sugar", "Twin sugar", "Bouteilles d'eau", "Gutsy Le remontant", "Gutsy Le digestif", "Gutsy Flamboyant", "Gutsy Vitalité", "Milk 3% (per case of 9 bottles of 2L)", "Cream 10% (1L)", "Napkins", "Cinamon sticks", "Degreaser pink product", "Small cups", "Medium cups", "Large cups", "Small lids", "Large lids", "Chocolate chips (milk chocolate)", "Chocolate chips(dark chocolate)" /*...*/] // Up to 25 items
    let itemsTable4 = ["Chicken" /*...*/] // Up to 50 items
    let itemsTable5 = ["Hair nets", "Blue rags", "Coffee trays", "Coffee stirs", "Plastic wrap", "Large Brown Bags for bagels", "Small Brown Bags #12", " Clear bagel bags (5*3*15)", "Garbage bags", "Recycling bags", "Receipt thermal paper rolls", "Moneris thermal paper rolls", "Kitchen printer paper rolls (only MK)", "Grill cleaner", "Desinfectant sanitizer", "Floor cleaner Pinosan", "Ali-Dher degreaser pink", "Vacuum bags 10-13 inches", "Vacuum bags 6-8 inches", "Window cleaner", "Detergent for dishwasher", "Mop heads", "Metal scrubs", "Yellow and green sponges", "Wood utensils (fork, spoon and knife)", "Straw", "Toilet paper" /*...*/] // Up to 50 items
    let itemsTable6 = ["Earl grey", "Masala chai", "Jasmin tea", "English breakfast", "Matcha powder", "Camomile", "Peppermint", "Cherry sencha", "Green sencha" /*...*/] // Up to 50 items
    let itemsTable7 = ["Chicken" /*...*/] // Up to 50 items
    let itemsTable8 = ["Chicken" /*...*/] // Up to 50 items
    // ... Additional tables if needed
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                                   // Display a loading indicator when the PDF is being generated
                                   ProgressView("Generating PDF...")
                               } else {
                                   inventoryTables
                                   Button("Save as PDF") {
                                       saveQuantitiesAsPDF()
                                   }
                               }
            }.background(Color.yellow)
                .sheet(isPresented: $showDocumentPicker) {
                                // Present the document picker
                                if let documentURL = documentURL {
                                    DocumentPicker(url: documentURL) {
                                        // Handle the dismissal of the document picker
                                        showDocumentPicker = false
                                    }
                                }
                            }
        }
        .environment(\.colorScheme, .light)
    }
    
    //Tabs in here
    private var inventoryTables: some View {
        TabView(selection: $selectedTab) {
            InventoryListView(title: "COSCTO", items: itemsTable1.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable1[index])
            }, quantities: $itemQuantities[0]).tag(0) // Pass the binding here
            InventoryListView(title: "Nantel", items: itemsTable2.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable2[index])
            }, quantities: $itemQuantities[1]).tag(1) // Pass the binding here
            InventoryListView(title: "Gordon", items: itemsTable3.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable3[index])
            }, quantities: $itemQuantities[2]).tag(2) // Pass the binding here
            InventoryListView(title: "Fernando Chicken", items: itemsTable4.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable4[index])
            }, quantities: $itemQuantities[3]).tag(3) // Pass the binding here
            InventoryListView(title: "CARROUSEL", items: itemsTable5.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable5[index])
            }, quantities: $itemQuantities[4]).tag(4) // Pass the binding here
            InventoryListView(title: "PURE TEA", items: itemsTable6.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable6[index])
            }, quantities: $itemQuantities[5]).tag(5) // Pass the binding here
            // Repeat for other tables...
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    // Save the inventory list with quantities as PDF
     private func saveQuantitiesAsPDF() {
         
         isLoading = true // Indicate loading
             let pdfData = generatePDFData()
                 documentURL = writeToTemporaryFile(data: pdfData)
                 showDocumentPicker = true // Trigger the document picker sheet
                 isLoading = false // End loading
             
         
     }
    
    
    private func writeToTemporaryFile(data: Data) -> URL {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("inventory.pdf")
        try? data.write(to: tempURL)
        return tempURL
    }
    
    struct DocumentPicker: UIViewControllerRepresentable {
        var url: URL
        var onDismiss: () -> Void

        func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            let picker = UIDocumentPickerViewController(forExporting: [url])
            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

        func makeCoordinator() -> Coordinator {
            Coordinator(self, onDismiss: onDismiss)
        }

        class Coordinator: NSObject, UIDocumentPickerDelegate {
            var parent: DocumentPicker
            var onDismiss: () -> Void

            init(_ parent: DocumentPicker, onDismiss: @escaping () -> Void) {
                self.parent = parent
                self.onDismiss = onDismiss
            }

            func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
                onDismiss()
            }

            func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
                onDismiss()
            }
        }
    }

    
    
    private func generatePDFData() -> Data {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let leftMargin: CGFloat = 50
        let rightMargin: CGFloat = 50
        let topMargin: CGFloat = 50
        let bottomMargin: CGFloat = 50
        let contentWidth = pageWidth - leftMargin - rightMargin
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
            let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)] // Bold font for titles
            var yPosition: CGFloat = topMargin // Start at the top margin
            
            // Get and format the current date and time
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            let currentTime = dateFormatter.string(from: Date())
            
            
            // Function to draw text at a position
            func drawText(_ text: String, x: CGFloat, y: CGFloat) {
                  let rect = CGRect(x: x + leftMargin, y: y, width: contentWidth, height: 20)
                  text.draw(in: rect, withAttributes: attributes)
              }
            
            // Function to draw text at a position, adjusting for left margin
            func drawTextTitle(_ text: String, x: CGFloat, y: CGFloat, usingAttributes textAttributes: [NSAttributedString.Key: UIFont]) {
                let rect = CGRect(x: x + leftMargin, y: y, width: contentWidth, height: 20)
                text.draw(in: rect, withAttributes: textAttributes)
            }
            
            // Function to draw a line, adjusting for left and right margins
            func drawLine(from startPoint: CGPoint, to endPoint: CGPoint) {
                let path = UIBezierPath()
                path.move(to: CGPoint(x: startPoint.x + leftMargin, y: startPoint.y))
                path.addLine(to: CGPoint(x: endPoint.x - rightMargin, y: endPoint.y))
                path.stroke()
            }
            
            // Function to draw a vertical line
            func drawLineVertical(from startPoint: CGPoint, to endPoint: CGPoint) {
                let path = UIBezierPath()
                path.move(to: startPoint)
                path.addLine(to: endPoint)
                path.stroke()
            }
            
            // Function to check and handle new page creation
            func checkAndCreateNewPage() {
                if yPosition > (pageHeight - bottomMargin) {
                    context.beginPage() // Begin a new page
                    yPosition = topMargin // Reset yPosition to the top margin for the new page
                }
            }
            
            // Draw table for each inventory list
            let tables = [("COSCTO", itemsTable1, itemQuantities[0]), ("Nantel", itemsTable2, itemQuantities[1]), ("Gordon", itemsTable3, itemQuantities[2]), ("Fernando Chicken", itemsTable4, itemQuantities[3]), ("CARROUSEL", itemsTable5, itemQuantities[4]), ("PURE TEA", itemsTable6, itemQuantities[5])] // Add more tables as needed
            
            for (tableName, itemNames, quantities) in tables {
                checkAndCreateNewPage() // Check if a new page is needed before starting a new table
                
               // drawLineVertical(from: CGPoint(x: 300, y: 50), to: CGPoint(x: 300, y: pageHeight-50))
                
                // Draw Table Name using titleAttributes
                drawTextTitle("  \(tableName)", x: 20, y: yPosition, usingAttributes: titleAttributes)
                yPosition += 20
                
                checkAndCreateNewPage() // Check for new page after drawing the table name
                
                // Draw Table Headers
                drawText("  ITEM", x: (300 - 20)/2, y: yPosition)
                drawText("  QUANTITY", x: ((550 - 320)/2)+(550 - 320), y: yPosition)
                yPosition += 20
                
                checkAndCreateNewPage() // Check for new page after drawing the headers
                
                // Draw a line after the headers
                drawLine(from: CGPoint(x: 20, y: yPosition), to: CGPoint(x: 575, y: yPosition))
                yPosition += 7
                 
                // Draw the timestamp at the top of the page (adjust x and y as needed)
                drawTextTitle("Generated: \(currentTime)", x: 300, y: (topMargin - 30), usingAttributes: attributes)
                drawTextTitle("Done by: Baldwin", x: 300, y: (topMargin - 30)+15, usingAttributes: attributes)
                
                // Draw items and quantities
                for (index, itemName) in itemNames.enumerated() {
                    checkAndCreateNewPage() // Check for a new page before drawing each item
                    
                    drawLineVertical(from: CGPoint(x: 320, y: 50), to: CGPoint(x: 320, y: yPosition+30))
                    drawText("  \(itemName)", x: 20, y: yPosition - 8)
                    drawText("  \(quantities[index])", x: 310, y: yPosition - 8)
                    yPosition += 7
                    drawLine(from: CGPoint(x: 20, y: yPosition), to: CGPoint(x: 575, y: yPosition))
                    yPosition += 7
                }
                
                // Add some space before the next table
                yPosition += 30
            }
        }
        return data
    }
}



struct InventoryListView: View {
    var title: String
    var items: [InventoryItem]
    @Binding var quantities: [String] // Add this line
    @State private var titlePressed = false // Add this line to track the state
    @State private var isExiting = false // New state variable to track exiting status

    var body: some View {
        VStack(alignment: .center) {
            Button(action: {
                if isExiting {
                    self.titlePressed = false
                    self.isExiting = false
                } else {
                    self.titlePressed = true
                    self.isExiting = true
                    // After 5 seconds, set titlePressed back to false and navigate to the main view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.titlePressed = false
                        self.isExiting = false
                    }
                }
            }) {
                // Display the title or the 'EXIT' depending on whether the title has been pressed
                HStack {
                    if titlePressed {
                        Text("EXIT")
                            .font(.title)
                            .foregroundColor(.red)
                    } else {
                        Text(title)
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle()) // This makes the button look like regular text
            .foregroundColor(.primary) // Use the primary color for the button text
            
            inventoryGrid
        }
    }

    private var inventoryGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                Text("ITEM").fontWeight(.bold).italic()
                Text("QUANTITY").fontWeight(.bold).italic()
                ForEach(items.indices, id: \.self) { index in
                    itemRow(item: items[index], quantity: $quantities[index])
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private func itemRow(item: InventoryItem, quantity: Binding<String>) -> some View {
            Text(item.name)
            TextField("Quantity", text: quantity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numbersAndPunctuation) // Use appropriate keyboard type
        
    }
}


struct store_inv_Previews: PreviewProvider {
    static var previews: some View {
        store_inv(selectedTab: .constant(0), itemQuantities: .constant(Array(repeating: Array(repeating: "", count: 100), count: 6)))
     }
}
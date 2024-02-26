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
class ImageSaver: NSObject, ObservableObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        // handle the response, e.g., by updating some state or showing an alert
    }
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
    @StateObject private var imageSaver = ImageSaver()


    // Hard coded item tables
    let itemsTable0 = ["Hinnawi Cream Cheese (labneh) for CK"]
    let itemsTable1 = ["Salted Butter", "Unsalted Butter (for CK)", "Cream Cheese Philadelphia", "Canola Oil", "Olive oil", "White Vinegar", "Apple Cider Vinegar", "Ketchup", "Tabasco", "Soya Sauce", "Maple Syrup", "Eggs", "Capers", "Cajun", "Garlic Powder", "Onion Powder", "Pepper", "Salt", "Paprika", "Oregano", "Honey squeeze bottle for clients", "Cinnamon sticks", "Sparkling water Montellier", "San Pellagrino Aranciata", "San Pellagrino Arcianta Rossa", "San Pellagrino Limonata", "Gloves large","Brown paper", "Diswashing soap", "Hand soap", "Bon Ami glass cleaner", "Red basket wax paper (for CK)", "Black basket wax paper (for CK)", "Magic eraser", "Javel", "Stainless steel cleaner", "Yellow and green sponges", "Vanilla", "Walnuts", "Large Chocolate chips (milk chocolate)", "Large Chocolate chips (dark chocolate)", "Small milk chocolate chips", "Small dark chocolate chips", "Peanut butter", "Strawberry jam", "Vaccum bags 10-13 inches", "Vacuum bags 6-8 inches", "Metal scrubs", "Yellow and green sponges", "Coffee trays", "Plastic wrap", "Receipt thermal paper rolls", "Moneris thermal paper rolls", "Smoked meat"] // Up to 10 items
    let itemsTable3 = ["Almond milk", "Soy milk", "Coconut milk", "Macadamia milk", "Oat milk", "Vanilla syrup", "Caramel syrup", "Chocolate sauce", "Salt Buster", "Urnex powder for espresso machine", "Sanitizer"/*...*/] // Up to 20 items
    let itemsTable2 = ["Eggs", "Bacon maple leaf", "Tofu", "Salmon grizzly", "Veggie burger", "Mayonaise", "Dijon", "Sriratcha (only Dubé Loiselle good brand)", "Brown sugar", "White sugar", "Twin sugar/splenda", "Bouteilles d'eau", "Gutsy Le remontant", "Gutsy Le digestif", "Gutsy Flamboyant", "Gutsy Vitalité", "Milk 3% (per case of 9 bottles of 2L)", "Cream 10% (1L)", "Napkins Tork", "Cinamon sticks", "Degreaser pink product", "Grill cleaner ", "Desinfectant sanitizer", "Floor cleaner Pinosan", "Papier Pêche", "Honey Large Size", "Ham for CK ", "Turkey for CK", "Cheddar for CK", "Mozzarella for CK", "Hand towel Tork", "Wood ustentils (fork, spoon and knife)", "Straws", "Garbage bags", "Toilet paper", "Hair nets", "Coffee stirs", "Blue rags", "Coke", "Diet coke", "Nestea", "Sprite", "Ginger ale", "Orange juice", "Apple juice" /*...*/] // Up to 25 items
    let itemsTable4 = ["Chicke (For CK) packages left" /*...*/] // Up to 50 items
    let itemsTable5 = ["Large Brown Bags for bagels", "Small Brown Bags #12", " Clear bagel bags (5*3*15)", "Detergent for dishwasher", "Rince agent for dishwasher", "Mop heads"/*...*/] // Up to 50 items
    let itemsTable6 = ["Earl grey", "Masala chai", "Jasmin tea", "English breakfast", "Matcha powder", "Camomile", "Peppermint", "Cherry sencha", "Green sencha" /*...*/] // Up to 50 items
    let itemsTable7 = ["Chicken" /*...*/] // Up to 50 items
    let itemsTable8 = ["Chicken" /*...*/] // Up to 50 items
    // ... Additional tables if needed
    
    var body: some View {
            VStack {
                if isLoading {
                                   // Display a loading indicator when the PDF is being generated
                                   ProgressView("Generating PDF...")
                               } else {
                                   inventoryTables
                                   Button("Save as PDF") {
                                       saveQuantitiesAsPDF()
                                   }
                                   .padding()
                                   Text("*** THIS FEAUTURE IS UNDER DEVELOPMENT ***         -Baldwin")
                                       .italic()
                                       .foregroundColor(.red)
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
        
        // Convert PDF data to UIImage array and save to Photos
        if let images = pdfDataToImages(pdfData: pdfData) {
            for image in images {
                imageSaver.writeToPhotoAlbum(image: image)
            }
        }
        
        isLoading = false // End loading
    }


    private func pdfDataToImages(pdfData: Data) -> [UIImage]? {
        guard let provider = CGDataProvider(data: pdfData as CFData),
              let pdfDoc = CGPDFDocument(provider) else {
            return nil
        }

        var images = [UIImage]()
        let renderer = UIGraphicsImageRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // Or get this size from the actual PDF page size

        for pageNumber in 1...pdfDoc.numberOfPages {
            guard let page = pdfDoc.page(at: pageNumber) else { continue }
            let image = renderer.image { ctx in
                UIColor.white.set()
                ctx.fill(CGRect(x: 0, y: 0, width: 612, height: 792)) // Fill the context with white color

                ctx.cgContext.translateBy(x: 0.0, y: 792) // Adjust based on actual PDF page size
                ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

                ctx.cgContext.drawPDFPage(page)
            }
            images.append(image)
        }

        return images
    }

    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // We got back an error!
            showAlert(withTitle: "Save error", message: error.localizedDescription)
        } else {
            showAlert(withTitle: "Saved!", message: "Your inventory image has been saved to your photos.")
        }
    }

    private func showAlert(withTitle title: String, message: String) {
        // Show an alert with given title and message
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

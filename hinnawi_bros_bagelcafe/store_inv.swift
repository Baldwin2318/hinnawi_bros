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
    var quantityUnit: String
    var quantityVal: String
    
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
    
    
    @State private var itemQuantitiesUnitTable1: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesUnitTable2: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesUnitTable3: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesUnitTable4: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesUnitTable5: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesUnitTable6: [String] = Array(repeating: "", count: 100)
    
    @State private var itemQuantitiesValTable1: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesValTable2: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesValTable3: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesValTable4: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesValTable5: [String] = Array(repeating: "", count: 100)
    @State private var itemQuantitiesValTable6: [String] = Array(repeating: "", count: 100)
    
    @Binding var selectedTab: Int  // Use the binding to control the tab selection
    @Binding var itemQuantities: [[String]]  // Add this line
    @Binding var itemQuantitiesUnit: [[String]]  // Add this line
    @Binding var itemQuantitiesVal: [[String]]  // Add this line

    @State private var showDocumentPicker = false
    @State private var documentURL: URL?
    @State private var isLoading = false // For indicating PDF generation progress
    @StateObject private var imageSaver = ImageSaver()

    
    let inv_type = ["COSCTO", "NANTEL", "GORDON", "FERNANDO CHICKEN", "CARROURSEL", "PURE TEA"]
    

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
    @State private var showingSavePDFAlert = false
    @State private var showingResetPDFAlert = false
    
    @State private var animateLeftChevron = false
    @State private var animateRightChevron = false
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {

            VStack {
                
                if isLoading {
                                   // Display a loading indicator when the PDF is being generated
                                   ProgressView("Generating PDF...")
                               } else {
                                   HStack{
                                    Spacer()
                                       Button(action: {
                                           
                                               saveQuantitiesAsPDF()
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
                                                   DispatchQueue.main.async {
                                                               
                                                        itemQuantitiesTable1 = Array(repeating: "", count: 100)
                                                        itemQuantitiesTable2 = Array(repeating: "", count: 100)
                                                        itemQuantitiesTable3 = Array(repeating: "", count: 100)
                                                        itemQuantitiesTable4 = Array(repeating: "", count: 100)
                                                        itemQuantitiesTable5 = Array(repeating: "", count: 100)
                                                        itemQuantitiesTable6 = Array(repeating: "", count: 100)

                                                        // Resetting item quantities units for all tables
                                                        itemQuantitiesUnitTable1 = Array(repeating: "", count: 100)
                                                        itemQuantitiesUnitTable2 = Array(repeating: "", count: 100)
                                                        itemQuantitiesUnitTable3 = Array(repeating: "", count: 100)
                                                        itemQuantitiesUnitTable4 = Array(repeating: "", count: 100)
                                                        itemQuantitiesUnitTable5 = Array(repeating: "", count: 100)
                                                        itemQuantitiesUnitTable6 = Array(repeating: "", count: 100)

                                                        // Resetting item quantities values for all tables
                                                        itemQuantitiesValTable1 = Array(repeating: "", count: 100)
                                                        itemQuantitiesValTable2 = Array(repeating: "", count: 100)
                                                        itemQuantitiesValTable3 = Array(repeating: "", count: 100)
                                                        itemQuantitiesValTable4 = Array(repeating: "", count: 100)
                                                        itemQuantitiesValTable5 = Array(repeating: "", count: 100)
                                                        itemQuantitiesValTable6 = Array(repeating: "", count: 100)
                                                       
                                                       for index in itemQuantities.indices {
                                                           itemQuantities[index] = Array(repeating: "", count: 100)
                                                       }

                                                       for index in itemQuantitiesUnit.indices {
                                                           itemQuantitiesUnit[index] = Array(repeating: "", count: 100)
                                                       }

                                                       for index in itemQuantitiesVal.indices {
                                                           itemQuantitiesVal[index] = Array(repeating: "", count: 100)
                                                       }
                                                          }
                                               },
                                               secondaryButton: .cancel(Text("No"))
                                           )
                                       }
                                    
                                       Spacer()
                                       Button(action: {
                                           // Go to previous day
                                           if selectedTab > 0 {
                                               selectedTab -= 1
                                           } else {
                                               selectedTab = inv_type.count - 1 // Loop back to the last day
                                           }
                                       }) {
                                           Image(systemName: "chevron.left")
                                               .foregroundColor(.blue)
                                               .offset(x:0, y:0)
                                               .frame(width: 40)
                                               .offset(x: animateLeftChevron ? -5 : 0) // Move left and right
                                                   .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateLeftChevron)
                                                   .onAppear {
                                                       self.animateLeftChevron = true
                                                   }
                                       }
                                       TabView(selection: $selectedTab) {
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
                                           if selectedTab < inv_type.count - 1 {
                                               selectedTab += 1
                                           } else {
                                               selectedTab = 0 // Loop back to the first day
                                           }
                                       }) {
                                           Image(systemName: "chevron.right")
                                               .foregroundColor(.blue)
                                               .offset(x:0, y:0)
                                               .frame(width: 40)
                                               .opacity(animateRightChevron ? 0.5 : 1) // Change opacity to indicate animation
                                               .offset(x: animateRightChevron ? 0 : 5) // Move left and right
                                               .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animateRightChevron)
                                               .onAppear {
                                                   self.animateRightChevron = true
                                               }
                                       }
                                       Spacer()
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
                                   inventoryTables
                               }

            }.background(Color.white)
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
                InventoryItem(name: name, quantity: itemQuantitiesTable1[index], quantityUnit: itemQuantitiesUnitTable1[index], quantityVal: itemQuantitiesValTable1[index])
            }, quantities: $itemQuantities[0], quantitiesUnit: $itemQuantitiesUnit[0], quantitiesVal: $itemQuantitiesVal[0]).tag(0) // Pass the binding here
            InventoryListView(title: "Nantel", items: itemsTable2.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable2[index], quantityUnit: itemQuantitiesUnitTable2[index], quantityVal: itemQuantitiesValTable2[index])
            }, quantities: $itemQuantities[1], quantitiesUnit: $itemQuantitiesUnit[1], quantitiesVal: $itemQuantitiesVal[1]).tag(1) // Pass the binding here
            InventoryListView(title: "Gordon", items: itemsTable3.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable3[index], quantityUnit: itemQuantitiesUnitTable3[index], quantityVal: itemQuantitiesValTable3[index])
            }, quantities: $itemQuantities[2], quantitiesUnit: $itemQuantitiesUnit[2], quantitiesVal: $itemQuantitiesVal[2]).tag(2) // Pass the binding here
            InventoryListView(title: "Fernando Chicken", items: itemsTable4.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable4[index], quantityUnit: itemQuantitiesUnitTable4[index], quantityVal: itemQuantitiesValTable4[index])
            }, quantities: $itemQuantities[3], quantitiesUnit: $itemQuantitiesUnit[3], quantitiesVal: $itemQuantitiesVal[3]).tag(3) // Pass the binding here
            InventoryListView(title: "CARROUSEL", items: itemsTable5.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable5[index], quantityUnit: itemQuantitiesUnitTable5[index], quantityVal: itemQuantitiesValTable5[index])
            }, quantities: $itemQuantities[4], quantitiesUnit: $itemQuantitiesUnit[4], quantitiesVal: $itemQuantitiesVal[4]).tag(4) // Pass the binding here
            InventoryListView(title: "PURE TEA", items: itemsTable6.enumerated().map { index, name in
                InventoryItem(name: name, quantity: itemQuantitiesTable6[index], quantityUnit: itemQuantitiesUnitTable6[index], quantityVal: itemQuantitiesValTable6[index])
            }, quantities: $itemQuantities[5], quantitiesUnit: $itemQuantitiesUnit[5], quantitiesVal: $itemQuantitiesVal[5]).tag(5) // Pass the binding here
            // Repeat for other tables...
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Makes the TabView swipeable
        .animation(.default, value: selectedTab)
                   .gesture(
                       DragGesture().onEnded { gesture in
                           // Determine swipe direction
                           if gesture.translation.width < 0 && selectedTab < inv_type.count - 1 {
                               // Swiped left, go to next view
                               selectedTab += 1
                           } else if gesture.translation.width > 0 && selectedTab > 0 {
                               // Swiped right, go to previous view
                               selectedTab -= 1
                           }
                       }
                   )
    }
    
    // Save the inventory list with quantities as PDF
    private func saveQuantitiesAsPDF() {
        
       showingSavePDFAlert = true
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
            let tables = [("COSCTO", itemsTable1, itemQuantities[0], itemQuantitiesVal[0], itemQuantitiesUnit[0]), ("Nantel", itemsTable2, itemQuantities[1], itemQuantitiesVal[1], itemQuantitiesUnit[1]), ("Gordon", itemsTable3, itemQuantities[2], itemQuantitiesVal[2], itemQuantitiesUnit[2]), ("Fernando Chicken", itemsTable4, itemQuantities[3], itemQuantitiesVal[3], itemQuantitiesUnit[3]), ("CARROUSEL", itemsTable5, itemQuantities[4], itemQuantitiesVal[4], itemQuantitiesUnit[4]), ("PURE TEA", itemsTable6, itemQuantities[5], itemQuantitiesVal[5], itemQuantitiesUnit[5])] // Add more tables as needed
            
            for (tableName, itemNames, quantities, quantitiesVal, quantitiesUnit) in tables {
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
                    if !quantitiesUnit[index].isEmpty {
                        drawText("  \(quantities[index]) \(quantitiesVal[index]) \(quantitiesUnit[index]) unit", x: 310, y: yPosition - 8)
                    } else {
                        drawText("  \(quantities[index]) \(quantitiesVal[index]) \(quantitiesUnit[index])", x: 310, y: yPosition - 8)
                    }

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
    @Binding var quantitiesUnit: [String] // Add this line
    @Binding var quantitiesVal: [String] // Add this line
    @State private var titlePressed = false // Add this line to track the state
    @State private var isExiting = false // New state variable to track exiting status
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .center) {
//            HStack{
//                Text(title)
//                    .frame(maxWidth: .infinity, alignment: .center)
//                    .font(.system(size: 50))
//            }
            inventoryGrid
        }
    }

    private var inventoryGrid: some View {
        ScrollView {
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                HStack {
                    Text("QUANTITY").fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center) // Align to the left
                     Text("ITEM").fontWeight(.bold)
                         .frame(maxWidth: .infinity, alignment: .center) // Align to the left
                    Text("CONTROLS").fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center) // Align to the left
                 }
                 .background(Color.white) // Just for visibility, can be removed
                 
                ForEach(items.indices, id: \.self) { index in
                    let item = items[index]
                    itemRow(
                        item: item,
                        quantity: $quantities[index],
                        quantityUnit: $quantitiesUnit[index], 
                        quantityVal: $quantitiesVal[index]
                        )
                    
                }
            }
            .padding()
        }
    }

    
    var options: [String] = ["", "box", "case", "pack", "celo", "bag"]

    @State private var currentOptionIndex = 0
    @State private var currentOptionIndexes: [UUID: Int] = [:] // Assuming each item has a UUID as an identifier

    @ViewBuilder
    private func itemRow(item: InventoryItem, quantity: Binding<String>, quantityUnit: Binding<String>, quantityVal: Binding<String>) -> some View {
        VStack {
            
                @State var selectedOption: String = "-" // Default selection or use your logic to set
            @State var numericQuantity: Int = 0 // To store the numeric part of the quantity

            HStack {
                HStack{
                    if !quantity.wrappedValue.isEmpty {
                        TextField(" ", text: quantity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numbersAndPunctuation)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 35)
                            .foregroundColor(.blue)
                            .font(.system(size: 16)) // Use the specified font size
                            .disabled(true) // This disables the TextField
                            .background(Color.white.opacity(0)) // Set the background color to semi-transparent white
                            .cornerRadius(5) // Optional: Apply a corner radius to soften the edges
                            .overlay(
                                RoundedRectangle(cornerRadius: 5) // Match cornerRadius value
                                    .stroke(Color.white, lineWidth: 1) // Set the border color to white with a line width of 1
                            )

                        
                    }
                    if !quantityVal.wrappedValue.isEmpty {
                        
                        Text("\(quantityVal.wrappedValue)")
                            .foregroundColor(.blue)
                            .font(.system(size: 16))
                            .padding(.leading, -7) // Adjust padding as needed
                    }
                    if !quantityUnit.wrappedValue.isEmpty {
                        HStack{
                            TextField(" ", text: quantityUnit)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.blue)
                                .disabled(true) // This disables the TextField
                                .frame(width: 35)
                                .background(Color.white.opacity(0)) // Set the background color to semi-transparent white
                                .cornerRadius(5) // Optional: Apply a corner radius to soften the edges
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5) // Match cornerRadius value
                                        .stroke(Color.white, lineWidth: 1) // Set the border color to white with a line width of 1
                                )

                            Text("unit") // Display the "unit" label next to the TextField
                                .padding(.leading, -7) // Optional: Adjust padding as needed for visual alignment
                                .foregroundColor(.blue)
                        }
                    }
                }
                .frame(width: 200)
                Rectangle()
                    .frame(width: 1, height: 120) // Adjust width for line thickness and height for line length
                    .foregroundColor(.gray.opacity(0.5)) // Change the color of the line as needed
            
                Text(item.name)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading) // Make the name take up all available space
                Rectangle()
                    .frame(width: 1, height: 120) // Adjust width for line thickness and height for line length
                    .foregroundColor(.gray.opacity(0.5)) // Change the color of the line as needed
            

                Button(action: {
                    // Action to decrease quantity
                    let currentQuantityUnit = Int(quantityUnit.wrappedValue) ?? 0 // Fallback to 0 if conversion fails
                    let updatedQuantityUnit = max(currentQuantityUnit - 1, 0) // Ensure not going below 0
                    quantityUnit.wrappedValue = String(updatedQuantityUnit) // Update the binding with the new string value
                    }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 30)) // Use the desired size
                        .foregroundColor(!quantity.wrappedValue.isEmpty && quantityVal.wrappedValue.isEmpty ? .white.opacity(0.1) : .gray) // White if disabled, gray otherwise

                }
                .disabled(!quantity.wrappedValue.isEmpty && quantityVal.wrappedValue.isEmpty) // Disable if conditions are met

                Button(action: {
                    // Action to decrease quantity
                    let currentQuantity = Int(quantity.wrappedValue) ?? 0 // Fallback to 0 if conversion fails
                          let updatedQuantity = currentQuantity - 1
                          quantity.wrappedValue = String(updatedQuantity) // Update the binding with the new string value
                   
                }) {
                    Image(systemName: "minus.circle.fill")
                    
                    .foregroundColor(.red) // White if disabled, gray otherwise
                        .font(.system(size: 60)) // Use the desired size
                }
                .disabled(quantity.wrappedValue.isEmpty && quantityVal.wrappedValue.isEmpty && !quantityUnit.wrappedValue.isEmpty) // Disable if conditions are met
           
                Button(action: {
                    // Action to increase quantity
                    let currentQuantity = Int(quantity.wrappedValue) ?? 0 // Fallback to 0 if conversion fails
                          let updatedQuantity = currentQuantity + 1
                          quantity.wrappedValue = String(updatedQuantity) // Update the binding with the new string value
                   
                }) {
                    Image(systemName: "plus.circle.fill") // Corrected to plus.circle.fill for increase
                    
                    .foregroundColor(.green) // White if disabled, gray otherwise
                        .font(.system(size: 60)) // Use the desired size
                }
                .disabled(quantity.wrappedValue.isEmpty && quantityVal.wrappedValue.isEmpty && !quantityUnit.wrappedValue.isEmpty) // Disable if conditions are met
                 
                Button(action: {
                    // Action to increase quantity
                    let currentQuantityUnit = Int(quantityUnit.wrappedValue) ?? 0 // Fallback to 0 if conversion fails
                          let updatedQuantityUnit = currentQuantityUnit + 1
                          quantityUnit.wrappedValue = String(updatedQuantityUnit)  // Update the binding with the new string value
                   
                }) {
                    Image(systemName: "plus.circle.fill") // Corrected to plus.circle.fill for increase
                        .foregroundColor(.gray)
                        .font(.system(size: 30)) // Use the desired size
                        .foregroundColor(!quantity.wrappedValue.isEmpty && quantityVal.wrappedValue.isEmpty ? .white.opacity(0.1) : .gray) // White if disabled, gray otherwise
                }
                .disabled(!quantity.wrappedValue.isEmpty && quantityVal.wrappedValue.isEmpty) // Disable if conditions are met
                
                Rectangle()
                    .frame(width: 1, height: 150) // Adjust width for line thickness and height for line length
                    .foregroundColor(quantity.wrappedValue.isEmpty && quantityUnit.wrappedValue.isEmpty ? .white.opacity(0.1) : .gray.opacity(0.5)) // White if disabled, gray otherwise
                
                Button(action: {
                    // Increment the currentOptionIndex, cycling back to 0 if at the end of the options array
                    currentOptionIndex = (currentOptionIndex + 1) % options.count
                    quantityVal.wrappedValue = options[currentOptionIndex]
                    print(options[currentOptionIndex])
                }) {
                    // Display the current option for this item
                    Image(systemName: "arrow.2.circlepath") // SF Symbol for cycling
                            
                        .foregroundColor(quantity.wrappedValue.isEmpty && quantityUnit.wrappedValue.isEmpty ? .white.opacity(0.1) : .blue) // White if disabled, gray otherwise

                        .font(.system(size: 20))
                }
                .disabled(quantity.wrappedValue.isEmpty && quantityUnit.wrappedValue.isEmpty) // Disable if conditions are met

               // .disabled((options) && !quantityUnit.wrappedValue.isEmpty)
            }
            
            Rectangle()
                .frame(height: 1) // Adjust the height for the thickness of the line
                .foregroundColor(.gray.opacity(0.5)) // Adjust the color as needed
        }
    }

}


struct store_inv_Previews: PreviewProvider {
    static var previews: some View {
        store_inv(selectedTab: .constant(0), itemQuantities: .constant(Array(repeating: Array(repeating: "", count: 100), count: 6)), itemQuantitiesUnit: .constant(Array(repeating: Array(repeating: "", count: 100), count: 6)), itemQuantitiesVal: .constant(Array(repeating: Array(repeating: "", count: 100), count: 6)))
     }
}

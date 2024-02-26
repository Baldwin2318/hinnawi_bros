//
//  PastryToPrepView.swift
//  hinnawi_bros_bagelcafe
//
//  Created by Baldwin Kiel Malabanan on 2024-02-20.
//

import Foundation
import SwiftUI

class PastryItemToPrep: Identifiable { // Ensure it conforms to Identifiable
    let id = UUID()
    var name: String
    var quantity: Int

    init(name: String, quantity: Int) {
        self.name = name
        self.quantity = quantity
    }
}
class PastryToPrepViewModel: ObservableObject {
    // Marking the items array as @Published so the view refreshes on updates
    @Published var pastries: [PastryItemToPrep] = [
        PastryItemToPrep(name: "Banana bread with nut", quantity: 0),
        PastryItemToPrep(name: "Banana bread without nut", quantity: 0),
        PastryItemToPrep(name: "Vegan brownie", quantity: 0),
        PastryItemToPrep(name: "Cinnamon muffins", quantity: 0),
        PastryItemToPrep(name: "Chocolate cake", quantity: 0),
        PastryItemToPrep(name: "Red velvet cake", quantity: 0),
        PastryItemToPrep(name: "Lemon poppy cake", quantity: 0),
        PastryItemToPrep(name: "Chocolate chip cookie", quantity: 0),
        PastryItemToPrep(name: "Chocolate and walnuts cookie", quantity: 0),
        PastryItemToPrep(name: "Berries cookie", quantity: 0),
        PastryItemToPrep(name: "Double chocolate cookie", quantity: 0),
        PastryItemToPrep(name: "Croissant", quantity: 0),
        PastryItemToPrep(name: "Chocolatine", quantity: 0),
        PastryItemToPrep(name: "Croissant aux amandes", quantity: 0),
        // ... add other items
    ]
    // Add methods to increment and decrement quantity that will update the @Published pastries array
    func incrementQuantity(for pastry: PastryItemToPrep) {
        if let index = pastries.firstIndex(where: { $0.id == pastry.id }) {
            pastries[index].quantity += 1
            // Triggering an update by making a change to the array
            pastries[index] = pastries[index]
        }
    }
    
    func decrementQuantity(for pastry: PastryItemToPrep) {
        if let index = pastries.firstIndex(where: { $0.id == pastry.id }), pastries[index].quantity > 0 {
            pastries[index].quantity -= 1
            // Triggering an update by making a change to the array
            pastries[index] = pastries[index]
        }
    }
    
}

struct PastryToPepView: View {
    @ObservedObject var viewModel = PastryToPrepViewModel()
    
    var body: some View {
        VStack{
            Text("*** THIS FEATURE IS UNDER DEVELOPMENT.        -Baldwin ***")
                .foregroundColor(.red)
                .italic()
            controlButtons
            List {
                ForEach(viewModel.pastries) { pastry in
                    HStack {
                        Text(pastry.name)
                            .font(.system(size: 22, weight: .regular)) // Customize font size and weight
                        Spacer()
                        // Minus button
                        Button(action: {
                            viewModel.decrementQuantity(for: pastry)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Removes the default button styling that might interfere with the tap
                        Text("\(pastry.quantity)")
                            .font(.system(size: 22, weight: .regular)) // Customize font size and weight
                            .frame(minWidth: 50, alignment: .center)
                        // Plus button
                        Button(action: {
                            viewModel.incrementQuantity(for: pastry)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                        }
                        .buttonStyle(BorderlessButtonStyle()) // Removes the default button styling that might interfere with the tap
                    }
                    .buttonStyle(PlainButtonStyle()) // Apply to the whole row to prevent row selection style
                }
            }
            VStack{
                Button(action: {
                    //edit
                }) {
                    Image(systemName: "gearshape")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                }
            }
            VStack{
                Text("Add/Remove item")
                    .foregroundColor(.blue)
            }
        }
        
        .background(Color.yellow)
        

    }
    private var controlButtons: some View {
        HStack {
            Button(action: {
                
            }) {
                Text("Save")
                    .frame(width: 90, height: 50)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            Button(action: {
            }) {
                Text("Clear")
                    .frame(width: 90, height: 50)
                    .foregroundColor(.white)
                    .background(Color.orange.opacity(0.8))
                    .cornerRadius(10)
            }
            Spacer()
            Text("Pastries Production").bold()
                .foregroundColor(.blue)
                .font(.system(size: 30, weight: .heavy)) // Customize font size and weight
            Spacer()
            Button("X") {
                
            }
            .frame(width: 60, height: 60)
            .font(.system(size: 50))
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(20)
        }
        .padding()
    }
}

struct PastryToPepView_Previews: PreviewProvider {
    static var previews: some View {
        PastryToPepView()
    }
}

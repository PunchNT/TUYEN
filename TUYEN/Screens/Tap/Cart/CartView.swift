import SwiftUI

struct CartView: View {
    
    @State private var items: [ShoppingItem] = [
        ShoppingItem(name: "Eggs", quantity: "10", unit: "units"),
        ShoppingItem(name: "Minced pork", quantity: "500", unit: "g"),
        ShoppingItem(name: "Fish sauce", quantity: "1", unit: "bottle"),
        ShoppingItem(name: "Lettuce", quantity: "1", unit: "head")
    ]
    
    @State private var showPopup = false
    
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing:20) {
                    
                    // TITLE
                    HStack {
                        Text("Shopping List 🛒")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    
                    ScrollView {
                        
                        VStack(spacing:15) {
                            
                            ForEach($items) { $item in
                                ShoppingRow(item: $item)
                            }
                            
                            
                            // ADD ITEM
                            Button {
                                showPopup = true
                            } label: {
                                
                                Text("+ Add item")
                                    .frame(maxWidth:.infinity)
                                    .padding()
                                    .foregroundColor(.gray)
                                    .overlay(
                                        RoundedRectangle(cornerRadius:15)
                                            .stroke(style: StrokeStyle(lineWidth:1, dash:[5]))
                                            .foregroundColor(.gray)
                                    )
                            }
                            .padding(.top,5)
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    // MAP BUTTON
                    NavigationLink {
                        MapMarket()
                    } label: {
                        
                        Text("Map")
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    .padding(.bottom,10)
                }
                
                
                if showPopup {
                    AddIngredientPopupView(items: $items, showPopup: $showPopup)
                }
            }
        }
    }
}

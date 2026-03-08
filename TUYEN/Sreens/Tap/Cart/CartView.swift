import SwiftUI

struct CartView: View {
    
    @State private var items: [ShoppingItem] = [
        ShoppingItem(name: "Eggs", quantity: "10", unit: "units"),
        ShoppingItem(name: "Minced pork", quantity: "500", unit: "g"),
        ShoppingItem(name: "Fish sauce", quantity: "1", unit: "bottle")
    ]
    
    @State private var showPopup = false
    
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Color.gray.opacity(0.1).ignoresSafeArea()
                
                VStack(spacing:20) {
                    
                    VStack(alignment:.leading, spacing:20) {
                        
                        Text("Shopping List 🛒")
                            .font(.largeTitle)
                            .bold()
                        
                        
                        ForEach($items) { $item in
                            
                            HStack(spacing:15) {
                                
                                Button {
                                    item.isChecked.toggle()
                                } label: {
                                    
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray,lineWidth:2)
                                            .frame(width:26,height:26)
                                        
                                        if item.isChecked {
                                            Circle()
                                                .fill(Color.green)
                                                .frame(width:16,height:16)
                                        }
                                    }
                                }
                                
                                
                                VStack(alignment:.leading) {
                                    
                                    Text(item.name)
                                        .font(.title3)
                                        .bold()
                                    
                                    Text("\(item.quantity) \(item.unit)")
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius:2)
                        }
                        
                        
                        // ADD ITEM
                        Button {
                            showPopup = true
                        } label: {
                            
                            HStack {
                                Spacer()
                                
                                Text("+ Add item")
                                    .foregroundColor(.gray)
                                    .font(.title3)
                                
                                Spacer()
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius:15)
                                    .stroke(style:StrokeStyle(lineWidth:1,dash:[5]))
                                    .foregroundColor(.gray)
                            )
                        }
                        
                        
                        Spacer()
                        
                        
                        // MAP BUTTON
                        NavigationLink {
                            MapMarket()
                        } label: {
                            
                            Text("Map")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                                .frame(maxWidth:.infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius:25)
                            .fill(Color.white)
                    )
                    .padding()
                    
                }
                
                
                if showPopup {
                    AddIngredientPopup(items: $items, showPopup: $showPopup)
                }
            }
        }
    }
}



struct ShoppingItem: Identifiable {
    let id = UUID()
    var name: String
    var quantity: String
    var unit: String
    var isChecked: Bool = false
}

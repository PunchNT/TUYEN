import SwiftUI

struct AddIngredientPopupView: View {
    
    @Binding var items: [ShoppingItem]
    @Binding var showPopup: Bool
    
    @State private var name = ""
    @State private var quantity = ""
    @State private var unit = ""
    
    
    var body: some View {
        
        ZStack {
            
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing:20) {
                
                Text("Ingredient")
                    .font(.title)
                    .bold()
                
                TextField("Lettuce", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    
                    VStack(alignment:.leading) {
                        Text("Quantity")
                        TextField("1", text: $quantity)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment:.leading) {
                        Text("Unit")
                        TextField("head", text: $unit)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                
                HStack {
                    
                    Button {
                        
                        items.append(
                            ShoppingItem(
                                name: name,
                                quantity: quantity,
                                unit: unit
                            )
                        )
                        
                        showPopup = false
                        
                    } label: {
                        
                        Text("OK")
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    
                    Button {
                        showPopup = false
                    } label: {
                        
                        Text("Cancel")
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding(40)
        }
    }
}

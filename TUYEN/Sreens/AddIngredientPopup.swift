import SwiftUI

struct AddIngredientPopup: View {
    
    @Binding var show: Bool
    
    @State private var ingredient = ""
    @State private var quantity = ""
    @State private var expire = ""
    
    var body: some View {
        
        ZStack {
            
            // background blur
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        show = false
                    }
                }
            
            
            VStack(spacing:20){
                
                Text("Ingredient")
                    .font(.title2)
                    .fontWeight(.bold)
                
                
                TextField("Cheese", text: $ingredient)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                
                
                HStack(spacing:15){
                    
                    VStack(alignment:.leading){
                        
                        Text("Quantity")
                            .fontWeight(.semibold)
                        
                        TextField("3 sheets", text: $quantity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    
                    VStack(alignment:.leading){
                        
                        Text("Expiration date")
                            .fontWeight(.semibold)
                        
                        TextField("8", text: $expire)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                
                
                HStack(spacing:15){
                    
                    Button {
                        withAnimation(.spring()) {
                            show = false
                        }
                    } label: {
                        
                        Text("OK")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.green,.mint],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius:5)
                    }
                    
                    
                    Button {
                        withAnimation(.spring()) {
                            show = false
                        }
                    } label: {
                        
                        Text("Cancel")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.red,.orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius:5)
                    }
                }
                
            }
            .padding(25)
            .background(Color.white)
            .cornerRadius(22)
            .shadow(radius:25)
            .padding(.horizontal,30)
            .transition(.scale)
        }
    }
}

#Preview {
    AddIngredientPopup(show: .constant(true))
}

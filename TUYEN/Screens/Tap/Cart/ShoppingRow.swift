import SwiftUI

struct ShoppingRow: View {
    
    @Binding var item: ShoppingItem
    
    var body: some View {
        
        HStack(spacing:15) {
            
            Button {
                item.isChecked.toggle()
            } label: {
                
                ZStack {
                    Circle()
                        .stroke(Color.gray,lineWidth:2)
                        .frame(width:25,height:25)
                    
                    if item.isChecked {
                        Image(systemName:"checkmark")
                            .font(.system(size:12,weight:.bold))
                    }
                }
            }
            
            
            VStack(alignment:.leading,spacing:3) {
                
                Text(item.name)
                    .font(.headline)
                
                Text("\(item.quantity) \(item.unit)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color:.black.opacity(0.05),radius:5,y:3)
    }
}

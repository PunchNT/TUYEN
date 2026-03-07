import SwiftUI

struct IngredientCard: View {
    
    var name:String
    var remain:String
    var day:String
    var color:Color
    
    var body: some View {
        
        HStack {
            
            Rectangle()
                .fill(color)
                .frame(width:5)
            
            
            VStack(alignment:.leading){
                
                Text(name)
                    .font(.headline)
                
                Text(remain)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(day)
                .font(.caption)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            
            Circle()
                .stroke(Color.gray,lineWidth:1)
                .frame(width:24,height:24)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color:.black.opacity(0.05),radius:5)
    }
}

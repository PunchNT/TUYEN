import SwiftUI

struct FoodCard: View {
    
    var name:String
    var remain:String
    var day:String
    var color:Color
    
    var body: some View {
        
        HStack{
            
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
                .padding(6)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(6)
            
            Circle()
                .stroke(Color.gray.opacity(0.5),lineWidth:1)
                .frame(width:22,height:22)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color:.black.opacity(0.08),radius:4)
    }
}

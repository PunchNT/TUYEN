import SwiftUI

struct FilterButton: View {
    
    var title: String
    @Binding var selected: String
    
    var body: some View {
        
        Button {
            selected = title
        } label: {
            
            Text(title)
                .padding(.horizontal,15)
                .padding(.vertical,8)
                .background(selected == title ? Color.green : Color.white)
                .foregroundColor(selected == title ? .white : .black)
                .cornerRadius(20)
                .shadow(radius:1)
        }
    }
}

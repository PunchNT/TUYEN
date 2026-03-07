import SwiftUI

struct GoalButton: View {
    
    var title: String
    var isSelected: Bool
    
    var body: some View {
        
        Text(title)
            .fontWeight(.semibold)
            .foregroundColor(isSelected ? .white : .black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color.green : Color.gray.opacity(0.2))
            .cornerRadius(12)
    }
}

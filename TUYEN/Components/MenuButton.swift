import SwiftUI

struct MenuButton: View {
    
    var icon: String
    var title: String
    var isActive: Bool
    
    var body: some View {
        
        VStack(spacing: 6) {
            
            Image(systemName: isActive ? icon + ".fill" : icon)
                .font(.system(size: 22))
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
        }
        .foregroundColor(isActive ? Color.green : Color.gray)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MenuButton(icon: "house", title: "TuYen", isActive: true)
}

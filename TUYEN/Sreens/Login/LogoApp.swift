import SwiftUI

struct LogoApp: View {
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image("tuyen_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 170)
            
            Text("TuYen")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.green)
            
            Spacer()
        }
    }
}

#Preview {
    LogoApp()
}

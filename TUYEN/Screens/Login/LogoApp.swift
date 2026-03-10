import SwiftUI

struct LogoApp: View {
    
    @State private var logoOpacity = 0.0
    
    var body: some View {
        
        ZStack {
            
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                
                Image("tuyenlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                
                Text("TUYEN")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.green)
                
            }
            .opacity(logoOpacity)
            
        }
        .onAppear {
            
            withAnimation(.easeIn(duration: 1.2)) {
                logoOpacity = 1
            }
            
        }
        
    }
}

#Preview {
    LogoApp()
}

import SwiftUI

struct ContentView: View {
    
    @State private var showSplash = true
    @State private var isLoggedIn = false
    
    var body: some View {
        
        if showSplash {
            
            LogoApp()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSplash = false
                    }
                }
            
        } else {
            
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

#Preview {
    ContentView()
}

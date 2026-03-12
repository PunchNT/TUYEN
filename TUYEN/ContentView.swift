import SwiftUI

struct ContentView: View {
    
    @State private var showSplash = true
    
    // 🌟 แก้ไข: เปลี่ยนจาก @State เป็น @AppStorage
    // เพื่อให้มันลิงก์กับตัวแปรใน LoginView อัตโนมัติ
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
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
                // 🌟 แก้ไข: ลบพารามิเตอร์ข้างในออก เรียกแค่ LoginView() เฉยๆ
                // เพราะตอนนี้ทั้งสองหน้าแชร์ @AppStorage ตัวเดียวกันแล้ว
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}

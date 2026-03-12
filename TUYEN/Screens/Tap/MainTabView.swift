import SwiftUI

struct MainTabView: View {
    // 🌟 ควบคุมว่าจะให้โชว์แท็บไหนจากตัวแปรนี้
    @AppStorage("selectedTab") var selectedTab = 0
    
    var body: some View {
        // 🌟 ใส่ selection: $selectedTab เพื่อผูกการเปลี่ยนหน้า
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("TuYen", systemImage: "refrigerator")
            }
            .tag(0) // แท็บที่ 0
            
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(1) // แท็บที่ 1
            
            NavigationStack {
                HistoriesView()
            }
            .tabItem {
                Label("Histories", systemImage: "clock.arrow.circlepath")
            }
            .tag(2) // แท็บที่ 2 (เราจะเด้งมาหน้านี้)
            
            NavigationStack {
                CartView()
            }
            .tabItem {
                Label("Cart", systemImage: "cart")
            }
            .tag(3) // แท็บที่ 3
            
            NavigationStack {
                Personal()
            }
            .tabItem {
                Label("Personal", systemImage: "person")
            }
            .tag(4) // แท็บที่ 4
        }
        .tint(.green)
    }
}

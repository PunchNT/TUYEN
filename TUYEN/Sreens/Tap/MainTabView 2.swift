import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Tab 1: หน้าหลัก (TuYen)
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("TuYen", systemImage: "refrigerator")
            }
            
            // Tab 2: ค้นหา
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            // Tab 3: ประวัติ
            NavigationStack {
                HistoriesView()
            }
            .tabItem {
                Label("Histories", systemImage: "clock.arrow.circlepath")
            }
            
            // Tab 4: รถเข็น
            NavigationStack {
                CartView()
            }
            .tabItem {
                Label("Cart", systemImage: "cart")
            }
            
            // Tab 5: ส่วนตัว
            NavigationStack {
                Personal()
            }
            .tabItem {
                Label("Personal", systemImage: "person")
            }
        }
        .tint(.green) // สีเขียวตามดีไซน์
    }
}

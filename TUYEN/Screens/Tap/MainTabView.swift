import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        
        TabView {
            
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("TuYen", systemImage: "refrigerator")
            }
            
            
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            
            NavigationStack {
                HistoriesView()
            }
            .tabItem {
                Label("Histories", systemImage: "clock.arrow.circlepath")
            }
            
            
            NavigationStack {
                CartView()
            }
            .tabItem {
                Label("Cart", systemImage: "cart")
            }
            
            
            NavigationStack {
                Personal()
            }
            .tabItem {
                Label("Personal", systemImage: "person")
            }
        }
        .tint(.green)
    }
}

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "refrigerator")
                    Text("TuYen")
                }
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            HistoriesView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("Histories")
                }
            
            CartView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
            
            PersonalView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Personal")
                }
        }
        .tint(.green)
    }
}

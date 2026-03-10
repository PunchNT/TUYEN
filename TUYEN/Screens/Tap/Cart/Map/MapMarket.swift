import SwiftUI
import MapKit

struct MapMarket: View {
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 13.7299,
            longitude: 100.775
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )
    
    @State private var selectedFilter = "Market near me"
    
    
    var body: some View {
        
        ZStack {
            
            // MAP
            Map(coordinateRegion: $region)
                .ignoresSafeArea()
            
            
            VStack(spacing:10) {
                
                // TITLE (เปลี่ยนตามปุ่มที่กด)
                HStack {
                    
                    Text(selectedFilter)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top,10)
                
                
                // FILTER BUTTONS
                ScrollView(.horizontal, showsIndicators:false) {
                    
                    HStack(spacing:10) {
                        
                        FilterButton(
                            title: "Market near me",
                            selected: $selectedFilter
                        )
                        
                        FilterButton(
                            title: "Big C near me",
                            selected: $selectedFilter
                        )
                        
                        FilterButton(
                            title: "Makro near me",
                            selected: $selectedFilter
                        )
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.top,5)
        }
    }
}

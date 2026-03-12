import SwiftUI
import MapKit
import CoreLocation
import Combine

struct MapMarket: View {
    
    @Environment(\.dismiss) var dismiss
    
    // ซูมใกล้ตั้งแต่เปิด
    @State private var position: MapCameraPosition = .userLocation(
        fallback: .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 13.7563, longitude: 100.5018),
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        )
    )
    
    @State private var selectedFilter = "Market near me"
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedPlace: MKMapItem?
    
    // Card
    @State private var showCard = false
    @State private var selectedItem: MKMapItem?
    
    @StateObject private var locationManager = LocationManager()
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            // ---------------- MAP ----------------
            Map(position: $position, selection: $selectedPlace) {
                
                UserAnnotation()
                
                ForEach(searchResults, id: \.self) { item in
                    
                    Marker(item.name ?? "", coordinate: item.placemark.coordinate)
                        .tint(.green)
                        .tag(item)
                }
            }
            .ignoresSafeArea()
            .mapControls {
                MapUserLocationButton()
            }
            
            
            // ---------------- HEADER ----------------
            VStack(spacing: 10) {
                
                HStack(spacing: 15) {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Text(selectedFilter)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .background(.ultraThinMaterial)
                
                
                // ---------------- FILTER ----------------
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 10) {
                        
                        FilterButton(title: "Market near me", selected: $selectedFilter)
                        FilterButton(title: "Big C near me", selected: $selectedFilter)
                        FilterButton(title: "Makro near me", selected: $selectedFilter)
                        
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            
            // ---------------- MARKET CARD ----------------
            if showCard, let item = selectedItem {
                
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(item.name ?? "Market")
                            .font(.headline)
                        
                        Text(item.placemark.title ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        
                        // ระยะทาง
                        if let userLocation = locationManager.location {
                            
                            let distance = userLocation.distance(
                                from: CLLocation(
                                    latitude: item.placemark.coordinate.latitude,
                                    longitude: item.placemark.coordinate.longitude
                                )
                            )
                            
                            Text(String(format: "%.1f km away", distance / 1000))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        
                        HStack {
                            
                            Button("Cancel") {
                                showCard = false
                            }
                            
                            Spacer()
                            
                            Button("Navigate") {
                                openInMaps(item)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding()
                    
                }
                .animation(.easeInOut, value: showCard)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        
        
        // ---------------- FIRST LOAD ----------------
        .onAppear {
            searchPlaces(query: "market")
        }
        
        
        // ---------------- FILTER CHANGE ----------------
        .onChange(of: selectedFilter) { _, newValue in
            
            let keyword = newValue.replacingOccurrences(of: " near me", with: "")
            searchPlaces(query: keyword)
        }
        
        
        // ---------------- PIN TAP ----------------
        .onChange(of: selectedPlace) { _, place in
            
            if let place {
                selectedItem = place
                showCard = true
            }
        }
    }
    
    
    // ---------------- SEARCH FUNCTION ----------------
    func searchPlaces(query: String) {
        
        guard let userLocation = locationManager.location else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        request.region = MKCoordinateRegion(
            center: userLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        Task {
            
            let search = MKLocalSearch(request: request)
            
            do {
                
                let response = try await search.start()
                
                await MainActor.run {
                    searchResults = response.mapItems
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    // ---------------- OPEN APPLE MAPS ----------------
    func openInMaps(_ item: MKMapItem) {
        
        let options = [
            MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving
        ]
        
        item.openInMaps(launchOptions: options)
    }
}


// ---------------- LOCATION MANAGER ----------------
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        location = locations.first
    }
}

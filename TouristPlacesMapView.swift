import Foundation
import SwiftUI
import CoreLocation
import MapKit


struct AlternateView: View {
    var location: Location
    @Environment(\.presentationMode) var presentationMode
    @State private var region: MKCoordinateRegion
    
    init(location: Location) {
        self.location = location
        _region = State(initialValue: MKCoordinateRegion(center: location.coordinates, latitudinalMeters: 600, longitudinalMeters: 600))
    }
    
    var body: some View {
        ScrollView{
            VStack {
                HStack{
                    Spacer()
                    Label("Dismiss", systemImage: "xmark")
                        .font(.title3)
                        .foregroundColor(Color.blue)
                        .padding()
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                
                Image(location.imageNames.first ?? "Image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                
                Text(location.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Description: \(location.description)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .padding()
                
                Text("Website: \(location.link)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                Map(coordinateRegion: $region, showsUserLocation: false, userTrackingMode: .none, annotationItems: [location]) { place in
                    MapPin(coordinate: place.coordinates, tint: .red)
                }
                .cornerRadius(10)
                .frame(height: 300)
                
            }
            .padding()
        }
    }
}

struct TouristPlacesMapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State private var locations: [Location] = []
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574), latitudinalMeters: 600, longitudinalMeters: 600)
    @State private var filteredLocations: [Location] = []
    @State private var selectedLocation: Location?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 5) {
                    if weatherMapViewModel.coordinates != nil {
                        VStack(spacing: 10) {
                            Map(coordinateRegion: $weatherMapViewModel.region, showsUserLocation: false, userTrackingMode: .none, annotationItems: filteredLocations) { place in
                                MapAnnotation(coordinate: place.coordinates) {
                                    VStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.red)
                                        Text(place.name)
                                            .font(.footnote)
                                    }
                                }
                            }
                            .cornerRadius(10)
                        }
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 600)
                        
                        VStack {
                            Text("Tourist Attractions in \(weatherMapViewModel.city)")
                        }
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.title)
                        .fontWeight(.bold)
                    }
                }
                
                List {
                    ForEach(filteredLocations) { location in
                        VStack {
                            HStack {
                                Image(location.imageNames.first ?? "Image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                Text("\(location.name)")
                                    .font(.headline)
                            }
                            .onTapGesture {
                                selectedLocation = location
                            }
                            .sheet(item: $selectedLocation) { location in
                                AlternateView(location: location)
                            }
                        }
                        .padding()
                    }
                }
                .frame(height: 700)
                .padding()
                
            }
            .onAppear {
                // Load tourist places when the view appears
                loadTouristPlaces()
                // Set annotations when the view appears
                Task {
                    do {
                        try await setAnnotations()
                    } catch {
                        print("Error setting annotations: \(error)")
                    }
                }
            }
        }
    }
    
    // Function to load tourist places, update locations, and filter them based on distance
    private func loadTouristPlaces() {
        let touristPlaces: [Location] = weatherMapViewModel.loadLocationsFromJSONFile(cityName: weatherMapViewModel.city) ?? []
        
        // Update the locations
        locations = touristPlaces
        
        // Filter the locations based on distance from the center of the map region
        if let centerCoordinate = weatherMapViewModel.coordinates {
            let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
            filteredLocations = locations.filter { location in
                let locationCoordinate = location.coordinates
                let locationLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
                let distance = centerLocation.distance(from: locationLocation)
                return distance <= weatherMapViewModel.region.span.latitudeDelta * 11100000 // Convert latitudeDelta to meters
            }
        }
        
        if let selectedLocation = selectedLocation {
            weatherMapViewModel.region.center = selectedLocation.coordinates
        }
    }
    
    private func setAnnotations() async throws {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "tourist places"
        request.region = weatherMapViewModel.region
        
        let search = MKLocalSearch(request: request)
        if let results = try? await search.start() {
            let items = results.mapItems
            print(items.count)
            for item in items {
                print("1. Coordinate:   ", item.placemark.coordinate)
                print("2. Name:   ", item.name ?? "undefined")
                print("3. Item:   ", item)
                print("4. Address:  ", item.placemark.thoroughfare ?? "Undefined")
            }
            DispatchQueue.main.async {
                self.weatherMapViewModel.annotations = items.map { item in
                    PlaceAnnotation(name: item.name ?? "Undefined", location: item.placemark.coordinate)
                }
            }
        }
    }
}



import SwiftUI
import MapKit

// Data Model
struct RiverOutfitter: Identifiable {
    let id = UUID()
    let name: String
    let neighborhood: String
    let description: String
    let price: String
    let address: String
    let lat: Double
    let long: Double
    let imageName: String
}

// Example data
let outfitters = [
    RiverOutfitter(name: "Lion's Club", neighborhood: "TXST", description: "Relaxing escape in the San Marcos river. Float time lasts an hour and ends at Rio Vista Falls.", price: "Adult Tube: $25", address: "170 Charles Austin Dr, San Marcos, TX", lat: 29.88595, long: -97.93500, imageName: "lions"),
    RiverOutfitter(name: "Texas State Tubes", neighborhood: "San Marcos", description: "Tube privately with a party or walk up and float through the Texas Hill Country.", price: "Adult Tube: $30", address: "2024 North Old Bastrop Hwy, San Marcos, TX", lat: 29.85607, long: -97.89953, imageName: "txtube"),
    RiverOutfitter(name: "Paddle SMTX", neighborhood: "TXST", description: "Crystal kayak glow tour at night. The photo is the meeting location where the trailer of kayaks will be.", price: "Adult Kayak: $55 per person", address: "170 Charles Austin Dr, San Marcos, TX", lat: 29.88595, long: -97.93500, imageName: "paddle"),
    RiverOutfitter(name: "Alamo Adventures", neighborhood: "San Marcos", description: "Guided Stand Up Paddleboard through the San Marcos river lasting about 2.5 hours.", price: "Contact for Pricing: 512-203-0094", address: "602 N 1-35 Frontage Rd, San Marcos, TX", lat: 29.87475, long: -97.93047, imageName: "alamo"),
    RiverOutfitter(name: "Great Gonzo's Tubes & Shuttles", neighborhood: "San Marcos", description: "Three sets of class 1 rapids with your 2-hour river ride.", price: "Adult Tube: $30, Cooler Tube: $22", address: "19385 San Marcos Hwy, San Marcos, TX", lat: 29.86212, long: -97.87744, imageName: "gonzo")
]

// Define Colors
extension Color {
    static let primaryGreen = Color(red: 78/255, green: 99/255, blue: 94/255)
    static let accentYellow = Color(red: 226/255, green: 224/255, blue: 8/255)
    static let secondaryGreen = Color(red: 168/255, green: 180/255, blue: 158/255)
    static let mutedGreen = Color(red: 129/255, green: 140/255, blue: 120/255)
    static let lightBackground = Color(red: 212/255, green: 208/255, blue: 185/255) // Light background color
}

struct ContentView: View {
    @State private var selectedNeighborhood: String = "All"
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 29.878654, longitude: -97.923086),
        span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
    )
    
    let neighborhoods = ["All", "TXST", "San Marcos"]
    
    var filteredOutfitters: [RiverOutfitter] {
        if selectedNeighborhood == "All" {
            return outfitters
        } else {
            return outfitters.filter { $0.neighborhood == selectedNeighborhood }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // Remove the space between the List and Map
                // Header
                Text("River Outfitters")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primaryGreen) // Darker text for better contrast
                    .padding([.top, .leading, .trailing])
                    .shadow(radius: 5) // Add some shadow for subtle emphasis
                
                // Filter Picker
                Picker("Neighborhood", selection: $selectedNeighborhood) {
                    ForEach(neighborhoods, id: \.self) { neighborhood in
                        Text(neighborhood)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primaryGreen)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing, .top])
                .background(Color.secondaryGreen) // Secondary Green color for background
                .cornerRadius(10)
                .shadow(radius: 5)
                
                // List of River Outfitters
                List(filteredOutfitters) { outfitter in
                    NavigationLink(destination: DetailView(outfitter: outfitter)) {
                        HStack {
                            Image(outfitter.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                            
                            VStack(alignment: .leading) {
                                Text(outfitter.name)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                Text(outfitter.neighborhood)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                        }
                    }
                    .listRowBackground(Color.secondaryGreen)
                    .cornerRadius(10)
                    .padding([.top, .bottom], 5)
                }
                .listStyle(PlainListStyle())
                .padding(.bottom, 5)
                
                // Map with Pins for Outfitters
                Map(coordinateRegion: $region, annotationItems: filteredOutfitters) { item in
                    MapPin(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), tint: .primaryGreen)
                }
                .frame(maxHeight: .infinity) // Ensure the map takes up the full screen height
                .edgesIgnoringSafeArea(.bottom) // Extend the map to the bottom of the screen
            }
            .navigationBarHidden(true)
            .background(Color.lightBackground) // Light background color for the entire app
        }
    }
}

// Detail Screen with Map
struct DetailView: View {
    let outfitter: RiverOutfitter
    
    @State private var region: MKCoordinateRegion
    
    init(outfitter: RiverOutfitter) {
        self.outfitter = outfitter
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: outfitter.lat, longitude: outfitter.long),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image
                Image(outfitter.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                
                // Details
                Text(outfitter.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primaryGreen)
                
                Text("Neighborhood: \(outfitter.neighborhood)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Address: \(outfitter.address)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Description: \(outfitter.description)")
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                Text("Price: \(outfitter.price)")
                    .font(.subheadline)
                    .foregroundColor(.primaryGreen)
                    .padding(.top, 10)
                
                // Map View with Pin for this specific outfitter
                Map(coordinateRegion: $region, annotationItems: [outfitter]) { item in
                    MapPin(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), tint: .primaryGreen)
                }
                .frame(height: 300)
                .cornerRadius(15)
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle(outfitter.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.lightBackground) // Light background color for the detail view
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

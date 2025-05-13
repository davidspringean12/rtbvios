import SwiftUI
import CoreLocation

struct RouteSelector: View {
    let routes: [String: [CLLocationCoordinate2D]]
    @Binding var selectedRouteId: String
    
    var body: some View {
        Picker("Select Route", selection: $selectedRouteId) {
            if routes.isEmpty {
                Text("No routes available")
                    .tag("")
            } else {
                ForEach(Array(routes.keys), id: \.self) { routeId in
                    Text("Route \(routeId)")
                        .tag(routeId)
                }
            }
        }
        .pickerStyle(.menu)
        .padding(.vertical)
    }
}

// Preview provider for SwiftUI canvas
#Preview {
    RouteSelector(
        routes: [:],
        selectedRouteId: .constant("")
    )
}

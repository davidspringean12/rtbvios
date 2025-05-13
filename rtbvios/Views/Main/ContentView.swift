import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        VStack {
            Text("City Bus Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text("Track live bus routes and locations on the map")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            RouteSelector(
                routes: viewModel.routes,
                selectedRouteId: $viewModel.selectedRouteId
            )
            
            MapView(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(12)
                .shadow(radius: 10)
        }
        .padding()
    }
}

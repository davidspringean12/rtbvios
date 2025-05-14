import SwiftUI

struct MapContainerView: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        VStack {
            HStack {
                // Route Selector
                Picker("Select Route", selection: $viewModel.selectedRouteId) {
                    ForEach(viewModel.routes) { route in
                        Text(route.displayName)
                            .tag(Optional(route.shapeId))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                // Simulation Control Button
                Button(action: {
                    viewModel.toggleSimulation()
                }) {
                    Image(systemName: viewModel.isSimulationRunning ? "pause.fill" : "play.fill")
                        .foregroundColor(viewModel.isSimulationRunning ? .red : .green)
                        .font(.title2)
                }
                .padding()
            }
            
            // Map View
            MapView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.loadRoutes()
        }
        .onChange(of: viewModel.selectedRouteId) { oldValue, newValue in
            // Stop simulation when route changes
            if viewModel.isSimulationRunning {
                viewModel.toggleSimulation()
            }
        }
    }
}

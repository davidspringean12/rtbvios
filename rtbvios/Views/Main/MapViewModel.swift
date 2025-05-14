import SwiftUI
import MapKit
import Combine

class MapViewModel: ObservableObject {
    @Published var routes: [RouteShape] = []
    @Published var selectedRouteId: String? = nil
    @Published var isSimulationRunning = false
    
    private var busAnnotation: BusAnnotation?
    private var simulationTimer: Timer?
    private var currentPointIndex = 0
    private var cancellables = Set<AnyCancellable>()
    
    var selectedRoute: RouteShape? {
        routes.first { $0.shapeId == selectedRouteId }
    }
    
    func loadRoutes() {
        guard let shapes = RouteService.loadShapes(from: "shapes") else {
            print("Failed to load shapes data")
            return
        }
        self.routes = shapes
        if let firstRoute = shapes.first {
            self.selectedRouteId = firstRoute.shapeId
        }
    }
    
    func toggleSimulation() {
        isSimulationRunning.toggle()
        
        if isSimulationRunning {
            startSimulation()
        } else {
            stopSimulation()
        }
    }
    
    private func startSimulation() {
        guard let selectedRoute = selectedRoute else { return }
        
        // Reset position to start
        currentPointIndex = 0
        
        // Create bus annotation if needed
        if busAnnotation == nil {
            busAnnotation = BusAnnotation(coordinate: selectedRoute.points[0])
        } else {
            busAnnotation?.coordinate = selectedRoute.points[0]
        }
        
        // Start timer for movement
        simulationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.moveBusToNextPoint()
        }
    }
    
    private func stopSimulation() {
        simulationTimer?.invalidate()
        simulationTimer = nil
    }
    
    private func moveBusToNextPoint() {
        guard let selectedRoute = selectedRoute else { return }
        let points = selectedRoute.points
        
        if currentPointIndex < points.count - 1 {
            currentPointIndex += 1
            
            // Animate bus movement
            withAnimation {
                busAnnotation?.coordinate = points[currentPointIndex]
            }
        } else {
            // Reset to beginning when reached end
            currentPointIndex = 0
            busAnnotation?.coordinate = points[0]
        }
    }
    
    func getBusAnnotation() -> BusAnnotation? {
        return busAnnotation
    }
}

import MapKit
import Combine

class MapViewModel: ObservableObject {
    @Published var routes: [String: [CLLocationCoordinate2D]] = [:]
    @Published var selectedRouteId: String = ""
    @Published var currentSegment: Int = 0
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
    
    private var busAnnotation: MKPointAnnotation?
    private var routeOverlay: MKPolyline?
    private var animationTimer: Timer?
    
    init() {
        loadRoutes()
    }
    
    private func loadRoutes() {
        // TODO: Load GTFS data from your backend or bundle
        // This would replace your current fetch('/src/assets/shapes.txt')
    }
    
    func updateBusLocation(at coordinate: CLLocationCoordinate2D) {
        if busAnnotation == nil {
            busAnnotation = MKPointAnnotation()
        }
        busAnnotation?.coordinate = coordinate
    }
}

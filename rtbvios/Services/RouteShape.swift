import Foundation
import CoreLocation
import MapKit

struct RouteShape: Identifiable {
    let id = UUID()
    let shapeId: String
    let points: [CLLocationCoordinate2D]
    
    var displayName: String {
        // Convert something like "1.0.7656_VIILE_SB" to "Viile SB"
        let components = shapeId.components(separatedBy: "_")
        if components.count >= 2 {
            return components[1...].joined(separator: " ")
        }
        return shapeId
    }
    
    var polyline: MKPolyline {
        MKPolyline(coordinates: points, count: points.count)
    }
}

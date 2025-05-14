import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        // Center on Sibiu
        let sibiuCenter = CLLocationCoordinate2D(
            latitude: 45.7912,
            longitude: 24.1419
        )
        let region = MKCoordinateRegion(
            center: sibiuCenter,
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05
            )
        )
        mapView.setRegion(region, animated: false)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Remove existing overlays and annotations
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        // Add selected route
        if let selectedRoute = viewModel.selectedRoute {
            mapView.addOverlay(selectedRoute.polyline)
            
            // Add bus annotation if simulation is running
            if viewModel.isSimulationRunning,
               let busAnnotation = viewModel.getBusAnnotation() {
                mapView.addAnnotation(busAnnotation)
            }
            
            // Zoom to fit route
            let padding = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            mapView.setVisibleMapRect(selectedRoute.polyline.boundingMapRect,
                                    edgePadding: padding,
                                    animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 5
                renderer.alpha = 0.7
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is BusAnnotation {
                let identifier = "BusAnnotation"
                var view: MKAnnotationView
                
                if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                    view = dequeuedView
                } else {
                    view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                }
                
                // Use a bus emoji or custom image
                view.image = UIImage(systemName: "bus.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                
                return view
            }
            return nil
        }
    }
}

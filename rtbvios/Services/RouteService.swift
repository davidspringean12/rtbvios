import Foundation
import CoreLocation

class RouteService {
    static func loadShapes(from filename: String) -> [RouteShape]? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "txt"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            return nil
        }
        
        var shapes: [String: [CLLocationCoordinate2D]] = [:]
        let lines = content.components(separatedBy: .newlines)
        
        // Skip header row
        let dataLines = lines[1..<lines.count]
        
        for line in dataLines where !line.isEmpty {
            let columns = line.components(separatedBy: ",")
            guard columns.count >= 4,
                  let shapeId = columns[0].isEmpty ? nil : columns[0],
                  let lat = Double(columns[1]),
                  let lon = Double(columns[2]) else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            if shapes[shapeId] == nil {
                shapes[shapeId] = []
            }
            shapes[shapeId]?.append(coordinate)
        }
        
        return shapes.map { RouteShape(shapeId: $0.key, points: $0.value) }
    }
}

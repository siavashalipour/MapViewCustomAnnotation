

import UIKit
import MapKit

class StoreAnnotation: NSObject, MKAnnotation {
    
    fileprivate var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }

    }

    var title: String?
    var subtitle: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: String, image: UIImage) {
        self.coord = coordinate
        self.title = ""
        self.image = image
        
    }
}


import UIKit
import MapKit
import SnapKit

class StoreAnnotationView: MKAnnotationView {
    
    var coordinate: CLLocationCoordinate2D!
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let storeAnnotation = self.annotation as! StoreAnnotation
        image = storeAnnotation.image
        coordinate = storeAnnotation.coordinate
        let aimage = UIImage(named: "sanFran")
        let imgView = UIImageView(image: aimage)
        detailCalloutAccessoryView = imgView
        imgView.snp.makeConstraints({ (make) in
            make.height.equalTo(detailCalloutAccessoryView!)
            make.width.equalTo(detailCalloutAccessoryView!)
        })
        
        imgView.layer.cornerRadius = 5
        imgView.clipsToBounds = true
        detailCalloutAccessoryView?.layer.cornerRadius = 20
        isDraggable = true
        canShowCallout = true
    }
}

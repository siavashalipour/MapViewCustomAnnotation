//
//  CustomAnnotationView.swift
//  MapDesign
//
//  Created by Siavash Abbasalipour on 15/09/2016.
//  Copyright © 2016. All rights reserved.
//

import UIKit
import MapKit

/// This is simple subclass of `MKPinAnnotationView` which includes reference for any currently
/// visible callout bubble (if any).

class CustomAnnotationView: MKAnnotationView {
    
    weak var calloutView: ExampleCalloutView?
    
    override var annotation: MKAnnotation? {
        willSet {
            let storeAnnotation = annotation as? StoreAnnotation
            image = storeAnnotation?.image
            calloutView?.removeFromSuperview()
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let storeAnnotation = self.annotation as! StoreAnnotation
        image = storeAnnotation.image
        image = UIImage(named: "sanFran")
        canShowCallout = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let animationDuration: TimeInterval = TimeInterval(0.25)
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            let calloutView = ExampleCalloutView(annotation: annotation as! StoreAnnotation)
            calloutView.add(to: self)
            self.calloutView = calloutView
            
            if animated {
                calloutView.alpha = 0
                UIView.animate(withDuration: animationDuration, animations: {
                    calloutView.alpha = 1
                }) 
            }
        } else {
            if animated {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.calloutView?.alpha = 0
                    }, completion: { finished in
                        self.calloutView?.removeFromSuperview()
                })
            } else {
                calloutView?.removeFromSuperview()
            }
        }
    }
    
    
}



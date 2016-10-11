//
//  ExampleCalloutView.swift
//  MapDesign
//
//  Created by Siavash Abbasalipour on 15/09/2016.
//  Copyright © 2016. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class ExampleCalloutView: CalloutView {
    
    var imageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "sanFran"))
        imgView.layer.cornerRadius = 25
        imgView.layer.masksToBounds = true
        return imgView
    }()

    
    /// Add constraints for subviews of `contentView`
    
    fileprivate func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        imageView.snp.remakeConstraints { (make) in
            make.bottom.equalTo(contentView).offset(-18)
            make.leading.equalTo(contentView).offset(5)
            make.trailing.equalTo(contentView).offset(-5)
            make.top.equalTo(contentView).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    init(annotation: StoreAnnotation) {
        super.init()
        
        configure()
        
        updateContents(for: annotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }
    
    /// Update callout contents
    
    fileprivate func updateContents(for annotation: StoreAnnotation) {
        imageView = UIImageView(image: UIImage(named: "sanFran"))

    }
    
}

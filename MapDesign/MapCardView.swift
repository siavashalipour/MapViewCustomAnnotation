//
//  MapCardView.swift
//  MapDesign
//
//  Created by Siavash Abbasalipour on 14/09/2016.
//  Copyright © 2016. All rights reserved.
//

import Foundation
import UIKit

final class MapCardView: UIView {

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var roundedRectView: UIView!
    @IBOutlet weak var focusBtn: UIButton!
    
    class func instanceFromNib() -> MapCardView {
        return Bundle.main.loadNibNamed("MapCardView",owner:self,options:nil)!.first as! MapCardView
    }
    
    func setupUI() {
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
    }
}

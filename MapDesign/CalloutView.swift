//
//  CalloutView.swift
//  MapDesign
//
//  Created by Siavash Abbasalipour on 15/09/2016.
//  Copyright © 2016. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

/// This callout view is used to render a custom callout bubble for an annotation view.
/// The size of this is dictated by the constraints that are established between the
/// this callout view's `contentView` and its subviews (e.g. if those subviews have their
/// own intrinsic size). Or, alternatively, you always could define explicit width and height
/// constraints for the callout.
///
/// This is an abstract class that you won't use by itself, but rather subclass to and fill
/// with the appropriate content inside the `contentView`. But this takes care of all of the
/// rendering of the bubble around the callout.

class CalloutView: UIView {
    
    enum BubblePointerType {
        case rounded
        case straight(angle: CGFloat)
    }
    
    fileprivate let bubblePointerType = BubblePointerType.rounded
    
    /// Insets for rounding of callout bubble's corners
    ///
    /// The "bottom" is amount of rounding for pointer at the bottom of the callout
    
    fileprivate let inset = UIEdgeInsets(top: 20, left: 20, bottom: 15, right: 20)
    
    /// Shape layer for callout bubble
    
    fileprivate lazy var bubbleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.white.cgColor
        layer.lineWidth = 0.5
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    /// Content view for annotation callout view
    ///
    /// This establishes the constraints between the `contentView` and the `CalloutView`,
    /// leaving enough padding for the chrome of the callout bubble.
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.snp.remakeConstraints({ (make) in
            make.edges.equalTo(self)
        })

        return contentView
    }()
    
    
    init() {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Should not call init(coder:)")
    }
    
    // if the view is resized, update the path for the callout bubble
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updatePath()
    }
    
    /// Update `UIBezierPath` for callout bubble
    ///
    /// The setting of the bubblePointerType dictates whether the pointer at the bottom of the
    /// bubble has straight lines or whether it has rounded corners.
    
    fileprivate func updatePath() {
        let path = UIBezierPath()
        
        var point: CGPoint
        
        var controlPoint: CGPoint
        
        point = CGPoint(x: bounds.size.width - inset.right, y: bounds.size.height - inset.bottom)
        path.move(to: point)
        
        switch bubblePointerType {
        case .rounded:
            // lower right
            point = CGPoint(x: bounds.size.width / 2.0 + inset.bottom, y: bounds.size.height - inset.bottom)
            path.addLine(to: point)
            
            // right side of arrow
            
            controlPoint = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height - inset.bottom)
            point = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
            path.addQuadCurve(to: point, controlPoint: controlPoint)
            
            // left of pointer
            
            controlPoint = CGPoint(x: point.x, y: bounds.size.height - inset.bottom)
            point = CGPoint(x: point.x - inset.bottom, y: controlPoint.y)
            path.addQuadCurve(to: point, controlPoint: controlPoint)
        case .straight(let angle):
            print(angle)
            // lower right
            point = CGPoint(x: bounds.size.width / 2.0 + tan(angle) * inset.bottom, y: bounds.size.height - inset.bottom)
            print(point)
            path.addLine(to: point)
            
            // right side of arrow
            
            point = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height)
            path.addLine(to: point)
            
            // left of pointer
            
            point = CGPoint(x: bounds.size.width / 2.0 - tan(angle) * inset.bottom, y: bounds.size.height - inset.bottom)
            path.addLine(to: point)
        }
        
        // bottom left
        
        point.x = inset.left
        path.addLine(to: point)
        
        // lower left corner
        
        controlPoint = CGPoint(x: 0, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: 0, y: controlPoint.y - inset.left)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // left
        
        point.y = inset.top
        path.addLine(to: point)
        
        // top left corner
        
        controlPoint = CGPoint.zero
        point = CGPoint(x: inset.left, y: 0)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // top
        
        point = CGPoint(x: bounds.size.width - inset.left, y: 0)
        path.addLine(to: point)
        
        // top right corner
        
        controlPoint = CGPoint(x: bounds.size.width, y: 0)
        point = CGPoint(x: bounds.size.width, y: inset.top)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        // right
        
        point = CGPoint(x: bounds.size.width, y: bounds.size.height - inset.bottom - inset.right)
        path.addLine(to: point)
        
        // lower right corner
        
        controlPoint = CGPoint(x:bounds.size.width, y: bounds.size.height - inset.bottom)
        point = CGPoint(x: bounds.size.width - inset.right, y: bounds.size.height - inset.bottom)
        path.addQuadCurve(to: point, controlPoint: controlPoint)
        
        path.close()
        
        bubbleLayer.path = path.cgPath
    }
    
    /// Add this `CalloutView` to an annotation view (i.e. show the callout on the map above the pin)
    
    func add(to annotationView: MKAnnotationView) {
        annotationView.addSubview(self)
        
        // constraints for this callout with respect to its superview
        
        NSLayoutConstraint.activate([bottomAnchor.constraint(equalTo: annotationView.topAnchor, constant: annotationView.calloutOffset.y),
            centerXAnchor.constraint(equalTo: annotationView.centerXAnchor, constant: annotationView.calloutOffset.x)

            ])
    }
    
}

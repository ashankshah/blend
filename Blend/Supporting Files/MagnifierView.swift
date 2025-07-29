//
//  PanZoomImageView.swift
//  Blend
//
//  Created by Mac OS on 29/06/2024.
//

import Foundation
import UIKit


class MagnifierView: UIView {

    var touchPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var viewToMagnify: UIView?
    var magnification: CGFloat = 15.0
    var radius: CGFloat = 40.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 3.0
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let viewToMagnify = viewToMagnify else { return }

        context.translateBy(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        context.scaleBy(x: magnification, y: magnification)
        context.translateBy(x: -touchPoint.x, y: -touchPoint.y)
        
        viewToMagnify.layer.render(in: context)
    }
}

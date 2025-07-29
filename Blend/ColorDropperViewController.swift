//
//  ColorDropperViewController.swift
//  Blend
//
//  Created by Mac OS on 20/07/2024.
//

import UIKit

class ColorDropperViewController: UIViewController {
    
    private var dropperView: UIView!
    private var dropperViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Dropper View
        setupDropperView()
    }
    
    private func setupDropperView() {
        dropperView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        dropperView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dropperView.layer.cornerRadius = 25
        dropperView.layer.borderWidth = 2
        dropperView.layer.borderColor = UIColor.white.cgColor
        dropperView.isHidden = true
        view.addSubview(dropperView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let color = getColorAt(location: location)
        view.backgroundColor = color
        print("Color at tap: \(color)")
    }
    
    private func getColorAt(location: CGPoint) -> UIColor {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return UIColor.clear
        }
        
        let pixelData = window.screenShot().cgImage?.dataProvider?.data
        let data = CFDataGetBytePtr(pixelData)
        let bytesPerRow = window.screenShot().cgImage?.bytesPerRow ?? 0
        
        let x = Int(location.x)
        let y = Int(location.y)
        
        let offset = (bytesPerRow * y) + (x * 4)
        let red = CGFloat(data![offset]) / 255.0
        let green = CGFloat(data![offset + 1]) / 255.0
        let blue = CGFloat(data![offset + 2]) / 255.0
        let alpha = CGFloat(data![offset + 3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

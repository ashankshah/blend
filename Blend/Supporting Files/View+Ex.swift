//
//  View+Ex.swift
//  Remax Impact
//
//  Created by Mac OS on 20/05/2024.
//

import UIKit
import CoreTelephony

extension UIView {
    func setViewCard(_ cornerRadius: CGFloat = 16, _ shadowColor: CGColor = UIColor.gray.cgColor,_ shadow: Float = 0.6) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.2)
        self.layer.shadowOpacity = shadow
        self.layer.cornerRadius = cornerRadius
    }
    
    func setViewCardWidthSpecificRoundCorner(_ cornerRadius: CGFloat = 10, _ shadowColor: CGColor = UIColor.lightGray.cgColor, corners: CACornerMask) {
//        self.layer.masksToBounds = false
        self.layer.maskedCorners = corners
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.8
        self.layer.cornerRadius = cornerRadius
        
    }
    func removeCardView() {
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func roundView(with radius:CGFloat,_ borderColor: UIColor = .clear, _ borderSize: CGFloat = 1, _ cardView: Bool = false){
        if cardView{
            setViewCard(radius)
        }else{
            
            self.layer.cornerRadius = radius
        }
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderSize
        self.clipsToBounds = true
        
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func roundCornerByCorner( _ corners: CACornerMask, radius: CGFloat,_ borderColor: UIColor = UIColor.clear , _ borderWidth: CGFloat = 0 ) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }

    func applyGradient(with colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}



extension UIApplication {
    
    var keyWindow: UIWindow? {
           // Get connected scenes
           return UIApplication.shared.connectedScenes
               // Keep only active scenes, onscreen and visible to the user
               .filter { $0.activationState == .foregroundActive }
               // Keep only the first `UIWindowScene`
               .first(where: { $0 is UIWindowScene })
               // Get its associated windows
               .flatMap({ $0 as? UIWindowScene })?.windows
               // Finally, keep only the key window
               .first(where: \.isKeyWindow)
    }
    
    var keyWindowPresentedController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController
        
        // If root `UIViewController` is a `UITabBarController`
        if let presentedController = viewController as? UITabBarController {
            // Move to selected `UIViewController`
            viewController = presentedController.selectedViewController
        }
        
        // Go deeper to find the last presented `UIViewController`
        while let presentedController = viewController?.presentedViewController {
            // If root `UIViewController` is a `UITabBarController`
            if let presentedController = presentedController as? UITabBarController {
                // Move to selected `UIViewController`
                viewController = presentedController.selectedViewController
            } else {
                // Otherwise, go deeper
                viewController = presentedController
            }
        }
        
        return viewController
    }
    
}

extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }

   func removeWhitespace() -> String {
       return self.replace(string: " ", replacement: "")
   }

 }


extension UIColor {
    
        func toHexString(includeAlpha: Bool = false) -> String? {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                return nil
            }
            
            let r = Int(red * 255.0)
            let g = Int(green * 255.0)
            let b = Int(blue * 255.0)
            let a = Int(alpha * 255.0)
            
            if includeAlpha {
                return String(format: "#%02X%02X%02X%02X", r, g, b, a)
            } else {
                return String(format: "#%02X%02X%02X", r, g, b)
            }
        }
    

    convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        return nil
    }
    
    func isSimilar(to color: UIColor, tolerance: CGFloat) -> Bool {
           var r1: CGFloat = 0
           var g1: CGFloat = 0
           var b1: CGFloat = 0
           var a1: CGFloat = 0
           self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)

           var r2: CGFloat = 0
           var g2: CGFloat = 0
           var b2: CGFloat = 0
           var a2: CGFloat = 0
           color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

           return abs(r1 - r2) <= tolerance &&
                  abs(g1 - g2) <= tolerance &&
                  abs(b1 - b2) <= tolerance &&
                  abs(a1 - a2) <= tolerance
       }
    
      func isWhiteFamily() -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Get the color components
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Define a threshold value to decide if a color is close to white
        let threshold: CGFloat = 0.9
        
        // Check if the RGB components are all above the threshold
        return red >= threshold && green >= threshold && blue >= threshold
      }
}

extension UIImage {
    func toString() -> String? {
        guard let imageData = self.pngData() else {
            return nil
        }
        let base64String = imageData.base64EncodedString(options: [])
        return base64String
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
      let size = self.size
      let widthRatio  = targetSize.width  / size.width
      let heightRatio = targetSize.height / size.height
      let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
      let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

      UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
      self.draw(in: rect)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return newImage!
    }
    
    func Size300X300() -> UIImage? {
        let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFit
         imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
         let image = imageView.asImage()
         let newImage = image.resizeImage(targetSize: CGSize(width:300, height: 300))
         return newImage

    }
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}



extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIWindow {
    func screenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

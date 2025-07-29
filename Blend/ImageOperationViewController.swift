//
//  ImageOperationViewController.swift
//  Blend
//
//  Created by Mac OS on 29/06/2024.
//

import UIKit
import CoreGraphics


protocol ViewControllerDelegate: AnyObject {
    func didDismissViewController()
}



class ImageOperationViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var savebtn: UIButton!
    
    @IBOutlet weak var pencilView1: UIView!
    @IBOutlet weak var pencilView2: UIView!
    @IBOutlet weak var pencilView3: UIView!
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var img1layer: UIImageView!
    @IBOutlet weak var img2layer: UIImageView!
    @IBOutlet weak var img3layer: UIImageView!
    
    @IBOutlet weak var colorLabel1: UILabel!
    @IBOutlet weak var colorLabel2: UILabel!
    @IBOutlet weak var colorLabel3: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var selectLbl: UILabel!
    @IBOutlet weak var selectView: UIView!
   
    @IBOutlet weak var containerView: UIView!
    var magnifierView: MagnifierView!
    
    var colorSet = [(pieceCode: String, hexValue: String)]()
    var selectedColors = [String]()
    var color = UIColor(.black)
    var counter = 1
    var set = 48
    var projectName = String()
    var imagePath = String()
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    weak var delegate: ViewControllerDelegate?
    
 
    let picker = UIColorPickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        switch set{
        case 12:
            colorSet = colorSet12
        case 24:
            colorSet = colorSet24
        case 36:
            colorSet = colorSet36
        case 48:
            colorSet = colorSet48
        case 72:
            colorSet = colorSet72
        case 132:
            colorSet = colorSet132
        default:
            colorSet = colorSet150
        }
        picker.delegate = self
        picker.title = ""
        picker.view.tintColor = .white
        picker.view.backgroundColor = #colorLiteral(red: 0.352761507, green: 0.6110755801, blue: 0.6290432811, alpha: 1)
        picker.view.roundView(with: 24)
        
        presentClippedPicker(picker)
        
        // Do any additional setup after loading the view.
        btn1.roundView(with: 24, .black,2.5)
        btn2.roundView(with: 24, .clear,1)
        btn3.roundView(with: 24, .clear,1)
        selectView.roundView(with: 24)
        magnifierView = MagnifierView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width * 0.3, height: imageView.frame.height * 0.3))
        magnifierView.radius = imageView.frame.height / 2
        magnifierView.viewToMagnify = imageView
        magnifierView.isHidden = true
        view.addSubview(magnifierView)
        savebtn.roundView(with: 24)
        
        if !projectName.isEmpty{
            self.nameLbl.text = projectName
            self.imageView.image = load(fileName: imagePath)
            imageView.isHidden = false
        }
        
        if color.isWhiteFamily() {
            self.img1layer.image = #imageLiteral(resourceName: "transparent")
        }else{
            self.img1layer.image = #imageLiteral(resourceName: "transparent")
        }
        
    }
    
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    
   @IBAction func SaveBtn() {
       if projectName.isEmpty{
           let ac = UIAlertController(title: "Enter Project Name", message: nil, preferredStyle: .alert)
           ac.addTextField()
           let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned ac] _ in
               let answer = ac.textFields![0]
               self.saveProjectName(answer.text ?? "", selectedColors: self.selectedColors, for: self.save(image: self.imageView.image!) ?? "")
           }
           ac.addAction(submitAction)
           present(ac, animated: true)
       }else{
           self.removeProject(for: projectName)
           self.saveProjectName(projectName, selectedColors: self.selectedColors, for: self.save(image: self.imageView.image!) ?? "")
       }
    }
    
    @IBAction func showPalette(_ sender: Any) {
       let paletteVC = PalleteViewController(collectionViewLayout: UICollectionViewFlowLayout())
        paletteVC.delegate = self
        paletteVC.selectedColors = selectedColors
       paletteVC.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            if let sheet = paletteVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()] // Medium size (half) and full size
                sheet.prefersGrabberVisible = true
            }
        } else {
            // Fallback on earlier versions
        }
       present(paletteVC, animated: true, completion: nil)
    }
    
    
    
    private func save(image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
           try? imageData.write(to: fileURL, options: .atomic)
           return fileName // ----> Save fileName
        }
        print("Error saving image")
        return nil
    }
    
       
   func saveProjectName(_ projectName: String, selectedColors: [String], for fileURL: String) {
       var savedProjectsDict = UserDefaults.standard.dictionary(forKey: "savedProjects") ?? [String: String]()
       let projectData: [String: Any] = [
            "fileURL": fileURL,
            "colors": selectedColors
        ]
       savedProjectsDict[projectName] = projectData
       UserDefaults.standard.set(savedProjectsDict, forKey: "savedProjects")
       self.dismiss(animated: false) {
           self.delegate?.didDismissViewController()
       }
   }
    
    func removeProject(for projectName: String) {
        // Retrieve the saved projects dictionary or initialize an empty one
        var savedProjectsDict = UserDefaults.standard.dictionary(forKey: "savedProjects") ?? [String: Any]()
        
        // Remove the project data for the given fileURL
        savedProjectsDict.removeValue(forKey: projectName)
        
        // Save the updated dictionary back to UserDefaults
        UserDefaults.standard.set(savedProjectsDict, forKey: "savedProjects")
        
        // Optionally notify or handle the UI updates here after deletion
        self.dismiss(animated: false) {
            self.delegate?.didDismissViewController()
        }
    }

    
    
    func getHexColorFromImage(at point: CGPoint) -> String? {
        guard let image = imageView.image else { return nil }

        let size = image.size
        let pointX = point.x * (size.width / imageView.bounds.size.width)
        let pointY = point.y * (size.height / imageView.bounds.size.height)

     
        let pixelData = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        defer {
            pixelData.deallocate()
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.translateBy(x: -pointX, y: pointY - CGFloat(size.height))
        context?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let red = CGFloat(pixelData[0]) / 255.0
        let green = CGFloat(pixelData[1]) / 255.0
        let blue = CGFloat(pixelData[2]) / 255.0

        let hexColor = String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        return hexColor
    }
    
    func getMatchingColorPercentage(color: UIColor, tolerance: CGFloat = 0.1) -> Double? {
        guard let image = imageView.image else { return nil }
        guard let cgImage = image.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height

        guard let data = cgImage.dataProvider?.data else { return nil }
        let pixelData = CFDataGetBytePtr(data)

        var matchingPixelCount = 0
        var totalPixelCount = 0

        for x in 0..<width {
            for y in 0..<height {
                let pixelIndex = ((width * y) + x) * 4
                let red = CGFloat(pixelData![pixelIndex]) / 255.0
                let green = CGFloat(pixelData![pixelIndex + 1]) / 255.0
                let blue = CGFloat(pixelData![pixelIndex + 2]) / 255.0

                let pixelColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                
                if color.isSimilar(to: pixelColor, tolerance: tolerance) {
                    matchingPixelCount += 1
                }

                totalPixelCount += 1
            }
        }

        let percentage = (Double(matchingPixelCount) / Double(totalPixelCount)) * 100
        return percentage
    }
    
    
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
            imageView.isHidden = false
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
            imageView.isHidden = false
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction func crossBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func colorBtn(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            counter = 1
            buttonBorder(btn: btn1)
        case 1:
            counter = 2
            buttonBorder(btn: btn2)
        default:
          
            counter = 3
            buttonBorder(btn: btn3)
        }
        pickColor()
    }
    
    @IBAction func pickButtonPressed(_ sender: Any) {
        selectedColors.append(color.toHexString()!)
    }
    
    func presentClippedPicker(_ picker: UIColorPickerViewController) {
         
            addChild(picker)
            containerView.addSubview(picker.view)
            picker.view.translatesAutoresizingMaskIntoConstraints = false
            picker.didMove(toParent: self)

            NSLayoutConstraint.activate([
              picker.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
              picker.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
              picker.view.topAnchor.constraint(equalTo: containerView.topAnchor),
             picker.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

          
            let maskLayer = CAShapeLayer()
            maskLayer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)).cgPath
            containerView.layer.mask = maskLayer

            
            containerView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.containerView.alpha = 1
            }
        }
    
    
    
    func pencilColor(img:UIImageView, color:UIColor){
        if color.isWhiteFamily() {
            img.image = #imageLiteral(resourceName: "transparent")
        } else {
            let pencilLogo = #imageLiteral(resourceName: "pencil").withRenderingMode(.alwaysTemplate)
            img.image = pencilLogo
            img.tintColor = color
        }
    }
    
    func buttonBorder(btn:UIButton){
        btn1.roundView(with: 0, .clear,0)
        btn2.roundView(with: 0, .clear,0)
        btn3.roundView(with: 0, .clear,0)
        btn.roundView(with: 24, .black,2.5)
       
        checkCounter()
    }
    
    func checkCounter(){
        switch counter {
        case 1:
            pencilView1.isHidden = false
            pencilView2.isHidden = true
            pencilView3.isHidden = true
        case 2:
            pencilView1.isHidden = false
            pencilView2.isHidden = false
            pencilView3.isHidden = true
        default:
            pencilView1.isHidden = false
            pencilView2.isHidden = false
            pencilView3.isHidden = false
        }
    }
    
    
    func hexToRGB(hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat)? {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        if hexFormatted.count != 6 {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        return (r, g, b)
    }
    
    func colorDistance(from color1: (r: CGFloat, g: CGFloat, b: CGFloat), to color2: (r: CGFloat, g: CGFloat, b: CGFloat)) -> CGFloat {
        let rDiff = color1.r - color2.r
        let gDiff = color1.g - color2.g
        let bDiff = color1.b - color2.b
        return sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff)
    }
    
    func closestColor(to hex: String, from colorSet: [(pieceCode: String, hexValue: String)]) -> (pieceCode: String, hexValue: String)? {
        guard let targetRGB = hexToRGB(hex: hex) else { return nil }
        
        var closestColor: (pieceCode: String, hexValue: String)?
        var smallestDistance: CGFloat = .greatestFiniteMagnitude
        
        for color in colorSet {
            guard let colorRGB = hexToRGB(hex: color.hexValue) else { continue }
            let distance = colorDistance(from: targetRGB, to: colorRGB)
            if distance < smallestDistance {
                smallestDistance = distance
                closestColor = color
            }
        }
        
        return closestColor
    }
    

    // Find the n closest colors to the target color
    func findClosestColors(to targetColor: UIColor, count: Int, from colorSet: [(pieceCode: String, hexValue: String)]) -> [(pieceCode: String, hexValue: String)] {
        let closestColors = [(pieceCode: String, hexValue: String)]()
        
        guard let targetRGB = hexToRGB(hex: targetColor.toHexString()!) else { return closestColors }
        
        let sortedColors = colorSet.sorted { (color1, color2) -> Bool in
            let distance1 = colorDistance(from: targetRGB, to: hexToRGB(hex: color1.hexValue)!)
            let distance2 = colorDistance(from: targetRGB, to: hexToRGB(hex: color2.hexValue)!)
            return distance1 < distance2
        }
        
        return Array(sortedColors.prefix(count))
    }

    // Blend colors with weighted contribution and return percentages of each color
    func blendColorsWithPercentage(targetColor: UIColor, colors: [(pieceCode: String, hexValue: String)]) -> (blendedColor: UIColor, percentages: [(pieceCode: String, percentage: Double)])? {
        var totalWeight: CGFloat = 0.0
        var totalR: CGFloat = 0
        var totalG: CGFloat = 0
        var totalB: CGFloat = 0
        var weights: [CGFloat] = []

        guard let targetRGB = hexToRGB(hex: targetColor.toHexString()!) else { return nil }

        for color in colors {
            guard let colorRGB = hexToRGB(hex: color.hexValue) else { continue }
            let distance = colorDistance(from: targetRGB, to: colorRGB)
            
            // Inverse of distance is the weight, but ensure non-zero weight (avoid division by zero)
            let weight = max(1.0 / (distance + 0.0001), 0.001)
            weights.append(weight)
            totalWeight += weight

            totalR += colorRGB.r * weight
            totalG += colorRGB.g * weight
            totalB += colorRGB.b * weight
        }

        // Compute the final blended color
        let blendedColor = UIColor(red: totalR / totalWeight, green: totalG / totalWeight, blue: totalB / totalWeight, alpha: 1.0)

        // Calculate the percentage contribution of each color
        var percentages: [(pieceCode: String, percentage: Double)] = []
        for (index, color) in colors.enumerated() {
            let percentage = (weights[index] / totalWeight) * 100
            percentages.append((pieceCode: color.pieceCode, percentage: Double(percentage)))
        }

        return (blendedColor, percentages)
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ImageOperationViewController:UIColorPickerViewControllerDelegate,ColorPalleteDelegate{
    
    func pickPalleteColor(color: UIColor) {
        self.color = color
        picker.view.backgroundColor = color
        selectView.layer.borderWidth = 1
        if color.isWhiteFamily(){
            selectView.layer.borderColor = UIColor.black.cgColor
            selectLbl.textColor = .black
        }else{
            selectView.layer.borderColor = UIColor.clear.cgColor
            selectLbl.textColor = .white
        }
        pickColor()
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor
        picker.view.backgroundColor = color
        selectView.layer.borderWidth = 1
      
        if color.isWhiteFamily(){
            selectView.layer.borderColor = UIColor.black.cgColor
            selectLbl.textColor = .black
        }else{
            selectView.layer.borderColor = UIColor.clear.cgColor
            selectLbl.textColor = .white
        }
        pickColor()
    }

    func pickColor(){
        switch counter {
        case 1:
            // Single closest color
            if let closest = closestColor(to: color.toHexString()!, from: colorSet) {
                print("Closest color is: \(closest.pieceCode) with hex value \(closest.hexValue)")
                colorLabel1.text = closest.pieceCode
                pencilColor(img: img1, color: UIColor(hex: "#" + closest.hexValue)!)
                if UIColor(hex: "#" + closest.hexValue)!.isWhiteFamily() {
                    self.img1layer.image = #imageLiteral(resourceName: "transparent")
                }else{
                    self.img1layer.image = #imageLiteral(resourceName: "transparent")
                }
            } else {
                print("No closest color found.")
            }

        case 2:
            // Find two closest colors and blend them
            let closestColors = findClosestColors(to: color, count: 2, from: colorSet)
            if closestColors.count == 2 {
                if let (_, percentages) = blendColorsWithPercentage(targetColor: color, colors: closestColors) {
                    colorLabel1.text = "\(percentages[0].pieceCode): \(percentages[0].percentage.rounded())%"
                    colorLabel2.text = "\(percentages[1].pieceCode): \(percentages[1].percentage.rounded())%"
                    if closestColors.count > 1{
                        pencilColor(img: img1, color: UIColor(hex: "#" +  closestColors[0].hexValue)!)
                        pencilColor(img: img2, color: UIColor(hex: "#" +  closestColors[1].hexValue)!)
                        if UIColor(hex: "#" + closestColors[0].hexValue)!.isWhiteFamily() {
                            self.img1layer.image = #imageLiteral(resourceName: "transparent")
                        }else{
                            self.img1layer.image = #imageLiteral(resourceName: "transparent")
                        }
                        if UIColor(hex: "#" + closestColors[1].hexValue)!.isWhiteFamily() {
                            self.img2layer.image = #imageLiteral(resourceName: "transparent")
                        }else{
                            self.img2layer.image = #imageLiteral(resourceName: "transparent")
                        }
                    }
                }
            }

        case 3:
            // Find three closest colors and blend them
            let closestColors = findClosestColors(to: color, count: 3, from: colorSet)
            if closestColors.count == 3 {
                if let (blendedColor, percentages) = blendColorsWithPercentage(targetColor: color, colors: closestColors) {
                    colorLabel1.text = "\(percentages[0].pieceCode): \(percentages[0].percentage.rounded())%"
                    colorLabel2.text = "\(percentages[1].pieceCode): \(percentages[1].percentage.rounded())%"
                    colorLabel3.text = "\(percentages[2].pieceCode): \(percentages[2].percentage.rounded())%"
                    print("Blended Color: \(blendedColor)")
                    if closestColors.count > 2{
                        
                        pencilColor(img: img1, color: UIColor(hex: "#" + closestColors[0].hexValue)!)
                        pencilColor(img: img2, color: UIColor(hex: "#" + closestColors[1].hexValue)!)
                        pencilColor(img: img3, color: UIColor(hex: "#" + closestColors[2].hexValue)!)
                        
                        if UIColor(hex: "#" + closestColors[0].hexValue)!.isWhiteFamily() {
                            self.img1layer.image = #imageLiteral(resourceName: "transparent")
                        }else{
                            self.img1layer.image = #imageLiteral(resourceName: "transparent")
                        }
                        if UIColor(hex: "#" + closestColors[1].hexValue)!.isWhiteFamily() {
                            self.img2layer.image = #imageLiteral(resourceName: "transparent")
                        }else{
                            self.img2layer.image = #imageLiteral(resourceName: "transparent")
                        }
                        if UIColor(hex: "#" + closestColors[2].hexValue)!.isWhiteFamily() {
                            self.img3layer.image = #imageLiteral(resourceName: "transparent")
                        }else{
                            self.img3layer.image = #imageLiteral(resourceName: "transparent")
                        }
                    }
                }
            }
        default:
            break
        }
    }

    
    
}


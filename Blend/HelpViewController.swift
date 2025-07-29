//
//  HelpViewController.swift
//  Blend
//
//  Created by Mac OS on 15/08/2024.
//

import UIKit

class HelpViewController: UIViewController {


    @IBOutlet weak var helpTxt:UITextView!
    let htmlText = "<p><strong style=\"font-size: 24px;\">Help</strong>:</p><p>Welcome to Blend! We help simplify the process of color matching in colored pencil art using algorithms and a simple user interface!</p><p>To start, click the &ldquo;New Project&rdquo; button on the My Projects page you were just at. Choose the brand and set size of the colored pencils you&rsquo;re working with. Then, upload your reference picture!</p><p>To select a specific color that you would like to match in your artwork, click the color dropper on the bottom left of the screen and use the magnifying glass to drag and pick.</p><p>Navigate the tabs labeled &ldquo;1&rdquo;, &ldquo;2&rdquo;, and &ldquo;3&rdquo; depending on how many colors you would like to blend. The 1 pencil tab will provide you with the 1 closest pencil in your set, the 2 pencil tab will provide you with the 2 pencils and proportions that when blended will match the selected color most closely, and finally the 3 pencil tab will provide 3 pencils and proportions that when blended will match the selected color most closely.</p><p>Instead of choosing common colors every time with the picker, you can click the save to palette button on the bottom right. Access your palette by clicking the palette icon on the top of the project page.</p><p>Next to the palette button, you can find the Save and Close buttons. Make sure to save your project to keep the image and colors in your palette if you want to access it again!</p><p>Feel free to email blendapp.help@gmail.com if you run into any issues!</p><p><strong style=\"font-size: 24px;\">About the Founder:</strong></p><p>This app was created by Oregon high school student and hobbyist artist Ashank Shah! Ashank often noticed that some colors in his artworks were slightly off and he could never get the perfect balance in his Prismacolor set. He published this app to solve the problem for himself and artists worldwide!</p><p>In his free time, Ashank conducts machine learning and computational biology research, teaches various classes, plays racquetball &amp; basketball, and of course, does art!</p>"
    
 
    override func viewDidLoad() {
           super.viewDidLoad()
           
           // Convert HTML to NSAttributedString
           if let attributedString = htmlText.htmlToAttributedString {
               let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
               

               let poppinsRegular = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
               let poppinsBold = UIFont(name: "Poppins-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 22)
               
           
               mutableAttributedString.addAttributes([.font: poppinsRegular], range: NSRange(location: 0, length: mutableAttributedString.length))
               
            
               let boldRange = (mutableAttributedString.string as NSString).range(of: "Help:")
               if boldRange.location != NSNotFound {
                   mutableAttributedString.addAttributes([.font: poppinsBold], range: boldRange)
               }
               
            
                 let founderRange = (mutableAttributedString.string as NSString).range(of: "About the Founder:")
                 if founderRange.location != NSNotFound {
                     mutableAttributedString.addAttributes([.font: poppinsBold], range: founderRange)
                 }
               
            
               helpTxt.attributedText = mutableAttributedString
           }
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

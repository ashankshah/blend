//
//  ViewController.swift
//  Blend
//
//  Created by Mac OS on 29/06/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func startBtn(_ sender: UIButton) {
        if let operationVC = storyboard?.instantiateViewController(withIdentifier: "MyProjectViewController") as? MyProjectViewController{
            self.navigationController?.pushViewController(operationVC, animated: false)
        }
    }

}


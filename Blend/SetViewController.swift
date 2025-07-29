//
//  SetViewController.swift
//  Blend
//
//  Created by Mac OS on 17/07/2024.
//

import UIKit

class SetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource   {

    @IBOutlet weak var tableView:UITableView!
    var brand = String()
    var setArray: [projectStruct] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        switch brand{
         case "Crayola":
            setArray.append(projectStruct(name: "12 pieces",img:  #imageLiteral(resourceName: "single-piece"),pattern:12))
            setArray.append(projectStruct(name: "24 pieces",img:  #imageLiteral(resourceName: "double-piece"),pattern:24))
            setArray.append(projectStruct(name: "36 pieces",img:  #imageLiteral(resourceName: "three-piece"),pattern:36))
            setArray.append(projectStruct(name: "48 pieces",img:  #imageLiteral(resourceName: "four-piece"),pattern:48))
            setArray.append(projectStruct(name: "50 pieces",img:  #imageLiteral(resourceName: "five-piece"),pattern:50))
            setArray.append(projectStruct(name: "100 pieces",img:  #imageLiteral(resourceName: "six-piece"),pattern:100))
            
        case "Prismacolor":
            setArray.append(projectStruct(name: "12 pieces",img:  #imageLiteral(resourceName: "single-piece"),pattern: 12))
            setArray.append(projectStruct(name: "24 pieces",img:  #imageLiteral(resourceName: "double-piece"),pattern:24))
            setArray.append(projectStruct(name: "36 pieces",img:  #imageLiteral(resourceName: "three-piece"),pattern:36))
            setArray.append(projectStruct(name: "48 pieces",img:  #imageLiteral(resourceName: "four-piece"),pattern:48))
            setArray.append(projectStruct(name: "72 pieces",img:  #imageLiteral(resourceName: "five-piece"),pattern:72))
            setArray.append(projectStruct(name: "132 pieces",img:  #imageLiteral(resourceName: "six-piece"),pattern:132))
            setArray.append(projectStruct(name: "150 pieces",img:  #imageLiteral(resourceName: "seven-piece"),pattern:150))
        default:
            setArray.append(projectStruct(name: "12 pieces",img:  #imageLiteral(resourceName: "single-piece"),pattern:12))
            setArray.append(projectStruct(name: "24 pieces",img:  #imageLiteral(resourceName: "double-piece"),pattern:24))
            setArray.append(projectStruct(name: "36 pieces",img:  #imageLiteral(resourceName: "three-piece"),pattern:36))
            setArray.append(projectStruct(name: "60 pieces",img:  #imageLiteral(resourceName: "four-piece"),pattern:60))
            setArray.append(projectStruct(name: "72 pieces",img:  #imageLiteral(resourceName: "five-piece"),pattern:72))
            setArray.append(projectStruct(name: "120 pieces",img:  #imageLiteral(resourceName: "six-piece"),pattern:120))
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectTableViewCell else {return UITableViewCell()}
        cell.customImageView.image = setArray[indexPath.row].img
        cell.nameLabel.text = setArray[indexPath.row].name
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let operationVC = storyboard?.instantiateViewController(withIdentifier: "ImageOperationViewController") as? ImageOperationViewController{
            operationVC.set = setArray[indexPath.row].pattern
            self.present(operationVC, animated: true
            )
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

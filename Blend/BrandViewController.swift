//
//  SavedViewController.swift
//  Blend
//
//  Created by Mac OS on 08/07/2024.
//

import UIKit

class BrandViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tableView:UITableView!
    var brands : [projectStruct] = []
      
    override func viewDidLoad() {
        super.viewDidLoad()
        brands.append(projectStruct(name: "Crayola",img:  #imageLiteral(resourceName: "crayola")))
        brands.append(projectStruct(name: "Prismacolor",img:  #imageLiteral(resourceName: "prisma")))
        brands.append(projectStruct(name: "Faber-Castell",img:  #imageLiteral(resourceName: "faber")))
        
        // Add a note label
        let noteLabel = UILabel()
        noteLabel.text = "Disclaimer: Blend is not affiliated with or endorsed by Crayola Inc., Prismacolor Inc., or Faber-Castell Inc."
        noteLabel.font = UIFont.systemFont(ofSize: 22)
        noteLabel.textColor = .darkGray
        noteLabel.numberOfLines = 0
        noteLabel.textAlignment = .center
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the view
        view.addSubview(noteLabel)
        
        // Constrain the label to the bottom of the view
        NSLayoutConstraint.activate([
            noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noteLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectTableViewCell else {return UITableViewCell()}
        cell.customImageView.image = brands[indexPath.row].img
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let operationVC = storyboard?.instantiateViewController(withIdentifier: "ImageOperationViewController") as? ImageOperationViewController{
//            self.present(operationVC, animated: true
//            )
//        }
        
        if let operationVC = storyboard?.instantiateViewController(withIdentifier: "SetViewController") as? SetViewController{
            operationVC.brand =  brands[indexPath.row].name
          self.navigationController?.pushViewController(operationVC, animated: false)
        }
    }
    
}

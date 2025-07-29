//
//  MyProjectViewController.swift
//  Blend
//
//  Created by Mac OS on 29/06/2024.
//

import UIKit

struct projectStruct{
    var name = String()
    var img = UIImage()
    var pattern = Int()
}


class MyProjectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ViewControllerDelegate {

    @IBOutlet weak var tableView:UITableView!
  //  var projectArray = [projectStruct]()
    var savedProjects: [(projectName: String, selectedColors:[String], imagePath: String)] = [] // Array to store saved projects
      
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func didDismissViewController() {
        loadSavedProjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSavedProjects()
    }
    
   
    func loadSavedProjects() {
        savedProjects = []
        if let savedProjectsDict = UserDefaults.standard.dictionary(forKey: "savedProjects") as? [String: [String: Any]] {
            for (projectName, projectData) in savedProjectsDict {
                // Extract the projectName
                let path = projectData["fileURL"] as? String ?? ""
                
                // Retrieve the colorSet as a string array
                let colors = projectData["colors"] as? [String] ?? []

                // Create a Project object or tuple including colorSet if needed
                savedProjects.append((projectName: projectName, selectedColors: colors, imagePath: path))
            }
        }
        
        // Reload the table view to reflect the changes
        tableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedProjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as? ProjectTableViewCell else {return UITableViewCell()}
    
        cell.customImageView.image = load(fileName: savedProjects[indexPath.row].imagePath)
        cell.nameLabel.text = savedProjects[indexPath.row].projectName
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let operationVC = storyboard?.instantiateViewController(withIdentifier: "ImageOperationViewController") as? ImageOperationViewController{
            operationVC.projectName = savedProjects[indexPath.row].projectName
            operationVC.imagePath = savedProjects[indexPath.row].imagePath
            operationVC.selectedColors = savedProjects[indexPath.row].selectedColors
            operationVC.delegate = self
            self.present(operationVC, animated: true
            )
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
    
    
    
    @IBAction func projectBtn(_ sender: UIButton) {
        if let brandVC = storyboard?.instantiateViewController(withIdentifier: "BrandViewController") as? BrandViewController{
          //  operationVC.delegate = self
            self.navigationController?.pushViewController(brandVC, animated: false)
        }
    }
    
    @IBAction func helptBtn(_ sender: UIButton) {
        if let helpVC = storyboard?.instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController{
          //  operationVC.delegate = self
            self.navigationController?.pushViewController(helpVC, animated: false)
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


class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var customImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.roundView(with: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

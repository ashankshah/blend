//
//  PalleteViewController.swift
//  Blend
//
//  Created by Mac OS on 15/08/2024.
//

import UIKit

protocol ColorPalleteDelegate{
    func pickPalleteColor(color:UIColor)
}

private let reuseIdentifier = "ColorCell"
private let headerReuseIdentifier = "HeaderView"

class PalleteViewController: UICollectionViewController {

  
    var selectedColors = [String]()
    var delegate : ColorPalleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(ColorCell.self, forCellWithReuseIdentifier: reuseIdentifier)
      
        self.collectionView!.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)

            
        // Layout setup
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        collectionView.collectionViewLayout = layout
       
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        layout.headerReferenceSize = CGSize(width: collectionView.frame.width, height: 54)

        collectionView.collectionViewLayout = layout
    }

    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedColors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColorCell
        let hexValue = selectedColors[indexPath.item]
        cell.backgroundColor = UIColor(hex: hexValue)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.delegate?.pickPalleteColor(color: UIColor(hex: self.selectedColors[indexPath.item])!)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionView.elementKindSectionHeader {
               let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! HeaderView
               headerView.titleLabel.text = "Color Palette"
               return headerView
           }
           return UICollectionReusableView()
       }
}


class ColorCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
}


class HeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Color Palette"
        label.font = UIFont(name: "Poppins-Bold", size: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        // Layout constraints for centering the label
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

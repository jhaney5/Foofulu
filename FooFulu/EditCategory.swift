//
//  EditCategory.swift
//  FooFulu
//
//  Created by netset on 11/3/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class EditCategory: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    var arrFoodTypeSet = [String]()
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrFoodTypeSet = ["BreakFast","Lunch","Dinner","Happy Hour"]
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFoodTypeSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
        let holdrView = cell.viewWithTag(1)!
        holdrView.backgroundColor = UIColor.white
        holdrView.dropShadow()
        holdrView.cornerRadiusForView()
        let imgView = cell.viewWithTag(2) as! UIImageView
        imgView.backgroundColor = UIColor.green
        let lblForDinner = cell.viewWithTag(3) as! UILabel
        lblForDinner.text = arrFoodTypeSet[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "headerView",
                                                                             for: indexPath)
            
            let holdrView = headerView.viewWithTag(30)!
            holdrView.backgroundColor = UIColor.white
            holdrView.dropShadow()
            holdrView.cornerRadiusForView()
            return headerView
        default:
            return UICollectionReusableView ()
        }
    }
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.frame.size.width
        return CGSize(width: width/2 - 46, height: width/2 - 46)
    }
}

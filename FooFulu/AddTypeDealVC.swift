//
//  AddTypeDealVC.swift
//  FooFulu
//
//  Created by netset on 11/8/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class AddTypeDealVC: BaseVC,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblPlaceHolder: UILabel!
	
    var collectionView: UICollectionView!
    var viewCheck = UIView()
    var arrFoodIcon = [UIImage]()
    var btnAddPhoto = UIButton()
	var selectedbusienessDetail = BusinessDetail()
	var isComesFromLandingPage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonContinue = UIBarButtonItem(title: "continue", style: .plain, target: self, action: #selector(self.btnActForCont(sender:)))
        self.navigationItem.rightBarButtonItem = buttonContinue
        Constant.imageSet.originalImage = nil
		self.navigationItem.leftBarButtonItem  = UIBarButtonItem(image: #imageLiteral(resourceName: "navigationBack"), style: .plain, target: self, action:#selector(self.btnActForBack(sender:)))
//        txtView.becomeFirstResponder()
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//UIApplication.shared.isStatusBarHidden = false
//		txtView.becomeFirstResponder()
		self.textViewAccessoryViewSet()
		print(arrFoodIcon.count)
		if !(Constant.imageSet.originalImage == nil) {
			txtView.becomeFirstResponder()
			arrFoodIcon.append(Constant.imageSet.originalImage!)
			self.checkForAddBtn()
			collectionView.reloadData()
		}
 	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		txtView.becomeFirstResponder()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		Constant.imageSet.originalImage = nil
	}
	func btnActForBack(sender:UIButton) {
		if isComesFromLandingPage{
			let appDelegate = UIApplication.shared.delegate as! AppDelegate
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let objMain: UITabBarController? = storyboard.instantiateViewController(withIdentifier: "HomeTabBarVC") as? UITabBarController
			appDelegate.window?.rootViewController = objMain
		}else{
			_ = navigationController?.popViewController(animated: true)
		}
	}
	
    func btnActForCont(sender:UIButton) {
        if txtView.text.count == 0 {
            alertViewController(title: "Alert!", message: "Please fill deal.")
		}else if arrFoodIcon.count == 0 {
			AlertUtility.showAlert(self, title: "Alert", message: "Are you sure you don’t want to add a photo?", cancelButton: "No", buttons: ["Yes"], actions: { (_, index) in
				if index != AlertUtility.CancelButtonIndex {
					let objEditDaySpecialVC :EditDaySpecialVC = self.storyboard?.instantiateViewController(withIdentifier: "EditDaySpecialVC") as! EditDaySpecialVC
					objEditDaySpecialVC.strForOrder = self.txtView.text
					objEditDaySpecialVC.addedBusienessImages = self.arrFoodIcon
					objEditDaySpecialVC.selectedbusienessData = self.selectedbusienessDetail
					self.navigationController?.pushViewController(objEditDaySpecialVC, animated: true)
				}
			})
		}else{
			let objEditDaySpecialVC :EditDaySpecialVC = self.storyboard?.instantiateViewController(withIdentifier: "EditDaySpecialVC") as! EditDaySpecialVC
			objEditDaySpecialVC.strForOrder = self.txtView.text
			objEditDaySpecialVC.addedBusienessImages = self.arrFoodIcon
			objEditDaySpecialVC.selectedbusienessData = self.selectedbusienessDetail
			self.navigationController?.pushViewController(objEditDaySpecialVC, animated: true)
		}
    }
    
    func textViewAccessoryViewSet () {
        let lblData = UILabel()
        lblData.frame = CGRect.init(x: 10, y: 6, width:self.view.frame.size.width , height: 20)
        lblData.text = "Add photo to your deal:"
        lblData.font = UIFont.init(name: "Arial", size: 13)
        lblData.textColor = UIColor.gray
        viewCheck.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 100)
        viewCheck.backgroundColor = UIColor.init(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
        viewCheck.addSubview(lblData)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 10, width: 220, height: viewCheck.frame.size.height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
        //   collectionView.prefetchDataSource = self
        collectionView.dataSource = self
        viewCheck.addSubview(collectionView!)
//        btnAddPhoto.frame = CGRect.init(x: collectionView.frame.origin.x + collectionView.frame.size.width + 10, y: 30, width: 60, height: 60)
        btnAddPhoto.frame = CGRect.init(x: self.view.frame.size.width - 70, y: 30, width: 60, height: 60)
        btnAddPhoto.backgroundColor = UIColor.init(red: 232.0/255.0, green: 231.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        btnAddPhoto.setImage(#imageLiteral(resourceName: "addPhotoEditype"), for: .normal)
        btnAddPhoto.addTarget(self, action: #selector(cameraNumberPad), for: .touchUpInside)
        viewCheck.addSubview(btnAddPhoto)
        self.checkForAddBtn()
        txtView.inputAccessoryView = viewCheck
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFoodIcon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.contentView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        let imgView = UIImageView()
        imgView.frame = CGRect.init(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
        imgView.image = arrFoodIcon[indexPath.row]
        cell.addSubview(imgView)
        let btnDelete = UIButton()
        btnDelete.frame = CGRect.init(x: cell.frame.size.width - 24, y: 4, width: 20, height: 20)
        btnDelete.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        btnDelete.addTarget(self, action: #selector(btnActForDelete), for: .touchUpInside)
        cell.addSubview(btnDelete)
        return cell
    }
    
    func btnActForDelete (sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: buttonPosition)
        print((indexPath?.item)!)
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this picture ?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Delete", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.deleteCellInCollectionView(at: (indexPath?.item)!)
            alert.dismiss(animated: true, completion: { _ in })
        })
        let noButton = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            alert.dismiss(animated: true, completion: { _ in })
        })
        alert.addAction(noButton)
        alert.addAction(yesButton)
        self.present(alert, animated: true, completion: { _ in })
    }
    
    func deleteCellInCollectionView(at index: Int) {
        arrFoodIcon.remove(at: index)
        self.checkForAddBtn()
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
		
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let objHomeVC :HomeVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //        //  objHomeVC.strFoodName = arrFoodTypeSet[indexPath.item]
        //        self.navigationController?.pushViewController(objHomeVC, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count == 1 && range.location == 0 {
            lblPlaceHolder.isHidden = false
        } else {
            lblPlaceHolder.isHidden = true
        }
        return true
    }
	
    func checkForAddBtn () {
        if arrFoodIcon.count > 2 {
            btnAddPhoto.isHidden = true
        } else {
            btnAddPhoto.isHidden = false
        }
    }
	
    func cameraNumberPad () {
		txtView.becomeFirstResponder()
        super.galleryAlert()
    }
    
    func doneWithNumberPad () {
        print("Done Butn Clicked")
        self.txtView.resignFirstResponder()
    }
    
    func btnActForContinue (sender:UIButton) {
        let objEditDaySpecialVC :EditDaySpecialVC = storyboard?.instantiateViewController(withIdentifier: "EditDaySpecialVC") as! EditDaySpecialVC
        objEditDaySpecialVC.strForOrder = txtView.text
        self.navigationController?.pushViewController(objEditDaySpecialVC, animated: true)
    }
    
    // MARK: - Button Action
    @IBAction func btnActForAddPhoto(_ sender: Any) {
    }
	
}

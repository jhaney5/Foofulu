//
//  EditDealVC.swift
//  FooFulu
//
//  Created by netset on 11/3/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class EditDealVC: BaseVC {
    @IBOutlet weak var btnForAddPhoto: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedDealDetailData:DealDetail!
    var textView = UITextView()
    var arrayOfImage = NSMutableArray()
    var strDeletedImagesIds : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIApplication.shared.isStatusBarHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.backBtnWithNavigationTitle(title: selectedDealDetailData.business.name)
        let buttonContinue = UIBarButtonItem(title: "Conitnue", style: .plain, target: self, action: #selector(buttonActForContinue))
        self.navigationItem.rightBarButtonItem = buttonContinue
        for index in 0..<selectedDealDetailData.images.count {
            let dict : NSDictionary = ["url":Constant.WebServicesApi.baseUrl + selectedDealDetailData.images[index].image!,"id":selectedDealDetailData.images[index].id,"image":""]
            arrayOfImage.add(dict)
        }
        self.checkImageCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func checkImageCount()  {
        if arrayOfImage.count  > 2 {
            btnForAddPhoto.isHidden = true
        } else {
            btnForAddPhoto.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
//    AlertUtility.showAlert(self, title: "Alert", message: "Are you sure you don’t want to add a photo?", cancelButton: "No", buttons: ["Yes"], actions: { (_, index) in
//    if index != AlertUtility.CancelButtonIndex {
//    let objEditDaySpecialVC :EditDaySpecialVC = self.storyboard?.instantiateViewController(withIdentifier: "EditDaySpecialVC") as! EditDaySpecialVC
//    objEditDaySpecialVC.strForOrder = self.txtView.text
//    objEditDaySpecialVC.addedBusienessImages = self.arrFoodIcon
//    objEditDaySpecialVC.selectedbusienessData = self.selectedbusienessDetail
//    self.navigationController?.pushViewController(objEditDaySpecialVC, animated: true)
//    }
//    })
    
    
    
    //updateProfile
    func buttonActForContinue () {
      /*  if textView.text.trimmingCharacters(in: CharacterSet.whitespaces).count==0 {
            alertViewController(title: "Alert!", message: "Please fill deal.")
        } else if arrayOfImage.count == 0 {
            alertViewController(title: "Alert!", message: "Please add image.")
        } else {
            let objEditDaySpecialVC :EditDaySpecialVC = self.storyboard?.instantiateViewController(withIdentifier: "EditDaySpecialVC") as! EditDaySpecialVC
            var arrayForImages = [UIImage]()
            for index in 0..<arrayOfImage.count{
                if ((arrayOfImage.value(forKey: "url") as! NSArray)[index] as! String).count==0 {
                    arrayForImages.append(((arrayOfImage.value(forKey: "image") as! NSArray)[index] as? UIImage)!)
                }
            }
            objEditDaySpecialVC.addedBusienessImages = arrayForImages
            objEditDaySpecialVC.strForOrder = textView.text!
            objEditDaySpecialVC.selectedDealDetailForUpdate = selectedDealDetailData
            objEditDaySpecialVC.strDeleteImageIds = strDeletedImagesIds
            self.navigationController?.pushViewController(objEditDaySpecialVC, animated: true)
        }*/
        if textView.text.trimmingCharacters(in: CharacterSet.whitespaces).count==0 {
            alertViewController(title: "Alert!", message: "Please fill deal.")
        }else if arrayOfImage.count == 0 {
            AlertUtility.showAlert(self, title: "Alert", message: "Are you sure you don’t want to add a photo?", cancelButton: "No", buttons: ["Yes"], actions: { (_, index) in
                if index != AlertUtility.CancelButtonIndex {
                    self.moveToNextController()
                }
            })
        } else {
            self.moveToNextController()
        }
    }
    
    func moveToNextController()  {
        let objEditDaySpecialVC :EditDaySpecialVC = self.storyboard?.instantiateViewController(withIdentifier: "EditDaySpecialVC") as! EditDaySpecialVC
        var arrayForImages = [UIImage]()
        for index in 0..<self.arrayOfImage.count{
            if ((self.arrayOfImage.value(forKey: "url") as! NSArray)[index] as! String).count==0 {
                arrayForImages.append(((self.arrayOfImage.value(forKey: "image") as! NSArray)[index] as? UIImage)!)
            }
        }
        objEditDaySpecialVC.addedBusienessImages = arrayForImages
        objEditDaySpecialVC.strForOrder = self.textView.text!
        objEditDaySpecialVC.selectedDealDetailForUpdate = self.selectedDealDetailData
        objEditDaySpecialVC.strDeleteImageIds = self.strDeletedImagesIds
        self.navigationController?.pushViewController(objEditDaySpecialVC, animated: true)
    }
    
    // MARK :- Action For button
    @IBAction func btnActForAddPhoto(_ sender: Any) {
        self.galleryAlertAlert()
    }
    
    func galleryAlertAlert() {
        let imageController = UIImagePickerController()
        imageController.isEditing = false
        imageController.delegate = self
        let optionMenu = UIAlertController(title: nil, message: "Choose Image", preferredStyle: .actionSheet)
        let fromGalleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            imageController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imageController, animated: true, completion: nil)
            print("Upload From Gallery")
        })
        let fromCameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                imageController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imageController, animated: true, completion: nil)
                print("Take Photo")
            }else {
                let alert = UIAlertController(title: "Error !!!", message: "Camera not available", preferredStyle: .alert)
                print("Camera not available")
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                    (alert: UIAlertAction!) -> Void in
                    print("Cancel")
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        optionMenu.addAction(fromGalleryAction)
        optionMenu.addAction(fromCameraAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    override func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        let dict : NSDictionary = ["url":"","id":"","image":image]
        arrayOfImage.add(dict)
        self.checkImageCount()
        collectionView.reloadData()
        picker.dismiss(animated: false, completion: {() -> Void in
        })
    }
    
    func btnActForDelete (sender: UIButton) {
        print(sender.tag-1000)
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this picture ?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Delete", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.deleteCellInCollectionView(at:sender.tag-1000)
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
        if ((arrayOfImage.value(forKey: "url") as! NSArray)[index] as! String).count>0 {
            if strDeletedImagesIds.count==0 {
                strDeletedImagesIds = String((arrayOfImage.value(forKey: "id") as! NSArray)[index] as! Int)
            } else {
                strDeletedImagesIds = strDeletedImagesIds + "," + String((arrayOfImage.value(forKey: "id") as! NSArray)[index] as! Int)
            }
        }
        arrayOfImage.removeObject(at: index)
        self.checkImageCount()
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EditDealVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! collectionViewCell
        cell.imgViewDeal.cornerRadiusForView()
        cell.imgViewDeal.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        cell.imgViewDeal.kf.indicatorType = .activity
        if ((arrayOfImage.value(forKey: "url") as! NSArray)[indexPath.row] as! String).count>0 {
            cell.imgViewDeal.kf.setImage(with:URL(string:(arrayOfImage.value(forKey: "url") as! NSArray)[indexPath.row] as! String))
        } else {
            cell.imgViewDeal.image = (arrayOfImage.value(forKey: "image") as! NSArray)[indexPath.row] as? UIImage
        }
        cell.btnForDelete.tag = indexPath.row+1000
        cell.btnForDelete.addTarget(self, action: #selector(btnActForDelete), for: .touchUpInside)
        //let lblForDetail = cell.viewWithTag(2) as! UILabel
        //lblForDetail.text = arrDetail[indexPath.item]
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
            textView = (holdrView.viewWithTag(112) as? UITextView)!
            textView.text = selectedDealDetailData.title
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
        if indexPath.row % 3 == 0 {
            return CGSize(width: width - 20, height: width/2)
        } else {
            return CGSize(width: width/2 - 40, height: width/2 - 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

class collectionViewCell:UICollectionViewCell{
    @IBOutlet weak var btnForDelete: UIButton!
    @IBOutlet weak var imgViewDeal: UIImageView!
}


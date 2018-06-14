//
//  EditDaySpecialVC.swift
//  FooFulu
//
//  Created by netset on 11/3/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class EditDaySpecialVC: BaseVC {
	@IBOutlet weak var categoryTitle: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	var selectedDealDetailForUpdate:DealDetail!
	var strDeleteImageIds:String!
	var selectedbusienessData:BusinessDetail!
	var addedBusienessImages:[UIImage]!
	var arrFoodIcon = [UIImage]()
	var dealStatus = DealData()
	var strForOrder=String()
	var cell : UICollectionViewCell?
	var daysWithCategory:DaysWithCategory?
	var selectedDaysIdArray = [Int]()
	var selectedCategoryIdArray = [Int]()
	var isEveryDayClicked = Bool()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		categoryTitle.text = strForOrder
		if selectedbusienessData != nil {
			super.backBtnWithNavigationTitle(title: selectedbusienessData.name!)
		} else {
			super.backBtnWithNavigationTitle(title: selectedDealDetailForUpdate.business.name)
			self.setDataForEdit()
		}
		arrFoodIcon = [#imageLiteral(resourceName: "breaffast"),#imageLiteral(resourceName: "lunch"),#imageLiteral(resourceName: "dinner"),#imageLiteral(resourceName: "happy-hr")]
		let buttonContinue = UIBarButtonItem(title: "POST", style: .plain, target: self, action: #selector(self.btnActForPost(sender:)))
		self.navigationItem.rightBarButtonItem = buttonContinue
	}
	
	func setDataForEdit() {
		for index in 0..<selectedDealDetailForUpdate.dealcategories.count{
			selectedCategoryIdArray.append(selectedDealDetailForUpdate.dealcategories[index].id)
		}
		for index in 0..<selectedDealDetailForUpdate.days.count{
			selectedDaysIdArray.append(selectedDealDetailForUpdate.days[index].id)
		}
		if selectedDaysIdArray.count < 7{
			isEveryDayClicked = false
		}else{
			isEveryDayClicked = true
		}
		collectionView.reloadData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		getWeekDaysData()
		collectionView.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func btnActForPost(sender:UIButton) {
		if selectedDaysIdArray.count == 0 {
			alertViewController(title: "", message: "Please select day.")
		} else if selectedCategoryIdArray.count == 0 {
			alertViewController(title: "", message: "Please select food type.")
		} else {
			if selectedbusienessData != nil {
				addDealApi()
			} else {
				// hit update api
				updateDealApi()
			}
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "dealAddedIdentifer"{
			let addFirstObj = segue.destination as! AddFirstDealVC
			addFirstObj.isDealAdded = dealStatus
		}
	}
	// MARK: Calling API
	
	func addDealApi(){
		let formattedCategoryArray = (selectedCategoryIdArray.map{String($0)}).joined(separator: ",")
		let formattedDaysArray = (selectedDaysIdArray.map{String($0)}).joined(separator: ",")
		let parameters = ["businessId":selectedbusienessData.id ?? "nil" ,
						  "dealTitle":strForOrder.utf8EncodedString(),
						  "days":formattedDaysArray,
						  "meals":formattedCategoryArray] as [String : Any]
		postServiceForUploadImagesArray(requestUrl: Constant.WebServicesApi.addDealApi, imagesArray: addedBusienessImages, params: parameters as NSDictionary) { (result) in
			do{
				self.dealStatus = try JSONDecoder().decode(DealData.self, from:result)
			}catch let jsonError{
				print("error",jsonError)
			}
			self.performSegue(withIdentifier: "dealAddedIdentifer", sender: nil)
		}
	}
	
	func updateDealApi(){
		let formattedCategoryArray = (selectedCategoryIdArray.map{String($0)}).joined(separator: ",")
		let formattedDaysArray = (selectedDaysIdArray.map{String($0)}).joined(separator: ",")
		let parameters = ["dealId":String(selectedDealDetailForUpdate.dealId),
						  "dealTitle":strForOrder.utf8EncodedString(),
						  "days":formattedDaysArray,
						  "deletedImages":strDeleteImageIds,
						  "meals":formattedCategoryArray] as [String : Any]
		postServiceForUploadImagesArray(requestUrl: Constant.WebServicesApi.updateDeal, imagesArray: addedBusienessImages, params: parameters as NSDictionary) { (result) in
			self.performSegue(withIdentifier: "dealAddedIdentifer", sender: nil)
		}
	}
	
	func getWeekDaysData() {
		getService(requestURL: Constant.WebServicesApi.getCategoriesAndDays) { (result) in
			print(result)
			do{
				self.daysWithCategory = try JSONDecoder().decode(DaysWithCategory.self, from:result)
				self.collectionView.reloadData()
			}catch let jsonError{
				print("error",jsonError)
			}
		}
	}
}

extension EditDaySpecialVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0{
			if daysWithCategory?.listDays != nil{
				return 8
			}
		} else  if section == 1{
			if daysWithCategory?.listDays != nil{
				return 4
			}
		}
		return 0
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		if  section == 1 {
			return CGSize(width: collectionView.frame.size.width, height: 20)
		}
		return CGSize(width: 0, height: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EditDaySpecialCollectionViewCell", for: indexPath) as! EditDaySpecialCollectionViewCell
		let daysCategoryData = daysWithCategory?.listDays[indexPath.row]
		if indexPath.section == 1 {
			let daysCategoryDataa = daysWithCategory?.listDays[indexPath.row+8]
			if (selectedCategoryIdArray.contains((daysCategoryDataa?.id)!)){
				cell.categoryName.text = daysCategoryDataa?.day
				cell.categoryImage.image = arrFoodIcon[indexPath.row]
				cell.viewAtBack.backgroundColor =  Constant.Color.k_AppNavigationColor
				cell.dayNameLabel.text = nil
			}else{
				cell.categoryName.text = daysCategoryDataa?.day
				cell.categoryImage.image = arrFoodIcon[indexPath.row]
				cell.viewAtBack.backgroundColor =  UIColor.white
				//cell.categoryImage
				cell.dayNameLabel.text = nil
			}
		} else {
			if indexPath.row == 7{
				if isEveryDayClicked{
					cell.dayNameLabel.textColor = UIColor.white
					cell.dayNameLabel.text = daysCategoryData?.day
					cell.categoryImage.image = nil
					cell.viewAtBack.backgroundColor =  Constant.Color.k_AppNavigationColor
					cell.categoryName.text = nil
				}else{
					cell.dayNameLabel.text = daysCategoryData?.day
					cell.dayNameLabel.textColor = Constant.Color.k_ApGrayFontColor
					cell.categoryImage.image = nil
					cell.viewAtBack.backgroundColor = UIColor.white
					cell.categoryName.text = nil
				}
			}else{
				if (selectedDaysIdArray.contains((daysCategoryData?.id)!)){
					cell.dayNameLabel.textColor = UIColor.white
					cell.dayNameLabel.text = daysCategoryData?.day
					cell.categoryImage.image = nil
					cell.viewAtBack.backgroundColor =  Constant.Color.k_AppNavigationColor
					cell.categoryName.text = nil
				}else{
					cell.dayNameLabel.text = daysCategoryData?.day
					cell.categoryImage.image = nil
					cell.dayNameLabel.textColor = Constant.Color.k_ApGrayFontColor
					cell.viewAtBack.backgroundColor = UIColor.white
					cell.categoryName.text = nil
					
				}
			}
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.section == 1{
			if let index = selectedCategoryIdArray.index(where: { $0 == daysWithCategory?.listDays[indexPath.row].id }) {
				selectedCategoryIdArray.remove(at: index)
			}else{
				selectedCategoryIdArray.append((daysWithCategory?.listDays[indexPath.row].id)!)
			}
		}else{
			if indexPath.row == 7{
				if isEveryDayClicked{
					isEveryDayClicked = false
					selectedDaysIdArray.removeAll()
				}else{
					isEveryDayClicked = true
					for i in 0...6{
						if !(selectedDaysIdArray.contains((daysWithCategory?.listDays[i].id)!)){
							selectedDaysIdArray.append((daysWithCategory?.listDays[i].id)!)
						}
					}
				}
			}else{
				let itemToRemove =  daysWithCategory?.listDays[indexPath.row].id
				var isMatch:Bool = false
				if selectedDaysIdArray.count > 0 {
					for index in 0..<selectedDaysIdArray.count{
						let value = selectedDaysIdArray[index]
						if  value == itemToRemove{
							isMatch = true
							selectedDaysIdArray.remove(at: index)
							break
						}
					}
				}
				if !isMatch{
					selectedDaysIdArray.append((daysWithCategory?.listDays[indexPath.row].id)!)
				}
				if selectedDaysIdArray.count < 7{
					isEveryDayClicked = false
				}else{
					isEveryDayClicked = true
				}
			}
		}
		collectionView.reloadData()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: (collectionView.frame.size.width/4)-15, height: (collectionView.frame.size.width/4)-20)
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	func collectionView(_ collectionView: UICollectionView,viewForSupplementaryElementOfKind kind: String,at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionElementKindSectionHeader:
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "collectionViewHeaderView",for: indexPath) as! collectionViewHeaderView
			return headerView
		default:
			return UICollectionReusableView()
		}
	}
}

class collectionViewHeaderView: UICollectionReusableView {
	@IBOutlet weak var viewForLine: UIView!
}

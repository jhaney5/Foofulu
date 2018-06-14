//
//  ContactUsViewController.swift
//  FooFulu
//
//  Created by netset on 07/02/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseVC {
	//MARK:- OUTLET(S)
	@IBOutlet weak var selectTypeTextfield: UITextField!
	@IBOutlet weak var feedbackTextView: UITextView!
	//MARK:- CONSTANT(S)
	var valuesArray = ["Bug Report","General Feedback"]
	var pickerView = UIPickerView()
	
	//MARK:- LIFE CYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		setRightViewImageOnTextfield()
		pickerView.delegate = self
		pickerView.dataSource = self
		selectTypeTextfield.inputView = pickerView
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.title = "Cantact Us"
	}
	
	//MARK:- PRIVATE METHOD(S)
	fileprivate func setRightViewImageOnTextfield(){
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
		let image = UIImage(named: "down_arrow")
		imageView.image = image
		view.addSubview(imageView)
		selectTypeTextfield.rightView = view
		selectTypeTextfield.rightViewMode = .always
	}
	
	fileprivate func contactUsApi(){
		let parameters = [
			"subject" : selectTypeTextfield.text!,
			"feedback": "qeeqw"//feedbackTextView.text!
		]
		super.showAnloaderFunct (text:"Fetching data..")
		super.postMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.contactUsApi, params: parameters as AnyObject) { (response) in
			print(response)
		}
	}
	
	fileprivate func formValidate() -> Bool{
		var message:String? = ""
		if (selectTypeTextfield.text?.isEmpty)!{
			message = "Please select type"
		}else if (feedbackTextView.text?.isEmpty)!{
			message = "Please enter feedback"
		}else{
			return true
		}
		if message != nil{
			let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
		return false
	}
	
	//MARK:- IB-ACTION(S)
	@IBAction func submitButonTapped(_ sender: Any) {
		if formValidate(){
			contactUsApi()
		}
	}
}
//MARK:- UIPICKERVIEW DELEGAT(S) AND DATASOURC(S)
extension ContactUsViewController:UIPickerViewDelegate,UIPickerViewDataSource{
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return valuesArray.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return valuesArray[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		selectTypeTextfield.text = valuesArray[row]
	}
}

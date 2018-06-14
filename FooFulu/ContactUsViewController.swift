//
//  ContactUsViewController.swift
//  FooFulu
//
//  Created by netset on 07/02/18.
//  Copyright © 2018 netset. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseVC,UITextViewDelegate{
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
		feedbackTextView.delegate = self
		selectTypeTextfield.inputView = pickerView
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationItem.title = "Contact Us"
	}
	
	//MARK:- PRIVATE METHOD(S)
	fileprivate func setRightViewImageOnTextfield(){
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 15))
		button.setImage(#imageLiteral(resourceName: "down_arrowWhite"), for: .normal)
		button.addTarget(self, action: #selector(textfieldRightArrowAction), for: .touchUpInside)
		selectTypeTextfield.rightView = button
		selectTypeTextfield.rightViewMode = .always
	}
	
	@objc fileprivate func textfieldRightArrowAction() {
		selectTypeTextfield.becomeFirstResponder()
	}
	
	fileprivate func contactUsApi(){
        feedbackTextView.resignFirstResponder()
		let parameters = [
			"subject" : selectTypeTextfield.text!,
			"feedback": feedbackTextView.text!
		]
		super.showAnloaderFunct (text:"Fetching data..")
		super.postMultipleArrayServiceWithParameters(requestUrl: Constant.WebServicesApi.contactUsApi, params: parameters as AnyObject) { (response) in
			print(response)
            let alert = UIAlertController(title: nil, message:  ((response as! NSDictionary).value(forKey: "message")! as! String), preferredStyle: .alert)
            let yesButton = UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.navigationController?.popViewController(animated: true)
                alert.dismiss(animated: true, completion: { _ in })
            })
            alert.addAction(yesButton)
            self.present(alert, animated: true, completion: { _ in })
		}
	}
	
	fileprivate func formValidate() -> Bool {
		var message:String? = ""
		if (selectTypeTextfield.text?.isEmpty)! {
			message = "Please select type"
		} else if (feedbackTextView.text?.isEmpty)! {
			message = "Please enter feedback"
		} else {
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
	
	//MARK:- TEXTVIEW DELEGATE
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
		let numberOfChars = newText.count
		return numberOfChars < 200
	}
}

//MARK:- UIPICKERVIEW DELEGATE(S) AND DATASOURCE(S)
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

//
//  SettingDetailVC.swift
//  FooFulu
//
//  Created by netset on 11/6/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class SettingDetailVC: BaseVC,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
     var arrForTitle = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.backBtnWithNavigationTitle(title: "Push Notifications")
        
        arrForTitle = ["Facebook","Google","Email"]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Constant.GlobalVariables.checkForSetting == "Push Notifications" {
            return 1
        } else {
            return arrForTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.clear
        
        let lblNameAccount = cell.viewWithTag(100) as! UILabel
        
        if Constant.GlobalVariables.checkForSetting == "Push Notifications" {
            lblNameAccount.text = "Recommended Deals"
        } else {
            lblNameAccount.text = arrForTitle[indexPath.row]
        }
        
        let switchview = UISwitch(frame:  CGRect.zero)
        cell.accessoryView = switchview
        switchview.layer.cornerRadius = (switchview.frame.size.height)/2
        switchview.addTarget(self, action: #selector(self.updateSwitch), for: .touchUpInside)
         switchview.thumbTintColor = UIColor.white
        switchview.tintColor = UIColor.gray
        switchview.backgroundColor = UIColor.clear
        
        
//        if (switchview.isOn) {
//            
//           switchview.onTintColor = UIColor.white
//           switchview.backgroundColor = UIColor.blue
//            switchview.isOn = true
//        }
//        else
//        {
//            switchview.backgroundColor = UIColor.gray
//            switchview.isOn = false
//        }

        
        switchview.onTintColor = UIColor.blue
       // switchview.thumbTintColor = GlobalConstantClass.Color.k_AppTextBlueColor
        switchview.isOn = true
        
        
        
        return cell
    }
    
    func updateSwitch(atIndexPath aswitch: UISwitch)
    {
        if aswitch.isOn
        {
          //  aswitch.onTintColor = UIColor.white
            aswitch.backgroundColor = UIColor.blue
           
        }
        else
        {
          //  aswitch.tintColor = UIColor.white
            aswitch.backgroundColor = UIColor.gray
          
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

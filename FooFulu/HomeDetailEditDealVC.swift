//
//  HomeDetailEditDealVC.swift
//  FooFulu
//
//  Created by netset on 11/8/17.
//  Copyright © 2017 netset. All rights reserved.
//

import UIKit

class HomeDetailEditDealVC: BaseVC,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollViewImage: UIScrollView!
    @IBOutlet weak var lblPaging: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var layoutForScrollHeight: NSLayoutConstraint!
    
    var arrForTitle = [String]()
    var arrForIndex = [String]()
    var arrMenuIconList = [UIImage]()
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrMenuIconList = [#imageLiteral(resourceName: "foodScroll"),#imageLiteral(resourceName: "foodScroll1"),#imageLiteral(resourceName: "food")]
        lblPaging.createCornerRadiusForLabel()
        scrollViewImage.delegate = self
        self.btnFavourite.isSelected = true
        //UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        arrForTitle = ["Happy Hour Beers $4, Cocktails $6 Friday + Saturday From 4pm-6pm","Early Birds Specials                      Tuesday From 12pm-2pm"]
        arrForIndex = ["1","2"]
        self.callForScrollView()
        lblPaging.text = "\(1)" + " of " + "\(arrMenuIconList.count)" + " >"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let width = self.view.frame.size.width
        let page:Int = Int((scrollViewImage.contentOffset.x + width)/width)
		if arrMenuIconList.count < 1 {
			lblPaging.isHidden = true
		}
        lblPaging.text = "\(page)" + " of " + "\(arrMenuIconList.count)" + " >"
    }
    
    func callForScrollView () {
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollViewImage.frame = CGRect(x: CGFloat(0), y: 0, width: CGFloat(self.view.frame.size.width), height: CGFloat(self.scrollViewImage.frame.height))
        
        for i in 0..<arrMenuIconList.count
        {
            let profileImages = UIImageView()
            profileImages.frame = CGRect(x: CGFloat(self.scrollViewImage.frame.width * CGFloat(i)), y: scrollViewImage.frame.origin.y, width: CGFloat(self.view.frame.size.width), height: CGFloat(self.layoutForScrollHeight.constant))
            profileImages.contentMode = .scaleToFill
            profileImages.image = arrMenuIconList[i]
            profileImages.clipsToBounds = true
            profileImages.layer.masksToBounds = true
            scrollViewImage.addSubview(profileImages)
         //   scrollViewImage.backgroundColor = UIColor.red
         //   profileImages.backgroundColor = UIColor.orange
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveLinear, animations: {() -> Void in
                
                self.scrollViewImage.contentSize = CGSize(width: CGFloat(self.scrollViewImage.frame.width * CGFloat(i + 1)), height: CGFloat(self.layoutForScrollHeight.constant))
                
            }, completion: {(_ finished: Bool) -> Void in
            })
            scrollViewImage.showsHorizontalScrollIndicator = false
        }
    }
    
    @IBAction func btnActForBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 98
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        headerView?.backgroundColor = Constant.Color.k_AppBackColor
        let setRatingView = headerView?.viewWithTag(2) as! FloatRatingView
        setRatingView.isUserInteractionEnabled = false
        setRatingView.rating = Double(4.5)
        
       super.ratingColorCordination(setRatingView: setRatingView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrForTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = Constant.Color.k_AppBackColor
        // label
        let lblIndex = cell.viewWithTag(1) as! UILabel
        let lblForTitle = cell.viewWithTag(2) as! UILabel
        
        lblIndex.text = arrForIndex[indexPath.row]
        lblForTitle.text = arrForTitle[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let objEditHomeDealVC :EditHomeDealVC = storyboard?.instantiateViewController(withIdentifier: "EditHomeDealVC") as! EditHomeDealVC
        self.navigationController?.pushViewController(objEditHomeDealVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action 
    
    @IBAction func btnActForFavourite(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}




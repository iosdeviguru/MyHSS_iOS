//
//  ViewSankhyaVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 16/04/2021.
//

import UIKit

class ViewSankhyaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let section = ["Sankhya","Male", "Female" ]
    
    let itemsName = [["Shishu", "Baal", "Kishore", "Tarun", "Yuva", "Jyeshta"], ["Shishu", "Baalika", "Kishori", "Taruni", "Yuvati", "Jyeshtaa"]]
    let itemsDetails = [["Below 5 Years - Pre-primary ", "5 to 11 Years - Primary School", "11 to 16 Years - Middle School", "17 to 25 Years - High School/College", "25 to 60 Years - Adults", ">60 Years - Senior citizen"], ["Below 5 Years - Pre-primary ", "5 to 11 Years - Primary School", "11 to 16 Years - Middle School", "17 to 25 Years - High School/College", "25 to 60 Years - Adults", ">60 Years - Senior citizen"],["Attendees"]]
    var itemValue = [["0", "0", "0", "0", "0", "0"], ["0", "0", "0", "0", "0", "0"]]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblTotal3: UILabel!
    var id = ""
    
    var dicMember = [[String:Any]]()
    
    var total = 0
    
    
    
    let totalLabel = UILabel(frame: CGRect(x: 80, y:  5, width: 40, height: 40))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getRecordAPI()
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "view_sankhya".localized, showbtn: "back")
    }
    
    // MARK: TableView Methods
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        
        return self.section[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        /// For value counting total
        var total = 0
        for i in 0..<itemValue.count {
            for j in 0..<itemValue[i].count {
                let value = Int(itemValue[i][j])!
                total += value
            }
        }
        let totalMembers3 = dicMember.count
        lblTotal3.font = UIFont.boldSystemFont(ofSize: 15)
        self.lblTotal3.text = "            Guest: \(total)     Sankhya:\(totalMembers3)    Total: \(totalMembers3 + total)"
        return self.section.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            
            let rect = CGRect(x: 20, y: 0, width: tableView.frame.size.width - 40, height: 60)
            let footerView = UIView(frame:rect)
            footerView.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            
            let lblTitle = UILabel(frame: CGRect(x: 20.0, y: footerView.center.y / 2, width: 160, height: 30))
            lblTitle.text = self.section[section]
            lblTitle.font = UIFont(name: "SourceSansPro-Regular", size: 20.0)
            lblTitle.backgroundColor = UIColor.clear
            lblTitle.textColor = UIColor.init(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1.0)
            
            
            
            footerView.addSubview(lblTitle)
            
            return footerView
        } else {
            let rect = CGRect(x: 20, y: 0, width: tableView.frame.size.width - 40, height: 60)
            let footerView = UIView(frame:rect)
            footerView.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            
            let lblTitle = UILabel(frame: CGRect(x: 20.0, y: footerView.center.y / 2, width: 200, height: 40))
            //            lblTitle.text = "Guest Information"
            //            lblTitle.text = "Additional Guest Total:\(total)"
            //            lblTitle.text = "Total: \(total)"
            
            lblTitle.font = UIFont(name: "SourceSansPro-Regular", size: 20.0)
            lblTitle.backgroundColor = UIColor.clear
            lblTitle.textColor = UIColor.init(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1.0)
            
            let lblGender = UILabel(frame: CGRect(x: lblTitle.frame.width, y: footerView.center.y / 2, width: 80, height: 30))
            lblGender.text = self.section[section]
            lblGender.font = UIFont(name: "SourceSansPro-SemiBold", size: 16.0)
            lblGender.textColor = UIColor.black
            lblGender.backgroundColor = UIColor.init(red: 255.0/255.0, green: 230.0/255.0, blue: 190.0/255.0, alpha: 1.0)
            lblGender.layer.cornerRadius = 15.0
            lblGender.layer.masksToBounds = true
            lblGender.textAlignment = .center
            
            footerView.addSubview(lblGender)
            footerView.addSubview(lblTitle)
            return footerView
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60  // or whatever
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return self.dicMember.count
            
        } else {
            
            return self.itemsName[section-1].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendancePreviewTVCell", for: indexPath) as! AttendancePreviewTVCell
        
        // Update the number of dicMembers label
        //            cell.lblCount.text = "Count: \(dicMember.count)"
        
        if indexPath.section == 0 {
            let strFirstName : String = dicMember[indexPath.row]["first_name"] as! String
            let strMiddleName : String = dicMember[indexPath.row]["middle_name"] as! String
            let strLastName : String = dicMember[indexPath.row]["last_name"] as! String
            
            strMiddleName == "" ? (cell.lblName.text = "\(strFirstName) \(strLastName)") : (cell.lblName.text = "\(strFirstName) \(strMiddleName) \(strLastName)")
            cell.lblDetails.text = ""
            cell.lblValue.text = ""
            
            
            
        }
        
        else {
            cell.lblName.text = self.itemsName[indexPath.section - 1][indexPath.row]
            cell.lblDetails.text = self.itemsDetails[indexPath.section - 1][indexPath.row]
            
            cell.lblValue.text = self.itemValue[indexPath.section - 1][indexPath.row]
            
            
            
            
        }
        
        
        return cell
        
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "AttendancePreviewTVCell", for: indexPath) as! AttendancePreviewTVCell
    //
    //
    //
    //        if indexPath.section == 0 {
    //            let strFirstName : String = dicMember[indexPath.row]["first_name"] as! String
    //            let strMiddleName : String = dicMember[indexPath.row]["middle_name"] as! String
    //            let strLastName : String = dicMember[indexPath.row]["last_name"] as! String
    //
    //            strMiddleName == "" ? (cell.lblName.text = "\(strFirstName) \(strLastName)") : (cell.lblName.text = "\(strFirstName) \(strMiddleName) \(strLastName)")
    //            cell.lblDetails.text = ""
    //            cell.lblValue.text = ""
    //
    //
    //
    //
    //        } else {
    //            cell.lblName.text = self.itemsName[indexPath.section - 1][indexPath.row]
    //            cell.lblDetails.text = self.itemsDetails[indexPath.section - 1][indexPath.row]
    //
    //            cell.lblValue.text = self.itemValue[indexPath.section - 1][indexPath.row]
    //
    //
    //
    //
    //        }
    //
    //
    //        return cell
    //
    //    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        selectedItemCompletion?(filteredArray[indexPath.row])
        //        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //Choose your custom row height
    }
    
    
    
    
    func getRecordAPI() {
        
        //        var dicUserDetails : [String:Any] = [:]
        //        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["id"] = self.id
        
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_record, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicMember.removeAll()
                        let arr = jsonData!["data"]
                        let dicData : [[String : Any]] = arr.object as? [[String : Any]] ?? []
                        self.dicMember = dicData[0]["member"] as! [[String : Any]]
                        
                        self.itemValue[0][0] = dicData[0]["shishu_male"] as! String
                        self.itemValue[0][1] = dicData[0]["baal"] as! String
                        self.itemValue[0][2] = dicData[0]["kishore"] as! String
                        self.itemValue[0][3] = dicData[0]["tarun"] as! String
                        self.itemValue[0][4] = dicData[0]["yuva"] as! String
                        self.itemValue[0][5] = dicData[0]["proudh"] as! String
                        self.itemValue[1][0] = dicData[0]["shishu_female"] as! String
                        self.itemValue[1][1] = dicData[0]["baalika"] as! String
                        self.itemValue[1][2] = dicData[0]["kishori"] as! String
                        self.itemValue[1][3] = dicData[0]["taruni"] as! String
                        self.itemValue[1][4] = dicData[0]["yuvati"] as! String
                        self.itemValue[1][5] = dicData[0]["proudha"] as! String
                        print(self.dicMember)
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                            
                            
                        }
                    }else {
                        if let strError = jsonData!["message"].string {
                            showAlert(title: APP.title, message: strError)
                        }
                    }
                }
                else {
                    if let strError = jsonData!["message"].string {
                        showAlert(title: APP.title, message: strError)
                    }
                }
            }
        }
    }
}

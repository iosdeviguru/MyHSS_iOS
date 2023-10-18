//
//  AttendancePreviewVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 16/04/2021.
//

import UIKit

class AttendancePreviewTVCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet var lblValue: UILabel!
    
}

class AttendancePreviewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let section = ["Sankhya", "Male", "Female"]
    
    var itemsName : [[String]] = []
    var itemsDetails : [[String]] = []
    var itemValue : [[String]] = []
    
    var dicMember = [[String:Any]]()
    var total = 0
    
    @IBOutlet weak var lblTotal2: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: " Sankhya preview".localized, showbtn: "back")
        self.firebaseAnalytics(_eventName: "SankhyaPreviewVC")
    }
    
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        
        return self.section[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        var total = 0
        for i in 0..<itemValue.count {
            for j in 0..<itemValue[i].count {
                let value = Int(itemValue[i][j])!
                total += value
            }
        }
        let totalMembers2 = dicMember.count
        lblTotal2.font = UIFont.boldSystemFont(ofSize: 15)
        self.lblTotal2.text = "            Guest: \(total)     Sankhya:\(totalMembers2)    Total: \(totalMembers2 + total)"
        return self.section.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let rect = CGRect(x: 20, y: 0, width: tableView.frame.size.width - 40, height: 60)
            let footerView = UIView(frame:rect)
            footerView.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            
            let lblTitle = UILabel(frame: CGRect(x: 20.0, y: footerView.center.y / 2, width: 160, height: 30))
            //            lblTitle.text = self.section[section]
            lblTitle.font = UIFont(name: "SourceSansPro-Regular", size: 20.0)
            lblTitle.backgroundColor = UIColor.clear
            lblTitle.textColor = UIColor.init(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1.0)
            
            footerView.addSubview(lblTitle)
            return footerView
        } else {
            let rect = CGRect(x: 20, y: 0, width: tableView.frame.size.width - 40, height: 60)
            let footerView = UIView(frame:rect)
            footerView.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            
            let lblTitle = UILabel(frame: CGRect(x: 20.0, y: footerView.center.y / 2, width: 160, height: 30))
            //            lblTitle.text = "Guest Information"
            
            //            lblTitle.text = "Additional Guest: \(total/2)"
            
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
        
        if indexPath.section == 0 {
            let strFirstName : String = dicMember[indexPath.row]["first_name"] as! String
            let strMiddleName : String = dicMember[indexPath.row]["middle_name"] as! String
            let strLastName : String = dicMember[indexPath.row]["last_name"] as! String
            
            strMiddleName == "" ? (cell.lblName.text = "\(strFirstName) \(strLastName)") : (cell.lblName.text = "\(strFirstName) \(strMiddleName) \(strLastName)")
            cell.lblDetails.text = ""
            
            //            self.dicMember[indexPath.row]["isPresent"] as! String == "false" ? (cell.lblValue.text = "Absent") : (cell.lblValue.text = "Present")
        } else {
            cell.lblName.text = self.itemsName[indexPath.section - 1][indexPath.row]
            cell.lblDetails.text = self.itemsDetails[indexPath.section - 1][indexPath.row]
            
            cell.lblValue.text = self.itemValue[indexPath.section - 1][indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        selectedItemCompletion?(filteredArray[indexPath.row])
        //        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 60
        }
        return UITableView.automaticDimension //Choose your custom row height
    }
    
}

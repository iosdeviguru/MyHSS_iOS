//
//  AdditionalGuestInformationVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 14/04/2021.
//

import UIKit
import ObjectiveC
import SSSpinnerButton

class AdditionalGuestInforTVCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet var btnMinus: UIButton!
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var btnPlus: UIButton!
}



class AdditionalGuestInformationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let section = ["Male", "Female" ]
    
    let itemsName = [["Shishu", "Baal", "Kishore", "Tarun", "Yuva", "Jyeshta"], ["Shishu", "Baalika", "Kishori", "Taruni", "Yuvati", "Jyeshtaa"], ["Total:"]]
    let itemsDetails = [["Below 5 Years - Pre-primary ", "5 to 11 Years - Primary School", "11 to 16 Years - Middle School", "17 to 25 Years - High School/College", "25 to 60 Years - Adults", ">60 Years - Senior citizen"], ["Below 5 Years - Pre-primary ", "5 to 11 Years - Primary School", "11 to 16 Years - Middle School", "17 to 25 Years - High School/College", "25 to 60 Years - Adults", ">60 Years - Senior citizen"],["Attendees"]]
    var itemValue = [["0", "0", "0", "0", "0", "0"], ["0", "0", "0", "0", "0", "0"]]
    
    
    var dicMember = [[String:Any]]()
    
    var strDate = ""
    var utsavName = ""
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet var lblShakhaName: UILabel!
    //    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var btnSubmit: SSSpinnerButton!
    
    var totalValue = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.fillData()
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 45
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        navigationBarDesign(txt_title: "guest_information".localized, showbtn: "back")
        navigationBarDesign(txt_title: "Guest Sankhya".localized, showbtn: "back")
        
        self.firebaseAnalytics(_eventName: "AdditionalGuestInfoVC")
        
        
    }
    
    
    func fillData() {
        //        self.lblDate.text = strDate
    }
    
    
    @objc func onMinusClick(_ sender: UIButton) {
        let section = (sender.tag / 10) - 10
        let row = sender.tag % 10
        var value = Int(self.itemValue[section][row]) ?? 0
        value -= 1
        if value < 0 {
            value = 0
        }
        self.itemValue[section][row] = "\(value)"
        let indexPath = IndexPath(row: row, section: section)
        if let cell = self.tableView.cellForRow(at: indexPath) as? AdditionalGuestInforTVCell {
            cell.lblValue.text = self.itemValue[section][row]
        }
        calculateTotal()
    }
    
    @objc func onPlusClick(_ sender: UIButton) {
        let section = (sender.tag / 10) - 10
        let row = sender.tag % 10
        var value = Int(self.itemValue[section][row]) ?? 0
        value += 1
        self.itemValue[section][row] = "\(value)"
        let indexPath = IndexPath(row: row, section: section)
        if let cell = self.tableView.cellForRow(at: indexPath) as? AdditionalGuestInforTVCell {
            cell.lblValue.text = self.itemValue[section][row]
        }
        calculateTotal()
    }
    
    
    
    func calculateTotal() {
        
        
        var total = 0
        for i in 0..<itemValue.count {
            for j in 0..<itemValue[i].count {
                total += Int(itemValue[i][j]) ?? 0
            }
        }
        let totalMembers = dicMember.count
        lblTotal.font = UIFont.boldSystemFont(ofSize: 15)
        self.lblTotal.text = "            Guest: \(total)     Sankhya:\(totalMembers)    Total: \(totalMembers + total)"
        
    }
    
    @IBAction func onPreviewClick(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AttendancePreviewVC") as! AttendancePreviewVC
        vc.itemsName = self.itemsName
        vc.itemsDetails = self.itemsDetails
        vc.itemValue = self.itemValue
        vc.dicMember = self.dicMember
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSubmitClick(_ sender: UIButton) {
        btnSubmit.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: {
            // Your code here
            self.addSankhyaAPI()
            let disableMyButton = sender as? UIButton
            disableMyButton?.isEnabled = false
        })
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        
        return self.section[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        
        
        return self.section.count
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let rect = CGRect(x: 20, y: 0, width: tableView.frame.size.width - 40, height: 60)
        let footerView = UIView(frame:rect)
        footerView.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        
        let lblTitle = UILabel(frame: CGRect(x: 20.0, y: footerView.center.y / 2, width: 160, height: 30))
        //        lblTitle.text = self.section[section]
        
        calculateTotal()
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60  // or whatever
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsName[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalGuestInforTVCell", for: indexPath) as! AdditionalGuestInforTVCell
        
        
        cell.lblName.text = self.itemsName[indexPath.section][indexPath.row]
        cell.lblDetails.text = self.itemsDetails[indexPath.section][indexPath.row]
        
        cell.lblValue.text = self.itemValue[indexPath.section][indexPath.row]
        cell.btnMinus.addTarget(self, action: #selector(onMinusClick(_:)), for: .touchUpInside)
        cell.btnPlus.addTarget(self, action: #selector(onPlusClick(_:)), for: .touchUpInside)
        
        let strSection : String = "\(indexPath.section + 10)"
        let strRow = "\(indexPath.row)"
        
        cell.btnPlus.tag = Int(strSection + strRow)!
        cell.btnMinus.tag = Int(strSection + strRow)!
        cell.lblValue.tag = Int(strSection + strRow)!
        
        return cell
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        selectedItemCompletion?(filteredArray[indexPath.row])
        //        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //Choose your custom row height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else { return }
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var headerFrame = headerView.frame
        
        if height != headerFrame.size.height {
            headerFrame.size.height = height
            headerView.frame = headerFrame
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    
    
    func addSankhyaAPI() {
        
        let arrFilter : [String] = self.dicMember.filter { $0["isPresent"] as! String == "true" }.map { $0["member_id"]! as! String }
        let stringArr = arrFilter.joined(separator: " ")
        let stringArray = stringArr.replacingOccurrences(of: " ", with: ", ", options: .literal, range: nil)
        //        var dicUserDetails : [String:Any] = [:]
        //        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["event_date"] = strDate
        parameters["org_chapter_id"] = _appDelegator.dicMemberProfile![0]["shakha_id"]
        parameters["utsav"] = utsavName
        parameters["member_id"] = stringArray
        parameters["shishu_male"] = self.itemValue[0][0]
        parameters["baal"] = self.itemValue[0][1]
        parameters["kishore"] = self.itemValue[0][2]
        parameters["tarun"] = self.itemValue[0][3]
        parameters["yuva"] = self.itemValue[0][4]
        parameters["proudh"] = self.itemValue[0][5]
        parameters["shishu_female"] = self.itemValue[1][0]
        parameters["baalika"] = self.itemValue[1][1]
        parameters["kishori"] = self.itemValue[1][2]
        parameters["taruni"] = self.itemValue[1][3]
        parameters["yuvati"] = self.itemValue[1][4]
        parameters["proudha"] = self.itemValue[1][5]
        //        parameters["total:"] = self.itemValue[2]
        parameters["api"] = "yes"
        
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.add_sankhya, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: {
                            // Your code here
                            if let strMessage = jsonData!["message"].string {
                                showAlert(title: APP.title, message: strMessage)
                            }
                        })
                    }else {
                        self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                            // Your code here
                            if let strError = jsonData!["message"].string {
                                showAlert(title: APP.title, message: strError)
                            }
                        })
                    }
                } else {
                    self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                        // Your code here
                        if let strError = jsonData!["message"].string {
                            showAlert(title: APP.title, message: strError)
                        }
                    })
                }
            }
        }
    }
    
}

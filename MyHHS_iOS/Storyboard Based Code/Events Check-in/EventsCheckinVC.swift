//
//  EventsCheckinVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/03/2023.
//

import UIKit

class EventsCheckinTVCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var checkinTimeLbl: UILabel!
    
    
    @IBOutlet weak var AgeCategoryView: UIView!
    @IBOutlet weak var lblAgeCategories: UILabel!
    
    @IBOutlet weak var btnApprove: UIButton!
    @IBOutlet weak var btnInactive: UIButton!
    

    
    @IBOutlet var widthConstraintApprove: NSLayoutConstraint!
    @IBOutlet var widthConstraintInactive: NSLayoutConstraint!
    
}

class EventsCheckinVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var checkinLbl: UILabel!
    
    @IBOutlet weak var checkinNumberLbl: UILabel!
    
    @IBAction func checkinBtnScan(_ sender: UIButton) {
    }
    
    
    @IBAction func filterMembers(_ sender: UIButton) {
    }
    
    var SearchBarValue:String!
    var searchActive : Bool = false
    var filteredArray : [[String: Any]] = []

    var dictMembership = [[String:Any]]()

    var strStatus = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if strStatus == "all" {
            navigationBarDesign(txt_title: "Membership Applications".localized, showbtn: "back")
            self.firebaseAnalytics(_eventName: "MembershipApplicationsVC")
        } else if strStatus == "1" {
            navigationBarDesign(txt_title: "Active Members".localized, showbtn: "back")
            self.firebaseAnalytics(_eventName: "ActiveMembersVC")
        } else if strStatus == "4" {
            navigationBarDesign(txt_title: "Inactive Members".localized, showbtn: "back")
            self.firebaseAnalytics(_eventName: "InactiveMembersVC")
        }
        
        self.getFamilyMemberAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    @objc func onTrashClicked(sender:UIButton)
    {
        let refreshAlert = UIAlertController(title: APP.title, message: "delete_message".localized, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "delete".localized, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle logic here")
            let index : IndexPath = IndexPath(row: sender.tag, section: 0)
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: index)
        }))

        refreshAlert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }

    @objc func onButtonApproveClicked(sender:UIButton)
    {
        let refreshAlert = UIAlertController(title: APP.title, message: "approve_message".localized, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "approve".localized, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle logic here")
            self.getApproveMemberAPI(memberid: "\(sender.tag)")
        }))

        refreshAlert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }

    @objc func onButtonInactiveClicked(sender:UIButton)
    {
        let refreshAlert = UIAlertController(title: APP.title, message: "inactive_message".localized, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "inactive".localized, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle logic here")
            self.getInactiveMemberAPI(memberid: "\(sender.tag)")
        }))

        refreshAlert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }


    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembershipApplicationsTVCell", for: indexPath) as! MembershipApplicationsTVCell
        
        if strStatus == "all" {
            cell.widthConstraintApprove.constant = 100.0
            cell.widthConstraintInactive.constant = 100.0
        } else if strStatus == "1" {
            cell.widthConstraintApprove.constant = 0.0
            cell.widthConstraintInactive.constant = 100.0
        } else if strStatus == "4" {
            cell.widthConstraintApprove.constant = 100.0
            cell.widthConstraintInactive.constant = 0.0
        }
        
        cell.btnTrash.tag = indexPath.row//Int(filteredArray[indexPath.row]["member_id"] as! String)!
        cell.btnTrash.addTarget(self, action: #selector(MembershipApplicationsVC.onTrashClicked(sender:)), for: .touchUpInside)
        cell.btnApprove.tag = Int(filteredArray[indexPath.row]["member_id"] as! String)!
        cell.btnInactive.tag = Int(filteredArray[indexPath.row]["member_id"] as! String)!
        cell.btnApprove.addTarget(self, action: #selector(MembershipApplicationsVC.onButtonApproveClicked(sender:)), for: .touchUpInside)
        cell.btnInactive.addTarget(self, action: #selector(MembershipApplicationsVC.onButtonInactiveClicked(sender:)), for: .touchUpInside)
        
        let strFirstName : String = filteredArray[indexPath.row]["first_name"] as! String
        let strMiddleName : String = filteredArray[indexPath.row]["middle_name"] as! String
        let strLastName : String = filteredArray[indexPath.row]["last_name"] as! String
        
        strMiddleName == "" ? (cell.lblName.text = "\(strFirstName) \(strLastName)") : (cell.lblName.text = "\(strFirstName) \(strMiddleName) \(strLastName)")
        
        cell.viewAgeCategories.roundCorners(corners: [.topLeft], radius: 10.0)
        cell.viewAgeCategories.layer.masksToBounds = true
        
        cell.lblDetails.text = filteredArray[indexPath.row]["chapter_name"] as? String
        cell.lblEmail.text = filteredArray[indexPath.row]["email"] as? String
        cell.lblMobileNo.text = filteredArray[indexPath.row]["mobile"] as? String
        cell.lblMobileNo.text = filteredArray[indexPath.row]["mobile"] as? String
                
        let strAgeCategories = filteredArray[indexPath.row]["age_categories"] as? String
        cell.lblAgeCategories.text = strAgeCategories?.lowercased()
        
        switch strAgeCategories?.lowercased() {
        case "male_shishu":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Shishu_male
        case "female_shishu":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Shishu_female
        case "baal":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Baal
        case "baalika":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Baalika
        case "kishore":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Kishore
        case "kishori":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Kishori
        case "tarun":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Tarun
        case "taruni":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Taruni
        case "yuva":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Yuva
        case "yuvati":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Yuvati
        case "jyeshta":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Proudh
        case "jyeshtaa":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Proudha
        case "Proudh":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Proudh
        case "Proudha":
            cell.viewAgeCategories.backgroundColor = AgeCategories.Proudha
        default:
            cell.viewAgeCategories.backgroundColor = Colors.bglightGray
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedItemCompletion?(filteredArray[indexPath.row])
//        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if let strID = filteredArray[indexPath.row]["member_id"] as? String {
                self.filteredArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.getDeleteMemberAPI(memberid: strID)
            }
        }
    }
    
    // MARK: SerchBar Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;

        searchBar.text = nil
        searchBar.resignFirstResponder()
        tableView.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.searchActive = true;
        self.searchBar.showsCancelButton = true
        
        self.filteredArray.removeAll()
        
        DispatchQueue.global(qos: .background).async {
//            print("This is run on the background queue")
            //  Filter technique 1
//            self.filteredArray: [Any] = dictFamilyMember.filter { NSPredicate(format: "(first_name contains[c] %@)", searchText).evaluate(with: $0) }

            //  Filter technique 2
            self.filteredArray = self.dictMembership.filter{
//                let string = $0["first_name"] as! String
                let string = $0["first_name"] as! String
                let stringLastName = $0["last_name"] as! String
                let stringEmail = $0["email"] as! String
                let stringMobile = $0["mobile"] as! String
                return (string.hasPrefix(searchText.lowercased()) || stringLastName.hasPrefix(searchText.lowercased()) || stringEmail.hasPrefix(searchText.lowercased()) || stringMobile.hasPrefix(searchText.lowercased()))
            }

            if self.filteredArray.isEmpty {
                self.searchActive = false
            } else {
                self.searchActive = true
            }
            
            DispatchQueue.main.async {
//                print("This is run on the main queue, after the previous code in outer block")
                self.tableView.reloadData()
            }
        }

    }

    
    // MARK: - API Functions

    func getFamilyMemberAPI() {
    
//         var dicUserDetails : [String:Any] = [:]
//         dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String //    dicUserDetails["user_id"]
        parameters["member_id"] = _appDelegator.dicDataProfile![0]["member_id"] as? String //  dicUserDetails["member_id"]
        parameters["tab"] = "family"   //  family or kendra or shakha
        parameters["status"] = strStatus  //  status = all, 0 pending, 1 active, 3 rejected, 4 inactive
        parameters["start"] = "0"
        parameters["length"] = "20"
        parameters["search"] = ""
        print(parameters)
    
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_listing, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                    let arr = jsonData!["data"]
                    print(arr)
                    self.dictMembership.removeAll()
                    self.filteredArray.removeAll()
                    for index in 0..<arr.count {
                        var dict = [String : Any]()
                        dict["middle_name"] = arr[index]["middle_name"].string
                        dict["rejection_msg"] = arr[index]["rejection_msg"].string
                        dict["age_categories"] = arr[index]["age_categories"].string
                        dict["gender"] = arr[index]["gender"].string
                        dict["member_id"] = arr[index]["member_id"].string
                        dict["mobile"] = arr[index]["mobile"].string
                        dict["dob"] = arr[index]["dob"].string
                        dict["is_admin_approved"] = arr[index]["is_admin_approved"].string
                        dict["org_name"] = arr[index]["org_name"].string
                        dict["email"] = arr[index]["email"].string
                        dict["status"] = arr[index]["status"].string
                        dict["is_email_verified"] = arr[index]["is_email_verified"].string
                        dict["chapter_name"] = arr[index]["chapter_name"].string
                        dict["first_name"] = arr[index]["first_name"].string
                        dict["is_guardian_approved"] = arr[index]["is_guardian_approved"].string
                        dict["last_name"] = arr[index]["last_name"].string
                        self.dictMembership.append(dict)
                    }
                    self.filteredArray = self.dictMembership
                    
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
    
    func getApproveMemberAPI(memberid : String) {
       
//        var dicUserDetails : [String:Any] = [:]
//        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["member_id"] = memberid
        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.get_approve, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                       let arr = jsonData!["data"]
                       print(arr)
                        self.getFamilyMemberAPI()
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
    
    func getInactiveMemberAPI(memberid : String) {
       
//        var dicUserDetails : [String:Any] = [:]
//        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["member_id"] = memberid
        print(parameters)
       
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_inactive, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                       let arr = jsonData!["data"]
                       print(arr)
                        self.getFamilyMemberAPI()
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

    func getDeleteMemberAPI(memberid : String) {

//        var dicUserDetails : [String:Any] = [:]
//        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]

        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["member_id"] = memberid
        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.get_delete, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                       let arr = jsonData!["data"]
                       print(arr)
                        self.getFamilyMemberAPI()
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

    func getRejectMemberAPI(memberid : String) {

//        var dicUserDetails : [String:Any] = [:]
//        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["member_id"] = memberid
        parameters["message"] = "I don't know you"
        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.get_reject, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                       let arr = jsonData!["data"]
                       print(arr)
                        self.getFamilyMemberAPI()
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

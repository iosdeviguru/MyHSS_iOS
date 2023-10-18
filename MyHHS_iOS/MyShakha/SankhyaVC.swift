//
//  SankhyaVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 10/04/2021.
//

import UIKit

class SankhyaTVCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    //    @IBOutlet weak var lblMobileNo: UILabel!
    //    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet weak var viewAgeCategories: UIView!
    @IBOutlet weak var lblAgeCategories: UILabel!
    
    
}

class SankhyaVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var SearchBarValue:String!
    var searchActive : Bool = false
    var filteredArray : [[String: Any]] = []
    
    var dictData = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "sankhya".localized, showbtn: "back")
        
        self.fillData()
        self.getSankhyaListingAPI()
        self.firebaseAnalytics(_eventName: "SankhyaListVC")
    }
    
    func fillData() {
        
    }
    
    @objc func onTrashClicked(sender:UIButton)
    {
        let refreshAlert = UIAlertController(title: APP.title, message: "delete_sankhya_message".localized, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "delete".localized, style: .default, handler: { (action: UIAlertAction!) in
            print("Handle logic here")
            let index : IndexPath = IndexPath(row: sender.tag, section: 0)
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: index)
            //            self.deleteSankhyaAPI(id: "\(sender.tag)")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func onAddSankhyaClick(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddSankhyaVC") as! AddSankhyaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SankhyaTVCell", for: indexPath) as! SankhyaTVCell
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(SankhyaVC.onTrashClicked(sender:)), for: .touchUpInside)
        
        if let strChapterName = filteredArray[indexPath.row]["chapter_name"] as? String {
            cell.lblName.text = strChapterName
        }
        if let strCreatedAt = filteredArray[indexPath.row]["event_date"] as? String {
            cell.lblDate.text = strCreatedAt
        }
        if let strPhone = filteredArray[indexPath.row]["phone"] as? String {
            //            cell.lblMobileNo.text = strPhone
        }
        if let strEmail = filteredArray[indexPath.row]["email"] as? String {
            //            cell.lblEmail.text = strEmail
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewSankhyaVC") as! ViewSankhyaVC
        vc.id = filteredArray[indexPath.row]["id"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162.0;//Choose your custom row height
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if let strID = filteredArray[indexPath.row]["id"] as? String {
                self.filteredArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.deleteSankhyaAPI(id: strID)
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
            self.filteredArray = self.dictData.filter{
                //                let string = $0["first_name"] as! String
                let string = $0["chapter_name"] as! String
                let stringEmail = $0["email"] as! String
                let stringMobile = $0["phone"] as! String
                return (string.hasPrefix(searchText.lowercased()) || stringEmail.hasPrefix(searchText.lowercased()) || stringMobile.hasPrefix(searchText.lowercased()))
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
    
    func getSankhyaListingAPI() {
        
        //         var dicUserDetails : [String:Any] = [:]
        //         dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String //    dicUserDetails["user_id"]
        parameters["chapter_id"] = _appDelegator.dicMemberProfile![0]["shakha_id"]
        parameters["start_date"] = ""   //  01/02/2021 //  Optional
        parameters["end_date"] = ""  //  09/03/2021    //  Optional
        parameters["start"] = "0"
        parameters["length"] = "20"
        parameters["search"] = ""
        
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_sankhya_list, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arr = jsonData!["data"]
                        print(arr)
                        self.dictData = arr.object as? [[String : Any]] ?? []
                        //                        self.dictData.removeAll()
                        //                        self.filteredArray.removeAll()
                        //                        for index in 0..<arr.count {
                        //                            var dict = [String : Any]()
                        //                            dict["chapter_name"] = arr[index]["chapter_name"].string
                        //                            dict["email"] = arr[index]["email"].string
                        //                            dict["event_date"] = arr[index]["event_date"].string
                        //                            dict["id"] = arr[index]["id"].string
                        //                            dict["phone"] = arr[index]["phone"].string
                        //                            dict["utsav"] = arr[index]["utsav"].string
                        //
                        //                            self.dictData.append(dict)
                        //                        }
                        self.filteredArray = self.dictData
                        
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
    
    func deleteSankhyaAPI(id : String) {
        
        //        var dicUserDetails : [String:Any] = [:]
        //        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["id"] = id
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.delete_sankhya, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        if let strMessage = jsonData!["message"].string {
                            showAlert(title: APP.title, message: strMessage)
                        }
                        DispatchQueue.main.async {
                            self.getSankhyaListingAPI()
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

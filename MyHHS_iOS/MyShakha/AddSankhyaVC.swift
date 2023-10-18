//
//  AddSankhyaVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 10/04/2021.
//

import UIKit
import Alamofire
import SSSpinnerButton

class AddSankhyaTVCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var btnCheckBox: UIButton!
    
}

class AddSankhyaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var txtDate: UITextField!
    @IBOutlet weak var lblUtsavListTitle: UILabel!
    @IBOutlet weak var lblUtsavList: UILabel!
    
    @IBOutlet weak var imgPresentAllCheckBox: UIImageView!
    
    @IBOutlet var btnSubmit: SSSpinnerButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var utsavName = ""
    var isPresentAll = false
    
    @IBOutlet weak var lblCount: UILabel!
    
    
    var dictData = [[String:Any]]()
    
    var dicUtsav = [[String:Any]]()
    var dicMember = [[String:Any]]()
    
    var strDate = ""
    var Total = ""
    
    var viewPicker : UIView!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        navigationBarDesign(txt_title: "add_sankhya".localized, showbtn: "back")
        
        self.fillData()
        self.getUtasavAPI()
        self.getMemberAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarWithRightButtonDesign(txt_title: "add_sankhya".localized, showbtn: "back", rightImg: "calender", bagdeVal: "", isBadgeHidden: true)
        self.firebaseAnalytics(_eventName: "AddSankhyaVC")
    }
    
    func fillData() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        strDate = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "d MMM | EEEE"
        txtDate.text = dateFormatter.string(from: Date())
    }
    //
    //    func Total(){
    //
    //    }
    
    override func rightBarItemClicked(_ sender: UIButton) {
        showDatePicker()
    }
    
    @IBAction func onDateChangeClick(_ sender: Any) {
        //        showDatePicker()
    }
    
    // MARK: - DatePicker functions
    func showDatePicker(){
        
        viewPicker = UIView(frame: CGRect(x: 0.0, y: self.view.frame.height - 500, width: self.view.frame.width, height: 500))
        viewPicker.backgroundColor = UIColor.white
        viewPicker.clipsToBounds = true
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 500)
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -99, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        
        datePicker.backgroundColor = UIColor.white
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            
            // Fallback on earlier versions
        }
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(AddMemberStep1VC.datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.center.x = self.view.center.x
        
        //ToolBar
        var toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 50))
        let doneButton = UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel".localized, style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datePicker
        
        self.viewPicker.addSubview(toolbar)
        
        self.viewPicker.addSubview(datePicker)
        
        self.view.addSubview(self.viewPicker)
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "dd/MM/yyyy"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        //        print("Selected value \(selectedDate)")
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM | EEEE"
        txtDate.text = formatter.string(from: datePicker.date)
        self.viewPicker.isHidden = true
        formatter.dateFormat = "dd/MM/yyyy"
        strDate = formatter.string(from: datePicker.date)
    }
    
    @objc func cancelDatePicker(){
        self.viewPicker.isHidden = true
    }
    
    @IBAction func onPresentAllClick(_ sender: Any) {
        
        if !isPresentAll {
            for index in 0..<self.dicMember.count {
                self.dicMember[index]["isPresent"] = "true"
            }
            self.imgPresentAllCheckBox.image = UIImage(named: "check_img")
            isPresentAll = true
        } else {
            for index in 0..<self.dicMember.count {
                self.dicMember[index]["isPresent"] = "false"
            }
            self.imgPresentAllCheckBox.image = UIImage(named: "uncheck")
            isPresentAll = false
        }
        
        var count = 0
        for member in self.dicMember {
            if member["isPresent"] as! String == "true" {
                count += 1
            }
        }
        
        self.lblCount.text = " Sankhya:\(count)"
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onUtsavListClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblUtsavList.text = dict["name"] as? String
            self.utsavName = dict["name"] as! String
            print(self.utsavName)
            self.getUtasavAPI()
        }
        vc.dataSource = dicUtsav
        vc.strNavigationTitle = "Utsav List"
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onGuestInfoClick(_ sender: Any) {
        
        let dicFilter = self.dicMember.filter { $0["isPresent"] as! String == "true" }.map { $0 }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AdditionalGuestInformationVC") as! AdditionalGuestInformationVC
        vc.dicMember = dicFilter
        vc.strDate = self.strDate
        vc.utsavName = self.utsavName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSubmitClick(_ sender: Any) {
        btnSubmit.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: {
            // Your code here
            self.addSankhyaAPI()
        })
    }
    
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dicMember.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSankhyaTVCell", for: indexPath) as! AddSankhyaTVCell
        
        let strFirstName : String = dicMember[indexPath.row]["first_name"] as! String
        let strMiddleName : String = dicMember[indexPath.row]["middle_name"] as! String
        let strLastName : String = dicMember[indexPath.row]["last_name"] as! String
        
        strMiddleName == "" ? (cell.lblName.text = "\(strFirstName) \(strLastName)") : (cell.lblName.text = "\(strFirstName) \(strMiddleName) \(strLastName)")
        
        self.dicMember[indexPath.row]["isPresent"] as! String == "false" ? (cell.imgCheckBox.image = UIImage(named:"uncheck")) : (cell.imgCheckBox.image = UIImage(named:"check_img"))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dicMember[indexPath.row]["isPresent"] as! String == "false" ? (self.dicMember[indexPath.row]["isPresent"] = "true") : (self.dicMember[indexPath.row]["isPresent"] = "false")
        tableView.reloadRows(at:[indexPath], with:.automatic)
        
        var presentCount = 0
        for index in 0..<self.dicMember.count {
            
            if self.dicMember[index]["isPresent"] as! String == "true" {
                presentCount += 1
            }
        }
        if presentCount == self.dicMember.count {
            self.imgPresentAllCheckBox.image = UIImage(named: "check_img")
            isPresentAll = true
        } else {
            self.imgPresentAllCheckBox.image = UIImage(named: "uncheck")
            isPresentAll = false
        }
        self.lblCount.text = "Sankhya:\(presentCount)"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension   //Choose your custom row height
    }
    
    // MARK: API's functions
    func getUtasavAPI() {
        
        APIManager.sharedInstance.callGetApi(url: APIUrl.get_utsav) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicUtsav.removeAll()
                        let arr = jsonData!["data"]
                        //                        self.lblShakha.text = arr[0]["chapter_name"].string
                        //                        self.shakhaIndex = arr[0]["org_chapter_id"].string!
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["id"].string
                            dict["name"] = arr[index]["utsav"].string
                            self.dicUtsav.append(dict)
                        }
                        //                        self.dicUtsav = arr.object as? [[String : Any]] ?? []
                        print(self.dicUtsav)
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
    
    func getMemberAPI() {
        
        //        var dicUserDetails : [String:Any] = [:]
        //        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_members, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicMember.removeAll()
                        var arr = jsonData!["data"]
                        //                        self.lblShakha.text = arr[0]["chapter_name"].string
                        //                        self.shakhaIndex = arr[0]["org_chapter_id"].string!
                        for index in 0..<arr.count {
                            arr[index]["isPresent"] = "false"
                        }
                        self.dicMember = arr.object as? [[String : Any]] ?? []
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
        parameters["shishu_male"]   = "0"
        parameters["shishu_female"] = "0"
        parameters["baal"]          = "0"
        parameters["baalika"]       = "0"
        parameters["kishore"]       = "0"
        parameters["kishori"]       = "0"
        parameters["tarun"]         = "0"
        parameters["taruni"]        = "0"
        parameters["yuva"]          = "0"
        parameters["yuvati"]        = "0"
        parameters["proudh"]        = "0"
        parameters["proudha"]       = "0"
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
                    }else
                    {
                        self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                            // Your code here
                            if let strError = jsonData!["message"].string {
                                showAlert(title: APP.title, message: strError)
                            }
                        })
                    }
                }
                else {
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

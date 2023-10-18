//
//  AddMemberStep1VC.swift
//  MyHHS_iOS
//
//  Created by baps on 24/06/2019 jun.
//

import UIKit
import RAGTextField

protocol TableviewSearchDelegate: class {
    func getYourSilectedIndex()
}

//protocol OlderSiblingDelegate: class {
//    // The following command (ie, method) must be obeyed by any
//    // underling (ie, delegate) of the older sibling.
//    func getYourNiceOlderSiblingAGlassOfWater()
//}

class AddMemberStep1VC: UIViewController {
    
    weak var delegate: TableviewSearchDelegate?
    
    //    weak var delegateSibling: OlderSiblingDelegate?
    
    @IBOutlet var lblHead: UILabel!
    
    @IBOutlet weak var txtFirstName: RAGTextField!
    @IBOutlet weak var txtMiddleName: RAGTextField!
    @IBOutlet weak var txtSurName: RAGTextField!
    
    @IBOutlet weak var txtUserName: RAGTextField!
    @IBOutlet weak var txtEmail: RAGTextField!
    @IBOutlet weak var txtPasssword: RAGTextField!
    @IBOutlet weak var txtConfirmPassword: RAGTextField!
    
    @IBOutlet weak var lblGenderTitle: UILabel!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var lblDOBTitle: UILabel!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var btnDOB: UIButton!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    
    @IBOutlet var viewInfoYellow: UIView!
    @IBOutlet var lblInfoYellowView: UILabel!
    
    
    
    @IBOutlet weak var heightConstraintForMember: NSLayoutConstraint!
    @IBOutlet weak var heightRelationshipToPrimaryMember: NSLayoutConstraint!
    @IBOutlet weak var heightOccupation: NSLayoutConstraint!
    
    @IBOutlet weak var lblRelationshipToPrimaryMemberTitle: UILabel!
    @IBOutlet weak var lblRelationshipToPrimaryMember: UILabel!
    @IBOutlet weak var btnRelationshipToPrimaryMember: UIButton!
    @IBOutlet weak var txtOtherRelationshipToPrimaryMember: RAGTextField!
    
    @IBOutlet weak var lblOccupationTitle: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var btnOccupation: UIButton!
    @IBOutlet weak var txtOtherOccupation: RAGTextField!
    
    @IBOutlet weak var lblVibhagTitle: UILabel!
    @IBOutlet weak var lblVibhag: UILabel!
    @IBOutlet weak var btnVibhag: UIButton!
    
    @IBOutlet weak var lblNagarTitle: UILabel!
    @IBOutlet weak var lblNagar: UILabel!
    @IBOutlet weak var btnNagar: UIButton!
    
    @IBOutlet weak var lblShakhaTitle: UILabel!
    @IBOutlet weak var lblShakha: UILabel!
    @IBOutlet weak var btnShakha: UIButton!
    
    @IBOutlet weak var lblNext: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    var dicRelitionship = [[String:Any]]()
    var dicOccuptions = [[String:Any]]()
    var dicVibhag = [[String:Any]]()
    var dicNagar = [[String:Any]]()
    var dicShakha = [[String:Any]]()
    
    var strGendar : String = ""
    //    var dicMember : [String: Any] = [:]
    
    var relitionshipIndex : String = "0"
    var occuptionsIndex : String = "0"
    var vibhagIndex : String = "0"
    var nagarIndex : String = "0"
    var shakhaIndex : String = "0"
    
    var viewPicker : UIView!
    let datePicker = UIDatePicker()
    
    lazy var leftBarButtonItemBackButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "Backbtn"),
                                     style: .plain, target: self, action: #selector(leftBarBackButtonClicked(_:)))
        return button
    }()
    
    
    @objc func leftBarBackButtonClicked(_ sender : UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        navigationItem.title = "Add Family Member".localized
        //        navigationItem.leftBarButtonItems = [leftBarButtonItemBackButton]
        
        if _appDelegator.userType == "self" {
            self.heightConstraintForMember.constant = 0.0
            self.heightRelationshipToPrimaryMember.constant = 0.0
        } else {
            self.heightConstraintForMember.constant = 304.0
            self.heightRelationshipToPrimaryMember.constant = 100.0
            self.getRelatinshipAPI()
            if let strEmail = _appDelegator.dicDataProfile![0]["email"] as? String {
                self.txtEmail.text = strEmail
            }
        }
        
        self.heightOccupation.constant = 100.0
        
        self.viewInfoYellow.isHidden = true
        
        if _appDelegator.isEdit {
            self.fillEditData()
        } else {
            self.fillData()
        }
        
        self.getOccuptionsAPI()
        self.getVibhagAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if _appDelegator.userType == "self" {
            navigationBarDesign(txt_title: "add_self".localized, showbtn: "back")
        } else {
            navigationBarDesign(txt_title: "Add_family_member".localized, showbtn: "back")
        }
        self.firebaseAnalytics(_eventName: "AddMemberStep1VC")
    }
    
    func fillData() {
        self.lblInfoYellowView.text = "Date_of_birth_msg".localized
        
        var dicUserDetails : [String:Any] = [:]
        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        print(dicUserDetails)
        if _appDelegator.userType == "self" {
            if let strFirstName = dicUserDetails["first_name"] as? String {
                self.txtFirstName.text = strFirstName
            }
            if let strLastName = dicUserDetails["last_name"] as? String {
                self.txtSurName.text = strLastName
            }
        }
    }
    
    func fillEditData() {
        
        if let strFirastName = _appDelegator.dicDataProfile![0]["first_name"] as? String {
            self.txtFirstName.text = strFirastName
        }
        if let strMiddleName = _appDelegator.dicDataProfile![0]["middle_name"] as? String {
            self.txtMiddleName.text = strMiddleName
        }
        if let strLastName = _appDelegator.dicDataProfile![0]["last_name"] as? String {
            self.txtSurName.text = strLastName
        }
        
        if let strGender = _appDelegator.dicMemberProfile![0]["gender"] as? String {
            strGender.lowercased() == "male" ? self.maleClick() : self.FemaleClick()
        }
        
        if let strDOB = _appDelegator.dicMemberProfile![0]["dob"] as? String {
            self.txtDOB.text = strDOB
        }
    }
    
    // MARK: - DatePicker functions
    func showDatePicker(){
        
        viewPicker = UIView(frame: CGRect(x: 0.0, y: self.view.frame.height - 300, width: self.view.frame.width, height: 300))
        viewPicker.backgroundColor = UIColor.white
        viewPicker.clipsToBounds = true
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -99, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -3, to: Date())
        
        datePicker.backgroundColor = UIColor.white
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
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
        
        txtDOB.inputAccessoryView = toolbar
        txtDOB.inputView = datePicker
        
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
        formatter.dateFormat = "dd/MM/yyyy"
        txtDOB.text = formatter.string(from: datePicker.date)
        self.viewPicker.isHidden = true
    }
    
    @objc func cancelDatePicker(){
        self.viewPicker.isHidden = true
    }
    
    // MARK: - Button actions
    
    @IBAction func onMaleClick(_ sender: UIButton) {
        self.maleClick()
    }
    
    func maleClick() {
        self.strGendar = "M"
        self.btnMale.borderWidth = 1.0
        self.btnMale.borderColor = Colors.txtAppDarkColor
        self.lblMale.textColor = Colors.txtAppDarkColor
        imgMale.image = imgMale.image?.withRenderingMode(.alwaysTemplate)
        imgMale.tintColor = Colors.txtAppDarkColor
        
        self.btnFemale.borderWidth = 1.0
        self.btnFemale.borderColor = Colors.txtdarkGray
        self.lblFemale.textColor = Colors.txtdarkGray
        imgFemale.image = imgFemale.image?.withRenderingMode(.alwaysTemplate)
        imgFemale.tintColor = Colors.txtdarkGray
    }
    
    
    @IBAction func onFemaleClick(_ sender: UIButton) {
        self.FemaleClick()
    }
    
    func FemaleClick() {
        self.strGendar = "F"
        self.btnFemale.borderWidth = 1.0
        self.btnFemale.borderColor = Colors.txtAppDarkColor
        self.lblFemale.textColor = Colors.txtAppDarkColor
        imgFemale.image = imgFemale.image?.withRenderingMode(.alwaysTemplate)
        imgFemale.tintColor = Colors.txtAppDarkColor
        
        self.btnMale.borderWidth = 1.0
        self.btnMale.borderColor = Colors.txtdarkGray
        self.lblMale.textColor = Colors.txtdarkGray
        imgMale.image = imgMale.image?.withRenderingMode(.alwaysTemplate)
        imgMale.tintColor = Colors.txtdarkGray
    }
    
    @IBAction func onInfoYelloClick(_ sender: UIButton) {
        self.viewInfoYellow.isHidden = false
    }
    
    @IBAction func onInfoYellowCloseClick(_ sender: UIButton) {
        self.viewInfoYellow.isHidden = true
    }
    
    
    @IBAction func onDOBClick(_ sender: UIButton) {
        showDatePicker()
    }
    
    @IBAction func onRelationshipToPrimaryMemberClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblRelationshipToPrimaryMember.text = dict["name"] as? String
            self.relitionshipIndex = dict["id"] as! String
            print(self.relitionshipIndex)
            if self.relitionshipIndex == "5" {
                self.heightRelationshipToPrimaryMember.constant = 190.0
            } else {
                self.heightRelationshipToPrimaryMember.constant = 100.0
            }
        }
        vc.strNavigationTitle = "relationship".localized
        vc.dataSource = dicRelitionship
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        //        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onOccupationClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblOccupation.text = dict["name"] as? String
            self.occuptionsIndex = dict["id"] as! String
            print(self.occuptionsIndex)
            if self.occuptionsIndex == "-99" {
                self.heightOccupation.constant = 190.0
            } else {
                self.heightOccupation.constant = 100.0
            }
        }
        vc.dataSource = dicOccuptions
        vc.strNavigationTitle = "occupation".localized
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onVibhagClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblVibhag.text = dict["name"] as? String
            self.vibhagIndex = dict["id"] as! String
            print(self.vibhagIndex)
            self.getNagarByVibhagIdAPI()
        }
        vc.dataSource = dicVibhag
        vc.strNavigationTitle = "vibhag".localized
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onNagarClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblNagar.text = dict["name"] as? String
            self.nagarIndex = dict["id"] as! String
            print(self.nagarIndex)
            self.getShakhaByNagarIdAPI()
        }
        vc.dataSource = dicNagar
        vc.strNavigationTitle = "nagar".localized
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onShakhaClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblShakha.text = dict["name"] as? String
            self.shakhaIndex = dict["id"] as! String
            print(self.shakhaIndex)
        }
        vc.dataSource = dicShakha
        vc.strNavigationTitle = "shakha".localized
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onNextClick(_ sender: Any) {
        
        if (checkStep1Validation() == true) {
            self.step1()
        }
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep2VC") as! AddMemberStep2VC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkStep1Validation() -> Bool {
        
        if(txtFirstName.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_full_name".localized)
            return false
        }
        //        else if(txtMiddleName.text == ""){
        //            showAlert(title: APP.title, message: "error_Please_enter_middle_name".localized)
        //            return false
        //        }
        else if(txtSurName.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_surname".localized)
            return false
        } else if strGendar == "" {
            showAlert(title: APP.title, message: "error_Please_choose_gender".localized)
            return false
        }
        else if txtDOB.text!.count == 0 {
            showAlert(title: APP.title, message: "error_Please_choose_date_of_birth".localized)
            return false
        }
        
        if _appDelegator.userType != "self" {
            if txtUserName.text == "" {
                showAlert(title: APP.title, message: "error_Please_enter_username".localized)
                return false
            } else if txtEmail.text == "" {
                showAlert(title: APP.title, message: "error_Please_enter_email".localized)
                return false
            } else if txtPasssword.text == "" {
                showAlert(title: APP.title, message: "error_Please_enter_password".localized)
                return false
            } else if isValidPassword(txtPasssword.text!) == false {
                showAlert(title: APP.title, message: "error_Please_enter_valid_password".localized)
                return false
            } else if txtConfirmPassword.text == "" {
                showAlert(title: APP.title, message: "error_Please_enter_confirm_password".localized)
                return false
            } else if(isValidEmail(txtEmail.text!) == false){
                showAlert(title: APP.title, message: "error_Please_enter_valid_email".localized)
                return false
            } else if txtPasssword.text != txtConfirmPassword.text {
                showAlert(title: APP.title, message: "error_password_confirm_password_not_match".localized)
                return false
            }
        }
        
        if relitionshipIndex == "5" {
            if txtOtherRelationshipToPrimaryMember.text == "" {
                showAlert(title: APP.title, message: "error_Please_enter_full_name".localized)
                return false
            }
        }
        if occuptionsIndex == "-99" {
            if txtOtherOccupation.text == "" {
                showAlert(title: APP.title, message: "error_Please_enter_full_name".localized)
                return false
            }
        }
        
        return true
    }
    
    
    func step1() {
        var dicUserDetails : [String:Any] = [:]
        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        if let strFirstName = txtFirstName.text {
            _appDelegator.dicMember["first_name"] = strFirstName
        }
        if let strMiddleName = txtMiddleName.text {
            _appDelegator.dicMember["middle_name"] = strMiddleName
        }
        if let strSurname = txtSurName.text {
            _appDelegator.dicMember["last_name"] = strSurname
        }
        if let strEmail = dicUserDetails["email"] {
            _appDelegator.dicMember["email"] = strEmail
        }
        _appDelegator.dicMember["gender"] = strGendar
        
        if let strDOB = txtDOB.text {
            _appDelegator.dicMember["dob"] = strDOB
        }
        
        let is18Year = self.isDate18YearsOld(date: txtDOB.text!)
        if is18Year {
            _appDelegator.dicMember["age"] = ""
        } else {
            _appDelegator.dicMember["age"] = "1"
        }
        
        if _appDelegator.userType != "self" {
            if let strUserName = txtUserName.text {
                _appDelegator.dicMember["username"] = strUserName
            }
            if let strPasssword = txtPasssword.text {
                _appDelegator.dicMember["password"] = strPasssword
            }
        }
        
        _appDelegator.dicMember["user_id"] = dicUserDetails["user_id"]
        _appDelegator.dicMember["occupation"] = occuptionsIndex
        _appDelegator.dicMember["shakha"] = shakhaIndex
        
        // parent_member_id not required for add self registration
        
        _appDelegator.dicMember["parent_member_id"] = _appDelegator.memberId
        _appDelegator.dicMember["is_self"] = _appDelegator.userType
        
        if _appDelegator.userType == "self" {
            _appDelegator.dicMember["relationship"] = " "
        } else {
            _appDelegator.dicMember["relationship"] = relitionshipIndex
            relitionshipIndex == "5" ? (_appDelegator.dicMember["other_relationship"] = txtOtherRelationshipToPrimaryMember.text!) : (_appDelegator.dicMember["other_relationship"] = "")
        }
        
        occuptionsIndex == "-99" ? (_appDelegator.dicMember["occupation_name"] = txtOtherOccupation.text!) : (_appDelegator.dicMember["occupation_name"] = "")
        
        if _appDelegator.userType != "self" {
            self.checkUserNameExistAPI()
        } else {
            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddMemberStep2VC") as! AddMemberStep2VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func isDate18YearsOld(date : String) -> Bool {
        let currentDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        
        let pickerDate = self.getStringToDate(date: date)//Date(timeIntervalSinceNow: TimeInterval(timeStemp))
        
        let order = Calendar.current.compare(currentDate!, to: pickerDate!, toGranularity: .hour)
        
        switch order {
        case .orderedDescending:
            print("DESCENDING")
        case .orderedAscending:
            print("ASCENDING")
        case .orderedSame:
            print("SAME")
        }
        // Compare to hour: DESCENDING
        let order2 = Calendar.current.compare(currentDate!, to: pickerDate!, toGranularity: .day)
        switch order2 {
        case .orderedDescending:
            print("DESCENDING")
            return true
        case .orderedAscending:
            print("ASCENDING")
            return false
        case .orderedSame:
            print("SAME")
            return true
        }
    }
    
    func getStringToDate(date : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"//"yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date) // replace Date String
    }
    
    func currentTimeInMiliseconds(date : Date) -> Int {
        let currentDate = date
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    // MARK: - API Calling
    func getRelatinshipAPI() {
        
        APIManager.sharedInstance.callGetApi(url: APIUrl.get_relationship) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicRelitionship.removeAll()
                        let arr = jsonData!["data"]
                        if _appDelegator.isEdit {
                            self.relitionshipIndex = _appDelegator.dicMemberProfile![0]["relationship"] as! String
                            let dicData : [[String : Any]] = arr.object as? [[String : Any]] ?? []
                            let arrFilter : [String] = dicData.filter { $0["member_relationship_id"] as! String ==  self.relitionshipIndex}.map { $0["relationship_name"]! as! String }
                            
                            arrFilter.count == 0 ? (self.lblRelationshipToPrimaryMember.text = " ") : (self.lblRelationshipToPrimaryMember.text = arrFilter[0])
                            
                            if self.relitionshipIndex == "5" {
                                self.heightRelationshipToPrimaryMember.constant = 190.0
                                self.txtOtherRelationshipToPrimaryMember.text =  _appDelegator.dicMemberProfile![0]["other_relationship"] as? String
                                
                            } else {
                                self.heightRelationshipToPrimaryMember.constant = 100.0
                            }
                        } else {
                            self.lblRelationshipToPrimaryMember.text = arr[0]["relationship_name"].string
                            self.relitionshipIndex = arr[0]["member_relationship_id"].string!
                        }
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["member_relationship_id"].string
                            dict["name"] = arr[index]["relationship_name"].string
                            self.dicRelitionship.append(dict)
                        }
                        print(self.dicRelitionship)
                        
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
    
    func getOccuptionsAPI() {
        
        APIManager.sharedInstance.callGetApi(url: APIUrl.get_Occuptions) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicOccuptions.removeAll()
                        let arr = jsonData!["data"]
                        if _appDelegator.isEdit {
                            self.lblRelationshipToPrimaryMember.text = _appDelegator.dicMemberProfile![0]["occupation"] as? String
                            let dicData : [[String : Any]] = arr.object as? [[String : Any]] ?? []
                            let arrFilter : [String] = dicData.filter { $0["occupation_name"] as? String ==  self.lblRelationshipToPrimaryMember.text}.map { $0["occupation_id"]! as! String }
                            self.occuptionsIndex = arrFilter[0]
                            if (self.lblRelationshipToPrimaryMember.text?.lowercased() == "other") {
                                self.txtOtherOccupation.text =  _appDelegator.dicMemberProfile![0]["other_occupation"] as? String
                                self.occuptionsIndex = "-99"
                                self.heightOccupation.constant = 190.0
                            } else {
                                self.heightOccupation.constant = 100.0
                            }
                        } else {
                            self.lblOccupation.text = arr[0]["occupation_name"].string
                            self.occuptionsIndex = arr[0]["occupation_id"].string!
                        }
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["occupation_id"].string
                            dict["name"] = arr[index]["occupation_name"].string
                            self.dicOccuptions.append(dict)
                        }
                        
                        var dictOther = [String : Any]()
                        dictOther["id"] = "-99"
                        dictOther["name"] = "Other"
                        self.dicOccuptions.append(dictOther)
                        
                        print(self.dicOccuptions)
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
    
    func getVibhagAPI() {
        
        APIManager.sharedInstance.callGetApi(url: APIUrl.get_vibhag) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicVibhag.removeAll()
                        let arr = jsonData!["data"]
                        if _appDelegator.isEdit {
                            self.lblVibhag.text = _appDelegator.dicMemberProfile![0]["vibhag"] as? String
                            self.vibhagIndex = _appDelegator.dicMemberProfile![0]["vibhag_id"] as! String
                        } else {
                            self.lblVibhag.text = arr[0]["chapter_name"].string
                            self.vibhagIndex = arr[0]["org_chapter_id"].string!
                        }
                        
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["org_chapter_id"].string
                            dict["name"] = arr[index]["chapter_name"].string
                            self.dicVibhag.append(dict)
                        }
                        print(self.dicVibhag)
                        self.getNagarByVibhagIdAPI()
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
    
    func getNagarByVibhagIdAPI() {
        
        var dicUserDetails : [String:Any] = [:]
        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = dicUserDetails["user_id"]
        parameters["vibhag_id"] = self.vibhagIndex
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_nagar, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicNagar.removeAll()
                        let arr = jsonData!["data"]
                        if _appDelegator.isEdit {
                            self.lblNagar.text = _appDelegator.dicMemberProfile![0]["nagar"] as? String
                            self.nagarIndex = _appDelegator.dicMemberProfile![0]["nagar_id"] as! String
                        } else {
                            self.lblNagar.text = arr[0]["chapter_name"].string
                            self.nagarIndex = arr[0]["org_chapter_id"].string!
                        }
                        
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["org_chapter_id"].string
                            dict["name"] = arr[index]["chapter_name"].string
                            self.dicNagar.append(dict)
                        }
                        print(self.dicNagar)
                        self.getShakhaByNagarIdAPI()
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
    
    func getShakhaByNagarIdAPI() {
        var dicUserDetails : [String:Any] = [:]
        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = dicUserDetails["user_id"]
        parameters["nagar_id"] = self.nagarIndex
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_shakha, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicShakha.removeAll()
                        let arr = jsonData!["data"]
                        if _appDelegator.isEdit {
                            self.lblShakha   .text = _appDelegator.dicMemberProfile![0]["shakha"] as? String
                            self.shakhaIndex = _appDelegator.dicMemberProfile![0]["shakha_id"] as! String
                        } else {
                            self.lblShakha.text = arr[0]["chapter_name"].string
                            self.shakhaIndex = arr[0]["org_chapter_id"].string!
                        }
                        
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["org_chapter_id"].string
                            dict["name"] = arr[index]["chapter_name"].string
                            self.dicShakha.append(dict)
                        }
                        print(self.dicShakha)
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
    
    func checkUserNameExistAPI() {
        
        var dicUserDetails : [String:Any] = [:]
        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = dicUserDetails["user_id"]
        parameters["username"] = self.txtUserName.text!
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.check_username_exist, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arr = jsonData!["data"]
                        print(arr)
                        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddMemberStep2VC") as! AddMemberStep2VC
                        //        vc.dicMember = dicMember
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        self.txtUserName.becomeFirstResponder()
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

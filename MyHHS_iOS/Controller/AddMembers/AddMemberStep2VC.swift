//
//  AddMemberStep2VC.swift
//  MyHHS_iOS
//
//  Created by Patel on 09/03/2021.
//

import UIKit
import RAGTextField

class AddMemberStep2VC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //    var dicMember : [String: Any] = [:]
    
    @IBOutlet weak var heightConstraintForMember: NSLayoutConstraint!
    
    @IBOutlet weak var lblContactInfoTitle: UILabel!
    
    @IBOutlet weak var txtPrimaryContactNumber: RAGTextField!
    
    @IBOutlet weak var txtSecondaryContactNumber: RAGTextField!
    
    @IBOutlet weak var txtSecondaryEmailAddress: RAGTextField!
    
    @IBOutlet weak var lblFindAddressTitle: UILabel!
    
    @IBOutlet weak var lblWhatsYourPostCode: UILabel!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var btnPostCode: UIButton!
    
    @IBOutlet weak var lblSelectAddressTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var txtBuildingName: RAGTextField!
    
    @IBOutlet weak var txtAddressLine1: RAGTextField!
    
    @IBOutlet weak var txtAddressLine2: RAGTextField!
    
    @IBOutlet weak var txtTownCity: RAGTextField!
    
    var dicPincode = [[String:Any]]()
    
    var countyFromAPI : String = ""
    var countryFromAPI : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print(appDelegate.dicMember)
        heightConstraintForMember.constant = 80.0
        
        if _appDelegator.isEdit {
            self.fillEditData()
        } else {
            self.fillData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate.userType == "self" {
            navigationBarDesign(txt_title: "add_self".localized, showbtn: "")
        } else {
            navigationBarDesign(txt_title: "Add_family_member".localized, showbtn: "")
        }
        self.firebaseAnalytics(_eventName: "AddMemberStep2VC")
    }
    
    func fillData() {
        if _appDelegator.userType != "self" {
            if let strPostcode = _appDelegator.dicMemberProfile![0]["postal_code"] as? String {
                self.txtPostCode.text = strPostcode
                self.getAddressByPinCodeAPI()
            }
        }
    }
    
    func fillEditData() {
        
        if let strMobile = _appDelegator.dicMemberProfile![0]["mobile"] as? String {
            self.txtPrimaryContactNumber.text = strMobile
        }
        if let strLandLine = _appDelegator.dicMemberProfile![0]["land_line"] as? String {
            self.txtSecondaryContactNumber.text = strLandLine
        }
        if let strPostalCode = _appDelegator.dicMemberProfile![0]["postal_code"] as? String {
            self.txtPostCode.text = strPostalCode
            self.txtPostCode.resignFirstResponder()
            self.getAddressByPinCodeAPI()
        }
    }
    
    @IBAction func onPostCodeClick(_ sender: UIButton) {
        if txtPostCode.text == "" {
            showAlert(title: APP.title, message: "error_Please_enter_postcode".localized)
            return
        }
        self.txtPostCode.resignFirstResponder()
        self.getAddressByPinCodeAPI()
    }
    
    @IBAction func onAddressClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblAddress.text = dict["name"] as? String
            self.getAddressInfoByIdAPI(id: dict["id"] as! String)
        }
        vc.dataSource = dicPincode
        vc.strNavigationTitle = "Address"
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func onPrevClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "AddMemberStep1", sender: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNextClick(_ sender: Any) {
        
        if (checkStep2Validation() == true) {
            self.step2()
        }
        
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep3VC") as! AddMemberStep3VC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkStep2Validation() -> Bool {
        
        if(txtPrimaryContactNumber.text == ""){
            showAlert(title: APP.title, message: "error_Please_primary_contact_number".localized)
            return false
        }
        //        else if(txtSecondaryContactNumber.text == ""){
        //            showAlert(title: APP.title, message: "error_Please_secondary_contact_number".localized)
        //            return false
        //        }
        //        else if(txtSecondaryEmailAddress.text == "") {
        //            showAlert(title: APP.title, message: "error_Please_secondary_email_address".localized)
        //            return false
        //        } else if(isValidEmail(txtSecondaryEmailAddress.text!) == false){
        //            showAlert(title: APP.title, message: "error_Please_valid_secondary_email_address".localized)
        //            return false
        //        }
        else if txtAddressLine1.text == "" {
            showAlert(title: APP.title, message: "error_Please_enter_address_line1".localized)
            return false
        } else if txtAddressLine2.text == "" {
            showAlert(title: APP.title, message: "error_Please_enter_address_line2".localized)
            return false
        } else if txtTownCity.text == "" {
            showAlert(title: APP.title, message: "error_Please_town_city".localized)
            return false
        }
        return true
    }
    
    func step2() {
        
        if let strPrimaryContactNumber = txtPrimaryContactNumber.text {
            appDelegate.dicMember["mobile"] = strPrimaryContactNumber
        }
        if let strSecondaryContactNumber = txtSecondaryContactNumber.text {
            appDelegate.dicMember["land_line"] = strSecondaryContactNumber
        }
        if let strPostCode = txtPostCode.text {
            appDelegate.dicMember["post_code"] = strPostCode
        }
        if let strBuildingName = self.txtBuildingName.text {
            appDelegate.dicMember["building_name"] = strBuildingName
        }
        if let strAddressLine1 = self.txtAddressLine1.text {
            appDelegate.dicMember["address_line_1"] = strAddressLine1
        }
        if let strAddressLine2 = self.txtAddressLine2.text {
            appDelegate.dicMember["address_line_2"] = strAddressLine2
        }
        if let strTownCity = self.txtTownCity.text {
            appDelegate.dicMember["post_town"] = strTownCity
        }
        appDelegate.dicMember["county"] = self.countyFromAPI
        appDelegate.dicMember["country"] = self.countryFromAPI
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep3VC") as! AddMemberStep3VC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getAddressByPinCodeAPI() {
        
        var parameters: [String: Any] = [:]
        parameters["pincode"] = self.txtPostCode.text
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_address_pincode, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arrData = jsonData!["data"]
                        let arrSummaries = arrData["Summaries"]
                        
                        self.heightConstraintForMember.constant = 480.0
                        self.dicPincode.removeAll()
                        for index in 0..<arrSummaries.count {
                            var dict = [String : Any]()
                            dict["id"] = "\(arrSummaries[index]["Id"])"
                            dict["name"] = "\(arrSummaries[index]["StreetAddress"]), \(arrSummaries[index]["Place"])"
                            self.dicPincode.append(dict)
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
    
    func getAddressInfoByIdAPI(id : String) {
        
        var parameters: [String: Any] = [:]
        parameters["id"] = id
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_address_by_id, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arrData = jsonData!["data"]
                        print(arrData)
                        
                        self.txtBuildingName.text = "\(arrData[0]["BuildingName"])"
                        self.txtAddressLine1.text = "\(arrData[0]["Line1"])"
                        self.txtAddressLine2.text = "\(arrData[0]["Line2"])"
                        self.txtTownCity.text = "\(arrData[0]["PostTown"])"
                        self.countyFromAPI = "\(arrData[0]["County"])"
                        self.countryFromAPI = "\(arrData[0]["CountryName"])"
                        
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

extension AddMemberStep2VC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currentText = textField.text else {
                        return true
                    }
                    
                    // Remove any non-digit characters from the text
                    let cleanText = currentText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
                    
                    // Check if the user is deleting characters or adding new ones
                    let isDeleting = string.isEmpty
                    
                    // Get the total length of the new text
                    let newLength = cleanText.count + (isDeleting ? 0 : string.count)
                    
                    // Check if the new text is more than 11 digits (12341231234 format)
                    if newLength > 11 {
                        return false
                    }
                    
                    // Format the phone number in "1234 123 1234" format
                    var formattedText = ""
                    var index = 0
                    for character in cleanText {
                        if index == 4 || index == 7 {
                            formattedText.append(" ") // Add a space at position 4 and 7
                        }
                        formattedText.append(character)
                        index += 1
                    }
                    
                    // Update the text in the text field
                    textField.text = formattedText
            return true
    }
}

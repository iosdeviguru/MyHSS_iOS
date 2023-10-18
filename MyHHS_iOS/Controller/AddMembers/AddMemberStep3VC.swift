//
//  AddMemberStep3VC.swift
//  MyHHS_iOS
//
//  Created by Patel on 10/03/2021.
//

import UIKit
import RAGTextField

class AddMemberStep3VC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var txtFullName: RAGTextField!
    @IBOutlet weak var txtPhoneNumber: RAGTextField!
    @IBOutlet weak var txtEmail: RAGTextField!
    
    @IBOutlet weak var heightConstraintRelationship: NSLayoutConstraint!
    @IBOutlet weak var lblRelationshipTitle: UILabel!
    @IBOutlet weak var lblRelationship: UILabel!
    @IBOutlet weak var txtOtherRelationship: RAGTextField!
    
    var dicRelitionship = [[String:Any]]()
    var relitionshipIndex : String = "0"
    var strEmergency_Guardian : String = "Emergency"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.        
        print(appDelegate.dicMember)
        
        self.heightConstraintRelationship.constant = 90.0
        self.fillData()
        if _appDelegator.isEdit {
            self.fillEditData()
        }
        self.getRelatinshipAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate.userType == "self" {
            navigationBarDesign(txt_title: "add_self".localized, showbtn: "")
        } else {
            navigationBarDesign(txt_title: "Add_family_member".localized, showbtn: "")
        }
        self.firebaseAnalytics(_eventName: "AddMemberStep3VC")
    }
    
    func fillData() {
        let strAge = appDelegate.dicMember["age"]
        if strAge as! String == "" {
            strEmergency_Guardian = "Emergency"
            self.lblHeaderTitle.text = "emergency_information".localized
            self.txtFullName.placeholder = "emergency_full_name".localized
            self.txtPhoneNumber.placeholder = "emergency_contact_number".localized
            self.txtEmail.placeholder = "emergency_email".localized
            self.lblRelationshipTitle.text = "emergency_relationship".localized
            
        } else {
            strEmergency_Guardian = "Guardian"
            self.lblHeaderTitle.text = "guardian_information".localized
            self.txtFullName.placeholder = "guardian_full_name".localized
            self.txtPhoneNumber.placeholder = "guardian_contact_number".localized
            self.txtEmail.placeholder = "guardian_email".localized
            self.lblRelationshipTitle.text = "guardian_relationship".localized
        }
    }
    
    func fillEditData() {
        
        if let strEmergencyName = _appDelegator.dicMemberProfile![0]["emergency_name"] as? String {
            self.txtFullName.text = strEmergencyName
        }
        if let strEmergencyPhone = _appDelegator.dicMemberProfile![0]["emergency_phone"] as? String {
            self.txtPhoneNumber.text = strEmergencyPhone
        }
        if let strEmergencyEmail = _appDelegator.dicMemberProfile![0]["emergency_email"] as? String {
            self.txtEmail.text = strEmergencyEmail
        }
    }
    
    @IBAction func onRelationshipClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        
        vc.selectedItemCompletion = {dict in
            self.lblRelationship.text = dict["name"] as? String
            self.relitionshipIndex = dict["id"] as! String
            print(self.relitionshipIndex)
            if self.relitionshipIndex == "5" {
                self.heightConstraintRelationship.constant = 188.0
            } else {
                self.heightConstraintRelationship.constant = 90.0
            }
        }
        vc.strNavigationTitle = "relationship".localized
        vc.dataSource = dicRelitionship
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onPrevClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "AddMemberStep1", sender: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNextClick(_ sender: Any) {
        if (checkStep3Validation() == true) {
            self.step3()
        }
        
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep4VC") as! AddMemberStep4VC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func checkStep3Validation() -> Bool {
        
        if txtFullName.text == "" {
            showAlert(title: APP.title, message: "error_please_enter_emergency_contact_name".localized)
            return false
        } else if txtPhoneNumber.text == "" {
            showAlert(title: APP.title, message: "error_please_enter_emergency_contact_number".localized)
            return false
        } else if txtEmail.text == "" {
            showAlert(title: APP.title, message: "error_please_enter_contact_email".localized)
            return false
        } else if isValidEmail(txtEmail.text!) == false {
            showAlert(title: APP.title, message: "error_Please_enter_valid_email".localized)
            return false
        } else if lblRelationship.text == "" {
            showAlert(title: APP.title, message: "error_please_select_relationship".localized)
            return false
        }
        
        if relitionshipIndex == "5" {
            if txtOtherRelationship.text == "" {
                showAlert(title: APP.title, message: "error_Please_enter_other_relationship".localized)
                return false
            }
        }
        return true
    }
    
    func step3() {
        
        if let strFullName = txtFullName.text {
            appDelegate.dicMember["emergency_name"] = strFullName
        }
        if let strPhoneNumber = txtPhoneNumber.text {
            appDelegate.dicMember["emergency_phone"] = strPhoneNumber
        }
        if let strEmail = self.txtEmail.text {
            appDelegate.dicMember["emergency_email"] = strEmail
        }
        appDelegate.dicMember["emergency_relationship"] = self.relitionshipIndex
        
        self.relitionshipIndex == "5" ? (appDelegate.dicMember["other_emergency_relationship"] = self.txtOtherRelationship.text!) : (appDelegate.dicMember["other_emergency_relationship"] = "")
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep4VC") as! AddMemberStep4VC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
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
                            self.lblRelationship.text = (_appDelegator.dicMemberProfile![0]["emergency_relatioship"] as? String)
                            if (self.lblRelationship.text?.lowercased() == "other") {
                                self.txtOtherRelationship.text =  _appDelegator.dicMemberProfile![0]["other_emergency_relationship"] as? String
                                self.relitionshipIndex = "5"
                                self.heightConstraintRelationship.constant = 188.0
                            } else {
                                let dicData : [[String : Any]] = arr.object as? [[String : Any]] ?? []
                                let arrFilter : [String] = dicData.filter { $0["relationship_name"] as? String ==  self.lblRelationship.text}.map { $0["member_relationship_id"]! as! String }
                                arrFilter.count == 0 ? (self.relitionshipIndex = "0") : (self.relitionshipIndex = arrFilter[0])
                                
                                self.heightConstraintRelationship.constant = 90.0
                            }
                        } else {
                            self.lblRelationship.text = arr[0]["relationship_name"].string
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
    
}

extension AddMemberStep3VC: UITextFieldDelegate {
    
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

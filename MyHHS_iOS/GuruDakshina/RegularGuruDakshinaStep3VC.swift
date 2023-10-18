//
//  RegularGuruDakshinaStep3VC.swift
//  MyHHS_iOS
//
//  Created by Patel on 05/04/2021.
//

import UIKit
import RAGTextField
import SSSpinnerButton

class RegularGuruDakshinaStep3VC: UIViewController {
    
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var lblAmountTitile: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAmount: UIButton!

    @IBOutlet weak var lblBillingInfoTitle: UILabel!

    @IBOutlet weak var txtAddress: RAGTextField!
    @IBOutlet weak var txtCity: RAGTextField!
    @IBOutlet weak var txtCountry: RAGTextField!
    @IBOutlet weak var txtPostCode: RAGTextField!
    
    @IBOutlet weak var btnRequest: SSSpinnerButton!
    
    @IBOutlet weak var lblPrev: UILabel!
    
    var strAmount = ""
    var strIndividualFamily = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewAmount.layer.cornerRadius = self.viewAmount.frame.height / 2
        
        self.lblAmount.text = "£ \(self.strAmount)"
        self.fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "regular_dakshina".localized, showbtn: "")
        self.firebaseAnalytics(_eventName: "RegularGuruDakshinaStep3VC")
    }
    
    func fillData() {

        if let strAddress = _appDelegator.dicMemberProfile![0]["building_name"] as? String {
            self.txtAddress.text = "\(strAddress), \(_appDelegator.dicMemberProfile![0]["address_line_1"]!), \(_appDelegator.dicMemberProfile![0]["address_line_2"]!)"
        }
        if let strCity = _appDelegator.dicMemberProfile![0]["city"] as? String {
            self.txtCity.text = strCity
        }
        if let strCountry = _appDelegator.dicDataProfile![0]["country"] as? String {
            strCountry == "<null>" ? (self.txtCountry.text = "United kingdom") : (self.txtCountry.text = strCountry)
        } else {
            self.txtCountry.text = "United kingdom"
        }
        if let strPostCode = _appDelegator.dicMemberProfile![0]["postal_code"] as? String {
            self.txtPostCode.text = strPostCode
        }
    }

    @IBAction func onEditAmountClick(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: APP.title, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "amount".localized
            textField.keyboardType = .numberPad
        }
        let saveAction = UIAlertAction(title: "save".localized, style: UIAlertAction.Style.default, handler: { alert -> Void in
            let amountTextField = alertController.textFields![0] as UITextField
            if let intAmount = Int(amountTextField.text!) {
                if intAmount <= 0 {
                    showAlert(title: APP.title, message: "error_Please_enter_valid_amount".localized)
                    return
                }
            }
            self.strAmount = amountTextField.text!
            self.lblAmount.text = "£ \(self.strAmount)"
        })
        let cancelAction = UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func onPrevClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "AddMemberStep1", sender: nil)
        navigationController?.popViewController(animated: true)
    }


    @IBAction func onRequestClick(_ sender: Any) {
        if (checkRegularGuruDakshinaStep3Validation() == true) {
            self.step3()
        }
//
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep4VC") as! AddMemberStep4VC
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkRegularGuruDakshinaStep3Validation() -> Bool {
        
        if(txtAddress.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_address".localized)
            return false
        } else if(txtCity.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_city".localized)
            return false
        } else if(txtCountry.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_Country".localized)
            return false
        } else if(txtPostCode.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_postcode".localized)
            return false
        }
        return true
    }
    
    
    func step3() {
        
        _appDelegator.dicOnteTimeGuruDakshina["line1"]           = txtAddress.text
        _appDelegator.dicOnteTimeGuruDakshina["city"]            = txtCity.text
        _appDelegator.dicOnteTimeGuruDakshina["country"]         = txtCountry.text
        _appDelegator.dicOnteTimeGuruDakshina["postal_code"]     = txtPostCode.text
        
        self.btnRequest.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: {
            // Your code here
            self.getGuruDakshinaCreateRegularAPI()
        })
    }

    func getGuruDakshinaCreateRegularAPI() {
        
        if let intAmount = Int(self.strAmount) {
            if intAmount <= 0 {
                showAlert(title: APP.title, message: "error_Please_enter_valid_amount".localized)
                return
            }
        }
        
//        var dicUserDetails : [String:Any] = [:]
//        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"]       = _appDelegator.dicMemberProfile![0]["user_id"] as? String //   dicUserDetails["user_id"]
        parameters["member_id"]     = _appDelegator.dicDataProfile![0]["member_id"] as? String
        parameters["amount"]        = self.strAmount
        parameters["start_date"]    = _appDelegator.dicOnteTimeGuruDakshina["start_date"]
        parameters["recurring"]     = _appDelegator.dicOnteTimeGuruDakshina["recurring"]
        parameters["is_linked_member"]     = _appDelegator.dicOnteTimeGuruDakshina["is_linked_member"]
        parameters["gift_aid"]      = _appDelegator.dicOnteTimeGuruDakshina["gift_aid"]
        parameters["line1"]         = _appDelegator.dicOnteTimeGuruDakshina["line1"]
        parameters["city"]          = _appDelegator.dicOnteTimeGuruDakshina["city"]
        parameters["country"]       = _appDelegator.dicOnteTimeGuruDakshina["country"]
        parameters["postal_code"]   = _appDelegator.dicOnteTimeGuruDakshina["postal_code"]
        parameters["dakshina"]      = "Regular"
        
        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.create_regular, parameters: parameters) { [self] (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        
                        self.btnRequest.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: {
                            // Your code here
                            let arr = jsonData!["data"]
                            print(jsonData!)
                            _appDelegator.dicOnteTimeGuruDakshina["account_name"] = arr[0]["account_name"].string
                            _appDelegator.dicOnteTimeGuruDakshina["account_number"] = arr[0]["account_number"].string
                            _appDelegator.dicOnteTimeGuruDakshina["sort_code"] = arr[0]["sort_code"].string
                            _appDelegator.dicOnteTimeGuruDakshina["reference_no"] = arr[0]["reference_no"].string
                            _appDelegator.dicOnteTimeGuruDakshina["paid_amount"] = arr[0]["paid_amount"].string
                            _appDelegator.dicOnteTimeGuruDakshina["frequency"] = arr[0]["frequency"].string
                            _appDelegator.dicOnteTimeGuruDakshina["gift_aid_text"] = arr[0]["gift_aid"].string
                            
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "RegularGuruDakshinaSucessVC") as! RegularGuruDakshinaSucessVC
                            vc.strAmount = self.strAmount
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    }else {
                        self.btnRequest.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                            // Your code here
                            if let strError = jsonData!["message"].string {
                                showAlert(title: APP.title, message: strError)
                            }
                        })
                    }
                }
                else {
                    self.btnRequest.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
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

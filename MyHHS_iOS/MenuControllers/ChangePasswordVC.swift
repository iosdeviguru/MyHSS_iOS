//
//  ChangePasswordVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 10/07/2021.
//

import UIKit
import RAGTextField
import SSSpinnerButton

class ChangePasswordVC: UIViewController {

    @IBOutlet var lblHead: UILabel!
    @IBOutlet var txtOldPwd: RAGTextField!
    @IBOutlet var txtNewPwd: RAGTextField!
    @IBOutlet var txtConfirmPwd: RAGTextField!
    @IBOutlet var btnSubmit: SSSpinnerButton!
    
    @IBOutlet var btnRightOldPwd: UIButton!
    @IBOutlet var btnRightNewPwd: UIButton!
    @IBOutlet var btnRightConfirmPwd: UIButton!
    
    
    var rightButton_pwd : UIButton!
    var showpwdOld : Bool!
    var showpwdNew : Bool!
    var showpwdConfirm : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "change_password".localized, showbtn: "back")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblHead.text = "reset_password".localized
        txtOldPwd = createTextField(txtPlaceholder: "old_password".localized, txtfield: txtOldPwd, Img: "lock_light")
        txtNewPwd = createTextField(txtPlaceholder: "new_password".localized, txtfield: txtNewPwd, Img: "lock_light")
        txtConfirmPwd = createTextField(txtPlaceholder: "confirm_password".localized, txtfield: txtConfirmPwd, Img: "lock_light")
        btnSubmit.setTitle("submit".localized, for: .normal)
        btnSubmit.layer.cornerRadius = 8
        
        self.firebaseAnalytics(_eventName: "ChangePasswordVC")
    }
    
    @IBAction func onRightPwdClick(_ sender: UIButton) {
        if sender.tag == 1111 {
            if(showpwdOld == false){
                showpwdOld = true
                btnRightOldPwd.setImage(UIImage.init(named: "eye-off-dark"), for: .normal)
            }else{
                showpwdOld = false
                btnRightOldPwd.setImage(UIImage.init(named: "eye-off-light"), for: .normal)
            }
            
            txtOldPwd.isSecureTextEntry.toggle()
        } else if sender.tag == 2222 {
            if(showpwdNew == false){
                showpwdNew = true
                btnRightNewPwd.setImage(UIImage.init(named: "eye-off-dark"), for: .normal)
            }else{
                showpwdNew = false
                btnRightNewPwd.setImage(UIImage.init(named: "eye-off-light"), for: .normal)
            }
            
            txtNewPwd.isSecureTextEntry.toggle()
            
        } else if sender.tag == 3333 {
            if(showpwdConfirm == false){
                showpwdConfirm = true
                btnRightConfirmPwd.setImage(UIImage.init(named: "eye-off-dark"), for: .normal)
            }else{
                showpwdConfirm = false
                btnRightConfirmPwd.setImage(UIImage.init(named: "eye-off-light"), for: .normal)
            }
            txtConfirmPwd.isSecureTextEntry.toggle()
        }
    }
    
    @IBAction func onSubmitClick(_ sender: UIButton) {
        if (checkChangePasswordValidation() == true) {
            
            self.btnSubmit.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: {
                // Your code here
                self.changePassword()
            })
        }
    }
    
    func checkChangePasswordValidation() -> Bool {
        if(txtOldPwd.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_old_password".localized)
            return false
        } else if(txtNewPwd.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_new_password".localized)
            return false
        } else if(txtConfirmPwd.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_confirm_password".localized)
            return false
        } else if isValidPassword(txtNewPwd.text!) == false {
            showAlert(title: APP.title, message: "error_Please_enter_valid_new_password".localized)
            return false
        } else if txtNewPwd.text != txtConfirmPwd.text {
            showAlert(title: APP.title, message: "error_password_confirm_password_not_match".localized)
            return false
        }
        
        return true
    }

    func changePassword() {
        
        var dicUserDetails : [String:Any] = [:]
        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]

        self.view.endEditing(true)
        var parameters: [String: Any] = [:]
        parameters["user_id"] = dicUserDetails["user_id"]
        parameters["old_password"] = txtOldPwd.text!
        parameters["new_password"] = txtNewPwd.text!
        print(parameters)
        APIManager.sharedInstance.callPostApi(url: APIUrl.change_password, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        if let strError = jsonData!["message"].string {
                            //                            showAlert(title: APP.title, message: strError)
                            self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: {
                                // Your code here
                                // create the alert
                                let alert = UIAlertController(title: "Success", message: "\(jsonData!["message"])", preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default, handler: { action in
                                    window?.switchToLoginScreen()
                                    _userDefault.delete(key: kDeviceToken)
                                    self.firebaseAnalytics(_eventName: "LogoutVC")
                                }))
                                self.present(alert, animated: true, completion: nil)
                            })
                        } else{
                            self.btnSubmit.stopAnimate(complete: {
                                // Your code here
                                showAlert(title: APP.title, message: "Error")
                            })
                        }
                    }else {
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

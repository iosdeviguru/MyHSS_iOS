//
//  Login.swift
//  MyHHS_iOS
//
//  Created by baps on 24/06/2019 jun.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import RAGTextField
import Alamofire
import NVActivityIndicatorView
import SideMenuSwift
import LocalAuthentication
import SSSpinnerButton
import SwiftyJSON

class Login: UIViewController  {
    
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var txtPwd: RAGTextField!
    @IBOutlet var txtUnm: RAGTextField!
    @IBOutlet var txtEmail_PWD: RAGTextField!
    @IBOutlet var lblHead: UILabel!
    @IBOutlet var btnForgotPwd: UIButton!
    @IBOutlet var btnGmailLogin: UIButton!
    @IBOutlet var btnFBLogin: UIButton!
    @IBOutlet var lblOr: UILabel!
    @IBOutlet var btnSignIn: SSSpinnerButton!
    
    @IBOutlet var lblRegister: UILabel!
    var rightButton_pwd : UIButton!
    var showpwd : Bool!
    
    
    @IBOutlet var viewForgotPWDBack: UIView!
    @IBOutlet var viewForgotPWD: UIView!
    
    @IBOutlet var lblForgotPWD: UILabel!
    
    
    @IBOutlet weak var btnSubmit_forgotPWD: SSSpinnerButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        //Login Attributed string
        let text2 = "Dont_have_any_account".localized
        let attributedString2 = NSMutableAttributedString.init(string: text2)
        let str2 = NSString(string: text2)
        let theRange3 = str2.range(of: "Register!")
        attributedString2.addAttribute(.foregroundColor, value: Colors.txtAppDarkColor, range: theRange3)
        lblRegister.attributedText = attributedString2
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: animated)
        
        //        (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        showpwd = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
        lblHead.text = "login_in".localized
        lblHead.text = "login_in".localized
        txtUnm = createTextField(txtPlaceholder: "username".localized, txtfield: txtUnm, Img: "email_light")
        txtEmail_PWD = createTextField(txtPlaceholder: "username".localized, txtfield: txtEmail_PWD, Img: "email_light")
        
        txtPwd = createTextField(txtPlaceholder: "password".localized, txtfield: txtPwd, Img: "lock_light")
        btnSignIn.layer.cornerRadius = 8
        
        imgLogo.layer.borderWidth = 4
        imgLogo.layer.borderColor = UIColor.white.cgColor
        imgLogo.layer.cornerRadius = imgLogo.frame.size.height/2
        
        btnSignIn.layer.cornerRadius = 8
        
        btnSubmit_forgotPWD.layer.cornerRadius = 8
        viewForgotPWD.roundCorners(corners: [.topLeft, .topRight], radius: 24)
        
        //viewSucessBack.isHidden = true
        viewForgotPWDBack.isHidden = true
        
        viewForgotPWD.backgroundColor = .white
        
        self.view.backgroundColor = .white
        self.txtPwd.isSecureTextEntry = true
        
        rightButton_pwd  = UIButton(type: .custom)
        rightButton_pwd.frame = CGRect(x:0, y:0, width:30, height:30)
        rightButton_pwd.setBackgroundImage(UIImage.init(named: "eye-off-light"), for: UIControl.State.normal)
        rightButton_pwd.addTarget(self, action: #selector(showped), for: UIControl.Event.touchUpInside)
        txtPwd.rightViewMode = .always
        txtPwd.rightView = rightButton_pwd
        
        self.firebaseAnalytics(_eventName: "LoginVC")
    }
    
    @objc func showped()
    {
        rightButton_pwd  = UIButton(type: .custom)
        rightButton_pwd.frame = CGRect(x:0, y:0, width:30, height:30)
        if(showpwd == false){
            showpwd = true
            rightButton_pwd.setBackgroundImage(UIImage.init(named: "eye-off-dark"), for: UIControl.State.normal)
        }else{
            showpwd = false
            rightButton_pwd.setBackgroundImage(UIImage.init(named: "eye-off-light"), for: UIControl.State.normal)
        }
        
        rightButton_pwd.addTarget(self, action: #selector(showped), for: UIControl.Event.touchUpInside)
        txtPwd.rightViewMode = .always
        txtPwd.rightView = rightButton_pwd
        txtPwd.isSecureTextEntry.toggle()
    }
    
    @IBAction func CloseForgotPWD(_ sender: Any) {
        viewForgotPWDBack.isHidden = true
        self.view.endEditing(true)
        self.firebaseAnalytics(_eventName: "LoginVC")
    }
    
    @IBAction func RegisterClick(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let reg = storyBoard.instantiateViewController(withIdentifier: "registerVC") as! RegisterVC
        reg.isfromLogin = "yes"
        self.navigationController?.pushViewController(reg, animated: true)
    }
    @IBAction func GMLoginClick(_ sender: Any) {
    }
    @IBAction func FBLoginClick(_ sender: Any) {
    }
    @IBAction func forgotPwdClick(_ sender: Any) {
        
        self.view.endEditing(true)
        viewForgotPWDBack.isHidden = false
        self.firebaseAnalytics(_eventName: "ForgotPasswordVC")
    }
    
    @IBAction func LoginClick(_ sender: Any) {
        
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        ////        let newViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        //        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ContentNavigation") as! NavigationController
        //        let vc = UINavigationController(rootViewController: newViewController)
        //        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        //        appdelegate.window!.rootViewController = vc
        //        window?.makeKeyAndVisible()
        
        if(txtUnm.text == "" && txtPwd.text == ""){
            showAlert(title: APP.title, message: "Enter valid username and password")
            
            return
        } else if txtUnm.text == "" {
            showAlert(title: APP.title, message: "Username required")
            return
        } else if txtPwd.text == "" {
            showAlert(title: APP.title, message: "Password required")
            return
        } else if isValidUserName(stringName: txtUnm.text ?? "") == false {
            showAlert(title: APP.title, message: "Please enter valid username")
            return
        } else if isValidPassword(password: txtPwd.text ?? "") == false {
            showAlert(title: APP.title, message: "Please enter valid password")
            return
        }
        /*else if(isValidEmail(txtUnm.text!) == false){
         showAlert(title: APP.title, message: "error_Please_enter_valid_email".localized)
         return
         }*/
        
        
        btnSignIn.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: {
            // Your code here
            self.login()
        })
        
    }
    
    func isValidUserName(stringName: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9]{5,}$")
        let range = NSRange(location: 0, length: stringName.utf16.count)
        return regex.firstMatch(in: stringName, options: [], range: range) != nil
    }

    func isValidPassword(password: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$")
        let range = NSRange(location: 0, length: password.utf16.count)
        return regex.firstMatch(in: password, options: [], range: range) != nil
    }

    func login() {
        // End editing to dismiss the keyboard
        view.endEditing(true)

        // Create a dictionary of parameters
        var parameters: [String: Any] = [
            "username": txtUnm.text ?? "",
            "password": txtPwd.text ?? "",
            "device": "I"
        ]

        if let deviceToken = _appDelegator.deviceToken {
            parameters["device_token"] = deviceToken
        } else {
            // Set an empty device token if not available
            parameters["device_token"] = ""
        }

        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.login, parameters: parameters) { [weak self] jsonData, error in
            guard let self = self else { return }
            if error == nil {
                if let status = jsonData?["status"].int {
                    if status == 1 {
                        self.handleSuccessfulLogin(jsonData: jsonData)
                    } else {
                        self.handleLoginFailure(jsonData: jsonData)
                    }
                }
            }
        }
    }

    func handleSuccessfulLogin(jsonData: JSON?) {
        let dic = jsonData?.dictionaryObject
        _userDefault.save(object: dic as Any, key: "user_details")
        _userDefault.save(object: true, key: APP.isLogin)
        
        if let token = jsonData?["token"].string {
            setDeviceToken(deviceToken: token)
            print("Toke Userdefault: \(getDeviceToken() ?? "")")
        }
        
        if _userDefault.get(key: kDeviceToken) != nil {
            btnSignIn.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: { [weak self] in
                guard let self = self else { return }
                let userData = _userDefault.get(key: "user_details") as! [String: Any]
                let fname = userData["first_name"] as? String ?? ""
                let lname = userData["last_name"] as? String ?? ""
                let passcodeVC = self.storyboard?.instantiateViewController(withIdentifier: "PasscodeView") as! PasscodeView
                passcodeVC.userName = fname + " " + lname
                passcodeVC.isFromHome = false
                self.navigationController?.pushViewController(passcodeVC, animated: true)
            })
        } else {
            btnSignIn.stopAnimate(complete: { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: "Tologin", sender: nil)
            })
        }
    }

    func handleLoginFailure(jsonData: JSON?) {
        btnSignIn.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
            // Handle the login failure
            if let strError = jsonData?["message"].string {
                showAlert(title: APP.title, message: strError)
            }
        })
    }

    
    
    @IBAction func onSubmitForgotPasswordClick(_ sender: Any) {
        if(txtEmail_PWD.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_username".localized)
            return
        }
        btnSubmit_forgotPWD.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: { [weak self] in
            guard let self = self else { return }
            self.forgotPassword()
        })
    }
    
    func forgotPassword() {
        // End editing to dismiss the keyboard
        view.endEditing(true)
    
        let parameters: [String: Any] = [
            "username": txtEmail_PWD.text ?? ""
        ]
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.forgot_password, parameters: parameters) { [weak self] jsonData, error in
            guard let self = self else { return }
            if error == nil {
                if let status = jsonData?["status"].int {
                    if status == 1 {
                        self.handlePasswordResetSuccess(jsonData: jsonData)
                    } else {
                        self.handlePasswordResetFailure(jsonData: jsonData)
                    }
                } else {
                    self.handlePasswordResetFailure(jsonData: jsonData)
                }
            }
        }
    }

    func handlePasswordResetSuccess(jsonData: JSON?) {
        btnSubmit_forgotPWD.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: { [weak self] in
            guard let self = self else { return }
            if let strError = jsonData?["message"].string {
                showAlert(title: APP.title, message: strError)
                viewForgotPWDBack.isHidden = true
                view.endEditing(true)
            }
        })
    }
                                                                             

    func handlePasswordResetFailure(jsonData: JSON?) {
        btnSubmit_forgotPWD.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
            // Handle the password reset failure
            if let strError = jsonData?["message"].string {
                showAlert(title: APP.title, message: strError)
            }
        })
    }
    
    func authenticateUser() {
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            
            // Device can use biometric authentication
            context.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Access requires authentication",
                reply: {(success, error) in
                    DispatchQueue.main.async {
                        
                        if let err = error {
                            
                            switch err._code {
                                
                            case LAError.Code.systemCancel.rawValue:
                                self.notifyUser("Session cancelled",
                                                err: err.localizedDescription)
                                
                            case LAError.Code.userCancel.rawValue:
                                self.notifyUser("Please try again",
                                                err: err.localizedDescription)
                                
                            case LAError.Code.userFallback.rawValue:
                                self.notifyUser("Authentication",
                                                err: "Password option selected")
                                // Custom code to obtain password here
                                
                            default:
                                self.notifyUser("Authentication failed",
                                                err: err.localizedDescription)
                            }
                            
                        } else {
                            self.notifyUser("Authentication Successful",
                                            err: "You now have full access")
                        }
                    }
                })
            
        } else {
            // Device cannot use biometric authentication
            if let err = error {
                switch err.code {
                    
                case LAError.Code.biometryNotEnrolled.rawValue:
                    notifyUser("User is not enrolled",
                               err: err.localizedDescription)
                    
                case LAError.Code.passcodeNotSet.rawValue:
                    notifyUser("A passcode has not been set",
                               err: err.localizedDescription)
                    
                    
                case LAError.Code.biometryNotAvailable.rawValue:
                    notifyUser("Biometric authentication not available",
                               err: err.localizedDescription)
                default:
                    notifyUser("Unknown error",
                               err: err.localizedDescription)
                }
            }
        }
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK".localized,
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true,
                     completion: nil)
    }
    
    func authUserWithFaceIDTouchIDOrPasscode() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"
        
        var authorizationError: NSError?
        let reason = "Authentication is required for you to continue"
        
        if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authorizationError) {
            
            let biometricType = localAuthenticationContext.biometryType == LABiometryType.faceID ? "Face ID" : "Touch ID"
            print("Supported Biometric type is: \( biometricType )")
            
            localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluationError) in
                if success {
                    print("Success")
                    DispatchQueue.main.async(execute: {
                        if #available(iOS 13.0, *) {
                            if let scene = self.view.window?.windowScene?.delegate as? SceneDelegate{
                                scene.window?.switchToWelcomScreen()
                            }
                        } else {
                            // Fallback on earlier versions
                            print("Need to handle for below iOS 13")
                        }
                    })
                } else {
                    print("Error \(evaluationError!)")
                    if let errorObj = evaluationError {
                        let messageToDisplay = self.getErrorDescription(errorCode: errorObj._code)
                        print(messageToDisplay)
                        let userData = _userDefault.get(key: "user_details") as! Dictionary<String, Any>
                        print(userData)
                        var fname = ""
                        var lname = ""
                        if let strFirstName = userData["first_name"] as? String {
                            fname = strFirstName
                        }
                        if let strLastName = userData["last_name"] as? String {
                            lname = strLastName
                        }
                        let passcodeVC = self.storyboard?.instantiateViewController(withIdentifier: "PasscodeView") as! PasscodeView
                        passcodeVC.userName = fname  + " " + lname
                        self.navigationController?.pushViewController(passcodeVC, animated: true)
                    }
                }
            }
            
        } else {
            print("User has not enrolled into using Biometrics")
        }
    }
    
    func getErrorDescription(errorCode: Int) -> String {
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            return "Authentication was not successful, because user failed to provide valid credentials."
            
        case LAError.appCancel.rawValue:
            return "Authentication was canceled by application (e.g. invalidate was called while authentication was in progress)."
            
        case LAError.invalidContext.rawValue:
            return "LAContext passed to this call has been previously invalidated."
            
        case LAError.notInteractive.rawValue:
            return "Authentication failed, because it would require showing UI which has been forbidden by using interactionNotAllowed property."
            
        case LAError.passcodeNotSet.rawValue:
            return "Authentication could not start, because passcode is not set on the device."
            
        case LAError.systemCancel.rawValue:
            return "Authentication was canceled by system (e.g. another application went to foreground)."
            
        case LAError.userCancel.rawValue:
            return "Authentication was canceled by user (e.g. tapped Cancel button)."
            
        case LAError.userFallback.rawValue:
            return "Authentication was canceled, because the user tapped the fallback button (Enter Password)."
            
        default:
            return "Error code \(errorCode) not found"
        }
        
    }
}

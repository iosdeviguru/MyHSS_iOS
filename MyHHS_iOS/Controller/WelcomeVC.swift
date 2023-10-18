//
//  WelcomeVC.swift
//  MyHHS_iOS
//
//  Created by baps on 24/06/2019 jun.
//

import UIKit
import LocalAuthentication

class WelcomeVC: UIViewController {
    
    @IBOutlet weak var topConstraintViewWelcome: NSLayoutConstraint!
    @IBOutlet var viewWelcome: UIView!
    @IBOutlet weak var viewWelcomeToMyHSS: NSLayoutConstraint!
    @IBOutlet weak var welcomToMyHSSToConstraints: NSLayoutConstraint!
    
    @IBOutlet var btnAddself: UIButton!
    @IBOutlet var lblAddSelf: UILabel!
    
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var viewmsg_back: UIView!
    
    var isFromPassCodeTrue = false
    var loadData = false
    
    @IBAction func onMenu(_ sender: UIButton) {
        sideMenuController?.revealMenu()
        
    }
    
    @IBAction func Home(_ sender: UIButton) {
        //        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "StaticHomeVC") as! StaticHomeVC
        ////        vc.strNavigation = "notification".localized
        //        self.navigationController?.pushViewController(vc, animated: true)
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "StaticHomeVC") as! StaticHomeVC
//        vc.strHeader = "isFromWelcome"
//        self.navigationController?.pushViewController(vc, animated: true)
        _userDefault.delete(key: kDeviceToken)
        _userDefault.delete(key: kUserInfo)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        self.firebaseAnalytics(_eventName: "LogoutVC")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //        navigationBarDesign(txt_title: "welocome".localized, showbtn: "Dashboard_white")
        //        navigationBarDesign(txt_title: "welocome".localized, showbtn: "Logout")
        self.navigationBarDesignForPasscode()
        lblMsg.text = "welocome_text_mag".localized
        lblMsg.textColor = UIColor.systemGreen
        lblMsg.font = UIFont( name:"SourceSansPro-Regular" , size: 20)
        
        btnAddself.setTitle( "add_self".localized, for: UIControl.State.normal)
        //		btnAddself.backgroundColor = Colors.yellow_button
        btnAddself.setTitleColor(Colors.txtBlack, for: UIControl.State.normal)
        btnAddself.layer.borderWidth = 1
        btnAddself.layer.borderColor = Colors.bglightGray.cgColor
        
        //		viewmsg_back.layer.borderWidth = 1
        //		viewmsg_back.layer.borderColor = UIColor.init(red: 248/255, green: 176/255, blue: 60/255, alpha: 1.0).cgColor
        
        btnAddself.layer.cornerRadius = 8
        self.viewmsg_back.cornerRadius = 8
        // Do any additional setup after loading the view.
        self.topConstraintViewWelcome.constant = -58
        self.viewWelcomeToMyHSS.constant = 140
        self.viewWelcome.isHidden = true
        viewmsg_back.isHidden = true
        self.btnAddself.isHidden = true
        self.lblAddSelf.isHidden = true
        if self.loadData == true {
            self.latestUpdateAPI()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.loadData == true {
            self.getProfileAPI()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFromPassCodeTrue == false {
            self.checkForPasscode()
        }
    }
    
    func authUserWithFaceIDTouchIDOrPasscode() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"
        
        var authorizationError: NSError?
        let reason = "Authentication is required for you to continue"
        
        DispatchQueue.main.async(execute: {
            if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authorizationError) {
                
                let biometricType = localAuthenticationContext.biometryType == LABiometryType.faceID ? "Face ID" : "Touch ID"
                print("Supported Biometric type is: \( biometricType )")
                
                localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluationError) in
                    if success {
                        print("Success")
                        DispatchQueue.main.async(execute: {
                            if let presentedAlert = self.presentedViewController as? UIAlertController {
                                    presentedAlert.dismiss(animated: true, completion: nil)
                                    self.getProfileAPI()
                                    self.latestUpdateAPI()
                                }
                        })
                    } else {
                        print("Error \(evaluationError!)")
                        if let errorObj = evaluationError {
                            let messageToDisplay = self.getErrorDescription(errorCode: errorObj._code)
                            print(messageToDisplay)
                            if messageToDisplay == "Authentication was canceled by user (e.g. tapped Cancel button)." {
                                DispatchQueue.main.async {
                                    self.goToHomeViewAfterCancel()
                                }
                            }
                        }
                    }
                }
                
            } else {
                print("User has not enrolled into using Biometrics")
            }
        })
    }
    
    func goToHomeViewAfterCancel() {
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
        passcodeVC.firstAttemptCreds = _userDefault.get(key: "user_passcode") as! String
        passcodeVC.isFromHome = true
        self.navigationController?.pushViewController(passcodeVC, animated: true)
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
    
    func checkForPasscode() {
        let isKeyPresent = self.isKeyPresentInUserDefaults(key: APP.isBiometric)
        if  isKeyPresent {
            let isBiometric = Singleton.shared.get(key: APP.isBiometric)
            if (isBiometric as! Int == 1) {
                self.authUserWithFaceIDTouchIDOrPasscode()
            } else {
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
                passcodeVC.firstAttemptCreds = _userDefault.get(key: "user_passcode") as! String
                passcodeVC.isFromHome = true
                self.navigationController?.pushViewController(passcodeVC, animated: true)
            }
        }
    }
    
    override func clickHome(_ sender: UIButton) {
        _userDefault.delete(key: kDeviceToken)
        _userDefault.delete(key: kUserInfo)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        self.firebaseAnalytics(_eventName: "LogoutVC")
    }
    
    @IBAction func AddSelfClick(_ sender: Any) {
        
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddMemberStep1VC") as! AddMemberStep1VC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - API Functions
    
    func getProfileAPI() {
        var dicUserDetails : [String:Any] = [:]
        
        let isKeyPresent = self.isKeyPresentInUserDefaults(key: "user_details")
        
        if !isKeyPresent {
            return
        }
        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = dicUserDetails["user_id"]
        parameters["member_id"] = dicUserDetails["member_id"]
        parameters["device"] = "I"
        if _userDefault.get(key: kDeviceToken) != nil {
            parameters["device_token"] = _userDefault.get(key: kDeviceToken) as! String
        }
        
        else {
            parameters["device_token"] = ""
        }
        
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_profile, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let dicResponse = jsonData?.dictionaryObject
                        print(dicResponse!)
                        _appDelegator.dicDataProfile = dicResponse!["data"] as? [[String : Any]]
                        _appDelegator.dicMemberProfile = dicResponse!["member"] as? [[String : Any]]
                        
                        //                        let dat = data_model.init(id: i, posted_on: date_post, teaser: dic.value(forKey: "teaser") as? String, title: dic.value(forKey: "title") as? String, like:  lik,compnm: dic.value(forKey: "feedname") as? String,timestmp: dic.value(forKey: "posted_on") as? String)
                        //
                        //                        self.arrData.add(dat)
                        
                        _appDelegator.ProfileDataModel = ProfileDataModel.init(dicData: dicResponse!["data"] as! [[String : Any]])
                        
                        if let dic : [[String : Any]] = dicResponse!["member"] as? [[String : Any]] {
                            _appDelegator.ProfileMemberModel = ProfileMemberModel.init(dicMember: dic)
                        }
                        NotificationCenter.default
                            .post(name: NSNotification.Name("isShakhaTab"),
                                  object: nil)
                        
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
    
    //    func isKeyPresentInUserDefaults(key: String) -> Bool {
    //        return UserDefaults.standard.object(forKey: key) != nil
    //    }
    
    func welcomeAPI() {
        
        var dicUserDetails : [String:Any] = [:]
        if _userDefault.get(key: "user_details") != nil {
            dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        }
        var parameters: [String: Any] = [:]
        parameters["user_id"] = dicUserDetails["user_id"]
        print(parameters)
        APIManager.sharedInstance.callPostApi(url: APIUrl.welcome, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        
                        if let strWelcome = jsonData!["tooltip"].string {
                            //                        showAlert(title: APP.title, message: strError)
                            self.viewmsg_back.isHidden = false
                            self.lblMsg.text = strWelcome
                            
                            if jsonData!["type"].string == "self" {
                                self.btnAddself.isHidden = false
                                self.lblAddSelf.isHidden = false
                                self.viewWelcome.isHidden = false
                                self.viewmsg_back.layer.borderWidth = 1.6
                                self.viewmsg_back.layer.borderColor = UIColor.init(red: 215/255, green: 132/255, blue: 0/255, alpha: 1.0).cgColor
                                self.lblMsg.textColor = UIColor.init(red: 215/255, green: 132/255, blue: 0/255, alpha: 1.0)
                                self.viewmsg_back.backgroundColor = UIColor.init(red: 255/255, green: 247/255, blue: 234/255, alpha: 1.0)
                                self.topConstraintViewWelcome.constant = -58
                                self.viewWelcomeToMyHSS.constant = 140
                                self.welcomToMyHSSToConstraints.constant = 40
                            } else {
                                self.btnAddself.isHidden = true
                                self.lblAddSelf.isHidden = true
                                self.viewWelcome.isHidden = false
                                self.viewmsg_back.layer.borderWidth = 1.6
                                self.viewmsg_back.layer.borderColor = UIColor.init(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0).cgColor
                                self.lblMsg.textColor = UIColor.init(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
                                self.viewmsg_back.backgroundColor = UIColor.init(red: 236/255, green: 255/255, blue: 244/255, alpha: 1.0)
                                //                                self.topConstraintViewWelcome.constant = 268
                                self.topConstraintViewWelcome.constant = -58
                                self.viewWelcomeToMyHSS.constant = 140
                                self.welcomToMyHSSToConstraints.constant = 100
                            }
                            
                            _appDelegator.userType = jsonData!["type"].string   // "self"//jsonData!["type"].string
                            if let strMemberId = jsonData!["member_id"].string {
                                _appDelegator.memberId = strMemberId
                            }
                            
                            //                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            //                            let vc = storyBoard.instantiateViewController(withIdentifier: "StaticHomeVC") as! StaticHomeVC
                            //                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        } else {
                            if #available(iOS 13.0, *) {
                                _appDelegator.userType = jsonData!["type"].string   // "self"//jsonData!["type"].string
                                if let strMemberId = jsonData!["member_id"].string {
                                    _appDelegator.memberId = strMemberId
                                }
                                
                                if let scene = self.view.window?.windowScene?.delegate as? SceneDelegate{
                                    scene.window?.switchToHomeScreen()
                                }
                            } else {
                                // Fallback on earlier versions
                                print("Need to handle for below iOS 13")
                            }
                            //                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            //                            let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                            //                            self.navigationController?.pushViewController(vc, animated: true)
                            self.getProfileAPI()
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
    
    // MARK: - API Functions
    
    func latestUpdateAPI() {
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        var parameters: [String: Any] = [:]
        parameters["app_name"] = "ios_hss"
        parameters["OSName"] = "ios"
        parameters["app_version"] = appVersion
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.latest_update, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arr = jsonData!["data"]
                        print(arr)
                        if let storeVersion = arr["lastestAppVersion"].string {
                            if storeVersion.compare(appVersion!, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending {
                                print("store version is newer")
                                let forceUpdateRequired = arr["ForceUpdateRequired"].string
                                if forceUpdateRequired == "true" {
                                    _userDefault.save(object: true, key: APP.isForceUpdate)
                                    // create the alert
                                    let alert = UIAlertController(title: APP.title, message: "New version is available. Please update to version \(storeVersion) now.", preferredStyle: UIAlertController.Style.alert)
                                    // add an action (button)
                                    let ok = UIAlertAction(title: "Update", style: .default, handler: { action in
                                        if let url = URL(string: "itms-apps://apple.com/app/id1566351540") {
                                            UIApplication.shared.open(url)
                                        }
                                    })
                                    alert.addAction(ok)
                                    // show the alert
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    let alert = UIAlertController(title: APP.title, message: "New version is available. Please update to version \(storeVersion) now.", preferredStyle: .alert)
                                    
                                    let ok = UIAlertAction(title: "Update", style: .default, handler: { action in
                                        _userDefault.save(object: true, key: APP.isForceUpdate)
                                    })
                                    alert.addAction(ok)
                                    let cancel = UIAlertAction(title: "Later", style: .default, handler: { action in
                                        _userDefault.save(object: false, key: APP.isForceUpdate)
                                        self.welcomeAPI()
                                    })
                                    alert.addAction(cancel)
                                    DispatchQueue.main.async(execute: {
                                        self.present(alert, animated: true)
                                    })
                                }
                            }
                        }else {
                            print("store version is latest no need to update")
                            _userDefault.save(object: false, key: APP.isForceUpdate)
                            self.welcomeAPI()
                        }
                    }else {
                        if let strError = jsonData!["message"].string {
                            //                             showAlert(title: APP.title, message: strError)
                        }
                        _userDefault.save(object: false, key: APP.isForceUpdate)
                        self.welcomeAPI()
                    }
                }
                else {
                    if let strError = jsonData!["message"].string {
                        showAlert(title: APP.title, message: strError)
                    }
                    _userDefault.save(object: false, key: APP.isForceUpdate)
                    self.welcomeAPI()
                }
            }
        }
    }
}

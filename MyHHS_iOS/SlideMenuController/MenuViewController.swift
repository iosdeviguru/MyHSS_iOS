//
//  MenuViewController.swift
//  SideMenuExample
//
//  Created by kukushi on 11/02/2018.
//  Copyright © 2018 kukushi. All rights reserved.
//

import UIKit
import StoreKit
import SideMenuSwift
import LocalAuthentication

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class MenuViewController: UIViewController {
    var isDarkModeEnabled = false
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
        }
    }
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblAbbreviation: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var btnProfile: UIButton!
    
    @IBOutlet var lblVersionNumber: UILabel!
    
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    private var themeColor = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.layer.cornerRadius = imageProfile.frame.height / 2
        lblAbbreviation.layer.cornerRadius = lblAbbreviation.frame.height / 2
        imageProfile.layer.masksToBounds = true
        lblAbbreviation.layer.masksToBounds = true
        
        
        
//        self.lblUserName.text = ""
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.lblVersionNumber.text = "App Version \(appVersion!)"
        
        isDarkModeEnabled = SideMenuController.preferences.basic.position == .under
        configureView()
        
        sideMenuController?.cache(viewControllerGenerator: {
            _mainStoryBoard.instantiateViewController(withIdentifier: "SecondViewController")
        }, with: "1")
        
        sideMenuController?.cache(viewControllerGenerator: {
            _mainStoryBoard.instantiateViewController(withIdentifier: "ThirdViewController")
        }, with: "2")
        
        sideMenuController?.delegate = self

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if _appDelegator.dicDataProfile?.count != nil {
            if let strAbbreviation = _appDelegator.dicDataProfile![0]["profile_word"] as? String {
                if strAbbreviation.count > 0 {
                    self.lblAbbreviation.text = strAbbreviation
                } else {
                    imageProfile.image = UIImage(named: "AppIcon")
                    self.lblAbbreviation.isHidden = true
                }
                
            }
            if let strName = _appDelegator.dicDataProfile![0]["username"] as? String {
                self.lblUserName.text = strName
            }
            if let strRole = _appDelegator.dicDataProfile![0]["role"] as? String {
                self.lblRole.text = strRole
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.firebaseAnalytics(_eventName: "SideMenuVC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("[Example] Menu did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("[Example] Menu will disappear")
    }
    
    private func configureView() {
        if isDarkModeEnabled {
            themeColor = UIColor(red: 0.03, green: 0.04, blue: 0.07, alpha: 1.00)
            lblUserName.textColor = .white
        } else {
            //            selectionMenuTrailingConstraint.constant = 0
            themeColor = UIColor(red: 0.98, green: 0.97, blue: 0.96, alpha: 1.00)
        }
        
        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        if showPlaceTableOnLeft {
            selectionMenuTrailingConstraint.constant = SideMenuController.preferences.basic.menuWidth - view.frame.width
        }
        
        view.backgroundColor = themeColor
        //        tableView.backgroundColor = themeColor
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let sideMenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sideMenuBasicConfiguration.position == .under) != (sideMenuBasicConfiguration.direction == .right)
        if showPlaceTableOnLeft {
            selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0 // Crash here
        }
        view.layoutIfNeeded()
    }
    
    @IBAction func onProfileClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        sideMenuController?.hideMenu()
    }
    
}

extension MenuViewController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }
    
    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }
    
    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will hide")
    }
    
    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did hide.")
    }
    
    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will reveal.")
    }
    
    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did reveal.")
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // swiftlint:disable force_cast
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SelectionCell
        cell.contentView.backgroundColor = themeColor
        let row = indexPath.row
        cell.imageRightIcon.image = UIImage(named: "ChevronRight")!
        cell.imageRightIcon.isHidden = true
        //        if row == 0 {
        //            cell.titleLabel?.text = "dashboard".localized
        //            cell.imageIcon.image = UIImage(named: "Dashboard")!
        //        } else if row == 1 {
        //            cell.titleLabel?.text = "shakha_name".localized
        //            cell.imageIcon.image = UIImage(named: "Shakha")!
        //        } else if row == 2 {
        //            cell.titleLabel?.text = "scan_QRCode".localized
        //            cell.imageIcon.image = UIImage(named: "Shakha")!
        //        } else if row == 3 {
        //            cell.titleLabel?.text = "khel_app".localized
        //            cell.imageIcon.image = UIImage(named: "Khel_icon")!
        //            cell.imageIcon.layer.cornerRadius = 5.0
        //            cell.imageIcon.layer.masksToBounds = true
        //        } else if row == 4 {
        //            cell.titleLabel?.text = "change_password".localized
        //            cell.imageIcon.image = UIImage(named: "lock")!
        //        } else if row == 5 {
        //            cell.titleLabel?.text = "change_biometric".localized
        //            cell.imageIcon.image = UIImage(named: "fingerprint")!
        //        } else if row == 6 {
        //            cell.titleLabel?.text = "policies_name".localized
        //            cell.imageIcon.image = UIImage(named: "Policies")!
        //        } else if row == 7 {
        //            cell.titleLabel?.text = "logout_name".localized
        //            cell.imageIcon.image = UIImage(named: "logout")!
        //        }
        
        if row == 0 {
            cell.titleLabel?.text = "khel_app".localized
            cell.imageIcon.image = UIImage(named: "Khel_icon")!
            cell.imageIcon.layer.cornerRadius = 5.0
            cell.imageIcon.layer.masksToBounds = true
        } else if row == 1 {
            cell.titleLabel?.text = "change_password".localized
            cell.imageIcon.image = UIImage(named: "lock")!
        } else if row == 2 {
            cell.titleLabel?.text = "change_biometric".localized
            cell.imageIcon.image = UIImage(named: "fingerprint")!
        } else if row == 3 {
            cell.titleLabel?.text = "policies_name".localized
            cell.imageIcon.image = UIImage(named: "Policies")!
        } else if row == 4 {
            cell.titleLabel?.text = "logout_name".localized
            cell.imageIcon.image = UIImage(named: "logout")!
        }
        
        cell.titleLabel?.textColor = isDarkModeEnabled ? .white : .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        //        if row == 0 {
        //            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //            if ((sideMenuController?.contentViewController as? UINavigationController)?.topViewController?.nibName) != vc.nibName {
        //                (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        //            }
        //        } else if row == 1 {
        //            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "MyShakhaVC") as! MyShakhaVC
        //            vc.strNavigation = "my_shakha".localized
        //            if ((sideMenuController?.contentViewController as? UINavigationController)?.topViewController?.nibName) != vc.nibName {
        //                (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        //            }
        //        } else if row == 2 {
        //            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "MyShakhaVC") as! MyShakhaVC
        //            vc.strNavigation = "my_shakha".localized
        //            if ((sideMenuController?.contentViewController as? UINavigationController)?.topViewController?.nibName) != vc.nibName {
        //                (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        //            }
        //        } else if row == 3 {
        //            guard let url = URL(string: "Khel://") else {
        //                return
        //            }
        //            if UIApplication.shared.canOpenURL(url) {
        //                // khel app is installed. Launch khel app and start navigation
        //                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //            } else {
        //                // khel App is not installed. Launch AppStore to install Khel app
        //                let vc = SKStoreProductViewController()
        //                vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: APP.appleID)], completionBlock: nil)
        //                present(vc, animated: true)
        //            }
        //        } else if row == 4 {
        //            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        //            if ((sideMenuController?.contentViewController as? UINavigationController)?.topViewController?.nibName) != vc.nibName {
        //                (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        //            }
        //        } else if row == 5 {
        //            self.biometricEnableOrNot()
        //        } else if row == 6 {
        //            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "PoliciesVC") as! PoliciesVC
        //            if ((sideMenuController?.contentViewController as? UINavigationController)?.topViewController?.nibName) != vc.nibName {
        //                (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
        //            }
        //
        //        } else if row == 7 {
        //            let refreshAlert = UIAlertController(title: APP.title, message: "logout_message".localized, preferredStyle: UIAlertController.Style.alert)
        //
        //            refreshAlert.addAction(UIAlertAction(title: "logout_name".localized, style: .default, handler: { (action: UIAlertAction!) in
        //                print("Handle Logout logic here")
        //                window?.switchToLoginScreen()
        //                _userDefault.delete(key: kDeviceToken)
        //                self.firebaseAnalytics(_eventName: "LogoutVC")
        //            }))
        //
        //            refreshAlert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
        //                print("Handle Cancel Logic here")
        //            }))
        //
        //            present(refreshAlert, animated: true, completion: nil)
        //
        //
        //        }
        if row == 0 {
            guard let url = URL(string: "Khel://") else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                // khel app is installed. Launch khel app and start navigation
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // khel App is not installed. Launch AppStore to install Khel app
                let vc = SKStoreProductViewController()
                vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: NSNumber(value: APP.appleID)], completionBlock: nil)
                present(vc, animated: true)
            }
        } else if row == 1 {
            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            if ((sideMenuController?.contentViewController as? UINavigationController)?.topViewController?.nibName) != vc.nibName
            {
                (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
            }
        } else if row == 2 {
            self.biometricEnableOrNot()
        } else if row == 3 {
            
            
            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "PoliciesVC") as! PoliciesVC
            if ((sideMenuController?.contentViewController as? UINavigationController)?.topViewController?.nibName) != vc.nibName {
                (sideMenuController?.contentViewController as? UINavigationController)?.pushViewController(vc, animated: true)
            }
            
            //                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //                    let vc = storyBoard.instantiateViewController(withIdentifier: "PoliciesVC") as! PoliciesVC
            ////                    vc.strHeader = "isFromWelcome"
            //                    self.navigationController?.pushViewController(vc, animated: true)
            
        } else if row == 4 {
            let refreshAlert = UIAlertController(title: APP.title, message: "logout_message".localized, preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "logout_name".localized, style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Logout logic here")
                window?.switchToLoginScreen()
                _userDefault.delete(key: kDeviceToken)
                _userDefault.delete(key: kUserInfo)
                self.firebaseAnalytics(_eventName: "LogoutVC")
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
            
        }
        
        
        sideMenuController?.hideMenu()
        //        if let identifier = sideMenuController?.currentCacheIdentifier() {
        //            print("[Example] View Controller Cache Identifier: \(identifier)")
        //        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var size : CGFloat = 60.0
        if _appDelegator.dicMemberProfile != nil {
            if let strShakhaTab = _appDelegator.dicMemberProfile![0]["shakha_tab"] as? String {
                if indexPath.row == 1 {
                    strShakhaTab == "no" ? (size = 0) : (size = 60)
                } else if indexPath.row == 2 {
                    strShakhaTab == "no" ? (size = 0) : (size = 60)
                }
            }
        }
        return size
    }
    
    func biometricEnableOrNot() {
        let alert = UIAlertController(title: APP.title, message: "Do you want to allow \(APP.title) to use TouchId or FaceId", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Allow", style: .default, handler: { action in
            _userDefault.save(object: true, key: APP.isBiometric)
            self.authUserWithFaceIDTouchIDOrPasscode()
        })
        alert.addAction(ok)
        let cancel = UIAlertAction(title: "Don't Allow", style: .default, handler: { action in
            _userDefault.save(object: false, key: APP.isBiometric)
        })
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
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
                } else {
                    print("Error \(evaluationError!)")
                    if let errorObj = evaluationError {
                        let messageToDisplay = self.getErrorDescription(errorCode: errorObj._code)
                        print(messageToDisplay)
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

class SelectionCell: UITableViewCell {
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageRightIcon: UIImageView!
}

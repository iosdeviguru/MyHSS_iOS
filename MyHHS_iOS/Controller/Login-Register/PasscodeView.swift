//
//  PasscodeView.swift
//  MyHHS_iOS
//
//  Created by IOS-Dev iGuru on 08/08/23.
//

import Foundation
import UIKit
import PinCodeInputView
import LocalAuthentication
import SideMenuSwift

class PasscodeView: UIViewController {

    // customize item view (password)
    // customize item view (password)
    let pinCodeInputView: PinCodeInputView<PasswordItemView> = .init(
        digit: 4,
        itemSpacing: 24,
        itemFactory: {
            return PasswordItemView()
    })

    private let titleLabel = UILabel()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblPasscode: UILabel!
    @IBOutlet weak var lblWelcomeMessage: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userName = ""
    var firstAttemptCreds = ""
    let cellId = "cellId"
    let backId = "backId"
    let numbers = ["1","2","3","4","5","6","7","8","9","Logout","0",""]
    var firstEntry = false
    var isFromLogin = false
    var isFromHome = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.addSubview(titleLabel)
        view.addSubview(pinCodeInputView)
        self.navigationBarDesignForPasscode()
        self.imgView.image = UIImage(named: "MyHSS_round")
        self.imgView.cornerRadius = 47
        if self.isFromHome == false {
            self.lblWelcomeMessage.text = self.firstAttemptCreds.count > 0 ? "Verify Passcode" : "Enter Passcode"
        } else {
            self.lblWelcomeMessage.text = "Enter Passcode"
        }
        
        //self.view.backgroundColor = UIColor(red: 248, green: 248, blue: 248, alpha: 0)

        // Calculate the y-coordinate for the pinCodeInputView
        let pinCodeY = lblWelcomeMessage.frame.origin.y + lblWelcomeMessage.frame.size.height

        // Set the frame for pinCodeInputView
        pinCodeInputView.frame = CGRect(x: 0, y: pinCodeY, width: 300, height: 50)
        pinCodeInputView.center.x = view.center.x
        pinCodeInputView.set(changeTextHandler: { text in
            print("data in inputview")
            print(text)
            
            if text.count == 4 {
                if self.isFromHome == true {
                    if _userDefault.get(key: "user_passcode") as! String == text {
                        self.goToHome()
                    } else {
                        let alert = UIAlertController(title: "MyHSS", message: "Pincode is wrong", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)
                    }
                } else {
                    if self.firstAttemptCreds.count > 0 {
                        if self.firstAttemptCreds == text {
                            //self.goToHome()
                            _userDefault.save(object: self.firstAttemptCreds, key: "user_passcode")
                            let alert = UIAlertController(title: APP.title, message: "Do you want to allow \(APP.title) to use TouchId or FaceId", preferredStyle: .alert)
                            
                            let ok = UIAlertAction(title: "Allow", style: .default, handler: { action in
                                _userDefault.save(object: true, key: APP.isBiometric)
                                self.authUserWithFaceIDTouchIDOrPasscode()
                            })
                            alert.addAction(ok)
                            let cancel = UIAlertAction(title: "Don't Allow", style: .default, handler: { action in
                                _userDefault.save(object: false, key: APP.isBiometric)
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let controller = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                                controller.isFromPassCodeTrue = true
                                controller.loadData = true
                                let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigation") as! MenuViewController
                                let navigationController  = UINavigationController(rootViewController: controller)
                                navigationController.navigationBar.isHidden = true
                                let slideMenuController = SideMenuController(contentViewController: navigationController, menuViewController: leftViewController)
                                window?.rootViewController = slideMenuController
                                window?.makeKeyAndVisible()
//                                if #available(iOS 13.0, *) {
//                                    if let scene = self.view.window?.windowScene?.delegate as? SceneDelegate{
//                                        //scene.window?.switchToWelcomScreen()
//                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                                        let controller = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
//                                        controller.isFromPassCodeTrue = true
//                                        controller.loadData = true
//                                        let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigation") as! MenuViewController
//                                        let navigationController  = UINavigationController(rootViewController: controller)
//                                        navigationController.navigationBar.isHidden = true
//                                        let slideMenuController = SideMenuController(contentViewController: navigationController, menuViewController: leftViewController)
//                                        window?.rootViewController = slideMenuController
//                                        window?.makeKeyAndVisible()
//                                    }
//                                } else {
//                                    // Fallback on earlier versions
//                                    print("Need to handle for below iOS 13")
//                                }
                            })
                            alert.addAction(cancel)
                            DispatchQueue.main.async(execute: {
                                self.present(alert, animated: true)
                            })
                        } else {
                            let alert = UIAlertController(title: "MyHSS", message: "Pincode not matched", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default))
                            self.present(alert, animated: true)
                        }
                    } else {
                        let passcodeVC = self.storyboard?.instantiateViewController(withIdentifier: "PasscodeView") as! PasscodeView
                        passcodeVC.userName = self.userName
                        passcodeVC.firstAttemptCreds = text
                        self.navigationController?.pushViewController(passcodeVC, animated: true)
                    }
                }

                                
            }
            
        })
        pinCodeInputView.set(
            appearance: .init(
                itemSize: CGSize(width: 30, height: 30),
                font: .systemFont(ofSize: 28, weight: .bold),
                textColor: UIColor(red: 24/255, green: 63/255, blue: 96/255, alpha: 1.0),
                backgroundColor: UIColor(red: 24/255, green: 63/255, blue: 96/255, alpha: 1.0),
                cursorColor: UIColor(red: 69/255, green: 108/255, blue: 1, alpha: 1),
                cornerRadius: 8
            )
        )
        // Create and configure the label
        let messageLabel = UILabel()
        if isFromHome == true {
            messageLabel.text = "Last logged in as \(userName)"
        } else {
            messageLabel.text = "Welcome \(userName)"
        }
        
        messageLabel.textColor = UIColor(red: 24/255, green: 63/255, blue: 96/255, alpha: 1.0) // Set your desired custom text color
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        messageLabel.textAlignment = .center

        // Calculate the y-coordinate for the messageLabel
        let messageLabelY = pinCodeInputView.frame.origin.y + pinCodeInputView.frame.size.height

        // Set the frame for messageLabel
        messageLabel.frame = CGRect(x: 0, y: messageLabelY, width: view.frame.size.width, height: 25)
        
        //let axisForCollectionView = messageLabel.frame.origin.y + messageLabel.frame.size.height + 10

        // Add the label to the parent view
        view.addSubview(messageLabel)
        self.setupCollectionViewConstraints(messageLabel: messageLabel)
        
    }
    
    func goToHome(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        controller.isFromPassCodeTrue = true
        controller.loadData = true
        let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigation") as! MenuViewController
        let navigationController  = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        let slideMenuController = SideMenuController(contentViewController: navigationController, menuViewController: leftViewController)
        window?.rootViewController = slideMenuController
        window?.makeKeyAndVisible()
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
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                        controller.isFromPassCodeTrue = true
                        controller.loadData = true
                        let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigation") as! MenuViewController
                        let navigationController  = UINavigationController(rootViewController: controller)
                        navigationController.navigationBar.isHidden = true
                        let slideMenuController = SideMenuController(contentViewController: navigationController, menuViewController: leftViewController)
                        window?.rootViewController = slideMenuController
                        window?.makeKeyAndVisible()
                        /*if #available(iOS 13.0, *) {
                            if let scene = self.view.window?.windowScene?.delegate as? SceneDelegate{
                                scene.window?.switchToWelcomScreen()
                            }
                        } else {
                            // Fallback on earlier versions
                            print("Need to handle for below iOS 13")
                        }*/
                    })
                } else {
                    print("Error \(evaluationError!)")
                    if let errorObj = evaluationError {
                        let messageToDisplay = self.getErrorDescription(errorCode: errorObj._code)
                        print(messageToDisplay)
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
    
    func setupCollectionViewConstraints(messageLabel: UILabel) {
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30), // Adjust top constraint as needed
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20), // Adjust bottom constraint as needed
        ])
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(numberCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(BackspaceCell.self, forCellWithReuseIdentifier: backId)
        
        
    }
    
}

extension PasscodeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 9 {
            let cell: numberCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! numberCell
            print(numbers[indexPath.item])
            cell.digitLabel.textColor = UIColor(red: 24/255, green: 63/255, blue: 96/255, alpha: 1.0)
            cell.digitLabel.font = UIDevice.current.screenType == .iPhones_5_5s_5c_SE ? .systemFont(ofSize: 20) : .systemFont(ofSize: 20)
            cell.digitLabel.text = numbers[indexPath.item]
            return cell
        } else if indexPath.item == 11 {
            let cell: BackspaceCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: backId, for: indexPath) as! BackspaceCell
            print(numbers[indexPath.item])
            return cell
        } else {
            let cell: numberCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! numberCell
            cell.borderColor = UIColor(red: 24/255, green: 63/255, blue: 96/255, alpha: 1.0)
            cell.borderWidth = 1
            cell.cornerRadius = cell.frame.width / 2
            print(numbers[indexPath.item])
            cell.digitLabel.textColor = UIColor(red: 24/255, green: 63/255, blue: 96/255, alpha: 1.0)
            cell.digitLabel.text = numbers[indexPath.item]
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let leftRightPadding = self.view.frame.width * 0.14
        let interSpacing = self.view.frame.width * 0.1
        
        let cellWidth = (view.frame.size.width - 2 * leftRightPadding - 2 * interSpacing) / 3
        
        return .init(width: cellWidth , height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let leftRightPadding = self.view.frame.width * 0.14
        let interSpacing = self.view.frame.width * 0.1
        
        return .init(top: 90, left: leftRightPadding, bottom: self.collectionView.frame.height - 20, right: leftRightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 9 {
            print("logout clicked")
            let YesAction: ((UIAlertAction) -> Void) = { action in
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
            let NoAction: ((UIAlertAction) -> Void) = { action in
                self.dismiss(animated: true)
            }
            alertWithAction(title: "", message: "Are you sure you would like to logout?", actionTitles: ["Yes", "No"], actions: [YesAction, NoAction])
        } else if indexPath.item == 11 {
            print("backspace clicked")
            pinCodeInputView.deleteBackward()
        } else if indexPath.item == 10 {
            print("0 clicked")
            pinCodeInputView.insertText("0")
        } else {
            let selectedNumber = "\(indexPath.item + 1)"
            print("\(indexPath.item + 1) clicked")
            pinCodeInputView.set(text: selectedNumber)
            pinCodeInputView.insertText(selectedNumber)
        }
    }
}

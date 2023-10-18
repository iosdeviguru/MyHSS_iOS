//
//  SceneDelegate.swift
//  MyHHS_iOS
//
//  Created by baps on 24/06/2019 jun.
//

import UIKit
import SideMenuSwift
import LocalAuthentication

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if _userDefault.get(key: kDeviceToken) != nil {
            window?.switchToWelcomScreen()
        } else {
            print("Need to check")
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        let isForceUpdate = self.isKeyPresentInUserDefaults(key: APP.isForceUpdate)
        if  isForceUpdate {
            let isUpdate = Singleton.shared.get(key: APP.isForceUpdate)
            if (isUpdate as! Int == 1) {
                let alert = UIAlertController(title: APP.title, message: "New version is available. Please update new version.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Update", style: .default, handler: { action in
                    if let url = URL(string: "itms-apps://apple.com/app/id1566351540") {
                        UIApplication.shared.open(url)
                    }
                })
                alert.addAction(ok)
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
        /*let isKeyPresent = self.isKeyPresentInUserDefaults(key: APP.isBiometric)
        if  isKeyPresent {
            let isBiometric = Singleton.shared.get(key: APP.isBiometric)
            if (isBiometric as! Int == 1) {
                self.authUserWithFaceIDTouchIDOrPasscode()
            }
        }*/
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
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
                    })
                } else {
                    print("Error \(evaluationError!)")
                    if let errorObj = evaluationError {
                        let messageToDisplay = self.getErrorDescription(errorCode: errorObj._code)
                        print(messageToDisplay)
                        let alert = UIAlertController(title: "MyHSS", message: "Authentication is required for you to continue", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
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

extension UIWindow {
    
    func switchToWelcomScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigation") as! MenuViewController
        let navigationController  = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        let slideMenuController = SideMenuController(contentViewController: navigationController, menuViewController: leftViewController)
        rootViewController = slideMenuController
        makeKeyAndVisible()
    }
    
    func switchToStaticHomeScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "StaticHomeVC") as! StaticHomeVC
        let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigation") as! MenuViewController
        let navigationController  = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        let slideMenuController = SideMenuController(contentViewController: navigationController, menuViewController: leftViewController)
        rootViewController = slideMenuController
        makeKeyAndVisible()
    }
    
    func switchToHomeScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigation") as! MenuViewController
        let navigationController  = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        let slideMenuController = SideMenuController(contentViewController: navigationController, menuViewController: leftViewController)
        
        rootViewController = slideMenuController
        makeKeyAndVisible()
    }
    
    func switchToLoginScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        rootViewController = navigationController
        makeKeyAndVisible()
    }
    
}

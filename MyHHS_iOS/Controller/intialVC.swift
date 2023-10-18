//
//  intialVC.swift
//  MyHHS_iOS
//
//  Created by baps on 24/06/2019 jun.
//

import UIKit
import SideMenuSwift

class intialVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        let device = Device.baseScreenSize.rawValue.width
        
        //        self.latestUpdateAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if _userDefault.get(key: kDeviceToken) != nil {
            //self.performSegue(withIdentifier: "welcomeshow", sender: nil)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            controller.isFromPassCodeTrue = false
            controller.loadData = true
            let leftViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigation") as! MenuViewController
            let navigationController  = UINavigationController(rootViewController: controller)
            navigationController.navigationBar.isHidden = true
            let slideMenuController = SideMenuController(contentViewController: navigationController, menuViewController: leftViewController)
            window?.rootViewController = slideMenuController
            window?.makeKeyAndVisible()
        }
        else
        {
            self.performSegue(withIdentifier: "Tologin", sender: nil)
            //let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //let vc = storyBoard.instantiateViewController(withIdentifier: "StaticHomeVC") as! StaticHomeVC
            //let navigationController = UINavigationController(rootViewController: vc)
            //navigationController.navigationBar.isHidden = true
            //UIApplication.shared.windows.first?.rootViewController = navigationController
            
            //            UIApplication.shared.windows.first?.rootViewController = vc
            //            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            //            if let scene = self.view.window?.windowScene?.delegate as? SceneDelegate{
            //                scene.window?.switchToStaticHomeScreen()
            //            }
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
                                    // create the alert
                                    let alert = UIAlertController(title: APP.title, message: "New version is available. Please update to version \(storeVersion) now.", preferredStyle: UIAlertController.Style.alert)
                                    // add an action (button)
                                    let ok = UIAlertAction(title: "Update", style: .default, handler: { action in
                                    })
                                    alert.addAction(ok)
                                    // show the alert
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    let alert = UIAlertController(title: APP.title, message: "New version is available. Please update to version \(storeVersion) now.", preferredStyle: .alert)
                                    
                                    let ok = UIAlertAction(title: "Update", style: .default, handler: { action in
                                    })
                                    alert.addAction(ok)
                                    let cancel = UIAlertAction(title: "Later", style: .default, handler: { action in
                                    })
                                    alert.addAction(cancel)
                                    DispatchQueue.main.async(execute: {
                                        self.present(alert, animated: true)
                                    })
                                }
                            }
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
    
    
}

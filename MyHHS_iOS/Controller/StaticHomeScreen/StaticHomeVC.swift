//
//  StaticHomeVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 26/06/2021.
//

import UIKit

class StaticHomeVC: UIViewController {
    
    @IBOutlet weak var heightConstraintMemberApplication: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintGuruPuja: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintShakha: NSLayoutConstraint!
    
    @IBOutlet weak var imgPublications: UIImageView!
    @IBOutlet weak var imgKnowledgeBase: UIImageView!
    @IBOutlet weak var imgMemberApplication: UIImageView!
    @IBOutlet var btnLeftbarButton: UIButton!
    
    
    @IBOutlet weak var lblMemberApplicaitonHeader: UILabel!
    
    var strHeader = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        navigationBarDesign(txt_title: "dashbaord".localized, showbtn: "menu")
        //        self.navigationController?.navigationBar.isHidden = true
        //        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        self.navigationController!.navigationBar.shadowImage = UIImage()
        //        self.navigationController!.navigationBar.isTranslucent = true
        self.fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*viewMySakhaBack.clipsToBounds = true
         viewMySakhaBack.dropShadow(color: Colors.txtBlack, offSet: CGSize.init(width: 2, height: 2))
         viewMySakhaBack.layer.masksToBounds = false
         viewMySakhaBack.roundCorners(corners: [.topLeft, .topRight,.bottomLeft,.bottomRight], radius: 10)*/
        
        setNeedsStatusBarAppearanceUpdate()
        self.firebaseAnalytics(_eventName: "DashbaordVC")
        self.latestUpdateAPI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func fillData() {
        if self.strHeader == "isFromWelcome" {
            btnLeftbarButton.setImage(UIImage(named: "Backbtn"), for: .normal)
        } else {
            btnLeftbarButton.setImage(UIImage(named: "login"), for: .normal)
        }
        self.imgMemberApplication.image = UIImage(named: "up_arrow")
        self.imgKnowledgeBase.image = UIImage(named: "up_arrow")
        self.imgPublications.image = UIImage(named: "up_arrow")
    }
    
    @IBAction func onMenuClick(_ sender: UIButton) {
        //        sideMenuController?.revealMenu()
        if self.strHeader == "isFromWelcome" {
            navigationController?.popViewController(animated: true)
        } else {
            window?.switchToLoginScreen()
        }
    }
    
    @IBAction func onMemberApplication(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) { // Adjust the duration as needed
            if self.heightConstraintMemberApplication.constant == 180 {
                self.heightConstraintMemberApplication.constant = 50
                self.imgMemberApplication.image = UIImage(named: "down_aerrow")
            } else {
                self.heightConstraintMemberApplication.constant = 180
                self.imgMemberApplication.image = UIImage(named: "up_arrow")
            }
            self.view.layoutIfNeeded() // Update the layout
        }
    }
    
    @IBAction func onProfileClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "StaticInvolvedVC") as! StaticInvolvedVC
        vc.strHeader = "hindu_sevika_samiti".localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onLinkedFamilyMemberClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "StaticInvolvedVC") as! StaticInvolvedVC
        vc.strHeader = "balgoculam".localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onAddFamilyMemberClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddMemberStep1VC") as! AddMemberStep1VC
        _appDelegator.userType = "family"
        _appDelegator.isEdit = false
        self.navigationController?.pushViewController(vc, animated: true)
        //        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddMemberStep4VC") as! AddMemberStep4VC
        //        _appDelegator.userType = "family"
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onGuruPujaClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            if self.heightConstraintGuruPuja.constant == 180 {
                self.heightConstraintGuruPuja.constant = 50
                self.imgKnowledgeBase.image = UIImage(named: "down_aerrow")
            } else {
                self.heightConstraintGuruPuja.constant = 180
                self.imgKnowledgeBase.image = UIImage(named: "up_arrow")
            }
            self.view.layoutIfNeeded() // Update the layout
        }
        
    }
    
    @IBAction func onOneOffDakhshinaClick(_ sender: UIButton) {
        //        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "OneTimeGuruDakshinaVC") as! OneTimeGuruDakshinaVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "StaticInvolvedVC") as! StaticInvolvedVC
        vc.strHeader = "AMRUT_VACHAN_title".localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onRegularDakhshinaClick(_ sender: UIButton) {
        //        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "RegularGuruDakshinaStep1VC") as! RegularGuruDakshinaStep1VC
        //        self.navigationController?.pushViewController(vc, animated: true)
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "StaticInvolvedVC") as! StaticInvolvedVC
        vc.strHeader = "SUBHASHITAS_title".localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onShakhaSectionClick(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            if self.heightConstraintShakha.constant == 180 {
                self.heightConstraintShakha.constant = 50
                self.imgPublications.image = UIImage(named: "down_aerrow")
            } else {
                self.heightConstraintShakha.constant = 180
                self.imgPublications.image = UIImage(named: "up_arrow")
            }
            self.view.layoutIfNeeded() // Update the layout
        }
    }
    
    @IBAction func onMyShakhaClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "StaticBlogsVC") as! StaticBlogsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onAboutUsClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "StaticInvolvedVC") as! StaticInvolvedVC
        vc.strHeader = "ABOUT_HSS_title".localized
        self.navigationController?.pushViewController(vc, animated: true)
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
                                    })
                                    alert.addAction(cancel)
                                    DispatchQueue.main.async(execute: {
                                        self.present(alert, animated: true)
                                    })
                                }
                            }
                        }
                        
                    }else {
                        _userDefault.save(object: false, key: APP.isForceUpdate)
                        if let strError = jsonData!["message"].string {
                            showAlert(title: APP.title, message: strError)
                        }
                    }
                }
                else {
                    _userDefault.save(object: false, key: APP.isForceUpdate)
                    if let strError = jsonData!["message"].string {
                        showAlert(title: APP.title, message: strError)
                    }
                }
            }
        }
    }
    
}

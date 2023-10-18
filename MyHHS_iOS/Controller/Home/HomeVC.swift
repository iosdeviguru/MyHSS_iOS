//
//  HomeVC.swift
//  MyHHS_iOS
//
//  Created by baps on 24/06/2019 jun.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var heightConstraintMemberApplication: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintGuruPuja: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintShakha: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintEvent: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintOthers: NSLayoutConstraint!
    
    @IBOutlet weak var widthConstraintSuchanBoard: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintMyShakha: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintFindShakha: NSLayoutConstraint!
    
    @IBOutlet weak var lblMemberApplicaitonHeader: UILabel!
    
    @IBOutlet weak var lastView: UIView!
    
    @IBOutlet weak var lastSub1: UIView!
    
    @IBOutlet weak var lastSub2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //		navigationBarDesign(txt_title: "dashbaord".localized, showbtn: "menu")
        //        self.navigationController?.navigationBar.isHidden = true
        //        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        self.navigationController!.navigationBar.shadowImage = UIImage()
        //        self.navigationController!.navigationBar.isTranslucent = true
    
        self.fillData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(isShakhaTab), name: NSNotification.Name ("isShakhaTab"), object: nil)
        
        heightConstraintEvent.constant = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*viewMySakhaBack.clipsToBounds = true
         viewMySakhaBack.dropShadow(color: Colors.txtBlack, offSet: CGSize.init(width: 2, height: 2))
         viewMySakhaBack.layer.masksToBounds = false
         viewMySakhaBack.roundCorners(corners: [.topLeft, .topRight,.bottomLeft,.bottomRight], radius: 10)*/
        
        setNeedsStatusBarAppearanceUpdate()
        self.firebaseAnalytics(_eventName: "DashbaordVC")
        
   // **--->>>    // logic to implement findmyshaka visibility based on role, currently, the finmyshakha is statically hidden from mainview from storyboard, below is dynamic code to handle the visibility of the findmyshakha. Any how this code will need to be updated : instead of "kendriya", may need to add other role based or responsibility based logic
        
        lastView.alpha = 0
        lastSub1.alpha = 0
        lastSub2.alpha = 0

        if let role1 = _appDelegator.dicDataProfile?[0]["role"] as? String, role1.contains("Kendriya")
        {
            lastView.alpha = 1
            lastSub1.alpha = 1
            lastSub2.alpha = 1
        }

        else if let role3 = _appDelegator.dicDataProfile?[0]["role"] as? String, role3 == "User" {
            lastView.alpha = 0
            lastSub1.alpha = 0
            lastSub2.alpha = 0
        }

        else if let role2 = _appDelegator.dicDataProfile?[0]["role"] as? String,
                ( role2.range(of: "\\bKendriya\\b", options: .regularExpression) != nil ) {
            // Code block to be executed if the 'role' string contains "Kendriya"
            lastView.alpha = 1
            lastSub1.alpha = 1
            lastSub2.alpha = 1
        }
        else{
            lastView.alpha = 0
            lastSub1.alpha = 0
            lastSub2.alpha = 0
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK : - Remove Notification
    deinit {
        NotificationCenter.default.removeObserver("isShakhaTab")
    }
    
    @objc func isShakhaTab(_ notification: Notification){
        self.widthConstraintSuchanBoard.constant = _screenSize.width / 3
        self.widthConstraintMyShakha.constant = 0
        self.widthConstraintFindShakha.constant = _screenSize.width / 3
        if _appDelegator.dicMemberProfile != nil {
            if let strShakhaTab = _appDelegator.dicMemberProfile![0]["shakha_tab"] as? String {
                if strShakhaTab == "no"{
                    self.widthConstraintSuchanBoard.constant = _screenSize.width / 3
                    self.widthConstraintMyShakha.constant = 0
                    self.widthConstraintFindShakha.constant = _screenSize.width / 3
                } else {
                    self.widthConstraintSuchanBoard.constant = _screenSize.width / 3
                    self.widthConstraintMyShakha.constant = _screenSize.width / 3
                    self.widthConstraintFindShakha.constant = _screenSize.width / 3
                }
            }
        }
    }
    
    func fillData() {
        self.widthConstraintSuchanBoard.constant = _screenSize.width / 3
        self.widthConstraintMyShakha.constant = 0
        self.widthConstraintFindShakha.constant = _screenSize.width / 3
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            if _appDelegator.dicMemberProfile != nil {
                if let strShakhaTab = _appDelegator.dicMemberProfile![0]["shakha_tab"] as? String {
                    if strShakhaTab == "no"{
                        self.widthConstraintSuchanBoard.constant = _screenSize.width / 3
                        self.widthConstraintMyShakha.constant = 0
                        self.widthConstraintFindShakha.constant = _screenSize.width / 3
                    } else {
                        self.widthConstraintSuchanBoard.constant = _screenSize.width / 3
                        self.widthConstraintMyShakha.constant = _screenSize.width / 3
                        self.widthConstraintFindShakha.constant = _screenSize.width / 3
                    }
                }
            }
        }
    }
    
    @IBAction func onMenuClick(_ sender: UIButton) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func onMemberApplication(_ sender: UIButton) {
        heightConstraintMemberApplication.constant == 180 ? (heightConstraintMemberApplication.constant = 50) : (heightConstraintMemberApplication.constant = 180)
    }
    
    @IBAction func onRightBarButtonClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "SuchnaVC") as! SuchnaVC
        vc.strNavigation = "notification".localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onProfileClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onLinkedFamilyMemberClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "MyShakhaVC") as! MyShakhaVC
        vc.strNavigation = "Family Member"
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
        heightConstraintGuruPuja.constant == 180 ? (heightConstraintGuruPuja.constant = 50) : (heightConstraintGuruPuja.constant = 180)
        
    }
    
    @IBAction func onOneOffDakhshinaClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "OneTimeGuruDakshinaVC") as! OneTimeGuruDakshinaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onRegularDakhshinaClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "RegularGuruDakshinaStep1VC") as! RegularGuruDakshinaStep1VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onShakhaSectionClick(_ sender: UIButton) {
        heightConstraintShakha.constant == 180 ? (heightConstraintShakha.constant = 50) : (heightConstraintShakha.constant = 180)
    }
    
    @IBAction func onMyShakhaClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "MyShakhaVC") as! MyShakhaVC
        vc.strNavigation = "My Shakha"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onOthersClick(_ sender: UIButton) {
        heightConstraintOthers.constant == 180 ? (heightConstraintOthers.constant = 50) : (heightConstraintOthers.constant = 180)
    }
    
    @IBAction func onFindShakhaClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "FindShakhaVC") as! FindShakhaVC
        vc.strNavigation = "Find a Shakha"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSuchanBoardClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "SuchnaVC") as! SuchnaVC
        vc.strNavigation = "suchana_board".localized
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onEventsSectionClick(_ sender: UIButton) {
        heightConstraintEvent.constant == 180 ? (heightConstraintEvent.constant = 50) : (heightConstraintEvent.constant = 180)
    }
//    
    @IBAction func onEventsClick(_ sender: UIButton) {
//        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "Event2") as! HostingViewController
//        vc.strNavigation = "events".localized
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSuryaNamskarClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "SuryaNamskarVC") as! SuryaNamskarVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

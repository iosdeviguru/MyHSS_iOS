//
//  ProfileVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 19/03/2021.
//

import UIKit
import ScrollableSegmentedControl
import SDWebImage

class ProfileVC: UIViewController {
    
    let items = ["about_me".localized, "personal_info".localized, "contact_info".localized, "other_info".localized]
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    
    @IBOutlet weak var lblAbbreviation: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblShakhaName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var viewProfile: UIView!
    
    @IBOutlet weak var scrollViewAboutMe: UIScrollView!
    @IBOutlet weak var scrollViewPersonalInfo: UIScrollView!
    @IBOutlet weak var scrollViewContactInfo: UIScrollView!
    @IBOutlet weak var scrollViewOtherInfo: UIScrollView!
    
    
    // MARK: - About Me
    @IBOutlet weak var imgShakha_AboutMe: UIImageView!
    @IBOutlet weak var lblSakhaNameTitle_aboutMe: UILabel!
    @IBOutlet weak var lblSakhaName_aboutMe: UILabel!
    
    @IBOutlet weak var imgShakhaAddress_aboutMe: UIImageView!
    @IBOutlet weak var lblShakhaAddressTitle_aboutMe: UILabel!
    @IBOutlet weak var lblShakhaAddress_aboutMe: UILabel!
    
    @IBOutlet weak var imgShakhaOccupation_aboutMe: UIImageView!
    @IBOutlet weak var lblShakhaOccupationTitle_aboutMe: UILabel!
    @IBOutlet weak var lblShakhaOccupation_aboutMe: UILabel!
    
    @IBOutlet weak var imgShakhaSpokenLanguage_aboutMe: UIImageView!
    @IBOutlet weak var lblShakhaSpokenLanguageTitle_aboutMe: UILabel!
    @IBOutlet weak var lblShakhaSpokenLanguage_aboutMe: UILabel!
    
    // MARK: - Personal Info
    @IBOutlet weak var lblRoleTitle_PersonalInfo: UILabel!
    @IBOutlet weak var lblRole_PersonalInfo: UILabel!
    
    @IBOutlet weak var lblFirstNameTitle_PersonalInfo: UILabel!
    @IBOutlet weak var lblFirstName_PersonalInfo: UILabel!
    
    @IBOutlet weak var lblMiddleNameTitle_PersonalInfo: UILabel!
    @IBOutlet weak var lblMiddleName_PersonalInfo: UILabel!
    
    @IBOutlet weak var lblSurNameTitle_PersonalInfo: UILabel!
    @IBOutlet weak var lblSurName_PersonalInfo: UILabel!
    
    @IBOutlet weak var lblEmailTitle_personalInfo: UILabel!
    @IBOutlet weak var lblEmail_personalInfo: UILabel!
    
    @IBOutlet weak var lblDOBTitle_personalInfo: UILabel!
    @IBOutlet weak var lblDOB_personalInfo: UILabel!
    
    @IBOutlet weak var lblShakhaTitle_personalInfo: UILabel!
    @IBOutlet weak var lblShakha_personalInfo: UILabel!
    
    @IBOutlet weak var lblNagarTitle_personalInfo: UILabel!
    @IBOutlet weak var lblNagar_personalInfo: UILabel!
    
    @IBOutlet weak var lblVibhagTitle_personalInfo: UILabel!
    @IBOutlet weak var lblVibhag_personalInfo: UILabel!
    
    // MARK: - Contact Info
    @IBOutlet weak var lblMobileNoTitle: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    
    @IBOutlet weak var lblSecondaryContactNoTitle: UILabel!
    @IBOutlet weak var lblSecondaryContactNo: UILabel!
    
    @IBOutlet weak var lblEmergencyGuardianInfoTitle: UILabel!
    
    @IBOutlet weak var lblNameTitle_ContactInfo: UILabel!
    @IBOutlet weak var lblName_ContactInfo: UILabel!
    
    @IBOutlet weak var lblPhoneTitle_ContactInfo: UILabel!
    @IBOutlet weak var lblPhone_ContactInfo: UILabel!
    
    @IBOutlet weak var lblEmailTitle_ContactInfo: UILabel!
    @IBOutlet weak var lblEmail_ContactInfo: UILabel!
    
    @IBOutlet weak var lblRelationshipTitle_ContactInfo: UILabel!
    @IBOutlet weak var lblRelationship_ContactInfo: UILabel!
    
    // MARK: - Other Info
    @IBOutlet weak var lblMedicalInfoTitle: UILabel!
    @IBOutlet weak var lblMedicalInfoValue: UILabel!
    @IBOutlet weak var btnMedicalInfo: UIButton!
    
    @IBOutlet weak var lblQualifiedFirstAidTitle: UILabel!
    @IBOutlet weak var lblQualifiedFirstAidValue: UILabel!
    @IBOutlet weak var btnQualifiedFirstAid: UIButton!
    @IBOutlet var heightConstraintButtonQFitstAid: NSLayoutConstraint!
    @IBOutlet var imgQualifiedFirstAid: UIImageView!
    
    @IBOutlet weak var lblDBSCertificateNumberTitle: UILabel!
    @IBOutlet weak var lblDBSCertificateNumber: UILabel!
    @IBOutlet weak var btnDBSCertificateNumber: UIButton!
    
    @IBOutlet weak var lblDBSCertificateDateTitle: UILabel!
    @IBOutlet weak var lblDBSCertificateDate: UILabel!
    @IBOutlet weak var btnDBSCertificateDate: UIButton!
    
    @IBOutlet weak var lblSafeguardingTrainingTitle: UILabel!
    @IBOutlet weak var lblSafeguardingTrainingValue: UILabel!
    @IBOutlet weak var btnSafeguardingTraining: UIButton!
    
    
    var dicData: [[String : Any]]?
    var dicMember: [[String : Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getScrollableSegmentedControl()
        
        self.dicData = _appDelegator.dicDataProfile
        self.dicMember = _appDelegator.dicMemberProfile
        //        self.getProfileAPI()
        self.fillData()
        self.scrollViewAboutMe.isHidden = false
        self.scrollViewPersonalInfo.isHidden = true
        self.scrollViewContactInfo.isHidden = true
        self.scrollViewOtherInfo.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "Profile".localized, showbtn: "back")
        self.firebaseAnalytics(_eventName: "ProfileVC_AboutMeView")
    }
    
    func fillData() {
        /*
         // Shadow Color and Radius
         viewProfile.clipsToBounds = true
         viewProfile.dropShadow(color: Colors.txtBlack, offSet: CGSize.init(width: 2, height: 2))
         viewProfile.layer.masksToBounds = false
         viewProfile.roundCorners(corners: [.topLeft, .topRight,.bottomLeft,.bottomRight], radius: 10)
         */
        
        let dicDataModel = _appDelegator.ProfileDataModel
        let dicMemberModel = _appDelegator.ProfileMemberModel
        
        self.lblAbbreviation.text = dicDataModel?.profile_word
        self.lblName.text = dicDataModel?.username
        self.lblShakhaName.text = dicDataModel?.role
        if dicMemberModel?.member_age != nil {
            self.lblAge.text = (dicMemberModel?.member_age)! + " Years"
        } else {
            self.lblAge.text = ""
        }
        self.lblGender.text = dicMemberModel?.gender
        
        // MARK: - About Me FillData
        self.lblSakhaName_aboutMe.text = dicMemberModel?.shakha
        self.lblShakhaAddress_aboutMe.text = "\(dicMemberModel?.building_name ?? ""), \(dicMemberModel?.address_line_1 ?? ""), \(dicMemberModel?.address_line_2 ?? ""), \(dicMemberModel?.postal_code ?? ""), \(dicMemberModel?.country ?? "")"
        self.lblShakhaOccupation_aboutMe.text = dicMemberModel?.occupation
        self.lblShakhaSpokenLanguage_aboutMe.text = dicMemberModel?.root_language
        
        // MARK: - Personal Info FillData
        self.lblRole_PersonalInfo.text          = dicDataModel?.role
        self.lblFirstName_PersonalInfo.text     = dicDataModel?.first_name
        self.lblMiddleName_PersonalInfo.text    = dicDataModel?.middle_name
        self.lblSurName_PersonalInfo.text       = dicDataModel?.last_name
        self.lblEmail_personalInfo.text         = dicDataModel?.email
        self.lblDOB_personalInfo.text           = dicMemberModel?.dob
        self.lblShakha_personalInfo.text        = dicMemberModel?.shakha
        self.lblNagar_personalInfo.text         = dicMemberModel?.nagar
        self.lblVibhag_personalInfo.text        = dicMemberModel?.vibhag
        
        // MARK: - Contact Info FillData
        self.lblMobileNo.text                   = dicMemberModel?.mobile
        self.lblSecondaryContactNo.text         = dicMemberModel?.land_line
        self.lblName_ContactInfo.text           = dicMemberModel?.emergency_name
        self.lblPhone_ContactInfo.text          = dicMemberModel?.emergency_phone
        self.lblEmail_ContactInfo.text          = dicMemberModel?.emergency_email
        self.lblRelationship_ContactInfo.text   = dicMemberModel?.emergency_relatioship

        
        // MARK: - Other Info FillData
        dicMemberModel?.medical_information_declare == "0" ? (self.lblMedicalInfoValue.text = "No") : (self.lblMedicalInfoValue.text = dicMemberModel?.medical_details)
        
        if dicMemberModel?.is_qualified_in_first_aid == "0" {
            self.lblQualifiedFirstAidValue.text = "No"
            self.btnQualifiedFirstAid.isHidden = true
        } else {
            self.lblQualifiedFirstAidValue.text = dicMemberModel?.date_of_first_aid_qualification
            let strURL : String = (_appDelegator.ProfileMemberModel?.first_aid_qualification_file)!
            strURL == "" ? (self.btnQualifiedFirstAid.isHidden = true) : (self.btnQualifiedFirstAid.isHidden = false)

            if strURL != "" {
                let filename: NSString = strURL as NSString
                let pathExtention = filename.pathExtension
                let pathPrefix = filename.deletingPathExtension
                
                if pathExtention == "pdf" {
                    self.btnQualifiedFirstAid.backgroundColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
                    self.btnQualifiedFirstAid.setTitle("Download Certificate", for: .normal)
                    self.heightConstraintButtonQFitstAid.constant = 30.0
                } else {
                    self.btnQualifiedFirstAid.setTitle("", for: .normal)
                    let strURL : String = (_appDelegator.ProfileMemberModel?.first_aid_qualification_file)!
                    // Check if the given string is an URL and an image
                    if strURL.isURL() {
                        self.btnQualifiedFirstAid.backgroundColor = UIColor.clear
                        self.imgQualifiedFirstAid.imageFromURL("\(BaseURL_download)\(strURL)", placeHolder:#imageLiteral(resourceName: "MyHSS_round"))
                    }
                    self.heightConstraintButtonQFitstAid.constant = 150.0
                }
            }
        }
        
        //        if let strDBSCertificateNumber = self.dicMember![0]["dbs_certificate_number"] as? String {
        //            self.lblDBSCertificateNumber.text = strDBSCertificateNumber
        //        }
        //        if let strDBSCertificateDate = self.dicMember![0]["dbs_certificate_date"] as? String {
        //            self.lblDBSCertificateDate.text = strDBSCertificateDate
        //        }
        //        if let strSafeguardingTraining = self.dicMember![0]["safeguarding_training_complete"] as? String {
        //            self.lblSafeguardingTrainingValue.text = strSafeguardingTraining
        //        }
    }
    
    func getScrollableSegmentedControl() {
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: items[0], image: nil, at: 0)
        segmentedControl.insertSegment(withTitle: items[1], image: nil, at: 1)
        segmentedControl.insertSegment(withTitle: items[2], image: nil, at: 2)
        segmentedControl.insertSegment(withTitle: items[3], image: nil, at: 3)
        
        segmentedControl.underlineSelected = true
        segmentedControl.selectedSegmentIndex = 0
        // Turn off all segments been fixed/equal width.
        // The width of each segment would be based on the text length and font size.
        segmentedControl.fixedSegmentWidth = false
        
        segmentedControl.addTarget(self, action: #selector(ProfileVC.segmentSelected(sender:)), for: .valueChanged)
        
        // change some colors
        segmentedControl.segmentContentColor = UIColor.black
        segmentedControl.selectedSegmentContentColor = UIColor.black
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = Colors.txtAppDarkColor
        
        let largerRedTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Colors.txtdarkGray]
        let largerRedTextHighlightAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Colors.txtAppDarkColor]
        let largerRedTextSelectAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Colors.txtAppDarkColor]
        segmentedControl.setTitleTextAttributes(largerRedTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(largerRedTextHighlightAttributes, for: .highlighted)
        segmentedControl.setTitleTextAttributes(largerRedTextSelectAttributes, for: .selected)
    }
    
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        switch sender.selectedSegmentIndex {
        case 0:
            self.scrollViewAboutMe.isHidden = false
            self.scrollViewPersonalInfo.isHidden = true
            self.scrollViewContactInfo.isHidden = true
            self.scrollViewOtherInfo.isHidden = true
            self.firebaseAnalytics(_eventName: "ProfileVC_AboutMeView")
            
        case 1:
            self.scrollViewAboutMe.isHidden = true
            self.scrollViewPersonalInfo.isHidden = false
            self.scrollViewContactInfo.isHidden = true
            self.scrollViewOtherInfo.isHidden = true
            self.firebaseAnalytics(_eventName: "ProfileVC_PersonalInfoView")
        case 2:
            self.scrollViewAboutMe.isHidden = true
            self.scrollViewPersonalInfo.isHidden = true
            self.scrollViewContactInfo.isHidden = false
            self.scrollViewOtherInfo.isHidden = true
            self.firebaseAnalytics(_eventName: "ProfileVC_ContactInfoView")
        case 3:
            self.scrollViewAboutMe.isHidden = true
            self.scrollViewPersonalInfo.isHidden = true
            self.scrollViewContactInfo.isHidden = true
            self.scrollViewOtherInfo.isHidden = false
            self.firebaseAnalytics(_eventName: "ProfileVC_OtherInfoView")
        default:
            self.scrollViewAboutMe.isHidden = false
            self.scrollViewPersonalInfo.isHidden = true
            self.scrollViewContactInfo.isHidden = true
            self.scrollViewOtherInfo.isHidden = true
            self.firebaseAnalytics(_eventName: "ProfileVC_AboutMeView")
        }
        
    }
    
    // MARK: - Button Actions
    @IBAction func onEditClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddMemberStep1VC") as! AddMemberStep1VC
        _appDelegator.userType = "self"
        _appDelegator.isEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - About Me Actions
    
    @IBAction func onSakha_AboutMe_click(_ sender: UIButton) {
    }
    
    @IBAction func onShakhaAddress_AboutMe_click(_ sender: UIButton) {
    }
    
    @IBAction func onShakhaOccupation_aboutMe_click(_ sender: UIButton) {
    }
    
    @IBAction func onShakhaSpokenLanguage_aboutMe(_ sender: UIButton) {
    }
    
    // MARK: - Personal Info
    @IBAction func onRole_personalInfo_Click(_ sender: UIButton) {
    }
    
    @IBAction func onFirstName_personalInfo_click(_ sender: UIButton) {
    }
    
    @IBAction func onMiddleName_PersonalInfo_click(_ sender: UIButton) {
    }
    
    @IBAction func onSurName_PersonalInfo_click(_ sender: UIButton) {
    }
    
    @IBAction func onEmail_personalInfo_click(_ sender: UIButton) {
    }
    
    @IBAction func onDOB_personalInfo_click(_ sender: UIButton) {
    }
    
    @IBAction func onShakha_personalInfo_click(_ sender: UIButton) {
    }
    
    @IBAction func onVibhag_personalInfo_click(_ sender: UIButton) {
    }
    
    
    // MARK: - Contact Info
    @IBAction func onMobileNoClick(_ sender: UIButton) {
    }
    
    @IBAction func onSecondaryContactNoClick(_ sender: UIButton) {
    }
    
    @IBAction func onName_ContactInfo_Click(_ sender: UIButton) {
    }
    
    @IBAction func onPhone_ContactInfo_Click(_ sender: UIButton) {
    }
    
    @IBAction func onEmail_ContactInfo_Click(_ sender: UIButton) {
    }
    
    @IBAction func onRelationship_ContactInfo_Click(_ sender: UIButton) {
    }
    
    
    // MARK: - Other Info
    @IBAction func onMedicalInfo(_ sender: UIButton) {
    }
    
    @IBAction func onQualifiedFirstAidClick(_ sender: UIButton) {
        
        let strURL : String = (_appDelegator.ProfileMemberModel?.first_aid_qualification_file)!
        
        // Check if the given string is an URL and an image
        if strURL.isURL() {
            self.downloadImage(url: (BaseURL_download + strURL))
        }
    }
    
    @IBAction func onDBSCertificateNumberClick(_ sender: UIButton) {
    }
    
    @IBAction func onDBSCertificateDateClick(_ sender: UIButton) {
    }
    
    @IBAction func onSafeguardingTrainingClick(_ sender: UIButton) {
    }
    
    // MARK: - downloadImage
    func downloadImage(url: String) {
        guard let imageUrl = URL(string: url) else { return }
        getDataFromUrl(url: imageUrl) { data, _, _ in
            DispatchQueue.main.async() {
                let activityViewController = UIActivityViewController(activityItems: [data ?? ""], applicationActivities: nil)
                activityViewController.modalPresentationStyle = .fullScreen
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    
    // MARK: - API Functions
    
    func getProfileAPI() {
        var dicUserDetails : [String:Any] = [:]
        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = dicUserDetails["user_id"]
        parameters["member_id"] = _appDelegator.memberId // dicUserDetails["member_id"]
        if _userDefault.get(key: kDeviceToken) != nil {
            parameters["device_token"] = _userDefault.get(key: kDeviceToken) as! String
        } else {
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
                        self.dicData = dicResponse!["data"] as? [[String : Any]]
                        self.dicMember = dicResponse!["member"] as? [[String : Any]]
                        self.fillData()
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

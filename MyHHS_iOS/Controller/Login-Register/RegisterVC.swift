//
//  RegisterVC.swift
//  MyHHS_iOS
//
//  Created by baps on 24/06/2019 jun.
//

import UIKit
import UIKit
import SkyFloatingLabelTextField
import RAGTextField
import Alamofire
import NVActivityIndicatorView
import SSSpinnerButton
import SwiftyJSON

class RegisterVC: UIViewController {
    var isfromLogin : String!
    
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var txtname: RAGTextField!
    @IBOutlet var txtSname: RAGTextField!
    @IBOutlet var txtunm: RAGTextField!
    @IBOutlet var txtemail: RAGTextField!
    
    @IBOutlet var txtPwd: RAGTextField!
    @IBOutlet var txtCPwd: RAGTextField!
    @IBOutlet var lblHead: UILabel!
    
    @IBOutlet var btnCheckMark: UIButton!
    @IBOutlet var btnRigister: SSSpinnerButton!
    
    @IBOutlet var lblUnmHint: UILabel!
    @IBOutlet var lblPwdHint: UILabel!
    @IBOutlet var lblAgree: UILabel!
    @IBOutlet var lblAlreadyAcc: UILabel!
    
    @IBOutlet weak var viewSucessBack: UIView!
    @IBOutlet weak var viewSucess: UIView!
    @IBOutlet weak var lblSucess: UILabel!
    @IBOutlet var btnOkSucess: UIButton!
    @IBOutlet var lblSucessMsg: UILabel!
    
    let text = "register_agree_text".localized
    
    var checkbool : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewSucessBack.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        lblHead.text = "Register_New_Membership".localized
        lblAgree.text = "register_agree_text".localized
        
        //Please check email to verify account.
        //		let text = "register_agree_text".localized
        //		let attributedString = NSMutableAttributedString.init(string: text)
        // 		let str = NSString(string: text)
        //		let theRange = str.range(of: "PrivacyPolicy".localized)
        //		let theRange2 = str.range(of: "MyHSSTermsConditions".localized)
        //		attributedString.addAttribute(.link, value: URL(string:PrivacyWebUrl)!, range: theRange)
        //
        //		attributedString.addAttribute(.link, value:  URL(string:TermsConditionsWebUrl)!, range: theRange2)
        //		lblAgree.attributedText = attributedString
        
        let fontText : UIFont = UIFont(name: "SourceSansPro-Regular", size: 18.0)!
        lblAgree.text = text
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "PrivacyPolicy".localized)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: fontText, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.txtAppDarkColor, range: range1)
        let range2 = (text as NSString).range(of: "MyHSSTermsConditions".localized)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: fontText, range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.txtAppDarkColor, range: range2)
        lblAgree.attributedText = underlineAttriString
        lblAgree.isUserInteractionEnabled = true
        lblAgree.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        lblAgree.isUserInteractionEnabled = true
        
        //Login Attributed string
        let text2 = "already_user".localized
        let attributedString2 = NSMutableAttributedString.init(string: text2)
        let str2 = NSString(string: text2)
        let theRange3 = str2.range(of: "Login")
        attributedString2.addAttribute(.foregroundColor, value: Colors.txtAppDarkColor, range: theRange3)
        lblAlreadyAcc.attributedText = attributedString2
        
        
        //lblAlreadyAcc.text = "already_user".localized
        checkbool = false
        lblUnmHint.text = "U_name_hint_text".localized
        lblPwdHint.text = "PWD_hint_text".localized
        txtname = createTextField(txtPlaceholder: "first_name".localized, txtfield: txtname, Img: "fullname")
        txtSname = createTextField(txtPlaceholder: "surname".localized, txtfield: txtSname, Img: "fullname")
        txtunm = createTextField(txtPlaceholder: "username".localized, txtfield: txtunm, Img: "user_img")
        
        
        txtemail = createTextField(txtPlaceholder: "email_address".localized, txtfield: txtemail, Img: "email_img")
        txtPwd = createTextField(txtPlaceholder: "password".localized, txtfield: txtPwd, Img: "lock_dark")
        txtCPwd = createTextField(txtPlaceholder: "confirm_password".localized, txtfield: txtCPwd, Img: "lock_dark")
        
        btnRigister.layer.cornerRadius = 8
        
        imgLogo.layer.borderWidth = 4
        imgLogo.layer.borderColor = UIColor.white.cgColor
        imgLogo.layer.cornerRadius = imgLogo.frame.size.height/2
        
        btnCheckMark.setBackgroundImage(UIImage.init(named: "uncheck"), for: UIControl.State.normal)
        
        btnOkSucess.layer.cornerRadius = 8
        viewSucess.roundCorners(corners: [.topLeft, .topRight], radius: 24)
        viewSucess.backgroundColor = .white
        
        self.firebaseAnalytics(_eventName: "RegisterVC")
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let privacyRange = (text as NSString).range(of: "PrivacyPolicy".localized)
        // comment for now
        let termsRange = (text as NSString).range(of: "MyHSSTermsConditions".localized)
        
        if gesture.didTapAttributedTextInLabel(label: lblAgree, inRange: privacyRange) {
            print("Tapped privacy")
            guard let url = URL(string: PrivacyWebUrl) else { return }
            UIApplication.shared.open(url)
        } else if gesture.didTapAttributedTextInLabel(label: lblAgree, inRange: termsRange) {
            print("Tapped terms")
            guard let url = URL(string: TermsConditionsWebUrl) else { return }
            UIApplication.shared.open(url)
        } else {
            print("Tapped none")
//            guard let url = URL(string: PrivacyWebUrl) else { return }
//            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func CloseSucess(_ sender: Any) {
        viewSucessBack.isHidden = true
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnOkSucess_click(_ sender: Any) {
        viewSucessBack.isHidden = true
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnCheckClick(_ sender: Any) {
        if(checkbool == false){
            checkbool = true
            btnCheckMark.setBackgroundImage(UIImage.init(named: "check_img"), for: UIControl.State.normal)
        }else{
            checkbool = false
            btnCheckMark.setBackgroundImage(UIImage.init(named: "uncheck"), for: UIControl.State.normal)
        }
    }
    @IBAction func RegisterClick(_ sender: Any) {
        
        if (checkRegistrationValidation() == true) {
            btnRigister.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: {
                // Your code here
                self.Register()
            })
        }
    }
    
    func checkRegistrationValidation() -> Bool {
        
        if(txtname.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_full_name".localized)
            return false
        } else if(txtSname.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_surname".localized)
            return false
        } else if(txtunm.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_username".localized)
            return false
        } else if txtemail.text == "" {
            showAlert(title: APP.title, message: "Please Enter Email")
            return false
        } else if txtPwd.text == "" {
            showAlert(title: APP.title, message: "Please enter password")
            return false
        } else if txtCPwd.text == "" {
            showAlert(title: APP.title, message: "error_Please_enter_confirm_password".localized)
            return false
        } else if isValidPassword(txtPwd.text!) == false {
            showAlert(title: APP.title, message: "Password must have 8 or more characters with a mix of letters with upper and lower combination, numbers &amp; symbols.")
            return false
        } else if isValidEmail(txtemail.text!) == false {
            showAlert(title: APP.title, message: "error_Please_enter_valid_email".localized)
            return false
        } else if txtPwd.text != txtCPwd.text {
            showAlert(title: APP.title, message: "error_password_confirm_password_not_match".localized)
            return false
        } else if checkbool == false {
            showAlert(title: APP.title, message: "error_Please_agree_terms_condition".localized)
            return false
        }
        
        return true
    }
    
    func Register() {
        // End editing to dismiss the keyboard
        view.endEditing(true)
        
        var parameters: [String: Any] = [
            "username": txtunm.text ?? "",
            "first_name": txtname.text ?? "",
            "last_name": txtSname.text ?? "",
            "email": txtemail.text ?? "",
            "password": txtPwd.text ?? "",
            "device": "I",
            "device_token": "dndsjbfskfnksnfdsnfdsn"
        ]
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.register, parameters: parameters) { (jsonData, error) in
            if error == nil {
                if let status = jsonData?["status"].int {
                    if status == 1 {
                        // Registration successful
                        self.handleSuccessfulRegistration()
                    } else {
                        self.handleRegistrationFailure(jsonData: jsonData)
                    }
                }
            }
        }
    }

    func handleSuccessfulRegistration() {
        btnRigister.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: {
            // Show the success message view
            self.viewSucessBack.isHidden = false
            
            // Customize the success message
            let email = self.txtemail.text!
            let text = "Please check your email \(email) to verify your account."
            
            // Apply color to the email address
            let attributedString = NSMutableAttributedString(string: text)
            if #available(iOS 13.0, *) {
                attributedString.addAttribute(.foregroundColor, value: Colors.txtAppDarkColor, range: (text as NSString).range(of: email))
            } else {
                attributedString.addAttribute(.foregroundColor, value: UIColor(red: 61/255, green: 91/255, blue: 155/255, alpha: 1.0), range: (text as NSString).range(of: email))
            }
            self.lblSucessMsg.attributedText = attributedString
        })
    }

    func handleRegistrationFailure(jsonData: JSON?) {
        btnRigister.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
            // Handle the registration failure
            if let strError = jsonData!["error"]["username"].string {
                showAlert(title: APP.title, message: strError)
            } else if let strError = jsonData?["message"].string {
                showAlert(title: APP.title, message: strError)
            }
        })
    }

    @IBAction func LoginClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

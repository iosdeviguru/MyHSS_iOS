//
//  OneTimeGuruDakshinaStep2VC.swift
//  MyHHS_iOS
//
//  Created by Patel on 31/03/2021.
//

import UIKit

class OneTimeGuruDakshinaStep2VC: UIViewController {

    var strAmount = ""
    var strDakshina = ""
    var strIndividual_family = ""
    var strGiftAid = "yes"
    
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var lblAmountTitile: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAmount: UIButton!
    
    @IBOutlet weak var lblDakshinaTitle: UILabel!
    @IBOutlet weak var lblDakshinaYes: UILabel!
    @IBOutlet weak var imgDakshinaYes: UIImageView!
    @IBOutlet weak var btnDakshinaYes: UIButton!
    
    @IBOutlet weak var lblDakshinaNo: UILabel!
    @IBOutlet weak var imgDakshinaNo: UIImageView!
    @IBOutlet weak var btnDakshinaNo: UIButton!
    
    @IBOutlet weak var lblDonatingAsFamilyTitle: UILabel!
    @IBOutlet weak var lblDonatingAsFamilyIndividual: UILabel!
    @IBOutlet weak var imgDonatingAsFamilyIndividual: UIImageView!
    @IBOutlet weak var btnDonatingAsFamilyIndividual: UIButton!
    
    @IBOutlet weak var lblDonatingAsFamily_family: UILabel!
    @IBOutlet weak var imgDonatingAsFamily_family: UIImageView!
    @IBOutlet weak var btnDonatingAsFamily_family: UIButton!
    
    @IBOutlet weak var lblGiftAidTitle: UILabel!
    @IBOutlet weak var lblGiftAid: UILabel!
    @IBOutlet weak var btnGiftAid: UIButton!
    
    @IBOutlet weak var viewGiftAidInfo: UIView!
    @IBOutlet weak var lblGiftAidInfo: UILabel!
    @IBOutlet weak var btnOKGiftAidInfo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "one_time_dakshina".localized, showbtn: "")
        self.viewAmount.layer.cornerRadius = self.viewAmount.frame.height / 2
        
        self.lblAmount.text = "£ \(self.strAmount)"
        self.viewGiftAidInfo.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.firebaseAnalytics(_eventName: "OneTimeDakshinaStep2VC")
    }
    
    func fillData() {

//        if let strName = _appDelegator.dicDataProfile![0]["username"] as? String {
//            self.txtName.text = strName
//        }
//        if let strSakhaName = _appDelegator.dicMemberProfile![0]["shakha"] as? String {
//            self.txtShakha.text = strSakhaName
//        }
        
    }
        
    @IBAction func onEditAmountClick(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: APP.title, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "amount".localized
            textField.keyboardType = .numberPad
        }
        let saveAction = UIAlertAction(title: "save".localized, style: UIAlertAction.Style.default, handler: { alert -> Void in
            let amountTextField = alertController.textFields![0] as UITextField
            if let intAmount = Int(amountTextField.text!) {
                if intAmount <= 0 {
                    showAlert(title: APP.title, message: "error_Please_enter_valid_amount".localized)
                    return
                }
            }
            self.strAmount = amountTextField.text!
            self.lblAmount.text = "£ \(self.strAmount)"
        })
        let cancelAction = UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func onDakshinaYesClick(_ sender: UIButton) {
        self.imgDakshinaYes.image = UIImage(named:"rightTikmark")
        self.imgDakshinaNo.image = nil
        
        strDakshina = "1"
        
        self.btnDakshinaYes.borderWidth = 1.0
        self.btnDakshinaYes.borderColor = Colors.txtAppDarkColor
        self.lblDakshinaYes.textColor = Colors.txtAppDarkColor

        self.btnDakshinaNo.borderWidth = 1.0
        self.btnDakshinaNo.borderColor = Colors.txtdarkGray
        self.lblDakshinaNo.textColor = Colors.txtdarkGray
    }
    
    @IBAction func onDakshinaNoClick(_ sender: UIButton) {
        self.imgDakshinaYes.image = nil
        self.imgDakshinaNo.image = UIImage(named:"rightTikmark")
        
        strDakshina = "0"
              
        self.btnDakshinaNo.borderWidth = 1.0
        self.btnDakshinaNo.borderColor = Colors.txtAppDarkColor
        self.lblDakshinaNo.textColor = Colors.txtAppDarkColor
        
        self.btnDakshinaYes.borderWidth = 1.0
        self.btnDakshinaYes.borderColor = Colors.txtdarkGray
        self.lblDakshinaYes.textColor = Colors.txtdarkGray
    }
    
    @IBAction func onDonatingAsFamilyIndividualClick(_ sender: UIButton) {
        self.onIndividualClick()
    }
    
    func onIndividualClick() {
        self.imgDonatingAsFamilyIndividual.image = UIImage(named:"rightTikmark")
        self.imgDonatingAsFamily_family.image = nil
        
        strIndividual_family = "individual".localized
        
        self.btnDonatingAsFamilyIndividual.borderWidth = 1.0
        self.btnDonatingAsFamilyIndividual.borderColor = Colors.txtAppDarkColor
        self.lblDonatingAsFamilyIndividual.textColor = Colors.txtAppDarkColor
        
        self.btnDonatingAsFamily_family.borderWidth = 1.0
        self.btnDonatingAsFamily_family.borderColor = Colors.txtdarkGray
        self.lblDonatingAsFamily_family.textColor = Colors.txtdarkGray
    }
    
    @IBAction func onDonatingAsFamily_familyClick(_ sender: UIButton) {
        self.getFamilyMember()
    }
    
    func onFamilyClick(){
        self.imgDonatingAsFamilyIndividual.image = nil
        self.imgDonatingAsFamily_family.image = UIImage(named:"rightTikmark")
        
        strIndividual_family = "family".localized
              
        self.btnDonatingAsFamily_family.borderWidth = 1.0
        self.btnDonatingAsFamily_family.borderColor = Colors.txtAppDarkColor
        self.lblDonatingAsFamily_family.textColor = Colors.txtAppDarkColor
        
        self.btnDonatingAsFamilyIndividual.borderWidth = 1.0
        self.btnDonatingAsFamilyIndividual.borderColor = Colors.txtdarkGray
        self.lblDonatingAsFamilyIndividual.textColor = Colors.txtdarkGray
    }
    
    @IBAction func onInfoYellowClick(_ sender: UIButton) {
        self.viewGiftAidInfo.isHidden = false
    }
    
    @IBAction func onOKGiftAidInfoClick(_ sender: UIButton) {
        self.viewGiftAidInfo.isHidden = true
    }
    
    
    @IBAction func onGiftAidClick(_ sender: UIButton) {
        lblGiftAid.text == "donate_as_gift_tax_payer_message".localized ? (lblGiftAid.text! = "donate_as_gift_occasion_message".localized) : (lblGiftAid.text! = "donate_as_gift_tax_payer_message".localized)
        
        lblGiftAid.text != "donate_as_gift_tax_payer_message".localized ? (self.strGiftAid = "no") : (self.strGiftAid = "yes")
        
    }
    
    @IBAction func onPrevClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "AddMemberStep1", sender: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNextClick(_ sender: Any) {
        if (checkOneTimeGuruDakshinaStep2Validation() == true) {
            self.step2()
        }
//        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep4VC") as! AddMemberStep4VC
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkOneTimeGuruDakshinaStep2Validation() -> Bool {
        
//        if(txtName.text == ""){
//            showAlert(title: APP.title, message: "error_Please_enter_name_text".localized)
//            return false
//        } else if(txtShakha.text == "") {
//            showAlert(title: APP.title, message: "error_Please_enter_shakha_name".localized)
//            return false
//        } else if(txtAmount.text == "") {
//            showAlert(title: APP.title, message: "error_Please_enter_amount".localized)
//            return false
//        }
        return true
    }
    
    
    func step2() {

        _appDelegator.dicOnteTimeGuruDakshina["amount"]           = self.strAmount
        _appDelegator.dicOnteTimeGuruDakshina["is_purnima_dakshina"] = self.strDakshina
        _appDelegator.dicOnteTimeGuruDakshina["is_linked_member"] = self.strIndividual_family
        _appDelegator.dicOnteTimeGuruDakshina["gift_aid"] = self.strGiftAid
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OneTimeGuruDakshinaStep3VC") as! OneTimeGuruDakshinaStep3VC
        vc.strAmount = self.strAmount
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getFamilyMember() {
        
        var parameters: [String: Any] = [:]
        parameters["user_id"]       = _appDelegator.dicMemberProfile![0]["user_id"] as? String
        parameters["member_id"]     = _appDelegator.dicDataProfile![0]["member_id"] as? String
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.family_members, parameters: parameters) { [self] (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        // Your code here
                        let arr = jsonData!["data"]
                        print(jsonData!)
//                        let arrayData = arr.object as? [[String : Any]] ?? []
                        var arrayData = [[String:Any]]()
                        for index in 0..<arr.count {
                            var dict = [String : Any]()

                            let strFirstName : String = arr[index]["first_name"].string!
                            let strMiddleName : String = arr[index]["middle_name"].string!
                            let strLastName : String = arr[index]["last_name"].string!
                            
                            strMiddleName == "" ? (dict["name"] = "\(strFirstName) \(strLastName)") : (dict["name"] = "\(strFirstName) \(strMiddleName) \(strLastName)")
                            arrayData.append(dict)
                        }
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListingTableViewController") as! ListingTableViewController
                        vc.strNavigationTitle = "family_member".localized
                        vc.arrayData = arrayData
//                        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                //        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        self.present(vc, animated: true, completion: nil)
                                                
                        self.onFamilyClick()
                    }else {
                        // Your code here
                        if let strError = jsonData!["message"].string {
                            showAlert(title: APP.title, message: strError)
                        }
                        self.onIndividualClick()
                    }
                }
                else {
                    // Your code here
                    if let strError = jsonData!["message"].string {
                        showAlert(title: APP.title, message: strError)
                    }
                    self.onIndividualClick()
                }
            }
        }
    }
    
}

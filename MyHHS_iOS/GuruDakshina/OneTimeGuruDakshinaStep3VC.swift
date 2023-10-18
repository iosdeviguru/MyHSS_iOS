//
//  OneTimeGuruDakshinaStep3VC.swift
//  MyHHS_iOS
//
//  Created by Patel on 01/04/2021.
//

import UIKit
import RAGTextField

class OneTimeGuruDakshinaStep3VC: UIViewController {

    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var lblAmountTitile: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAmount: UIButton!

    @IBOutlet weak var lblBillingInfoTitle: UILabel!

    @IBOutlet weak var txtAddress: RAGTextField!
    @IBOutlet weak var txtCity: RAGTextField!
    @IBOutlet weak var txtCountry: RAGTextField!
    @IBOutlet weak var txtPostCode: RAGTextField!
    
    
    @IBOutlet weak var lblPrev: UILabel!
    @IBOutlet weak var lblNext: UILabel!
    
    var strAmount = ""
    var strIndividualFamily = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "one_time_dakshina".localized, showbtn: "")
        self.viewAmount.layer.cornerRadius = self.viewAmount.frame.height / 2
        
        self.lblAmount.text = "£ \(self.strAmount)"
        self.fillData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.firebaseAnalytics(_eventName: "OneTimeDakshinaStep3VC")
    }
    
    func fillData() {

        if let strAddress = _appDelegator.dicMemberProfile![0]["building_name"] as? String {
            self.txtAddress.text = "\(strAddress), \(_appDelegator.dicMemberProfile![0]["address_line_1"]!), \(_appDelegator.dicMemberProfile![0]["address_line_2"]!)"
        }
        if let strCity = _appDelegator.dicMemberProfile![0]["city"] as? String {
            self.txtCity.text = strCity
        }
        if let strCountry = _appDelegator.dicDataProfile![0]["country"] as? String {
            strCountry == "<null>" ? (self.txtCountry.text = "United kingdom") : (self.txtCountry.text = strCountry)
        } else {
            self.txtCountry.text = "United kingdom"
        }
        if let strPostCode = _appDelegator.dicMemberProfile![0]["postal_code"] as? String {
            self.txtPostCode.text = strPostCode
        }
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
    
    @IBAction func onPrevClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "AddMemberStep1", sender: nil)
        navigationController?.popViewController(animated: true)
    }


    @IBAction func onNextClick(_ sender: Any) {
        if (checkOneTimeGuruDakshinaStep3Validation() == true) {
            self.step3()
        }
//
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep4VC") as! AddMemberStep4VC
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkOneTimeGuruDakshinaStep3Validation() -> Bool {
        
        if(txtAddress.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_address".localized)
            return false
        } else if(txtCity.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_city".localized)
            return false
        } else if(txtCountry.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_Country".localized)
            return false
        } else if(txtPostCode.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_postcode".localized)
            return false
        }
        return true
    }
    
    
    func step3() {
        
        _appDelegator.dicOnteTimeGuruDakshina["line1"]           = txtAddress.text
        _appDelegator.dicOnteTimeGuruDakshina["city"]            = txtCity.text
        _appDelegator.dicOnteTimeGuruDakshina["country"]         = txtCountry.text
        _appDelegator.dicOnteTimeGuruDakshina["postal_code"]     = txtPostCode.text
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OneTimeGuruDakshinaStep4VC") as! OneTimeGuruDakshinaStep4VC
        vc.strAmount = self.strAmount
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

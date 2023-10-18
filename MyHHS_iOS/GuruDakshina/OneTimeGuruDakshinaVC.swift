//
//  OneTimeGuruDakshinaVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 31/03/2021.
//

import UIKit
import RAGTextField

class OneTimeGuruDakshinaVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtName: RAGTextField!
    @IBOutlet weak var txtShakha: RAGTextField!
    
    @IBOutlet weak var lblHowmuchTitle: UILabel!
    @IBOutlet weak var lblPoundSymbol: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _appDelegator.dicOnteTimeGuruDakshina.removeAll()
        self.fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "one_time_dakshina".localized, showbtn: "back")
        self.firebaseAnalytics(_eventName: "OneTimeDakshinaStep1VC")
    }
    
    func fillData() {

        if let strName = _appDelegator.dicDataProfile![0]["username"] as? String {
            self.txtName.text = strName
        }
        if let strSakhaName = _appDelegator.dicMemberProfile![0]["shakha"] as? String {
            self.txtShakha.text = strSakhaName
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblPoundSymbol.textColor = Colors.txtBlack
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text?.count == 0 {
            self.lblPoundSymbol.textColor = Colors.txtdarkGray
        }
    }
    

    
    @IBAction func onNextClick(_ sender: Any) {
        if (checkOneTimeGuruDakshinaStep1Validation() == true) {
            self.step1()
        }
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep2VC") as! AddMemberStep2VC
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkOneTimeGuruDakshinaStep1Validation() -> Bool {
        
        if(txtName.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_name_text".localized)
            return false
        } else if(txtShakha.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_shakha_name".localized)
            return false
        } else if(txtAmount.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_amount".localized)
            return false
        }
        
        if let intAmount = Int(txtAmount.text!) {
            if intAmount <= 0 {
                showAlert(title: APP.title, message: "error_Please_enter_valid_amount".localized)
                return false
            }
        }
        return true
    }
    
    
    func step1() {

        _appDelegator.dicOnteTimeGuruDakshina["amount"] = self.txtAmount.text!        
        
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "OneTimeGuruDakshinaStep2VC") as! OneTimeGuruDakshinaStep2VC
        vc.strAmount = self.txtAmount.text!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
}

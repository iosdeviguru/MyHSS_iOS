//
//  RegularGuruDakshinaStep1VC.swift
//  MyHHS_iOS
//
//  Created by Patel on 05/04/2021.
//

import UIKit
import RAGTextField

class RegularGuruDakshinaStep1VC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: RAGTextField!
    @IBOutlet weak var txtShakha: RAGTextField!
    
    @IBOutlet weak var lblHowmuchTitle: UILabel!
    @IBOutlet weak var lblPoundSymbol: UILabel!
    @IBOutlet weak var txtAmount: UITextField!

    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationBarDesign(txt_title: "regular_dakshina".localized, showbtn: "back")
        
//        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "infoyellow"), style: .plain, target: self, action: #selector(rightBarButton))
//        self.navigationItem.rightBarButtonItem  = rightBarButtonItem
        
        _appDelegator.dicOnteTimeGuruDakshina.removeAll()
        self.viewInfo.isHidden = true
        self.fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarWithRightButtonDesign(txt_title: "regular_dakshina".localized, showbtn: "back", rightImg: "infoyellow", bagdeVal: "", isBadgeHidden: true)

        self.firebaseAnalytics(_eventName: "RegularGuruDakshinaStep1VC")
    }
    
    override func rightBarItemClicked(_ sender: UIButton) {
        self.viewInfo.isHidden = false
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
    
    @IBAction func onOKInfoClick(_ sender: UIButton) {
        self.viewInfo.isHidden = true
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
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RegularGuruDakshinaStep2VC") as! RegularGuruDakshinaStep2VC
        vc.strAmount = self.txtAmount.text!
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

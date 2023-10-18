//
//  PaidEventsStep4.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/03/2023.
//

import UIKit
import RAGTextField
import ATGValidator
import MonthYearPicker
import SSSpinnerButton

class PaidEventsStep4: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var lblAmountTitile: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAmount: UIButton!

    @IBOutlet weak var lblPaymentMethodTitle: UILabel!
    
    @IBOutlet weak var txtCardNumber: RAGTextField!
    @IBOutlet weak var imgCardNumber: UIImageView!
    
    @IBOutlet weak var txtExprirationDate: RAGTextField!
    @IBOutlet weak var imgExprirationDate: UIImageView!
    
    @IBOutlet weak var txtCVV: RAGTextField!
    @IBOutlet weak var imgCVV: UIImageView!
    
    @IBOutlet weak var txtCardHolderName: RAGTextField!
    @IBOutlet weak var imgCardholderName: UIImageView!

    @IBOutlet weak var btnDonate: SSSpinnerButton!
    @IBOutlet weak var lblDonet: UILabel!
    
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var lblPrev: UILabel!

    
    var strAmount = ""
    var strIndividualFamily = ""
    var strEncryptedCardNumber = ""
    var strEncryptedCVV = ""
    
    var viewPicker : UIView!
    var datePicker = MonthYearPickerView()
    
    var picker = MonthYearPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "one_time_dakshina".localized, showbtn: "")
        self.viewAmount.layer.cornerRadius = self.viewAmount.frame.height / 2
        
        self.lblAmount.text = "£ \(self.strAmount)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.firebaseAnalytics(_eventName: "OneTimeDakshinaStep4VC")
    }

    func fillData() {

//        if let strName = _appDelegator.dicDataProfile![0]["username"] as? String {
//            self.txtName.text = strName
//        }
//        if let strSakhaName = _appDelegator.dicMemberProfile![0]["shakha"] as? String {
//            self.txtShakha.text = strSakhaName
//        }
    }
    
    // MARK: - DatePicker functions
    func showMonthYearPicker(){
        viewPicker = UIView(frame: CGRect(x: 0.0, y: self.view.frame.height - 300, width: self.view.frame.width, height: 300))
        viewPicker.backgroundColor = UIColor.white
        viewPicker.clipsToBounds = true
        // Posiiton date picket within a view
        datePicker = MonthYearPickerView(frame: CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200))
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        
        datePicker.backgroundColor = UIColor.white
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(OneTimeGuruDakshinaStep4VC.dateChanged(_:)), for: .valueChanged)
        datePicker.center.x = self.view.center.x

        //ToolBar
        var toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 50))
        let doneButton = UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel".localized, style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        txtExprirationDate.inputAccessoryView = toolbar
        txtExprirationDate.inputView = datePicker
                
        self.viewPicker.addSubview(toolbar)
        
        self.viewPicker.addSubview(datePicker)

        self.view.addSubview(self.viewPicker)
        
    }
    
    @objc func dateChanged(_ sender: MonthYearPickerView){
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "MM/yyyy"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
//        print("Selected value \(selectedDate)")
    }
    
    @objc func donedatePicker(){

     let formatter = DateFormatter()
     formatter.dateFormat = "MM/yyyy"
        txtExprirationDate.text = formatter.string(from: datePicker.date)
        imgExprirationDate.image = UIImage(named: "right_green")
        self.viewPicker.isHidden = true
   }

   @objc func cancelDatePicker(){
        self.viewPicker.isHidden = true
    }
    
    // MARK: - TextField delegate methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if txtCardNumber == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            (count == 16 || count == 17) ? (imgCardNumber.image = UIImage(named: "right_green")) : (imgCardNumber.image = UIImage(named: "right_gray"))
            return count <= 16
        }
        
        if txtCardNumber == textField {
            // Line 1
            txtCardNumber.validationRules = [
                PaymentCardRule(acceptedTypes: [.visa, .mastercard, .maestro, .amex, .dinersClub, .discover])
            ]
            // Line 2
            txtCardNumber.validateOnInputChange(true)
            // Line 3
            txtCardNumber.validationHandler = { [self] result in
                if self.txtCardNumber.text?.isEmpty ?? true {
                    self.imgCardNumber.image = UIImage(named: "right_gray")//nil
                } else {
                    result.status == .success ? (imgCardNumber.image = UIImage(named: "right_green")) : (imgCardNumber.image = UIImage(named: "right_gray"))
                }
            }
        } else if txtCVV == textField {
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            (count == 3 || count == 4) ? (imgCVV.image = UIImage(named: "right_green")) : (imgCVV.image = UIImage(named: "right_gray"))
            return count <= 3
        } else if txtCardHolderName == textField {
            self.txtCardHolderName.text?.isEmpty == true ? (self.imgCardholderName.image = UIImage(named: "right_gray")) : (self.imgCardholderName.image = UIImage(named: "right_green"))
        }
        return true
    }
    
    // MARK: - Encription Function
    
    func cardNumberEncryption(cardNumber : String) -> String {
        
        //  4 leter random + 4 letter card number + 3 leter random + rest card number + 5 leter random
        
        let first4random = Int.random(in: 1000..<9999)
        
        let indexFirst4 = cardNumber.index(cardNumber.startIndex, offsetBy: 4)
        let first4CardNumber = cardNumber[..<indexFirst4]
        
        let middle3random = Int.random(in: 100..<999)
        
        let indexCardNumber4toAll = cardNumber.index(cardNumber.endIndex, offsetBy: 0)
        let cardNumber4toAll = cardNumber[indexFirst4..<indexCardNumber4toAll]
        
        let last5random = Int.random(in: 10000..<99999)
        
        return "\(first4random)\(first4CardNumber)\(middle3random)\(cardNumber4toAll)\(last5random)"
    }
    
    func cardCVVEncryption(cardCVV : String) -> String {
        
        //  2 leter random + cvv + 1 leter random
        
        let first2random = Int.random(in: 10..<99)
        
        let last1random = Int.random(in: 0..<9)
        
        return "\(first2random)\(cardCVV)\(last1random)"
    }
    
    // MARK: - Button Action
    @IBAction func onEditAmountClick(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: APP.title, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Amount"
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
    
    @IBAction func onExpirationClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.showMonthYearPicker()
    }
    
    @IBAction func onPrevClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "AddMemberStep1", sender: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNextClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "AddMemberStep1", sender: nil)
        navigationController?.popViewController(animated: true)
    }


    @IBAction func onDonetClick(_ sender: Any) {
        if (checkOneTimeGuruDakshinaStep4Validation() == true) {
            self.step4()
        }
//
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep4VC") as! AddMemberStep4VC
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkOneTimeGuruDakshinaStep4Validation() -> Bool {
        
        if(txtCardNumber.text == ""){
            showAlert(title: APP.title, message: "error_Please_enter_card_number".localized)
            return false
        } else if(txtExprirationDate.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_expriration_date".localized)
            return false
        } else if(txtCVV.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_cvv".localized)
            return false
        } else if(txtCardHolderName.text == "") {
            showAlert(title: APP.title, message: "error_Please_enter_cardholder_name".localized)
            return false
        }
        
        self.strEncryptedCardNumber = self.cardNumberEncryption(cardNumber: txtCardNumber.text!)
        self.strEncryptedCVV = self.cardCVVEncryption(cardCVV: txtCVV.text!)
        
        return true
    }
    
    
    func step4() {
        btnDonate.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: {
            // Your code here
            self.getGuruDakshinaCreateOnetimeAPI()
        })
    }

    
    func getGuruDakshinaCreateOnetimeAPI() {
        if let intAmount = Int(self.strAmount) {
            if intAmount <= 0 {
                showAlert(title: APP.title, message: "error_Please_enter_valid_amount".localized)
                return
            }
        }
        
//        var dicUserDetails : [String:Any] = [:]
//        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"]       = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["member_id"]     = _appDelegator.dicDataProfile![0]["member_id"] as? String
        parameters["amount"]        = self.strAmount
        parameters["is_linked_member"]     = _appDelegator.dicOnteTimeGuruDakshina["is_linked_member"]
        parameters["gift_aid"]      = _appDelegator.dicOnteTimeGuruDakshina["gift_aid"]
        parameters["is_purnima_dakshina"]  = _appDelegator.dicOnteTimeGuruDakshina["is_purnima_dakshina"]
        parameters["line1"]         = _appDelegator.dicOnteTimeGuruDakshina["line1"]
        parameters["city"]          = _appDelegator.dicOnteTimeGuruDakshina["city"]
        parameters["country"]       = _appDelegator.dicOnteTimeGuruDakshina["country"]
        parameters["postal_code"]   = _appDelegator.dicOnteTimeGuruDakshina["postal_code"]
        parameters["dakshina"]      = "One-Time"
        parameters["card_number"]   = self.strEncryptedCardNumber
        parameters["name"]          = self.txtCardHolderName.text!
        parameters["card_expiry"]   = self.txtExprirationDate.text!
        parameters["card_cvv"]      = self.strEncryptedCVV
        
        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.create_onetime, parameters: parameters) { [self] (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.btnDonate.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: {
                            // Your code here
                            let arr = jsonData!["data"]
                            print(jsonData!)
                            _appDelegator.dicOnteTimeGuruDakshina["order_id"] = arr[0]["order_id"].string
                            _appDelegator.dicOnteTimeGuruDakshina["paid_amount"] = arr[0]["order_id"].string
                            _appDelegator.dicOnteTimeGuruDakshina["gift_aid_text"] = arr[0]["gift_aid"].string
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "OneTimeGuruDakshinaSuccessVC") as! OneTimeGuruDakshinaSuccessVC
                            vc.strAmount = self.strAmount
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                    }else {
                        self.btnDonate.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                            // Your code here
                            if let strError = jsonData!["message"].string {
                                showAlert(title: APP.title, message: strError)
                            }
                        })
                    }
                }
                else {
                    self.btnDonate.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                        // Your code here
                        if let strError = jsonData!["message"].string {
                            showAlert(title: APP.title, message: strError)
                        }
                    })
                }
            }
        }
    }

}




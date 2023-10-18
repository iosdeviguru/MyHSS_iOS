//
//  RegularGuruDakshinaStep2VC.swift
//  MyHHS_iOS
//
//  Created by Patel on 05/04/2021.
//

import UIKit

class RegularGuruDakshinaStep2VC: UIViewController {

    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var lblAmountTitile: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnAmount: UIButton!
    
    @IBOutlet weak var lblPaymentStartDateTitle: UILabel!
    @IBOutlet weak var txtPaymentStartDate: UITextField!
    
    @IBOutlet weak var lblWouldYouLikeToDonateTitle: UILabel!
    @IBOutlet weak var lblWouldYouLikeToDonate: UILabel!
    
    
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
    
    var viewPicker : UIView!
    let datePicker = UIDatePicker()
    
    var strAmount = ""
    var strPaymentDate = ""
    var strIndividual_family = ""
    var strGiftAid = "yes"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewAmount.layer.cornerRadius = self.viewAmount.frame.height / 2
        
        self.lblAmount.text = "£ \(self.strAmount)"
        self.viewGiftAidInfo.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "regular_dakshina".localized, showbtn: "")
        self.firebaseAnalytics(_eventName: "RegularGuruDakshinaStep2VC")
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
    func showDatePicker(){
        
        viewPicker = UIView(frame: CGRect(x: 0.0, y: self.view.frame.height - 300, width: self.view.frame.width, height: 300))
        viewPicker.backgroundColor = UIColor.white
        viewPicker.clipsToBounds = true
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        
        datePicker.backgroundColor = UIColor.white
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(AddMemberStep1VC.datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.center.x = self.view.center.x
                
        //ToolBar
        var toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 50))
        let doneButton = UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "cancel".localized, style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        txtPaymentStartDate.inputAccessoryView = toolbar
        txtPaymentStartDate.inputView = datePicker
                
        self.viewPicker.addSubview(toolbar)
        
        self.viewPicker.addSubview(datePicker)

        self.view.addSubview(self.viewPicker)
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "dd/MM/yyyy"
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
//        print("Selected value \(selectedDate)")
    }
    
    @objc func donedatePicker(){

     let formatter = DateFormatter()
     formatter.dateFormat = "dd/MM/yyyy"
     txtPaymentStartDate.text = formatter.string(from: datePicker.date)
     strPaymentDate = formatter.string(from: datePicker.date)
        self.viewPicker.isHidden = true
   }

   @objc func cancelDatePicker(){
        self.viewPicker.isHidden = true
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
    
    @IBAction func onPaymentStartDateClick(_ sender: UIButton) {
        self.showDatePicker()
    }
    
    @IBAction func onWouldYouLikeToDonateClick(_ sender: UIButton) {
                
        var datasource = [[String:Any]]()
        var dict = [String : Any]()
        dict["id"] = "1"
        dict["name"] = "monthly".localized
        datasource.append(dict)
        dict["id"] = "1"
        dict["name"] = "Quarterly".localized
        datasource.append(dict)
        dict["id"] = "1"
        dict["name"] = "Annually".localized
        datasource.append(dict)
        

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        
        vc.strNavigationTitle = ""
        
        vc.selectedItemCompletion = {dict in
            self.lblWouldYouLikeToDonate.text = dict["name"] as? String
            print(dict["name"] as! String)
        }
        vc.dataSource = datasource
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
        //        self.delegate?.getYourSilectedIndex()
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
        if (checkRegularGuruDakshinaStep2Validation() == true) {
            self.step2()
        }

//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep4VC") as! AddMemberStep4VC
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    func checkRegularGuruDakshinaStep2Validation() -> Bool {
        
        if(strPaymentDate == ""){
            showAlert(title: APP.title, message: "error_Please_enter_payment_date".localized)
            return false
        } else if(strGiftAid == "") {
            showAlert(title: APP.title, message: "error_Please_enter_donating_individual_family".localized)
            return false
        }
        return true
    }
    
    
    func step2() {

        _appDelegator.dicOnteTimeGuruDakshina["amount"]           = self.strAmount
        _appDelegator.dicOnteTimeGuruDakshina["start_date"] = self.txtPaymentStartDate.text
        _appDelegator.dicOnteTimeGuruDakshina["recurring"] = self.lblWouldYouLikeToDonate.text
        _appDelegator.dicOnteTimeGuruDakshina["is_linked_member"] = self.strIndividual_family
        _appDelegator.dicOnteTimeGuruDakshina["gift_aid"] = self.strGiftAid
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RegularGuruDakshinaStep3VC") as! RegularGuruDakshinaStep3VC
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

//
//  EventsStep3.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/03/2023.
//


import UIKit
import RAGTextField
import ATGValidator
import TagListView
import MobileCoreServices
import UniformTypeIdentifiers
import Alamofire
import Photos
import SSSpinnerButton
import Foundation


class EventsStep3: UIViewController, UIScrollViewDelegate, TagListViewDelegate, UIActionSheetDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var heightConstraintMedicalInformation: NSLayoutConstraint!
    @IBOutlet weak var lblOtherInfoTitle: UILabel!
    @IBOutlet weak var lblMedicalInformationTitle: UILabel!
    @IBOutlet weak var lblMedicalInformationYes: UILabel!
    @IBOutlet weak var imgMedicalInformationYesTick: UIImageView!
    @IBOutlet weak var btnMedicalInformationYes: UIButton!
    
    @IBOutlet weak var lblMedicalInformationNo: UILabel!
    @IBOutlet weak var imgMedicalInformationNoTick: UIImageView!
    @IBOutlet weak var btnMedicalInformationNo: UIButton!
    @IBOutlet weak var lblMedicalInformationDetails: UILabel!
    @IBOutlet weak var txtViewMedicalInformationDetails: UITextView!
    
    @IBOutlet weak var heightConstraintQualification: NSLayoutConstraint!
    @IBOutlet weak var lblQualificationTitle: UILabel!
    @IBOutlet weak var lblQualificationYes: UILabel!
    @IBOutlet weak var imgQualificationYesTick: UIImageView!
    @IBOutlet weak var btnQualificationYes: UIButton!
    @IBOutlet weak var lblQualificationNo: UILabel!
    @IBOutlet weak var imgQualificationNoTick: UIImageView!
    @IBOutlet weak var btnQualificationNo: UIButton!
    
    @IBOutlet weak var lblDateQualificationTitle: UILabel!
    @IBOutlet weak var txtDateQualification: UITextField!
    @IBOutlet weak var btnDateQualification: UIButton!
    
    @IBOutlet weak var lblQualificationFileTitle: UILabel!
    @IBOutlet weak var lblQualificationFileName: UILabel!
    @IBOutlet weak var btnQualificationFile: UIButton!
    @IBOutlet weak var lblQualificationFileType: UILabel!
    
    @IBOutlet weak var lblSpecialDieataryRequirementsTitle: UILabel!
    @IBOutlet var btnSpecialDieatary: UIButton!
    @IBOutlet weak var lblSpokenLanguageTitle: UILabel!
    
    @IBOutlet weak var lblOriginatingStateIndiaTitle: UILabel!
    @IBOutlet weak var lblOriginatingStateIndia: UILabel!
    
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    @IBOutlet weak var lblTermsAndCondition: UILabel!
    
    @IBOutlet var btnSubmit: SSSpinnerButton!
    
    var viewPicker : UIView!
    let datePicker = UIDatePicker()
    
    var strMedicalInformation : String = ""
    var strQualification : String = ""
    var isAgree : Bool = false
    
    var dicDietaries = [[String:Any]]()
    var dicLanguages = [[String:Any]]()
    var dicIndianstates = [[String:Any]]()
    
    var dicSelectedDietaries = [[String:Any]]()
    var dicSelectedSpokenLang = [[String:Any]]()
    
    var indianstatesIndex : String = "0"
    
    var isImageSelected : Bool? = nil
    var selectedImage: UIImage? = nil
    var pdfURL: URL? = nil
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var spokenLangTagListView: TagListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print(appDelegate.dicMember)
        
        self.tagListView.delegate = self
        self.spokenLangTagListView.delegate = self
        
        self.heightConstraintMedicalInformation.constant = 0.0
        self.heightConstraintQualification.constant = 0.0
        
        let text = "agree_membership_text".localized
        //        let str = NSString(string: text)
        //        let attributedString = NSMutableAttributedString.init(string: text)
        //        let theRange = str.range(of: "HSSMembershipAgreement".localized)
        //        attributedString.addAttribute(.link, value: URL(string:MembershipWebUrl)!, range: theRange)
        //        lblTermsAndCondition.attributedText = attributedString
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "HSSMembershipAgreement".localized)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "SourceSansPro-Regular", size: 18.0)!, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: Colors.linkColor, range: range1)
        lblTermsAndCondition.attributedText = underlineAttriString
        lblTermsAndCondition.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        lblTermsAndCondition.isUserInteractionEnabled = true
        
        if _appDelegator.isEdit {
            self.fillEditData()
        } else {
            self.fillData()
        }
        self.getIndianStatesAPI()
        self.getDietariesAPI()
        self.getLanguagesAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate.userType == "self" {
            navigationBarDesign(txt_title: "add_self".localized, showbtn: "")
        } else {
            navigationBarDesign(txt_title: "Add_family_member".localized, showbtn: "")
        }
        self.firebaseAnalytics(_eventName: "AddMemberStep4VC")
    }
    
    func fillData() {
        
    }
    
    func fillEditData() {
        
        if let strMI = _appDelegator.dicMemberProfile![0]["medical_information_declare"] as? String {
            if strMI == "1" {
                self.onMedicalInformationYesClick()
                self.txtViewMedicalInformationDetails.text = _appDelegator.dicMemberProfile![0]["medical_details"] as? String
            } else {
                self.onMedicalInformationNoClick()
            }
        }
        
        if let strQF = _appDelegator.dicMemberProfile![0]["is_qualified_in_first_aid"] as? String {
            if strQF == "1" {
                self.onQualificationYesClick()
                self.txtDateQualification.text = _appDelegator.dicMemberProfile![0]["first_aid_date"] as? String
                
                if let strFile = _appDelegator.dicMemberProfile![0]["first_aid_qualification_file"] as? String {
                    let fileUrl = URL.init(fileURLWithPath: strFile)
                    self.lblQualificationFileName.text = "\(fileUrl.lastPathComponent)"
                    self.pdfURL = fileUrl
                    self.isImageSelected = false
                }
                
            } else {
                self.onQualificationNoClick()
            }
        }
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        guard let url = URL(string: MembershipWebUrl) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - DatePicker functions
    func showDatePicker(){
        
        viewPicker = UIView(frame: CGRect(x: 0.0, y: self.view.frame.height - 300, width: self.view.frame.width, height: 300))
        viewPicker.backgroundColor = UIColor.white
        viewPicker.clipsToBounds = true
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -99, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -3, to: Date())
        
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
        
        txtDateQualification.inputAccessoryView = toolbar
        txtDateQualification.inputView = datePicker
        
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
        txtDateQualification.text = formatter.string(from: datePicker.date)
        self.viewPicker.isHidden = true
    }
    
    @objc func cancelDatePicker(){
        self.viewPicker.isHidden = true
    }
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        
        if sender == self.tagListView {
            let dicFilter = self.dicSelectedDietaries.filter { $0["name"] as! String != title }.map { $0 }
            self.dicSelectedDietaries = dicFilter
            print(dicFilter)
        } else if sender == self.spokenLangTagListView {
            let dicFilter = self.dicSelectedSpokenLang.filter { $0["name"] as! String != title }.map { $0 }
            self.dicSelectedSpokenLang = dicFilter
            print(dicFilter)
        }
        
    }
    
    // MARK: - ImagePicker Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        print(fileUrl.lastPathComponent)
        self.lblQualificationFileName.text = fileUrl.lastPathComponent
        
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imgData = NSData(data: tempImage.jpegData(compressionQuality: 1)!)
        let imageSize: Int = imgData.count
        print("actual size of image in KB: %f ", Double(imageSize) / 1000.0)
        self.selectedImage  = tempImage
        self.isImageSelected = true
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - DocumentPicker Methods
    func selectFiles() {
        let documentPickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.lblQualificationFileName.text = "\(myURL.lastPathComponent)"
        self.pdfURL = myURL
        self.isImageSelected = false
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Button actions
    
    @IBAction func onSpecialDieataryClick(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            // Add one tag
            self.tagListView.addTag("\(dict["name"]!)")
            
            self.dicSelectedDietaries.append(dict)
        }
        vc.dataSource = dicDietaries
        vc.strNavigationTitle = "special_dieatary".localized
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func onSpokenLangClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            // Add one tag
            self.spokenLangTagListView.addTag("\(dict["name"]!)")
            
            self.dicSelectedSpokenLang.append(dict)
        }
        vc.dataSource = dicLanguages
        vc.strNavigationTitle = "spoken_language".localized
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onMedicalInformationYesClick(_ sender: UIButton) {
        self.onMedicalInformationYesClick()
    }
    
    func onMedicalInformationYesClick() {
        self.heightConstraintMedicalInformation.constant = 170.0
        
        self.imgMedicalInformationYesTick.image = UIImage(named:"rightTikmark")
        self.imgMedicalInformationNoTick.image = nil
        
        strMedicalInformation = "1"
        
        self.btnMedicalInformationYes.borderWidth = 1.0
        self.btnMedicalInformationYes.borderColor = Colors.txtAppDarkColor
        self.lblMedicalInformationYes.textColor = Colors.txtAppDarkColor
        
        self.btnMedicalInformationNo.borderWidth = 1.0
        self.btnMedicalInformationNo.borderColor = Colors.txtdarkGray
        self.lblMedicalInformationNo.textColor = Colors.txtdarkGray
    }
    
    @IBAction func onMedicalInformationNoClick(_ sender: UIButton) {
        self.onMedicalInformationNoClick()
    }
    
    func onMedicalInformationNoClick() {
        self.heightConstraintMedicalInformation.constant = 0.0
        self.imgMedicalInformationYesTick.image = nil
        self.imgMedicalInformationNoTick.image = UIImage(named:"rightTikmark")
        
        strMedicalInformation = "0"
        
        self.btnMedicalInformationNo.borderWidth = 1.0
        self.btnMedicalInformationNo.borderColor = Colors.txtAppDarkColor
        self.lblMedicalInformationNo.textColor = Colors.txtAppDarkColor
        
        self.btnMedicalInformationYes.borderWidth = 1.0
        self.btnMedicalInformationYes.borderColor = Colors.txtdarkGray
        self.lblMedicalInformationYes.textColor = Colors.txtdarkGray
    }
    
    @IBAction func onQualificationYesClick(_ sender: UIButton) {
        self.onQualificationYesClick()
    }
    
    func onQualificationYesClick() {
        self.heightConstraintQualification.constant = 248.0
        self.imgQualificationYesTick.image = UIImage(named:"rightTikmark")
        self.imgQualificationNoTick.image = nil
        
        strQualification = "1"
        
        self.btnQualificationYes.borderWidth = 1.0
        self.btnQualificationYes.borderColor = Colors.txtAppDarkColor
        self.lblQualificationYes.textColor = Colors.txtAppDarkColor
        
        self.btnQualificationNo.borderWidth = 1.0
        self.btnQualificationNo.borderColor = Colors.txtdarkGray
        self.lblQualificationNo.textColor = Colors.txtdarkGray
    }
    
    @IBAction func onQualificationNoClick(_ sender: UIButton) {
        self.onQualificationNoClick()
    }
    
    func onQualificationNoClick() {
        self.heightConstraintQualification.constant = 0.0
        self.imgQualificationYesTick.image = nil
        self.imgQualificationNoTick.image = UIImage(named:"rightTikmark")
        
        strQualification = "0"
        
        self.btnQualificationNo.borderWidth = 1.0
        self.btnQualificationNo.borderColor = Colors.txtAppDarkColor
        self.lblQualificationNo.textColor = Colors.txtAppDarkColor
        
        self.btnQualificationYes.borderWidth = 1.0
        self.btnQualificationYes.borderColor = Colors.txtdarkGray
        self.lblQualificationYes.textColor = Colors.txtdarkGray
    }
    
    @IBAction func onDateQualificationClick(_ sender: UIButton) {
        showDatePicker()
    }
    
    @IBAction func onQualificationFileClick(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "upload_file".localized, message: "", preferredStyle: .actionSheet)
        
        //        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
        //            print("delete")
        //        })
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        let imgAction = UIAlertAction(title: "upload_image".localized, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            print("Upload Image")
            let imagePickerController = UIImagePickerController()
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        })
        
        let docAction = UIAlertAction(title: "upload_PDF".localized, style: .default, handler: { (alert: UIAlertAction!) -> Void in
            print("Upload PDF")
            self.selectFiles()
        })
        
        //        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        alertController.addAction(imgAction)
        alertController.addAction(docAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onOriginatingStateIndiaClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        
        vc.selectedItemCompletion = {dict in
            self.lblOriginatingStateIndia.text = dict["name"] as? String
            self.indianstatesIndex = dict["id"] as! String
            print(self.indianstatesIndex)
        }
        vc.strNavigationTitle = "originating_state".localized
        vc.dataSource = dicIndianstates
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onTermsAndConditionClick(_ sender: UIButton) {
        if(isAgree){
            isAgree = false
            btnTermsAndCondition.setBackgroundImage(UIImage.init(named: "uncheck"), for: UIControl.State.normal)
        }else{
            isAgree = true
            btnTermsAndCondition.setBackgroundImage(UIImage.init(named: "check_img"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func onPrevClick(_ sender: Any) {
        //self.performSegue(withIdentifier: "AddMemberStep1", sender: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSubmitClick(_ sender: Any) {
        if (checkStep4Validation() == true) {
            self.step4()
        }
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func checkStep4Validation() -> Bool {
        
        if strMedicalInformation == "" {
            showAlert(title: APP.title, message: "error_Please_select_medical_info_declare".localized)
            return false
        } else if strQualification == "" {
            showAlert(title: APP.title, message: "error_Please_select_date_First_aid_qualification".localized)
            return false
        } else if lblOriginatingStateIndia.text == "" {
            showAlert(title: APP.title, message: "originating_state_in_india".localized)
            return false
        } else if dicSelectedDietaries.count == 0 {
            showAlert(title: APP.title, message: "error_Please_select_special_dietary".localized)
            return false
        } else if dicSelectedSpokenLang.count == 0 {
            showAlert(title: APP.title, message: "error_Please_select_spoken_language".localized)
            return false
        } else if !isAgree {
            showAlert(title: APP.title, message: "error_please_choose_HSS_membership_agreement".localized)
            return false
        }
        
        if strMedicalInformation == "1" {
            if(txtViewMedicalInformationDetails.text.count == 0){
                showAlert(title: APP.title, message: "error_Please_select_medical_info_details".localized)
                return false
            }
        }
        
        if strQualification == "1" {
            if(txtDateQualification.text!.count == 0){
                showAlert(title: APP.title, message: "error_Please_select_date_First_aid_qualification".localized)
                return false
            }
            if lblQualificationFileName.text!.count == 0 {
                showAlert(title: APP.title, message: "error_Please_select_file_photo".localized)
                return false
            }
        }
        
        return true
    }
    
    func step4() {
        
        appDelegate.dicMember["medical_information"] = self.strMedicalInformation
        if self.strMedicalInformation == "1" {
            appDelegate.dicMember["provide_details"] = txtViewMedicalInformationDetails.text!
        } else {
            appDelegate.dicMember["provide_details"] = ""
        }
        
        appDelegate.dicMember["is_qualified_in_first_aid"] = self.strQualification
        if self.strQualification == "1" {
            appDelegate.dicMember["date_of_first_aid_qualification"] = self.txtDateQualification.text!
            appDelegate.dicMember["qualification_file"] = ""
            
        } else {
            appDelegate.dicMember["date_of_first_aid_qualification"] = ""
            appDelegate.dicMember["qualification_file"] = ""    //  Document file
        }
        
        var strDietariesId = ""
        for dic in self.dicSelectedDietaries {
            if let strId = dic["id"] as? String {
                strDietariesId.count == 0 ? (strDietariesId = strId) : (strDietariesId = "\(strDietariesId), \(strId)")
            }
        }
        
        appDelegate.dicMember["special_med_dietry_info"] = strDietariesId
        
        var strlanguageId = ""
        for dic in self.dicSelectedSpokenLang {
            if let strId = dic["id"] as? String {
                strlanguageId.count == 0 ? (strlanguageId = strId) : (strlanguageId = "\(strlanguageId), \(strId)")
            }
        }
        
        appDelegate.dicMember["language"] = strlanguageId
        appDelegate.dicMember["state"] = self.indianstatesIndex
        
        self.btnSubmit.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: .white, spinnerSize: 20, complete: {
            // Your code here
            if _appDelegator.isEdit {
                //                self.uploadingImage()
                self.updateMemberAPI()
            } else {
                self.createMemberAPI()
            }
        })
        
    }
    
    
    
    // MARK: - API functions
    
    func getDietariesAPI() {
        
        APIManager.sharedInstance.callGetApi(url: APIUrl.get_dietaries) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arr = jsonData!["data"]
                        if _appDelegator.isEdit {
                            if let strDietryId = _appDelegator.dicMemberProfile![0]["special_med_dietry_info_id"] as? String {
                                self.dicSelectedDietaries.removeAll()
                                self.tagListView.removeAllTags()
                                let dicData : [[String : Any]] = arr.object as? [[String : Any]] ?? []
                                let arrDietryId = strDietryId.components(separatedBy: ", ")
                                for i in 0..<arrDietryId.count {
                                    let arrFilter : [String] = dicData.filter { $0["dietary_requirements_id"] as! String ==  arrDietryId[i]}.map { $0["dietary_requirements_name"]! as! String }
                                    var dict = [String : Any]()
                                    dict["id"] = arrDietryId[i]
                                    dict["name"] = arrFilter[0]
                                    self.dicSelectedDietaries.append(dict)
                                    self.tagListView.addTag(arrFilter[0])
                                }
                            }
                        }
                        
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["dietary_requirements_id"].string
                            dict["name"] = arr[index]["dietary_requirements_name"].string
                            self.dicDietaries.append(dict)
                        }
                        print(self.dicDietaries)
                        
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
    
    func getLanguagesAPI() {
        
        APIManager.sharedInstance.callGetApi(url: APIUrl.get_languages) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arr = jsonData!["data"]
                        if _appDelegator.isEdit {
                            if let strLanguageId = _appDelegator.dicMemberProfile![0]["root_language_id"] as? String {
                                self.dicSelectedSpokenLang.removeAll()
                                self.spokenLangTagListView.removeAllTags()
                                let dicData : [[String : Any]] = arr.object as? [[String : Any]] ?? []
                                let arrLanguageId = strLanguageId.components(separatedBy: ", ")
                                for i in 0..<arrLanguageId.count {
                                    let arrFilter : [String] = dicData.filter { $0["language_id"] as! String ==  arrLanguageId[i]}.map { $0["language_name"]! as! String }
                                    var dict = [String : Any]()
                                    dict["id"] = arrLanguageId[i]
                                    dict["name"] = arrFilter[0]
                                    self.dicSelectedSpokenLang.append(dict)
                                    self.spokenLangTagListView.addTag(arrFilter[0])
                                }
                            }
                        }
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["language_id"].string
                            dict["name"] = arr[index]["language_name"].string
                            self.dicLanguages.append(dict)
                        }
                        print(self.dicLanguages)
                        
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
    
    func getIndianStatesAPI() {
        
        APIManager.sharedInstance.callGetApi(url: APIUrl.get_indian_states) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arr = jsonData!["data"]
                        if _appDelegator.isEdit {
                            self.lblOriginatingStateIndia.text = _appDelegator.dicMemberProfile![0]["indian_connection_state"] as? String
                            let dicData : [[String : Any]] = arr.object as? [[String : Any]] ?? []
                            let arrFilter : [String] = dicData.filter { $0["state_name"] as? String ==  self.lblOriginatingStateIndia.text}.map { $0["indian_state_list_id"]! as! String }
                            self.indianstatesIndex = arrFilter[0]
                        } else {
                            self.lblOriginatingStateIndia.text = arr[0]["state_name"].string
                            self.indianstatesIndex = arr[0]["indian_state_list_id"].string!
                        }
                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            dict["id"] = arr[index]["indian_state_list_id"].string
                            dict["name"] = arr[index]["state_name"].string
                            self.dicIndianstates.append(dict)
                        }
                        print(self.dicIndianstates)
                        
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
    
    
    // MARK: - Create Member API function
    
    func createMemberAPI() {
        let dicData = appDelegate.dicMember
        
        var parameters: [String: Any]   = [:]
        parameters["user_id"]           = dicData["user_id"]
        parameters["first_name"]        = dicData["first_name"]
        parameters["middle_name"]       = dicData["middle_name"]
        parameters["last_name"]         = dicData["last_name"]
        parameters["email"]             = dicData["email"]
        parameters["gender"]            = dicData["gender"]
        parameters["dob"]               = dicData["dob"]
        parameters["age"]               = dicData["age"]
        parameters["relationship"]      = dicData["relationship"]
        parameters["other_relationship"]            = dicData["other_relationship"]
        parameters["occupation"]        = dicData["occupation"]
        parameters["occupation_name"]   = dicData["occupation_name"]
        parameters["shakha"]            = dicData["shakha"]
        parameters["mobile"]            = dicData["mobile"]
        parameters["land_line"]         = dicData["land_line"]
        parameters["post_code"]         = dicData["post_code"]
        parameters["building_name"]     = dicData["building_name"]
        parameters["address_line_1"]    = dicData["address_line_1"]
        parameters["address_line_2"]    = dicData["address_line_2"]
        parameters["post_town"]         = dicData["post_town"]
        //        parameters["county"]            = dicData["county"]
        parameters["country"]           = dicData["country"]
        parameters["emergency_name"]    = dicData["emergency_name"]
        parameters["emergency_phone"]   = dicData["emergency_phone"]
        parameters["emergency_email"]   = dicData["emergency_email"]
        parameters["emergency_relationship"]        = dicData["emergency_relationship"]
        parameters["other_emergency_relationship"]  = dicData["other_emergency_relationship"]
        parameters["medical_information"]           = dicData["medical_information"]
        parameters["provide_details"]               = dicData["provide_details"]
        parameters["is_qualified_in_first_aid"]     = dicData["is_qualified_in_first_aid"]
        parameters["date_of_first_aid_qualification"]     = dicData["date_of_first_aid_qualification"]
        //        parameters["qualification_file"]            = dicData["qualification_file"]
        parameters["special_med_dietry_info"]       = dicData["special_med_dietry_info"]
        parameters["language"]          = dicData["language"]
        parameters["state"]             = dicData["state"]
        parameters["app"]               = "yes"
        parameters["type"]              = "family"
        parameters["is_self"]           = dicData["is_self"]
        parameters["is_linked"]         = ""
        parameters["parent_member_id"]  = dicData["parent_member_id"]
        parameters["county"]            = dicData["county"]
        if appDelegate.userType != "self" {
            parameters["username"]          = dicData["username"]
            parameters["password"]          = dicData["password"]
        }
        
        
        /*
         parameters = ["emergency_phone": "1114444789", "address_line_2": "King George Vi Club", "occupation_name": "", "qualification_file": "", "relationship": "1", "land_line": "1235647890", "other_relationship": "", "other_emergency_relationship": "", "middle_name": "", "emergency_name": "aaa", "emergency_relationship": "1", "post_town": "Maidenhead", "special_med_dietry_info": "2", "app": "yes", "mobile": "1679432580", "is_self": "self", "dob": "23/04/2009", "user_id": "207", "shakha": "227", "building_name": "King George Vi Club", "gender": "M", "date_of_first_aid_qualification": "23/04/2008", "state": "33", "medical_information": "0", "provide_details": "", "language": "16, 13", "first_name": "Nikhil", "post_code": "SL6 1SH ", "email": "nik.Modi92@gmail.com", "address_line_1": "Flat", "is_qualified_in_first_aid": "1", "occupation": "386", "parent_member_id": "", "is_linked": "", "last_name": "Modi", "emergency_email": "aaa@gmail.com", "type": "family", "age": "1"] as [String : Any]
         */
        print(parameters)
        
        if strQualification == "1" {
            if self.isImageSelected == true {
                //                let imageData = self.selectedImage!.pngData()
                let imageData = self.selectedImage!.jpegData(compressionQuality: 1.0)
                let mimeType = self.mimeType(for: imageData!)
                self.upload(url:APIUrl.create_member, data: imageData!, params: parameters, fileName: "image_\(Date.init().timeIntervalSince1970)", mimeType: (mimeType.0, mimeType.1))
            } else {
                //remove ! from url and unwrap optional
                guard let pdfData = try? Data(contentsOf: (self.pdfURL?.asURL())!) else { return }
                //                let pdfData = try! Data(contentsOf: (self.pdfURL?.asURL())!)
                let data : Data = pdfData
                let mimeType = self.mimeType(for: data)
                self.upload(url:APIUrl.create_member, data: data, params: parameters, fileName: "file_\(Date.init().timeIntervalSince1970)", mimeType: (mimeType.0, mimeType.1))
            }
        } else {
            parameters["qualification_file"]            = dicData["qualification_file"]
            APIManager.sharedInstance.callPostApi(url: APIUrl.create_member, parameters: parameters) { (jsonData, error) in
                if error == nil
                {
                    if let status = jsonData!["status"].int
                    {
                        if status == 1
                        {
                            let arrData = jsonData!["data"]
                            // create the alert
                            let alert = UIAlertController(title: "Success", message: "\(jsonData!["message"])", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default, handler: { action in
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            print(arrData)
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
    
    func mimeType(for data: Data) -> (String, String) {
        
        var b: UInt8 = 0
        data.copyBytes(to: &b, count: 1)
        
        switch b {
        case 0xFF:
            return ("image/jpeg", ".jpeg")
        case 0x89:
            return ("image/png", ".png")
        case 0x47:
            return ("image/gif", ".gif")
        case 0x4D, 0x49:
            return ("image/tiff", ".tiff")
        case 0x25:
            return ("application/pdf", ".pdf")
        case 0xD0:
            return ("application/vnd", ".vnd")
        case 0x46:
            return ("text/plain", ".plain")
        default:
            return ("application/pdf", ".pdf")
        }
    }
    
    func upload(url : String, data : Data, params: [String: Any], fileName: String, mimeType: (String, String)) {
        let urlString = url
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept": "application/json"
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if value is Int {
                        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if element is Int {
                                let value = "(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                
                multipartFormData.append(data, withName: "qualification_file", fileName: "\(fileName)\(mimeType.1)", mimeType: mimeType.0)
            },
            to: urlString, //URL Here
            method: .post,
            headers: headers)
        .responseJSON { (resp) in
            defer{}
            switch resp.result {
            case .success(let JSON):
                let jsonData = JSON as! NSDictionary
                
                if let status = jsonData["status"]
                {
                    if (status as AnyObject).intValue == 1
                    {
                        self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .success, backToDefaults: true, complete: {
                            // Your code here
                            // create the alert
                            //                                let alert = UIAlertController(title: APP.title, message: jsonData["message"] as? String, preferredStyle: UIAlertController.Style.alert)
                            
                            let alert = UIAlertController(title: APP.title, message: " We have recived your membership application. Once you're approved, you'll get full access to the App.\nThank you! " as? String, preferredStyle: UIAlertController.Style.alert)
                            
                            
                            // add an action (button)
                            let ok = UIAlertAction(title: "Ok".localized, style: .default, handler: { action in
                                let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                            alert.addAction(ok)
                            // show the alert
                            self.present(alert, animated: true, completion: nil)
                        })
                    } else {
                        self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                            // Your code here
                            if let strError = jsonData["message"] as? String {
                                showAlert(title: APP.title, message: strError)
                            }
                        })
                    }
                } else {
                    self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                        // Your code here
                        if let strError = jsonData["message"] as? String {
                            showAlert(title: APP.title, message: strError)
                        }
                    })
                }
                break
            case .failure(let error):
                self.btnSubmit.stopAnimationWithCompletionTypeAndBackToDefaults(completionType: .fail, backToDefaults: true, complete: {
                    // Your code here
                    print(error)
                })
            }
        }
    }
    
    
    // MARK: - Update Member API function
    
    func updateMemberAPI() {
        let dicData = appDelegate.dicMember
        
        var parameters: [String: Any]   = [:]
        parameters["member_id"]         = _appDelegator.dicMemberProfile![0]["member_id"] as? String
        parameters["first_name"]        = dicData["first_name"]
        parameters["middle_name"]       = dicData["middle_name"]
        parameters["last_name"]         = dicData["last_name"]
        parameters["email"]             = dicData["email"]
        parameters["gender"]            = dicData["gender"]
        parameters["dob"]               = dicData["dob"]
        parameters["age"]               = dicData["age"]
        parameters["relationship"]      = dicData["relationship"]
        parameters["other_relationship"]            = dicData["other_relationship"]
        parameters["occupation"]        = dicData["occupation"]
        parameters["occupation_name"]   = dicData["occupation_name"]
        parameters["shakha"]            = dicData["shakha"]
        parameters["mobile"]            = dicData["mobile"]
        parameters["land_line"]         = dicData["land_line"]
        parameters["post_code"]         = dicData["post_code"]
        parameters["building_name"]     = dicData["building_name"]
        parameters["address_line_1"]    = dicData["address_line_1"]
        parameters["address_line_2"]    = dicData["address_line_2"]
        parameters["post_town"]         = dicData["post_town"]
        //        parameters["county"]            = dicData["county"]
        parameters["country"]           = dicData["country"]
        parameters["emergency_name"]    = dicData["emergency_name"]
        parameters["emergency_phone"]   = dicData["emergency_phone"]
        parameters["emergency_email"]   = dicData["emergency_email"]
        parameters["emergency_relationship"]        = dicData["emergency_relationship"]
        parameters["other_emergency_relationship"]  = dicData["other_emergency_relationship"]
        parameters["medical_information"]           = dicData["medical_information"]
        parameters["provide_details"]               = dicData["provide_details"]
        parameters["is_qualified_in_first_aid"]     = dicData["is_qualified_in_first_aid"]
        parameters["date_of_first_aid_qualification"]     = dicData["date_of_first_aid_qualification"]
        //        parameters["qualification_file"]            = dicData["qualification_file"]
        parameters["special_med_dietry_info"]       = dicData["special_med_dietry_info"]
        parameters["language"]          = dicData["language"]
        parameters["state"]             = dicData["state"]
        parameters["app"]               = "yes"
        parameters["type"]              = "family"
        parameters["is_self"]           = dicData["is_self"]
        parameters["is_linked"]         = ""
        parameters["parent_member_id"]  = dicData["parent_member_id"]
        parameters["county"]            = dicData["county"]
        
        /*
         parameters = ["emergency_phone": "1114444789", "address_line_2": "King George Vi Club", "occupation_name": "", "qualification_file": "", "relationship": "1", "land_line": "1235647890", "other_relationship": "", "other_emergency_relationship": "", "middle_name": "", "emergency_name": "aaa", "emergency_relationship": "1", "post_town": "Maidenhead", "special_med_dietry_info": "2", "app": "yes", "mobile": "1679432580", "is_self": "self", "dob": "23/04/2009", "user_id": "207", "shakha": "227", "building_name": "King George Vi Club", "gender": "M", "date_of_first_aid_qualification": "23/04/2008", "state": "33", "medical_information": "0", "provide_details": "", "language": "16, 13", "first_name": "Nikhil", "post_code": "SL6 1SH ", "email": "nik.Modi92@gmail.com", "address_line_1": "Flat", "is_qualified_in_first_aid": "1", "occupation": "386", "parent_member_id": "", "is_linked": "", "last_name": "Modi", "emergency_email": "aaa@gmail.com", "type": "family", "age": "1"] as [String : Any]
         */
        print(parameters)
        
        if strQualification == "1" {
            if self.isImageSelected == true {
                //                let imageData = self.selectedImage!.pngData()
                let imageData = self.selectedImage!.jpegData(compressionQuality: 1.0)
                let mimeType = self.mimeType(for: imageData!)
                self.upload(url:APIUrl.update_member, data: imageData!, params: parameters, fileName: "image_\(Date.init().timeIntervalSince1970)", mimeType: (mimeType.0, mimeType.1))
            } else {
                //remove ! from url and unwrap optional
                guard let pdfData = try? Data(contentsOf: (self.pdfURL?.asURL())!) else { return }
                //                let pdfData = try! Data(contentsOf: (self.pdfURL?.asURL())!)
                let data : Data = pdfData
                let mimeType = self.mimeType(for: data)
                self.upload(url:APIUrl.update_member, data: data, params: parameters, fileName: "file_\(Date.init().timeIntervalSince1970)", mimeType: (mimeType.0, mimeType.1))
            }
        } else {
            parameters["qualification_file"]            = dicData["qualification_file"]
            APIManager.sharedInstance.callPostApi(url: APIUrl.update_member, parameters: parameters) { (jsonData, error) in
                if error == nil
                {
                    if let status = jsonData!["status"].int
                    {
                        if status == 1
                        {
                            let arrData = jsonData!["data"]
                            // create the alert
                            let alert = UIAlertController(title: "Success", message: "\(jsonData!["message"])", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default, handler: { action in
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            print(arrData)
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
    
}

//
//  AddSuryaNamskarCountVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 28/01/2022.
//


import UIKit
import SwiftyJSON
import Alamofire


struct surynamaskarStruct {
    var date: String
    var count: String
}

class AddSuryaNamskarCountVC: UIViewController, UITextFieldDelegate {
    
    var surynamaskarData: [surynamaskarStruct] = [
        surynamaskarStruct(date: "Date", count: "0"),
        //        surynamaskarStruct(date: "Date", count: "0"),
        //        surynamaskarStruct(date: "Date", count: "0")
    ]
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var btnMember: UIButton!
    
    @IBOutlet weak var familyMemberHeightConstraint: NSLayoutConstraint!
    
    var viewPicker : UIView!
    let datePicker = UIDatePicker()
    
    var btnIndex : Int!
    var strMemberId : String!
    var dicMember = [[String:Any]]()
    
    lazy var loader : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.dicMember.count > 0 {
            self.strMemberId = self.dicMember[0]["id"] as? String
            self.lblMember.text = self.dicMember[0]["name"] as? String
            self.familyMemberHeightConstraint.constant = 90
        } else {
            self.familyMemberHeightConstraint.constant = 0
        }
        
        view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "Record Suryanamskar", showbtn: "back")
    }
    
    @IBAction func onMemberClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblMember.text = dict["name"] as? String
            self.strMemberId = dict["id"] as? String
        }
        vc.dataSource = dicMember
        vc.strNavigationTitle = "Family Member"
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onCancelClick(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onSaveClick(_ sender: UIButton) {
        //        var arrData: [surynamaskarStruct] = []
        
        //        for arr in surynamaskarData {
        //            if arr.date != "Date" && arr.count != "0" {
        //                arrData.append(surynamaskarStruct(date: arr.date, count: arr.count))
        //            }
        //        }
        var arrData = [[String:Any]]()
        for arr in surynamaskarData {
            if arr.date != "Date" && arr.count != "0" {
                var dict = [String : Any]()
                dict["date"] = arr.date
                dict["count"] = arr.count
                arrData.append(dict)
            }
        }
        
        if arrData.count == 0 {
            showAlert(title: APP.title, message: "Please Enter Date and Suryanamaskar")
        }
        
        if arrData.count > 0 {
            self.saveSuryaNamskarCountDataAPI(arrData)
            
            ////static controller to directly update the suryanamaskar chart instead of going back and then getting updated suryanamaskar
            
            //            let alertController = UIAlertController(title:APP.title, message: "Suryanamaskar has been saved successfully!", preferredStyle:.alert)
            //
            //            let Action = UIAlertAction.init(title: "Ok", style: .default) { (UIAlertAction) in
            //                // Write Your code Here
            //
            //                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuryaNamskarVC") as! SuryaNamskarVC
            //                vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            //        //        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            //                self.present(vc, animated: true, completion: nil)
            //            }
            //
            //            alertController.addAction(Action)
            //            self.present(alertController, animated: true, completion: nil)
            
            //// Till here for alert controller. if not implemented, updated suryanamaskar will happen only once user goes back and comes back to suryanamaskarVC
            
            
        }
        
        //        else {
        //            showAlert(title: APP.title, message: "Please select date and count before Save")
        //        }
        
        
        
        
        
        
        
        
    }
    
    // MARK: - DatePicker functions
    func showDatePicker(){
        
        viewPicker = UIView(frame: CGRect(x: 0.0, y: self.view.frame.height - 500, width: self.view.frame.width, height: 500))
        viewPicker.backgroundColor = UIColor.white
        viewPicker.clipsToBounds = true
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 500)
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        
        datePicker.backgroundColor = UIColor.white
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        } else {
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            
            // Fallback on earlier versions
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
        
        //        txtDate.inputAccessoryView = toolbar
        //        txtDate.inputView = datePicker
        
        self.viewPicker.addSubview(toolbar)
        
        self.viewPicker.addSubview(datePicker)
        self.viewPicker.clipsToBounds = true
        self.view.addSubview(self.viewPicker)
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "dd/MM/yyyy"
        // Apply date format
        let _: String = dateFormatter.string(from: sender.date)
        //        print("Selected value \(selectedDate)")
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate = formatter.string(from: datePicker.date)
        surynamaskarData[btnIndex].date = strDate
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.viewPicker.isHidden = true
    }
    
    @objc func cancelDatePicker(){
        self.viewPicker.isHidden = true
    }
    
    @objc func onAddMoreClicked() {
        print("AddMore Button Pressed")
        // condition to not let user "add more" without completely filling data
        //        for i in surynamaskarData {
        //            if i.date == "Date" || i.count == "0" || i.count == "" {
        //                showAlert(title: APP.title, message: "Please select date and count before AddMore")
        //                return
        //            }
        //        }
        surynamaskarData.append(surynamaskarStruct(date: "Date", count: "0"))
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func onDateClick(_ sender: UIButton) {
        btnIndex = sender.tag
        view.endEditing(true)
        if self.viewPicker == nil {
            self.showDatePicker()
        } else {
            if self.viewPicker.isHidden == true {
                self.showDatePicker()
            } else {
                self.viewPicker.isHidden = true
            }
        }
    }
    
    @objc func onDeleteClick(_ sender: UIButton) {
        surynamaskarData.remove(at: sender.tag)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.viewPicker != nil {
            if self.viewPicker.isHidden == false {
                self.viewPicker.isHidden = false
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
        surynamaskarData[textField.tag].count = textField.text ?? "0"
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //////// for dev/stg API only
    //( uncomment use _appDelegator.dicDa...)
    //( delete "1390" in  parameters["member_id"] = "1390" and uncomment above...)
    //(uncomment   APIUrl.save_suryanamaskar)
    
    func saveSuryaNamskarCountDataAPI(_ data : [[String:Any]]) {

        var parameters: [String: Any] = [:]
        parameters["surynamaskar"] = self.json(from: data)
        parameters["member_id"] = // self.strMemberId
        _appDelegator.dicDataProfile![0]["member_id"] as? String

        print(parameters)
        //dev/stg API only ()
        APIUrl.save_suryanamaskar
        //"https://stg.myhss.org.uk/api/v1/suryanamaskar/save_suryanamaskar_count"
        loader.startAnimating()
        APIManager.sharedInstance.callPostApi(url: APIUrl.save_suryanamaskar, parameters: parameters) {
            (jsonData, error) in
            self.loader.stopAnimating()
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let strMessage : String = jsonData!["message"].rawValue as! String
                        print(strMessage)

                        // create the alert
                        let alert = UIAlertController(title: APP.title, message: strMessage, preferredStyle: UIAlertController.Style.alert)
                        // add an action (button)
                        let ok = UIAlertAction(title: "Ok".localized, style: .default, handler: { action in
                            DispatchQueue.main.async {
                                self.dismiss(animated: true)
                            }
                        })
                        alert.addAction(ok)
                        // show the alert
                        self.present(alert, animated: true, completion: nil)

                    }else {
                        if let strError = jsonData!["message"].string {
                            showAlert(title: APP.title, message: strError)
                        }
                    }
                }
                else {

                }
            }
        }
    }
}


//////// for Live API only
//    func saveSuryaNamskarCountDataAPI(_ data : [[String:Any]]) {
//        var parameters: [String: Any] = [:]
//        parameters["surynamaskar"] = self.json(from: data)
//        parameters["member_id"] = self.strMemberId // _appDelegator.dicDataProfile![0]["member_id"] as? String
//
//        print(parameters)
////          APIUrl.save_suryanamaskar
//        //live API only
//        //"https://myhss.org.uk/api/v1/suryanamaskar/save_suryanamaskar_count"
//        loader.startAnimating()
//        let url = URL(string: APIUrl.save_suryanamaskar)!
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//          .validate()
//          .responseJSON { response in
//            self.loader.stopAnimating()
//            switch response.result {
//            case .success(let response):
//              print(response)
//                let jsonData = JSON(response)
//                if let status = jsonData["status"].int
//                {
//                    if status == 1
//                    {
//                        let strMessage : String = jsonData["message"].rawValue as! String
//                       print(strMessage)
//
//                        // create the alert
//                        let alert = UIAlertController(title: APP.title, message: strMessage, preferredStyle: UIAlertController.Style.alert)
//                        // add an action (button)
//                        let ok = UIAlertAction(title: "Ok".localized, style: .default, handler: { action in
//                            DispatchQueue.main.async {
//                                self.dismiss(animated: true)
//                            }
//                        })
//                        alert.addAction(ok)
//                        // show the alert
//                        self.present(alert, animated: true, completion: nil)
//
//                    } else {
//                        if let strError = jsonData["message"].string {
//                            showAlert(title: APP.title, message: strError)
//                        }
//                    }
//                }
//            case .failure(let error):
//              print(error.localizedDescription)
//                showAlert(title: APP.title, message: error.localizedDescription)
//            }
//        }
//    }
//}

extension AddSuryaNamskarCountVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surynamaskarData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddSuryaNamskarCountTVCell.cellIdentifier) as! AddSuryaNamskarCountTVCell
        cell.btnDate.tag = indexPath.row
        cell.btnDate.addTarget(self, action: #selector(self.onDateClick(_:)), for: .touchUpInside)
        
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(self.onDeleteClick(_:)), for: .touchUpInside)
        
        cell.lblDate.text = surynamaskarData[indexPath.row].date
        cell.txtCount.text = surynamaskarData[indexPath.row].count
        cell.txtCount.tag = indexPath.row
        cell.txtCount.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        if #available(iOS 13.0, *) {
            viewFooter.backgroundColor = UIColor.systemGray5
        } else {
            // Fallback on earlier versions
            viewFooter.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
            
        }
        let size = tableView.frame.size
        let addMoreButton = UIButton()
        addMoreButton.setTitle("+ Add More", for: .normal)
        addMoreButton.setTitleColor(Colors.txtAppDarkColor, for: .normal)
        addMoreButton.frame = CGRect(x: 0, y: 0, width: size.width, height: 20)
        addMoreButton.addTarget(self, action: #selector(onAddMoreClicked), for: .touchUpInside)
        viewFooter.addSubview(addMoreButton)
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}


//
//  FindShakhaDetailsVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 13/08/2021.
//

import UIKit
import GoogleMaps

class FindShakhaDetailsVC: UIViewController {

    @IBOutlet weak var lblShakhaName: UILabel!
    @IBOutlet weak var lblShakhaAddress: UILabel!
    @IBOutlet weak var lblShakhaEmail: UILabel!
    @IBOutlet weak var lblShakhaContactPerson: UILabel!
    @IBOutlet weak var lblShakhaPhone: UILabel!
    @IBOutlet weak var lblShakhaDay: UILabel!
    @IBOutlet weak var lblShakhaTime: UILabel!
    
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    
    var shakhaData : ShakhaData?
    var strShakhaId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationBarWithRightButtonDesign(txt_title: "Shakha Details", showbtn: "back", rightImg: "get-dir", bagdeVal: "", isBadgeHidden: true)
//        self.getShakhaDetailsAPI()
        self.fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "Shakha Details", showbtn: "back")
    }
    
    func fillData() {
        if let strChapterName = shakhaData?.chapter_name {
            self.lblShakhaName.text = strChapterName
        }
        
        if let str = shakhaData?.address_line_1 {
            self.lblShakhaAddress.text = "\(str), \(shakhaData?.address_line_2 ?? ""), \(shakhaData?.city ?? ""), \(shakhaData?.county ?? ""), \(shakhaData?.country ?? ""), \(shakhaData?.postal_code ?? "")"
        }
        
        if let str = shakhaData?.email {
            self.lblShakhaEmail.text = str
        }
        
        if let str = shakhaData?.contact_person_name {
            self.lblShakhaContactPerson.text = str
        }
        
        if let str = shakhaData?.phone {
            self.lblShakhaPhone.text = str
        }
        
        if let str = shakhaData?.day {
            self.lblShakhaDay.text = str
        }
        
        if let str = shakhaData?.start_time {
            let endTime = shakhaData?.end_time ?? ""
            if !str.isEmpty && !endTime.isEmpty {
                let strStartTime = str.timeConversion12(time24: str)
                let strEndTime = endTime.timeConversion12(time24: endTime)
                if !strStartTime.isEmpty || !strEndTime.isEmpty {
                    self.lblShakhaTime.text = "\(strStartTime) - \(strEndTime)"
                }
            }
        }

    }

    @IBAction func onGetDirectionsClicked(_ sender: UIButton) {
        let lat = Double((self.shakhaData?.latitude)!) ?? 0.0
        let long = Double((self.shakhaData?.longitude)!) ?? 0.0
        
        self.openGoogleMap(lat: lat, long: long)
    }
    
    func openGoogleMap(lat: CLLocationDegrees , long: CLLocationDegrees) {
//         guard let lat = booking?.booking?.pickup_lat, let latDouble =  Double(lat) else {Toast.show(message: StringMessages.CurrentLocNotRight);return }
//         guard let long = booking?.booking?.pickup_long, let longDouble =  Double(long) else {Toast.show(message: StringMessages.CurrentLocNotRight);return }
        let latDouble =  Double(lat)
        let longDouble =  Double(long)
        
          if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

              if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                        UIApplication.shared.open(url, options: [:])
               }}
          else {
                 //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                                   UIApplication.shared.open(urlDestination)
                               }
                    }

            }
    
    @IBAction func onMailClick(_ sender: UIButton) {
        let email = self.lblShakhaEmail.text!
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @IBAction func onPhoneClick(_ sender: UIButton) {
        var strPhone = self.lblShakhaPhone.text!
        strPhone = strPhone.replacingOccurrences(of: " ", with: "")
        guard let number = URL(string: "tel://" + strPhone) else { return }
        UIApplication.shared.open(number)
    }
    
        // MARK: - API Functions
    
        func getShakhaDetailsAPI() {
             var parameters: [String: Any] = [:]
             parameters["shakha_id"] = strShakhaId
             print(parameters)
    
            APIManager.sharedInstance.callPostApi(url: APIUrl.get_shakha_detail, parameters: parameters) { (jsonData, error) in
                 if error == nil
                 {
                     if let status = jsonData!["status"].int
                     {
                         if status == 1
                         {
                            let arr = jsonData!["data"]
                            let dicData : [String : Any] = arr.object as? [String : Any] ?? [:]
                            print(dicData)
                            if let strChapterName = dicData["chapter_name"] as? String {
                                self.lblShakhaName.text = strChapterName
                            }
                            
                            if let str = dicData["address_line_1"] as? String {
                                self.lblShakhaAddress.text = "\(str), \(dicData["address_line_2"] as? String ?? ""), \(dicData["city"] as? String ?? ""), \(dicData["county"] as? String ?? ""), \(dicData["country"] as? String ?? ""), \(dicData["postal_code"] as? String ?? "")"
                            }
                            
                            if let str = dicData["email"] as? String {
                                self.lblShakhaEmail.text = str
                            }
                            
                            if let str = dicData["contact_person_name"] as? String {
                                self.lblShakhaContactPerson.text = str
                            }
                            
                            if let str = dicData["phone"] as? String {
                                self.lblShakhaPhone.text = str
                            }
                            
                            if let str = dicData["day"] as? String {
                                self.lblShakhaDay.text = str
                            }
                            
                            if let str = dicData["start_time"] as? String {
                                let endTime = dicData["end_time"] as? String ?? ""
                                if !str.isEmpty && !endTime.isEmpty {
                                    let strStartTime = str.timeConversion12(time24: str)
                                    let strEndTime = endTime.timeConversion12(time24: endTime)
                                    if !strStartTime.isEmpty || !strEndTime.isEmpty {
                                        self.lblShakhaTime.text = "\(strStartTime) - \(strEndTime)"
                                    }
                                }
                            }
                            
                            
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

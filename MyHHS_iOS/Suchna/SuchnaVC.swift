//
//  SuchnaVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 12/07/2021.
//

import UIKit

class SuchanaTVCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var viewBackground: UIView!

}

class SuchnaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var strNavigation = ""

    var dictSuchna = [[String:Any]]()

    var suchanaResponseDM : SuchanaResponseDM?

    var suchanaData : [SuchanaData] {
        return suchanaResponseDM?.suchanaData ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: strNavigation, showbtn: "back")
        self.getSuchanaByMemberAPI()
    }


    // MARK: TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dictSuchna.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuchanaTVCell", for: indexPath) as! SuchanaTVCell
        if let strIsRead = self.dictSuchna[indexPath.row]["is_read"] as? String {
            if #available(iOS 13.0, *) {
                strIsRead == "0" ? (cell.viewBackground.backgroundColor = UIColor.systemGray6) : (cell.viewBackground.backgroundColor = UIColor.white)
            } else {
                // Fallback on earlier versions
            }
        }

        if let strDate = self.dictSuchna[indexPath.row]["created_date"] as? String {

            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date: Date? = dateFormatterGet.date(from: strDate) as Date?

            cell.lblDate.text = date!.string(format: "yyyy-MM-dd")
//            let arrDate = strDate.components(separatedBy: " ")
//            cell.lblDate.text = "\(arrDate[0])"
        }

        cell.lblTitle.text = self.dictSuchna[indexPath.row]["suchana_title"] as? String
        cell.lblDetails.text = self.dictSuchna[indexPath.row]["suchana_text"] as? String

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:SuchanaTVCell = tableView.cellForRow(at: indexPath) as! SuchanaTVCell

        if cell.lblDetails.numberOfLines == 0 {
            cell.lblDetails.numberOfLines = 2
        } else {
            cell.lblDetails.numberOfLines = 0
//            cell.viewBackground.backgroundColor = UIColor.white
            seenSuchanaByMemberAPI(suchanaId: (self.dictSuchna[indexPath.row]["id"] as? String)!)
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //Choose your custom row height
    }

    func getSuchanaByMemberAPI() {

//        let earlyDate = Calendar.current.date(
//          byAdding: .month,
//          value: -1,
//          to: Date())

        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String
        parameters["member_id"] = _appDelegator.dicDataProfile![0]["member_id"] as? String
//        parameters["start_date"] = Date().string(format: "yyyy-MM-dd")
//        parameters["end_date"] = earlyDate!.string(format: "yyyy-MM-dd")

        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.get_suchana_by_member, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                       let arr = jsonData!["data"]
                       print(arr)
                        self.dictSuchna = arr.object as? [[String : Any]] ?? []

                       DispatchQueue.main.async {
                           self.tableView.reloadData()
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

    func seenSuchanaByMemberAPI(suchanaId : String) {
        
        var parameters: [String: Any] = [:]
//        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String
        parameters["member_id"] = _appDelegator.dicDataProfile![0]["member_id"] as? String
        parameters["suchana_id"] = suchanaId

        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.seen_suchana_by_member, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.getSuchanaByMemberAPI()
                    }else {
                        if let strError = jsonData!["message"].string {
//                            showAlert(title: APP.title, message: strError)
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


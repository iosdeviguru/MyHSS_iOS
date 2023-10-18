//
//  PaidEventsStep6.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/03/2023.
//


import UIKit

class PaidEventsStep6: UIViewController {


    @IBOutlet weak var lblOrderTitle: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!

    @IBOutlet weak var GoToEvents: UILabel!
    
    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var DateTimeLbl: UILabel!
    
    @IBOutlet weak var LocationLbl: UILabel!
    
    
    
    var strAmount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "one_time_dakshina".localized, showbtn: "")
        self.fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.firebaseAnalytics(_eventName: "OneTimeDakshinaSuccessVC")
    }

    func fillData() {

       

        if let strOrderId = _appDelegator.dicOnteTimeGuruDakshina["order_id"] as? String {
            self.lblOrderId.text = strOrderId
        }
       
    }
    
    @IBAction func EventsListBtn(_ sender: UIButton) {
    }
    
 
    
}

//
//  PaidEventsStep5.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/03/2023.
//


import UIKit

class PaidEventsStep5: UIViewController {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblSuccessHeaderTitle: UILabel!
    
    @IBOutlet weak var lblOrderTitle: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblPaymentStatusTitle: UILabel!
    @IBOutlet weak var lblPaymentStatus: UILabel!
    
    @IBOutlet weak var RegisterView: UIView!
    
    
    @IBOutlet weak var btnDashboard: UIButton!
    
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

        self.lblAmount.text = "£ \(self.strAmount)"

        if let strOrderId = _appDelegator.dicOnteTimeGuruDakshina["order_id"] as? String {
            self.lblOrderId.text = strOrderId
        }
       
    }
    
    @IBAction func ViewRegisterBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func onDashbaordClick(_ sender: UIButton) {
        window?.switchToWelcomScreen()
    }
    
}

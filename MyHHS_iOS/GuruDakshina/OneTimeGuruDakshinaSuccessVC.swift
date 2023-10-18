//
//  OneTimeGuruDakshinaSuccessVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 05/04/2021.
//

import UIKit

class OneTimeGuruDakshinaSuccessVC: UIViewController {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblSuccessHeaderTitle: UILabel!
    
    @IBOutlet weak var lblOrderTitle: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblPaymentStatusTitle: UILabel!
    @IBOutlet weak var lblPaymentStatus: UILabel!
    
    @IBOutlet weak var lblGiftAidTitle: UILabel!
    @IBOutlet weak var lblGiftTitle: UILabel!
    
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
        if let strGift = _appDelegator.dicOnteTimeGuruDakshina["gift_aid_text"] as? String {
            self.lblGiftTitle.text = strGift
        }
    }
    
    @IBAction func onDashbaordClick(_ sender: UIButton) {
        window?.switchToWelcomScreen()
    }
    
}

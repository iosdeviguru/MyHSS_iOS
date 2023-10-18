//
//  RegularGuruDakshinaSucessVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 05/04/2021.
//

import UIKit

class RegularGuruDakshinaSucessVC: UIViewController {
    
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblSuccessHeaderTitle: UILabel!
    @IBOutlet weak var lblDetailsHeaderTitle: UILabel!
    
    @IBOutlet weak var lblReferenceNo: UILabel!
    
    @IBOutlet weak var lblFrequencyTitle: UILabel!
    @IBOutlet weak var lblFrequencyId: UILabel!
    @IBOutlet weak var lblSortCodeTitle: UILabel!
    @IBOutlet weak var lblSortCode: UILabel!
    
    @IBOutlet weak var lblAccountNameTitle: UILabel!
    @IBOutlet weak var lblAccountName: UILabel!
    @IBOutlet weak var lblAccountNumberTitle: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    
    
    @IBOutlet weak var lblGiftAidTitle: UILabel!
    @IBOutlet weak var lblGiftTitle: UILabel!
    
    @IBOutlet weak var btnDashboard: UIButton!
    
    var strAmount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "regular_dakshina".localized, showbtn: "")
        self.firebaseAnalytics(_eventName: "RegularGuruDakshinaSuccessVC")
    }

    func fillData() {

        self.lblAmount.text = "£ \(self.strAmount)"
                
        if let strAccountName = _appDelegator.dicOnteTimeGuruDakshina["account_name"] as? String {
            self.lblAccountName.text = strAccountName
        }
        if let strAccountNumber = _appDelegator.dicOnteTimeGuruDakshina["account_number"] as? String {
            self.lblAccountNumber.text = strAccountNumber
        }
        if let strSortCode = _appDelegator.dicOnteTimeGuruDakshina["sort_code"] as? String {
            self.lblSortCode.text = strSortCode
        }
        if let strFrequency = _appDelegator.dicOnteTimeGuruDakshina["frequency"] as? String {
            self.lblFrequencyId.text = strFrequency
        }
        if let strReferenceNo = _appDelegator.dicOnteTimeGuruDakshina["reference_no"] as? String {
            self.lblReferenceNo.text = strReferenceNo
        }
        if let strGift = _appDelegator.dicOnteTimeGuruDakshina["gift_aid_text"] as? String {
            self.lblGiftTitle.text = strGift
        }
    }
    
    @IBAction func onDashbaordClick(_ sender: UIButton) {
        window?.switchToWelcomScreen()
    }
    
}

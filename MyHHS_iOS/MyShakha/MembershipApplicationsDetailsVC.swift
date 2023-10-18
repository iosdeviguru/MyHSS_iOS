//
//  MembershipApplicationsDetailsVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 10/04/2021.
//

import UIKit

class MembershipApplicationsDetailsVC: UIViewController {

    @IBOutlet weak var lblShakha: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblGuruDakshinaTitle: UILabel!
    @IBOutlet weak var lblGuruDakshina: UILabel!
    
    @IBOutlet weak var lblContributionTypeTitle: UILabel!
    @IBOutlet weak var lblContributionType: UILabel!
    
    @IBOutlet weak var lblRefrenceTitle: UILabel!
    @IBOutlet weak var lblRefrence: UILabel!
    
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblGiftAidTitle: UILabel!
    @IBOutlet weak var lblGiftAid: UILabel!
    
    @IBOutlet weak var lblFrequencyDonationTitle: UILabel!
    @IBOutlet weak var lblFrequencyDonation: UILabel!


    var dictData = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "guru_dakshina".localized, showbtn: "back")

        self.fillData()

    }

    func fillData() {
        
        if let strShakhaName = dictData["chapter_name"] as? String {
            self.lblShakha.text = strShakhaName
        }

        let strFirstName : String = dictData["first_name"] as! String
        let strLastName : String = dictData["last_name"] as! String

        strLastName == "" ? (self.lblName.text = "\(strFirstName)") : (self.lblName.text = "\(strFirstName) \(strLastName)")
        
        if let strPaidAmount = dictData["paid_amount"] as? String {
            self.lblGuruDakshina.text = "£ \(strPaidAmount)"
        }
        if let strDakshina = dictData["dakshina"] as? String {
            self.lblContributionType.text = strDakshina
        }

        if let strOrderId = dictData["order_id"] as? String {
            self.lblRefrence.text = strOrderId
        }

        if let strStatus = dictData["status"] as? String {
            self.lblStatus.text = strStatus
        }
        if let strDate = dictData["created_at"] as? String {
            self.lblDate.text = strDate
        }
        if let strGiftAid = dictData["gift_aid"] as? String {
            self.lblGiftAid.text = strGiftAid
        }
        if let strRecurring = dictData["recurring"] as? String {
            self.lblFrequencyDonation.text = strRecurring
        }

    }
    
    @IBAction func onOneTimeDakshinaClick(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "OneTimeGuruDakshinaVC") as! OneTimeGuruDakshinaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onRegularDakhsinClick(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RegularGuruDakshinaStep1VC") as! RegularGuruDakshinaStep1VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

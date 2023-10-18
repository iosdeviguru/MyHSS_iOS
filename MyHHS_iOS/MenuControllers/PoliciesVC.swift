//
//  PoliciesVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 21/04/2021.
//

import UIKit

class PoliciesVC: UIViewController {
    
    @IBOutlet var lblCOC: UILabel!
    @IBOutlet var btnCOC: UIButton!
    
    @IBOutlet var lblDPP: UILabel!
    @IBOutlet var btnDPP: UIButton!
    
    @IBOutlet var lblMembershipAgreement: UILabel!
    @IBOutlet var btnMembershipAgreement: UIButton!
    
    @IBOutlet var lblTOC: UILabel!
    @IBOutlet var btnTOC: UIButton!
    
    @IBOutlet var lblPrivacyPolicy: UILabel!
    @IBOutlet var btnPrivacyPolicy: UIButton!
    
    
    private var CODE_CONTENT: String = "https://myhss.org.uk/page/code-of-conduct/6"
    private var DATA_PROTECTION: String = "https://myhss.org.uk/page/data-protection-policy/4"
    private var MEMBERSHIP: String = "https://myhss.org.uk/page/hss-uk-membership-agreement/7"
    private var TERMS_CONDITION: String = "https://myhss.org.uk/page/myhss-terms-conditions/2"
    private var PRIVACY_POLICY: String = "https://myhss.org.uk/page/privacy-policy/1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "policies_name".localized, showbtn: "back")
        
        
        self.fillData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.firebaseAnalytics(_eventName: "PoliciesVC")
    }
    
    func fillData() {
    }
    
    @IBAction func onCOCClick(_ sender: UIButton) {
        guard let url = URL(string: CODE_CONTENT) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func onDPPClick(_ sender: UIButton) {
        guard let url = URL(string: DATA_PROTECTION) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func onMembershipAgreementClick(_ sender: UIButton) {
        guard let url = URL(string: MEMBERSHIP) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func onTOCClick(_ sender: UIButton) {
        guard let url = URL(string: TERMS_CONDITION) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func onPrivacyPolicyClick(_ sender: UIButton) {
        guard let url = URL(string: PRIVACY_POLICY) else { return }
        UIApplication.shared.open(url)
    }
    
    
}

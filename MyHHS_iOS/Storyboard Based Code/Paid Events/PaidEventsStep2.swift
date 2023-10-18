//
//  PaidEventsStep2.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/03/2023.
//

import UIKit

class PaidEventsStep2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var SummaryLbl: UILabel!
    
    @IBOutlet weak var TitleLbl: UILabel!
    
    @IBOutlet weak var TitleLblDesc: UILabel!
    
    @IBOutlet weak var DateTimeLbl: UILabel!
    
    @IBOutlet weak var DateTimeLblDesc: UILabel!
    
    
    @IBOutlet weak var EmailLbl: UILabel!
    
    @IBOutlet weak var EmailLblDesc: UILabel!
    
    @IBOutlet weak var PhoneLbl: UILabel!
    
    @IBOutlet weak var PhoneLblDesc: UILabel!
    
    @IBOutlet weak var VenueLbl: UILabel!
    
    @IBOutlet weak var VenueLblDesc: UILabel!
    
    @IBOutlet weak var ChargesLbl: UILabel!
    
    @IBOutlet weak var ChargesLblDesc: UILabel!
    
    
    @IBOutlet weak var AgreeLbl1: UILabel!
    
    @IBOutlet weak var AgreeLbl2: UILabel!
    
    @IBAction func CheckBoxBtn(_ sender: UIButton) {
    }
    
    
    
    
    
    
    
    @IBAction func onPreviousClick(_ sender: Any) {
//        
//        if (checkStep1Validation() == true) {
//            self.step1()
//        }
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep2VC") as! AddMemberStep2VC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    @IBAction func onNextClick(_ sender: Any) {
        
//        if (checkStep1Validation() == true) {
//            self.step1()
//        }
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyBoard.instantiateViewController(withIdentifier: "AddMemberStep2VC") as! AddMemberStep2VC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  PaidEventsVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/03/2023.
//

import UIKit
import MapKit

class PaidEventsVC: UIViewController,MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var EvntImg: UIImageView!
    
    @IBOutlet weak var EvntTitle: UILabel!
    
    @IBOutlet weak var MapLocation: MKMapView!
    
    @IBOutlet weak var EvntLocationLabel: UILabel!
    
    @IBOutlet weak var EvntSchedule: UILabel!
    
    @IBOutlet weak var EvntAddess: UILabel!
    
    @IBOutlet weak var EventOrganiser: UILabel!
    
    @IBOutlet weak var EventOrganiserGender: UILabel!
    
    @IBOutlet weak var EvntCharges: UILabel!
    
    @IBOutlet weak var EvntHeader: UILabel!
    
    @IBOutlet weak var EvntAbout: UILabel!
    
    @IBOutlet weak var EvntAboutDesc: UILabel!
    
    @IBOutlet weak var ImgTime: UIImageView!
    
    @IBOutlet weak var ImgAddress: UIImageView!
    
    @IBOutlet weak var ImgGender: UIImageView!
    
    @IBOutlet weak var ImgCharges: UIImageView!
    
    @IBOutlet weak var ImgOrganiser: UIImageView!
    
    @IBOutlet weak var ButtonView: UIView!
    
    @IBAction func RegisterButton(_ sender: UIButton) {
    }
    
    @IBOutlet weak var RegisterLabel: UILabel!
    
    @IBOutlet weak var ImgRegisterArrow: UIImageView!
    
    
    
    @IBOutlet weak var EventNavigation: UIView!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

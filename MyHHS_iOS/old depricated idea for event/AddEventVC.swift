//
//  AddEventVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 27/12/2021.
//

import UIKit

class AddEventVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: "events".localized, showbtn: "back")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: "events".localized, showbtn: "back")
    }

    @IBAction func onAddEventsClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "ConfirmEventVC") as! ConfirmEventVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

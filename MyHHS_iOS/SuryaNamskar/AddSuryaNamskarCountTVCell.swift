//
//  AddSuryaNamskarCountTVCell.swift
//  MyHHS_iOS
//
//  Created by Patel on 28/01/2022.
//

import UIKit

class AddSuryaNamskarCountTVCell: UITableViewCell {

    @IBOutlet weak var txtCount: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    
    static let cellIdentifier : String = {
        return String(describing: AddSuryaNamskarCountTVCell.self)
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

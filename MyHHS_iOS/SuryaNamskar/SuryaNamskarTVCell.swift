//
//  SuryaNamskarTVCell.swift
//  MyHHS_iOS
//
//  Created by Patel on 27/01/2022.
//

import UIKit

class SuryaNamskarTVCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    static let cellIdentifier : String = {
        return String(describing: SuryaNamskarTVCell.self)
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var model : SuryaNamskarData! {
        didSet {
            lblDate.text = changeDateFormate(model.count_date ?? "01/01/2020")
            lblTitle.text = "Count: \(model.count ?? "0")"
        }
    }
    
    func changeDateFormate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let resultString = dateFormatter.string(from: date!)
        return resultString
    }

}

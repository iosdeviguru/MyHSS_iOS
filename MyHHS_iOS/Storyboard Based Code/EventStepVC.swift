//
//  EventStepVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/03/2023.
//
// For Storyboard based Code for EVENTS
import UIKit



class EventStepVCTVCell: UITableViewCell {
    @IBOutlet weak var EventLbl: UILabel!
    @IBOutlet weak var EventSchedule: UILabel!
    
    @IBOutlet weak var ShakhaLbl: UILabel!
    
    @IBOutlet weak var EventImg: UIImageView!
    
}
class EventStepVC: UITableViewController{
    
    @IBOutlet weak var TableViewEvents: UITableView!
    @IBOutlet weak var dataSource: UITableViewDataSource!
   
    

//    var events: [Datum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
  
    }
    
 
    @IBOutlet weak var AddEventView: UIView!
    
    @IBAction func SegmentBtn(_ sender: UISegmentedControl) {
    }
    
}


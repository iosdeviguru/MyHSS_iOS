//
//  EventsVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 24/12/2021.
//

import UIKit
import SwiftyJSON
import ScrollableSegmentedControl

class AllEventsTVCell: UITableViewCell {
    
    @IBOutlet weak var imgActive: UIImageView!
    @IBOutlet weak var lblActive: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
}

class EventsVC: UIViewController {

    var items = ["all_events".localized, "upcoming_events".localized, "completed_events".localized]

    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    
    @IBOutlet weak var tableViewAllEvents: UITableView!
    @IBOutlet weak var tableViewUpcomingEvents: UITableView!
    @IBOutlet weak var tableViewCompletedEvents: UITableView!
    
//    var strNavigation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getScrollableSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationBarDesign(txt_title: strNavigation, showbtn: "back")
    }
    

    func getScrollableSegmentedControl() {
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.insertSegment(withTitle: items[0], image: nil, at: 0)
        segmentedControl.insertSegment(withTitle: items[1], image: nil, at: 1)
        segmentedControl.insertSegment(withTitle: items[2], image: nil, at: 2)
        
        segmentedControl.underlineSelected = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.fixedSegmentWidth = false
        
        segmentedControl.addTarget(self, action: #selector(EventsVC.segmentSelected(sender:)), for: .valueChanged)
        
        // change some colors
        segmentedControl.segmentContentColor = UIColor.black
        segmentedControl.selectedSegmentContentColor = UIColor.black
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = Colors.txtAppDarkColor
        
        let largerRedTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Colors.txtdarkGray]
        let largerRedTextHighlightAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Colors.txtAppDarkColor]
        let largerRedTextSelectAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: Colors.txtAppDarkColor]
        segmentedControl.setTitleTextAttributes(largerRedTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(largerRedTextHighlightAttributes, for: .highlighted)
        segmentedControl.setTitleTextAttributes(largerRedTextSelectAttributes, for: .selected)
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        print("Segment at index \(sender.selectedSegmentIndex)  selected")
        switch sender.selectedSegmentIndex {
        case 0:
            self.tableViewAllEvents.isHidden = false
            self.tableViewUpcomingEvents.isHidden = true
            self.tableViewCompletedEvents.isHidden = true
            self.firebaseAnalytics(_eventName: "All_Events")
            
        case 1:
            self.tableViewAllEvents.isHidden = true
            self.tableViewUpcomingEvents.isHidden = false
            self.tableViewCompletedEvents.isHidden = true
            self.firebaseAnalytics(_eventName: "Upcoming_Events")
        case 2:
            self.tableViewAllEvents.isHidden = true
            self.tableViewUpcomingEvents.isHidden = true
            self.tableViewCompletedEvents.isHidden = false
            self.firebaseAnalytics(_eventName: "Completed_Events")
        default:
            self.tableViewAllEvents.isHidden = false
            self.tableViewUpcomingEvents.isHidden = true
            self.tableViewCompletedEvents.isHidden = true
            self.firebaseAnalytics(_eventName: "All_Events")
        }
        
    }
    
    
}

extension EventsVC : UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewAllEvents {
            return 5
        } else if tableView == tableViewUpcomingEvents {
            return 5
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewAllEvents {

            let cell = tableViewAllEvents.dequeueReusableCell(withIdentifier: "AllEventsTVCell", for: indexPath) as! AllEventsTVCell
            
            let strFirstName : String = "Name \(indexPath.row)"
            
            cell.lblName.text = strFirstName
            
            cell.lblDetails.text = "xyz@gmail.com"
            cell.lblDate.text = "12/12/22"
            
            return cell
            
        } else if tableView == tableViewUpcomingEvents {
            let cell = tableViewUpcomingEvents.dequeueReusableCell(withIdentifier: "UpcomingEventsTVCell", for: indexPath) as! AllEventsTVCell
            
            let strFirstName : String = "Name \(indexPath.row + 100)"
            
            cell.lblName.text = strFirstName
            
            cell.lblDetails.text = "xyz@gmail.com"
            cell.lblDate.text = "1/1/21"
            return cell
        } else {
            let cell = tableViewCompletedEvents.dequeueReusableCell(withIdentifier: "CompleteEventsTVCell", for: indexPath) as! AllEventsTVCell
            
            let strFirstName : String = "Name \(indexPath.row + 500)"
            
            cell.lblName.text = strFirstName
            
            cell.lblDetails.text = "xyz@gmail.com"
            cell.lblDate.text = "1/5/21"
            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        selectedItemCompletion?(filteredArray[indexPath.row])
//        dismiss(animated: true, completion: nil)
        
//        if tableView == self.tableViewMyFamily {
//
//            self.getProfileAPI(memberId: filteredArray[indexPath.row]["member_id"] as! String)
//            let refreshAlert = UIAlertController(title: APP.title, message: "edit_message".localized, preferredStyle: UIAlertController.Style.alert)
//
//            refreshAlert.addAction(UIAlertAction(title: "edit".localized, style: .default, handler: { (action: UIAlertAction!) in
//                print("Handle Logout logic here")
//                _appDelegator.dicDataProfile = self.dicData
//                _appDelegator.dicMemberProfile = self.dicMember
//
//                let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddMemberStep1VC") as! AddMemberStep1VC
//                _appDelegator.userType = "self"
//                _appDelegator.isEdit = true
//                self.navigationController?.pushViewController(vc, animated: true)
//            }))
//            refreshAlert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//            }))
//            present(refreshAlert, animated: true, completion: nil)
//        } else
        let isBooked = true
        
        if isBooked {
            
            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        if #available(iOS 13.0, *) {
            viewFooter.backgroundColor = UIColor.systemGray5
        } else {
            // Fallback on earlier versions
        }
        let size = tableView.frame.size
        let lblNoResultFound = UILabel()
        lblNoResultFound.frame = CGRect(x: 0, y: 0, width: size.width, height: 100)
        lblNoResultFound.text = "no_results_found".localized
        lblNoResultFound.textColor = Colors.txtAppDarkColor
        lblNoResultFound.font = UIFont(name: "SourceSansPro-Regular", size: 20.0)
        lblNoResultFound.textAlignment = .center
        viewFooter.addSubview(lblNoResultFound)
        return viewFooter
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let data : Int = 5
        
        if tableView == tableViewAllEvents {
            if data > 0 {
                return 0
            }
            return 100
        } else if tableView == tableViewUpcomingEvents {
            if data > 0 {
                return 0
            }
            return 100
        } else {
            if data > 0 {
                return 0
            }
            return 100
        }
    }
}

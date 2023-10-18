//
//  MyShakhaVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/04/2021.
//

import UIKit
import SwiftyJSON
import ScrollableSegmentedControl

class MyFamilyTVCell: UITableViewCell {
    
    @IBOutlet weak var imgActive: UIImageView!
    @IBOutlet weak var lblActive: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var viewAgeCategories: UIView!
    @IBOutlet weak var lblAgeCategories: UILabel!
}

class GuruDakshinaTVCell: UITableViewCell {
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblTicketId: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    @IBOutlet weak var lblGuruDakshinaTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
}


class MyShakhaVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var items = ["my_family".localized, "my_shakha".localized, "guru_dakshina".localized]
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    
    @IBOutlet weak var scrollViewMyShakha: UIScrollView!
    
    @IBOutlet weak var btnAddFamilyMember: UIButton!
    @IBOutlet weak var tableViewMyFamily: UITableView!
    
    @IBOutlet weak var searchBarMyFamily: UISearchBar!
    
    @IBOutlet weak var membershipView: UIView!
    
    @IBOutlet weak var activeMemberView: UIView!
    
    @IBOutlet weak var inactiveMemberView: UIView!
    
    @IBOutlet weak var sankhyaView: UIView!
    var SearchBarValue:String!
    var searchActive : Bool = false
    var filteredArray : [[String: Any]] = []
    
    var dictFamilyMember = [[String:Any]]()
    var strNavigation = ""
    
    var dicData: [[String : Any]]?
    var dicMember: [[String : Any]]?
    
    @IBOutlet var lblMemberApplicationBadge: UILabel!
    
    // MARK: - Guru Dakshina
    @IBOutlet weak var btnOneTimeDakshina: UIButton!
    @IBOutlet weak var btnRegularDakshina: UIButton!
    @IBOutlet weak var tableViewGuruDakshina: UITableView!
    
    @IBOutlet weak var searchBarGuruDakshina: UISearchBar!
    
    @IBOutlet var viewShakhaDetails: UIView!
    @IBOutlet var viewcount: UIView!
    @IBOutlet var lblCount: UILabel!
    
    @IBOutlet var lblViewMyShakhaTitile: UILabel!
    @IBOutlet var lblViewMyShakha: UILabel!
    
    @IBOutlet var lblViewMyNagarTitle: UILabel!
    @IBOutlet var lbllblViewMyNagar: UILabel!
    
    @IBOutlet var lblViewMyVibhagTitle: UILabel!
    @IBOutlet var lblViewMyVibhag: UILabel!
    
    var strCount = "0"
    ////    var searchActive : Bool = false
    var filteredArrayGuruDakshina : [[String: Any]] = []
    
    var dictGuruDakshina = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "myshakha_icon", bagdeVal: "0", isBadgeHidden: false)
        
        
        self.lblMemberApplicationBadge.isHidden = true
        self.lblMemberApplicationBadge.layer.cornerRadius = self.lblMemberApplicationBadge.frame.height / 2
        self.lblMemberApplicationBadge.layer.masksToBounds = true
        
        self.fillData()
        self.getScrollableSegmentedControl()
        //        self.getFamilyMemberAPI()
        self.getGuruDakshinaAPI()
        if let role = _appDelegator.dicDataProfile![0]["role"] as? String, role == "Sankhya Pramukh" {
            self.membershipView.isHidden = true
            self.activeMemberView.isHidden = true
            self.inactiveMemberView.isHidden = true
            
            viewDidLayoutSubviews()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // condition to check the role and show the my shakha features accordingly
        
        
        
        
        
        if _appDelegator.dicMemberProfile![0]["shakha_tab"] as? String == "yes" {
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "myshakha_icon", bagdeVal: strCount, isBadgeHidden: false)
            
            
        } else {
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "", bagdeVal: "", isBadgeHidden: true)
        }
        
        self.getFamilyMemberAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Check if other views are hidden
        if membershipView.isHidden && activeMemberView.isHidden && inactiveMemberView.isHidden  {
            // Adjust the position of the specific view
            let newFrame = CGRect(x: sankhyaView.frame.origin.x, y: 0, width: sankhyaView.frame.size.width, height: sankhyaView.frame.size.height)
            sankhyaView.frame = newFrame
        }
    }
    
    
    
    func fillData() {
        
        
        self.viewShakhaDetails.isHidden = true
        self.viewcount.roundCorners(corners: [.bottomRight], radius: 7.0)
        self.viewcount.layer.masksToBounds = true
        
        
        if let shakhaSankhyaAvgCount : Int = _appDelegator.dicMemberProfile![0]["shakha_sankhya_avg"] as? Int {
            strCount = String(shakhaSankhyaAvgCount)
        }
        self.lblCount.text = strCount
        
        if let strSakhaName = _appDelegator.dicMemberProfile![0]["shakha"] as? String {
            self.lblViewMyShakha.text = strSakhaName
        }
        if let strNagarName = _appDelegator.dicMemberProfile![0]["nagar"] as? String {
            self.lbllblViewMyNagar.text = strNagarName
        }
        if let strVibhagName = _appDelegator.dicMemberProfile![0]["vibhag"] as? String {
            self.lblViewMyVibhag.text = strVibhagName
        }
        
    }
    
    
    override func rightBarItemClicked(_ sender: UIButton) {
        print("New...")
        self.viewShakhaDetails.isHidden = false
        self.firebaseAnalytics(_eventName: "MyShakhaInfoVC")
    }
    
    @IBAction func onCloseViewClick(_ sender: UIButton) {
        self.viewShakhaDetails.isHidden = true
        self.firebaseAnalytics(_eventName: "MyShakhaVC")
    }
    
    func getScrollableSegmentedControl() {
        self.items.removeAll()
        if _appDelegator.dicMemberProfile![0]["shakha_tab"] as? String == "yes" {
            items = ["my_family".localized, "my_shakha".localized, "guru_dakshina".localized]
            
            segmentedControl.insertSegment(withTitle: items[0], image: nil, at: 0)
            segmentedControl.insertSegment(withTitle: items[1], image: nil, at: 1)
            segmentedControl.insertSegment(withTitle: items[2], image: nil, at: 2)
        } else {
            items = ["my_family".localized, "guru_dakshina".localized]
            
            segmentedControl.insertSegment(withTitle: items[0], image: nil, at: 0)
            segmentedControl.insertSegment(withTitle: items[1], image: nil, at: 1)
        }
        
        segmentedControl.segmentStyle = .textOnly
        
        segmentedControl.underlineSelected = true
        
        if strNavigation == "My Shakha" {
            segmentedControl.selectedSegmentIndex = 1
            self.scrollViewMyShakha.isHidden = false
            self.tableViewMyFamily.isHidden = true
            self.btnAddFamilyMember.isHidden = true
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "myshakha_icon", bagdeVal: strCount, isBadgeHidden: false)
            self.firebaseAnalytics(_eventName: "MyShakhaVC")
        } else {
            segmentedControl.selectedSegmentIndex = 0
            self.scrollViewMyShakha.isHidden = true
            self.tableViewMyFamily.isHidden = false
            self.btnAddFamilyMember.isHidden = false
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "", bagdeVal: "", isBadgeHidden: false)
            self.firebaseAnalytics(_eventName: "MyFamilyVC")
        }
        
        self.tableViewGuruDakshina.isHidden = true
        self.btnOneTimeDakshina.isHidden = true
        self.btnRegularDakshina.isHidden = true
        
        // Turn off all segments been fixed/equal width.
        // The width of each segment would be based on the text length and font size.
        segmentedControl.fixedSegmentWidth = false
        
        segmentedControl.addTarget(self, action: #selector(ProfileVC.segmentSelected(sender:)), for: .valueChanged)
        
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
            self.btnAddFamilyMember.isHidden = false
            self.tableViewMyFamily.isHidden = false
            self.scrollViewMyShakha.isHidden = true
            self.tableViewGuruDakshina.isHidden = true
            self.btnOneTimeDakshina.isHidden = true
            self.btnRegularDakshina.isHidden = true
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "", bagdeVal: "", isBadgeHidden: true)
            self.firebaseAnalytics(_eventName: "MyFamilyVC")
        case 1:
            if _appDelegator.dicMemberProfile![0]["shakha_tab"] as? String == "yes" {
                self.btnAddFamilyMember.isHidden = true
                self.tableViewMyFamily.isHidden = true
                self.scrollViewMyShakha.isHidden = false
                self.tableViewGuruDakshina.isHidden = true
                self.btnOneTimeDakshina.isHidden = true
                self.btnRegularDakshina.isHidden = true
                navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "myshakha_icon", bagdeVal: strCount, isBadgeHidden: false)
                self.firebaseAnalytics(_eventName: "MyShakhaVC")
            } else {
                self.btnAddFamilyMember.isHidden = true
                self.tableViewMyFamily.isHidden = true
                self.scrollViewMyShakha.isHidden = true
                self.tableViewGuruDakshina.isHidden = false
                self.btnOneTimeDakshina.isHidden = false
                self.btnRegularDakshina.isHidden = false
                navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "", bagdeVal: "", isBadgeHidden: true)
                self.firebaseAnalytics(_eventName: "GuruDakshinaaVC")
            }
        case 2:
            self.btnAddFamilyMember.isHidden = true
            self.tableViewMyFamily.isHidden = true
            self.scrollViewMyShakha.isHidden = true
            self.tableViewGuruDakshina.isHidden = false
            self.btnOneTimeDakshina.isHidden = false
            self.btnRegularDakshina.isHidden = false
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "", bagdeVal: "", isBadgeHidden: true)
            self.firebaseAnalytics(_eventName: "GuruDakshinaaVC")
        default:
            self.btnAddFamilyMember.isHidden = true
            self.tableViewMyFamily.isHidden = true
            self.scrollViewMyShakha.isHidden = false
            self.tableViewGuruDakshina.isHidden = true
            self.btnOneTimeDakshina.isHidden = true
            self.btnRegularDakshina.isHidden = true
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "myshakha_icon", bagdeVal: strCount, isBadgeHidden: false)
            self.firebaseAnalytics(_eventName: "MyShakhaVC")
        }
        
    }
    
    // MARK: - Button Actions
    @IBAction func onAddFamilyMemberClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "AddMemberStep1VC") as! AddMemberStep1VC
        _appDelegator.userType = "family"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onMembershipApplicationsClick(_ sender: UIButton) {
        
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "MembershipApplicationsVC") as! MembershipApplicationsVC
        vc.strStatus = "0"
        self.navigationController?.pushViewController(vc, animated: true)
       
        
    }
    
    @IBAction func onActiveMembersClick(_ sender: UIButton) {
        
        
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "MembershipApplicationsVC") as! MembershipApplicationsVC
        vc.strStatus = "1"  //  1 active
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func onInActiveMembersClick(_ sender: UIButton) {
        
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "MembershipApplicationsVC") as! MembershipApplicationsVC
        vc.strStatus = "4"    // 4 inactive
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func onSankhyaClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "SankhyaVC") as! SankhyaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onOneTimeDakhsinaClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "OneTimeGuruDakshinaVC") as! OneTimeGuruDakshinaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onRegularDakhinaClick(_ sender: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "RegularGuruDakshinaStep1VC") as! RegularGuruDakshinaStep1VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewMyFamily {
            return self.filteredArray.count
        } else {
            return self.filteredArrayGuruDakshina.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewMyFamily {
            
            let cell = tableViewMyFamily.dequeueReusableCell(withIdentifier: "MyFamilyTVCell", for: indexPath) as! MyFamilyTVCell
            
            let strFirstName : String = filteredArray[indexPath.row]["first_name"] as! String
            let strMiddleName : String = filteredArray[indexPath.row]["middle_name"] as! String
            let strLastName : String = filteredArray[indexPath.row]["last_name"] as! String
            
            strMiddleName == "" ? (cell.lblName.text = "\(strFirstName) \(strLastName)") : (cell.lblName.text = "\(strFirstName) \(strMiddleName) \(strLastName)")
            
            cell.viewAgeCategories.roundCorners(corners: [.topLeft], radius: 10.0)
            cell.viewAgeCategories.layer.masksToBounds = true
            
            cell.lblDetails.text = filteredArray[indexPath.row]["chapter_name"] as? String
            cell.lblEmail.text = filteredArray[indexPath.row]["email"] as? String
            cell.lblMobileNo.text = filteredArray[indexPath.row]["mobile"] as? String
            
            filteredArray[indexPath.row]["status"] as! String == "1" ? (cell.lblActive.text = "Active") : (cell.lblActive.text = "Inactive")
            filteredArray[indexPath.row]["status"] as! String == "1" ? (cell.lblActive.textColor = UIColor(red: 40.0/255.0, green: 167.0/255.0, blue: 69.0/255.0, alpha: 1.0)) : (cell.lblActive.textColor = UIColor(red: 213.0/255.0, green: 75.0/255.0, blue: 61.0/255.0, alpha: 1.0))
            filteredArray[indexPath.row]["status"] as! String == "1" ? (cell.imgActive.image = UIImage(named:"approve")) : (cell.imgActive.image = UIImage(named:"Inactive"))
            
            let strAgeCategories = filteredArray[indexPath.row]["age_categories"] as? String
            cell.lblAgeCategories.text = strAgeCategories?.lowercased()
            
            switch strAgeCategories?.lowercased() {
            case "male_shishu":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Shishu_male
            case "female_shishu":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Shishu_female
            case "baal":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Baal
            case "baalika":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Baalika
            case "kishore":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Kishore
            case "kishori":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Kishori
            case "tarun":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Tarun
            case "taruni":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Taruni
            case "yuva":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Yuva
            case "yuvati":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Yuvati
            case "jyeshta":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Proudh
            case "jyeshtaa":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Proudha
            case "proudh":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Proudh
            case "proudha":
                cell.viewAgeCategories.backgroundColor = AgeCategories.Proudha
            default:
                cell.viewAgeCategories.backgroundColor = Colors.bglightGray
            }
            
            return cell
            
        } else {
            let cell = tableViewGuruDakshina.dequeueReusableCell(withIdentifier: "GuruDakshinaTVCell", for: indexPath) as! GuruDakshinaTVCell
            
            let strFirstName : String = filteredArrayGuruDakshina[indexPath.row]["first_name"] as! String
            let strLastName : String = filteredArrayGuruDakshina[indexPath.row]["last_name"] as! String
            
            strLastName == "" ? (cell.lblName.text = "\(strFirstName)") : (cell.lblName.text = "\(strFirstName) \(strLastName)")
            
            if let strShakhaName = filteredArrayGuruDakshina[indexPath.row]["chapter_name"] as? String {
                cell.lblDetails.text = strShakhaName
            }
            if let strDakshina = filteredArrayGuruDakshina[indexPath.row]["dakshina"] as? String {
                cell.lblPaymentType.text = strDakshina
            }
            //            cell.lblTicketId.text = filteredArrayGuruDakshina[indexPath.row]["order_id"] as? String
            if let strPaidAmount = filteredArrayGuruDakshina[indexPath.row]["paid_amount"] as? String {
                cell.lblAmount.text = "£ \(strPaidAmount)"
            }
            if let strDate = filteredArrayGuruDakshina[indexPath.row]["created_at"] as? String {
                cell.lblDate.text = strDate
            }
            
            if let strOrderId = filteredArrayGuruDakshina[indexPath.row]["order_id"] as? String {
                filteredArrayGuruDakshina[indexPath.row]["dakshina"] as! String != "Regular" ? (cell.lblTicketId.text = "") : (cell.lblTicketId.text = strOrderId)
            }
            
            filteredArrayGuruDakshina[indexPath.row]["dakshina"] as! String == "Regular" ? (cell.viewHeader.backgroundColor = UIColor(red: 255.0/255.0, green: 238.0/255.0, blue: 210.0/255.0, alpha: 1.0)) : (cell.viewHeader.backgroundColor = UIColor(red: 232.0/255.0, green: 243.0/255.0, blue: 255.0/255.0, alpha: 1.0))
            
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
        if tableView == self.tableViewGuruDakshina {
            
            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "MembershipApplicationsDetailsVC") as! MembershipApplicationsDetailsVC
            vc.dictData = filteredArrayGuruDakshina[indexPath.row]
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
        if tableView == self.tableViewMyFamily {
            if self.filteredArray.count > 0 {
                return 0
            }
            return 100
        } else {
            if self.filteredArrayGuruDakshina.count > 0 {
                return 0
            }
            return 100
        }
    }
    
    // MARK: SerchBar Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        tableViewMyFamily.resignFirstResponder()
        self.searchBarMyFamily.showsCancelButton = false
        tableViewMyFamily.reloadData()
        tableViewGuruDakshina.resignFirstResponder()
        self.searchBarGuruDakshina.showsCancelButton = false
        tableViewGuruDakshina.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar == self.searchBarMyFamily {
            self.searchActive = true;
            self.searchBarMyFamily.showsCancelButton = true
            
            self.filteredArray.removeAll()
            
            DispatchQueue.global(qos: .background).async {
                //  Filter technique 2
                self.filteredArray = self.dictFamilyMember.filter{
                    //                let string = $0["first_name"] as! String
                    let string = $0["first_name"] as! String
                    let stringLastName = $0["last_name"] as! String
                    let stringEmail = $0["email"] as! String
                    let stringMobile = $0["mobile"] as! String
                    return (string.hasPrefix(searchText.lowercased()) || stringLastName.hasPrefix(searchText.lowercased()) || stringEmail.hasPrefix(searchText.lowercased()) || stringMobile.hasPrefix(searchText.lowercased()))
                }
                
                if self.filteredArray.isEmpty {
                    self.searchActive = false
                } else {
                    self.searchActive = true
                }
                
                DispatchQueue.main.async {
                    self.tableViewMyFamily.reloadData()
                }
            }
        } else {
            self.searchActive = true;
            self.searchBarGuruDakshina.showsCancelButton = true
            
            self.filteredArrayGuruDakshina.removeAll()
            
            DispatchQueue.global(qos: .background).async {
                //  Filter technique 2
                self.filteredArrayGuruDakshina = self.dictGuruDakshina.filter{
                    //                let string = $0["first_name"] as! String
                    let string = $0["first_name"] as! String
                    let stringLastName = $0["last_name"] as! String
                    return (string.hasPrefix(searchText.lowercased()) || stringLastName.hasPrefix(searchText.lowercased()))
                }
                
                if self.filteredArrayGuruDakshina.isEmpty {
                    self.searchActive = false
                } else {
                    self.searchActive = true
                }
                
                DispatchQueue.main.async {
                    self.tableViewGuruDakshina.reloadData()
                }
            }
        }
    }
    
    
    // MARK: - API Functions
    
    func getFamilyMemberAPI() {
        
        //         var dicUserDetails : [String:Any] = [:]
        //         dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String //    dicUserDetails["user_id"]
        parameters["member_id"] = _appDelegator.dicDataProfile![0]["member_id"] as? String //dicUserDetails["member_id"]
        parameters["tab"] = "family"   //  family or kendra or shakha
        parameters["status"] = "all"   //  status = all, 0 pending, 1 active, 3 rejected, 4 inactive
        parameters["start"] = "0"
        parameters["length"] = "20"
        parameters["search"] = ""
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_listing, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                   
                    
                    
                    if status == 1
                    {
                        let arr = jsonData!["data"]
                        print(arr)
                        self.lblMemberApplicationBadge.isHidden = true
                        self.lblMemberApplicationBadge.text = "\(arr.count)"
                        self.dictFamilyMember = arr.object as? [[String : Any]] ?? []
                        //                        for index in 0..<arr.count {
                        //                            var dict = [String : Any]()
                        //                            dict["middle_name"] = arr[index]["middle_name"].string
                        //                            dict["rejection_msg"] = arr[index]["rejection_msg"].string
                        //                            dict["age_categories"] = arr[index]["age_categories"].string
                        //                            dict["gender"] = arr[index]["gender"].string
                        //                            dict["member_id"] = arr[index]["member_id"].string
                        //                            dict["mobile"] = arr[index]["mobile"].string
                        //                            dict["dob"] = arr[index]["dob"].string
                        //                            dict["is_admin_approved"] = arr[index]["is_admin_approved"].string
                        //                            dict["org_name"] = arr[index]["org_name"].string
                        //                            dict["email"] = arr[index]["email"].string
                        //                            dict["status"] = arr[index]["status"].string
                        //                            dict["is_email_verified"] = arr[index]["is_email_verified"].string
                        //                            dict["chapter_name"] = arr[index]["chapter_name"].string
                        //                            dict["first_name"] = arr[index]["first_name"].string
                        //                            dict["is_guardian_approved"] = arr[index]["is_guardian_approved"].string
                        //                            dict["last_name"] = arr[index]["last_name"].string
                        //                            self.dictFamilyMember.append(dict)
                        //                        }
                        self.filteredArray = self.dictFamilyMember
                        
                        DispatchQueue.main.async {
                            self.tableViewMyFamily.reloadData()
                        }
                    }else {
                        if let strError = jsonData!["message"].string {
                            //                             showAlert(title: APP.title, message: strError)
                            print(strError)
                        }
                    }
                }
                else {
                    if let strError = jsonData!["message"].string {
                        showAlert(title: APP.title, message: strError)
                    }
                }
            }
        }
    }
    
    func getGuruDakshinaAPI() {
        
        //        var dicUserDetails : [String:Any] = [:]
        //        dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
        
        var parameters: [String: Any] = [:]
        parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String // dicUserDetails["user_id"]
        parameters["chapter_id"] = _appDelegator.dicDataProfile![0]["member_id"] as? String //  dicUserDetails["member_id"]
        parameters["start"] = "0"
        parameters["length"] = "20"
        parameters["search"] = ""
        print(parameters)
        
        APIManager.sharedInstance.callPostApi(url: APIUrl.get_dakshina_list, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        let arr = jsonData!["data"]
                        print(arr)
                        self.dictGuruDakshina = arr.object as? [[String : Any]] ?? []
                        //                        for index in 0..<arr.count {
                        //                            var dict = [String : Any]()
                        //                            dict["address_line"] = arr[index]["address_line"].string
                        //                            dict["age_category"] = arr[index]["age_category"].string
                        //                            dict["buyer_email"] = arr[index]["buyer_email"].string
                        //                            dict["buyer_name"] = arr[index]["buyer_name"].string
                        //                            dict["cancel_date"] = arr[index]["cancel_date"].string
                        //                            dict["chapter_name"] = arr[index]["chapter_name"].string
                        //                            dict["city"] = arr[index]["city"].string
                        //                            dict["country"] = arr[index]["country"].string
                        //                            dict["created_at"] = arr[index]["created_at"].string
                        //                            dict["created_by"] = arr[index]["created_by"].string
                        //                            dict["currency"] = arr[index]["currency"].string
                        //                            dict["dakshina"] = arr[index]["dakshina"].string
                        //                            dict["first_name"] = arr[index]["first_name"].string
                        //                            dict["gift_aid"] = arr[index]["gift_aid"].string
                        //                            dict["id"] = arr[index]["id"].string
                        //                            dict["is_linked_member"] = arr[index]["is_linked_member"].string
                        //                            dict["is_purnima_dakshina"] = arr[index]["is_purnima_dakshina"].string
                        //                            dict["last_name"] = arr[index]["last_name"].string
                        //                            dict["member_id"] = arr[index]["member_id"].string
                        //                            dict["nidhi_notes"] = arr[index]["nidhi_notes"].string
                        //                            dict["order_id"] = arr[index]["order_id"].string
                        //                            dict["paid_amount"] = arr[index]["paid_amount"].string
                        //                            dict["postcode"] = arr[index]["postcode"].string
                        //                            dict["recurring"] = arr[index]["recurring"].string
                        //                            dict["shakha_id"] = arr[index]["shakha_id"].string
                        //                            dict["start_date"] = arr[index]["start_date"].string
                        //                            dict["status"] = arr[index]["status"].string
                        //                            dict["txn_id"] = arr[index]["txn_id"].string
                        //                            self.dictGuruDakshina.append(dict)
                        //                        }
                        self.filteredArrayGuruDakshina = self.dictGuruDakshina
                        
                        DispatchQueue.main.async {
                            self.tableViewGuruDakshina.reloadData()
                        }
                    }else {
                        if let strError = jsonData!["message"].string {
                            //                            showAlert(title: APP.title, message: strError)
                            print(strError)
                        }
                    }
                }
                else {
                    if let strError = jsonData!["message"].string {
                        showAlert(title: APP.title, message: strError)
                    }
                }
            }
        }
    }
    
    
    //    // MARK: - API Functions
    //
    //    func getProfileAPI(memberId : String) {
    ////         var dicUserDetails : [String:Any] = [:]
    //
    //        let isKeyPresent = self.isKeyPresentInUserDefaults(key: "user_details")
    //
    //        if !isKeyPresent {
    //            return
    //        }
    ////         dicUserDetails = _userDefault.get(key: "user_details") as! [String : Any]
    //
    //         var parameters: [String: Any] = [:]
    //         parameters["user_id"] = _appDelegator.dicMemberProfile![0]["user_id"] as? String //    dicUserDetails["user_id"]
    //         parameters["member_id"] = memberId//dicUserDetails["member_id"]
    //         print(parameters)
    //
    //        APIManager.sharedInstance.callPostApi(url: APIUrl.get_profile, parameters: parameters) { (jsonData, error) in
    //             if error == nil
    //             {
    //                 if let status = jsonData!["status"].int
    //                 {
    //                     if status == 1
    //                     {
    //                        let dicResponse = jsonData?.dictionaryObject
    //                        print(dicResponse!)
    //                        self.dicData = dicResponse!["data"] as? [[String : Any]]
    //                        self.dicMember = dicResponse!["member"] as? [[String : Any]]
    //                     }else {
    //                         if let strError = jsonData!["message"].string {
    //                             showAlert(title: APP.title, message: strError)
    //                         }
    //                     }
    //                 }
    //                 else {
    //                     if let strError = jsonData!["message"].string {
    //                         showAlert(title: APP.title, message: strError)
    //                     }
    //                 }
    //             }
    //         }
    //     }
    
}

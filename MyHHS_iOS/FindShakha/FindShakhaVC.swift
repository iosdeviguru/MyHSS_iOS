//
//  FindShakhaVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 22/07/2021.
//

import UIKit
import GoogleMaps
import Alamofire

class FindShakhaTVCell: UITableViewCell {
        
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    var model : ShakhaData! {
        didSet {
            lblTitle.text = model.postal_code
        }
    }
}

class FindShakhaListTVCell: UITableViewCell {
        
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDayTime: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContactPerson: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnContactNo: UIButton!
    @IBOutlet weak var btnGetDirection: UIButton!
    
    
    var modelList : ShakhaData! {
        didSet {
            lblTitle.text = modelList.chapter_name
            lblAddress.text = "\(modelList.address_line_1 ?? ""), \(modelList.address_line_2 ?? ""), \(modelList.city ?? ""), \(modelList.county ?? ""), \(modelList.country ?? ""), \(modelList.postal_code ?? "")"
            self.lblDayTime.text = ""
            if let str = modelList.start_time {
                if let endTime = modelList.end_time {
                    if !str.isEmpty && !endTime.isEmpty {
                        let strStartTime = str.timeConversion12(time24: str)
                        let strEndTime = endTime.timeConversion12(time24: endTime)
                        if !strStartTime.isEmpty || !strEndTime.isEmpty {
                            self.lblDayTime.text = "\(modelList.day ?? "") : \(strStartTime) - \(strEndTime)"
                        }
                    }
                }
            }
            lblContactPerson.text = "Contact Person: " + modelList.contact_person_name!
            
            let main_string_email = "Email: " + modelList.email!
            let string_to_color_email = "Email: "
            let range_email = (main_string_email as NSString).range(of: string_to_color_email)
            let attributedString_email = NSMutableAttributedString(string:main_string_email)
            attributedString_email.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range_email)
            
            lblDistance.text = "\(modelList.distance ?? 0.0)" + " Miles"
            lblEmail.attributedText = attributedString_email

            let main_string = "Phone: " + modelList.phone!
            let string_to_color = "Phone: "
            let range = (main_string as NSString).range(of: string_to_color)
            let attributedString = NSMutableAttributedString(string:main_string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: range)

            lblContactNo.attributedText = attributedString //"Phone: " + modelList.phone!
            //            lblDistance.text = ""
        }
    }
}

class FindShakhaVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet var tableViewList: UITableView!
    @IBOutlet weak var viewSearchBarList: UIView!
    @IBOutlet weak var searchBarList: UISearchBar!
    @IBOutlet weak var heightSearchListView: NSLayoutConstraint!
    var filteredArrayList : [ShakhaData] = []
    var responseArrayList : [ShakhaData] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var heightSearchView: NSLayoutConstraint!
    
    var SearchBarValue:String!
    var searchActive : Bool = false
    var filteredArray : [ShakhaData] = []
    var responseArray : [ShakhaData] = []
    
    var strNavigation = ""
    
    @IBOutlet var slider: UISlider!
    @IBOutlet weak var lblSliderValue: UILabel!
    @IBOutlet var hightFilterConstraint: NSLayoutConstraint!
    @IBOutlet var btnFilter: UIButton!
    var sliderVal : Int = 15000
    
    var dictFindShakha = [[String:Any]]()
    
    var locationManager: CLLocationManager = CLLocationManager()
    var latValue = CLLocationDegrees()
    var longValue = CLLocationDegrees()
    var markerArray = Array<Any>()
//    var i : Int = 0
//    var origin = String()
//    var destination = String()
//    var mapView: GMSMapView = GMSMapView()
    @IBOutlet var mapView: GMSMapView!
    private var infoWindow = MapInfoWindow()
    // MARK: Needed to create the custom info window
    var locationMarker : GMSMarker? = GMSMarker()
    
    var shakhaResponseDM : ShakhaResponseDM?
    
    var shakhaData : [ShakhaData] {
        return shakhaResponseDM?.shakhaData ?? []
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationBarDesign(txt_title: strNavigation, showbtn: "back")
        self.tableView.isHidden = true
        
        
        hightFilterConstraint.constant = 0.0
        self.btnFilter.layer.cornerRadius = 10.0
        self.btnFilter.layer.masksToBounds = true
        
        self.searchBar.isHidden = false
        self.heightSearchView.constant = 60
        
        if BaseURL == prodURL {
            sliderVal = 15
        }
        //  Initialize Slider
        self.slider.value = Float(self.sliderVal)
        lblSliderValue.text = "\(self.sliderVal)"
        lblSliderValue.center = setUISliderThumbValueWithLabel(slider: self.slider)
        
        print(GMSServices.openSourceLicenseInfo())
                
        //  Get current location
        getCurrentLocation()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
//        infoWindow = loadNiB()
        self.findShakhaAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tableViewList.isHidden {
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "map_list", bagdeVal: "", isBadgeHidden: true)
        } else {
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "map_location", bagdeVal: "", isBadgeHidden: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        mapView.clear()
    }
    
    override func rightBarItemClicked(_ sender: UIButton) {
        
        if self.tableViewList.isHidden {
            infoWindow.removeFromSuperview()
            if hightFilterConstraint.constant == 100 {
                hightFilterConstraint.constant = 0
                self.btnFilter.setImage(UIImage(named: "scale_miles_"), for: .normal)
            }
            self.searchBar.resignFirstResponder()
            self.viewSearchBarList.isHidden = false
            self.tableViewList.isHidden = false
            self.tableView.isHidden = true
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "map_location", bagdeVal: "", isBadgeHidden: true)
        } else {
            self.searchBarList.resignFirstResponder()
            self.viewSearchBarList.isHidden = true
            self.tableViewList.isHidden = true
            self.tableView.isHidden = true
            navigationBarWithRightButtonDesign(txt_title: strNavigation, showbtn: "back", rightImg: "map_list", bagdeVal: "", isBadgeHidden: true)
            self.filteredArray = self.filteredArrayList
            self.initializeYourMap()
        }
    }

    
    @IBAction func onSliderValueChange(_ sender: UISlider) {
        
        self.sliderVal = Int(round(sender.value))
        lblSliderValue.text = "\(self.sliderVal)"
        lblSliderValue.center = setUISliderThumbValueWithLabel(slider: sender)
        self.initializeYourMap()
    }
    
    func setUISliderThumbValueWithLabel(slider: UISlider) -> CGPoint {
        let sliderTrack: CGRect = slider.trackRect(forBounds: slider.bounds)
        let sliderFrm: CGRect = slider.thumbRect(forBounds: slider.bounds, trackRect: sliderTrack, value: slider.value)
        return CGPoint(x: sliderFrm.origin.x + slider.frame.origin.x + 12, y: slider.frame.origin.y + 50)
    }
    
    func getCurrentLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization() // Call the authorizationStatus() class

        if CLLocationManager.locationServicesEnabled() { // get my current locations lat, lng
            
            let lat = locationManager.location?.coordinate.latitude
            let long = locationManager.location?.coordinate.longitude
            if let lattitude = lat  {
                if let longitude = long {
                    latValue = lattitude
                    longValue = longitude
                    
                    let camera = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 9.0)
                    mapView.camera = camera
                } else {
                    
                }
            } else {
                print("problem to find lat and lng")
            }
        }
        else {
            print("Location Service not Enabled. Plz enable u'r location services")
        }
    }
    
    func initializeYourMap() {

         for item in filteredArray {
            let latitude : Double = Double(item.latitude!) ?? 0.0 //(item as AnyObject).value(forKey: "lat")
            let longitude : Double = Double(item.longitude!) ?? 0.0 //(item as AnyObject).value(forKey: "long")
            let titleString : String = item.chapter_name ?? "" //(item as AnyObject).value(forKey: "title")

//            drawMarker(title: titleString, lat: latitude , long: longitude)
//             drawPath(title: titleString as! String, lat: latitude as! CLLocationDegrees , long: longitude as! CLLocationDegrees)
//            print("\(item.chapter_name!): \(self.distanceTwoCoordinates(lat: latitude, long: longitude))")
            mapView.clear()
            if distanceTwoCoordinates(lat: latitude, long: longitude) {
                drawMarker(title: titleString, orgChapterId: item.org_chapter_id!, lat: latitude , long: longitude)
            }
         }
 }
    
    func initializeYourMapByPostalCode(postCode: String) {

         for item in filteredArray {
            if postCode == item.postal_code {
                let latitude : Double = Double(item.latitude!) ?? 0.0
                let longitude : Double = Double(item.longitude!) ?? 0.0
                let titleString : String = item.chapter_name ?? ""

                mapView.clear()
                if distanceTwoCoordinates(lat: latitude, long: longitude) {
                    drawMarker(title: titleString, orgChapterId: item.org_chapter_id!, lat: latitude , long: longitude)
                }
            }
         }
 }
    
    func drawMarker(title: String, orgChapterId: String, lat: CLLocationDegrees , long: CLLocationDegrees) {
        
        DispatchQueue.main.async(execute: { [self] in
            
                    
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 9.0)
            mapView.camera = camera
            
            let position = CLLocationCoordinate2D(latitude: lat,longitude: long)
//            let marker = GMSMarker(position: position)
//            marker.title = title
//            marker.snippet = orgChapterId
//            marker.icon = UIImage(named: "solid-flag")
//            marker.setIconSize(scaledToSize: .init(width: 30, height: 30))
//            marker.map = self.mapView
            
            self.locationMarker = GMSMarker(position: position)
            self.locationMarker?.title = title
            self.locationMarker?.snippet = orgChapterId
            self.locationMarker?.icon = UIImage(named: "solid-flag")
            self.locationMarker?.setIconSize(scaledToSize: .init(width: 30, height: 30))
            self.locationMarker?.map = self.mapView
        })
    }
    
    func drawPath(title: String, lat: CLLocationDegrees , long: CLLocationDegrees) {
        print("Not working right now................!!!")
//        if i == 0 {
//             origin = "\(lat),\(long)"
//             destination = "\(lat),\(long)"
//
//        } else {
//            destination = "\(lat),\(long)"
//        }
//        i=1
//
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
//        origin = "\(lat),\(long)"
//        AF.request(url).responseJSON { response in
//
//            let json = try!  JSON(data: response.data!)
//            let routes = json["routes"].arrayValue
//
//            for route in routes
//            {
//                let routeOverviewPolyline = route["overview_polyline"].dictionary
//                let points = routeOverviewPolyline?["points"]?.stringValue
//                let path = GMSPath.init(fromEncodedPath: points!)
//                let polyline = GMSPolyline.init(path: path)
//                polyline.strokeWidth = 4
//                polyline.strokeColor = UIColor.red
//                polyline.map = self.mapView
//            }
//
//        }
    }
    
    func distanceTwoCoordinates(lat: CLLocationDegrees , long: CLLocationDegrees) -> Bool {
        let coordinate0 = CLLocation(latitude: self.latValue, longitude: longValue)
        let coordinate1 = CLLocation(latitude: lat, longitude: long)
        
        let distanceInMiles = coordinate0.distance(from: coordinate1) / 1609.344 // Miles
        return Int(distanceInMiles) <= self.sliderVal ? true : false
    }
    
    func distanceTwoCoordinates2(lat: CLLocationDegrees , long: CLLocationDegrees) -> String {
        let coordinate0 = CLLocation(latitude: self.latValue, longitude: longValue)
        let coordinate1 = CLLocation(latitude: lat, longitude: long)
        
        let distanceInMiles = coordinate0.distance(from: coordinate1) / 1609.344 // Miles
        if distanceInMiles <= Double(self.sliderVal) {
            return String(format: "%.1f", distanceInMiles)
        }
        return "0"
    }
    
    @IBAction func onFilterClick(_ sender: UIButton) {
        self.tableView.isHidden = true
        if hightFilterConstraint.constant == 100 {
            hightFilterConstraint.constant = 0
            self.btnFilter.setImage(UIImage(named: "scale_miles_"), for: .normal)
        } else {
            hightFilterConstraint.constant = 100
            self.btnFilter.setImage(UIImage(named: "scale_miles_grey"), for: .normal)
        }
        
    }
    
    // MARK: Marker Methods
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // Needed to create the custom info window
        locationMarker = marker
        infoWindow = loadNiB()
//        infoWindow.translatesAutoresizingMaskIntoConstraints = false
        infoWindow.titleInfo.text = marker.title
        infoWindow.btnTitleAction.tag = Int(marker.snippet!) ?? 0
        infoWindow.btnTitleAction.addTarget(self, action: #selector(didTapInButton(button:)), for: .touchUpInside)
        
        let image = UIImage(named: "get-dir")?.withRenderingMode(.alwaysTemplate)
        infoWindow.buttonAction.setImage(image, for: .normal)
        infoWindow.buttonAction.tintColor = Colors.txtAppDarkColor
        infoWindow.buttonAction.tag = Int(marker.snippet!) ?? 0
        infoWindow.buttonAction.addTarget(self, action: #selector(didTapInDirectionsButton(button:)), for: .touchUpInside)
        
        
        guard let location = locationMarker?.position else {
            print("locationMarker is nil")
            return false
        }
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
        self.view.addSubview(infoWindow)
        
        return false
    }
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if (locationMarker != nil){
            guard let location = locationMarker?.position else {
                print("locationMarker is nil")
                return
            }
            infoWindow.center = mapView.projection.point(for: location)
            infoWindow.center.y = infoWindow.center.y - sizeForOffset(view: infoWindow)
        }
    }
    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }

    
    // MARK: Needed to create the custom info window
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
    }
    
    // MARK: Needed to create the custom info window (this is optional)
    func sizeForOffset(view: UIView) -> CGFloat {
        return -70.0
    }
    
    // MARK: Needed to create the custom info window (this is optional)
    func loadNiB() -> MapInfoWindow{
        let infoWindow = MapInfoWindow.instanceFromNib() as! MapInfoWindow
        return infoWindow
    }

    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableViewList == tableView {
            return self.filteredArrayList.count
        } else {
            return self.filteredArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableViewList == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FindShakhaListTVCell", for: indexPath) as! FindShakhaListTVCell
            
            cell.modelList = self.filteredArrayList[indexPath.row]
            
            cell.btnEmail.tag = indexPath.row
            cell.btnEmail.addTarget(self, action: #selector(onMailClick(button:)), for: .touchUpInside)
            
            cell.btnContactNo.tag = indexPath.row
            cell.btnContactNo.addTarget(self, action: #selector(onPhoneClick(button:)), for: .touchUpInside)
            
            cell.btnGetDirection.tag = indexPath.row
            cell.btnGetDirection.addTarget(self, action: #selector(onGoogleMapClick(button:)), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FindShakhaTVCell", for: indexPath) as! FindShakhaTVCell
            
            cell.model = filteredArray[indexPath.row]
                
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableViewList == tableView {
            let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "FindShakhaDetailsVC") as! FindShakhaDetailsVC
//            vc.strShakhaId = self.filteredArrayList[indexPath.row].org_chapter_id!
            vc.shakhaData = self.filteredArrayList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            print(self.filteredArray[indexPath.row])
            self.searchBar.text = self.filteredArray[indexPath.row].postal_code
            
            self.latValue = Double(self.filteredArray[indexPath.row].latitude!) ?? 0.0
            self.longValue = Double(self.filteredArray[indexPath.row].longitude!) ?? 0.0
            
            initializeYourMapByPostalCode(postCode: self.searchBar.text!)
            
            self.tableView.isHidden = true
            self.searchBar.resignFirstResponder()
            self.tableView.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //Choose your custom row height
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
        if self.tableViewList == tableView {
            if self.filteredArrayList.count > 0 {
                return 0
            }
            return 100
        } else {
            if self.filteredArray.count > 0 {
                return 0
            }
            return 100
        }
    }
    
    @objc func didTapInButton(button: UIButton) {
        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "FindShakhaDetailsVC") as! FindShakhaDetailsVC
        vc.strShakhaId = String(button.tag)
        for index in 0..<self.filteredArray.count {
            let id : Int = (self.filteredArray[index].org_chapter_id! as NSString).integerValue
            if button.tag == id {
                vc.shakhaData = self.filteredArray[index]
            }
        }
        infoWindow.removeFromSuperview()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapInDirectionsButton(button: UIButton) {

        for index in 0..<self.filteredArray.count {
            let id : Int = (self.filteredArray[index].org_chapter_id! as NSString).integerValue
            if button.tag == id {
                let lat = Double(self.filteredArray[index].latitude!) ?? 0.0
                let long = Double(self.filteredArray[index].longitude!) ?? 0.0
                self.openGoogleMap(lat: lat, long: long)
            }
        }
    }
    
    @objc func onMailClick(button: UIButton) {
        let email = shakhaData[button.tag].email!
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @objc func onPhoneClick(button: UIButton) {
        var strPhone = shakhaData[button.tag].phone!
        strPhone = strPhone.replacingOccurrences(of: " ", with: "")
        guard let number = URL(string: "tel://" + strPhone) else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func onGoogleMapClick(button: UIButton) {
        let lat = Double(self.filteredArray[button.tag].latitude!) ?? 0.0
        let long = Double(self.filteredArray[button.tag].longitude!) ?? 0.0
        
        self.openGoogleMap(lat: lat, long: long)
    }
    
    func openGoogleMap(lat: CLLocationDegrees , long: CLLocationDegrees) {
//         guard let lat = booking?.booking?.pickup_lat, let latDouble =  Double(lat) else {Toast.show(message: StringMessages.CurrentLocNotRight);return }
//         guard let long = booking?.booking?.pickup_long, let longDouble =  Double(long) else {Toast.show(message: StringMessages.CurrentLocNotRight);return }
        let latDouble =  Double(lat)
        let longDouble =  Double(long)
        
          if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

              if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                        UIApplication.shared.open(url, options: [:])
               }}
          else {
                 //Open in browser
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latDouble),\(longDouble)&directionsmode=driving") {
                                   UIApplication.shared.open(urlDestination)
                               }
                    }

            }
    
    // MARK: API Calling
    func findShakhaAPI() {

        APIManager.sharedInstance.callGetApi(url: APIUrl.get_shakha_list) { (jsonData, error) in
            
            do {
                self.shakhaResponseDM = try JSONDecoder().decode(ShakhaResponseDM.self, from: (jsonData?.rawData())!)
                self.filteredArray = self.shakhaData
                self.responseArray = self.shakhaData
                self.initializeYourMap()
                for var item in self.filteredArray {
                    let latitude : Double = Double(item.latitude!) ?? 0.0
                    let longitude : Double = Double(item.longitude!) ?? 0.0
                    let isAvailable = self.distanceTwoCoordinates(lat: latitude, long: longitude)
                    if isAvailable {
                        let dist : Double = Double(self.distanceTwoCoordinates2(lat: latitude, long: longitude))!
                        item.distance = dist
                        self.filteredArrayList.append(item)
                        self.responseArrayList.append(item)
                    }
                }
                
                let sortArr = self.filteredArrayList.sorted(by: {($0.distance!) < $1.distance!})
                self.filteredArrayList = sortArr
                self.responseArrayList = sortArr

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableViewList.reloadData()
                }
            } catch {
                print("Error : \(error)")
            }
        }
    }
    
    // MARK: ScrollView Methods
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // we set a variable to hold the contentOffSet before scroll view scrolls
        let lastContentOffset: CGFloat = 0
        if lastContentOffset < scrollView.contentOffset.y {
            // did move up
        } else if lastContentOffset > scrollView.contentOffset.y {
            // did move down
        } else {
            // didn't move
        }
    }

    
    // MARK: SerchBar Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        if searchBar == self.searchBar {
            DispatchQueue.main.async {
                self.filteredArray = self.responseArray
                self.tableView.reloadData()
            }
            self.tableView.isHidden = false
            infoWindow.removeFromSuperview()
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false
        searchBar.showsCancelButton = false
        if searchBar == self.searchBar {
            self.tableView.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        if searchBar == self.searchBarList {
            DispatchQueue.main.async {
                self.filteredArrayList.removeAll()
                self.filteredArrayList = self.responseArrayList
                self.tableViewList.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                self.filteredArray.removeAll()
                self.filteredArray = self.responseArray
                self.tableView.resignFirstResponder()
                self.tableView.reloadData()
            }

        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == self.searchBarList {
            searchActive = false
            self.searchBarList.resignFirstResponder()
            self.tableViewList.resignFirstResponder()
        } else {
            searchActive = false
            self.searchBar.resignFirstResponder()
            self.tableView.resignFirstResponder()
        }
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchActive = true;
        if searchBar == self.searchBarList {
            self.searchBarList.showsCancelButton = true

            self.filteredArrayList.removeAll()

            self.filteredArrayList = self.responseArrayList.filter {
                let string = $0.chapter_name!.lowercased()
                let stringAddressLine1 = $0.address_line_1!.lowercased()
                let stringAddressLine2 = $0.address_line_2!.lowercased()
                let stringBuildingName = $0.building_name!.lowercased()
                let stringCity = $0.city!.lowercased()
                let stringPostCode = $0.postal_code!.lowercased()

                return (string.hasPrefix(searchText.lowercased()) || stringAddressLine1.hasPrefix(searchText.lowercased()) || stringAddressLine2.hasPrefix(searchText.lowercased()) || stringBuildingName.hasPrefix(searchText.lowercased()) || stringCity.hasPrefix(searchText.lowercased()) || stringPostCode.hasPrefix(searchText.lowercased()))
            }
            if self.filteredArrayList.isEmpty {
                self.searchActive = false
            } else {
                self.searchActive = true
            }
            DispatchQueue.main.async {
                self.tableViewList.reloadData()
            }
            
        } else {
            self.searchBar.showsCancelButton = true
            self.filteredArray.removeAll()
            
            DispatchQueue.global(qos: .background).async {
                //            print("This is run on the background queue")
                if searchText.count > 0 {
                    self.filteredArray = self.shakhaData.filter { $0.postal_code!.lowercased().contains(searchText.lowercased()) }
                    print(self.filteredArray)
                } else {
                    self.filteredArray = self.shakhaData
                }
                
                if self.filteredArray.isEmpty {
                    self.searchActive = false
                } else {
                    self.searchActive = true
                }

                DispatchQueue.main.async {
                    //          print("This is run on the main queue, after the previous code in outer block")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if textField == searchBarList {
            textField.resignFirstResponder()  //if desired
//            searchActive = false
            searchBarList.resignFirstResponder()
        }
        return true
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        print("You tapped : \(marker.position.latitude),\(marker.position.longitude)")
//        let vc = _mainStoryBoard.instantiateViewController(withIdentifier: "FindShakhaDetailsVC") as! FindShakhaDetailsVC
//        vc.strShakhaId = marker.snippet! //self.filteredArrayList[indexPath.row].org_chapter_id!
//        self.navigationController?.pushViewController(vc, animated: true)
//
//        return true // or false as needed.
//    }
    
    // MARK: Delegates to handle events for the location manager.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        GoogleMapsHelper.didUpdateLocations(locations, locationManager: locationManager, mapView: mapView)
        mapView.camera = GMSCameraPosition(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0, zoom: 0, bearing: 0, viewingAngle: 0)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        GoogleMapsHelper.handle(manager, didChangeAuthorization: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error:: \(error)")
    }

}

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}

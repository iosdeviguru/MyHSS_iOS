//
//  SuryaNamskarVC.swift
//  MyHHS_iOS
//
//  Created by Patel on 07/01/2022.
//

import UIKit
import Foundation
import Charts
import TinyConstraints

struct surynamaskarModel {
    var date: Date
    var value: Double
    var memberId: String
}

class SuryaNamskarVC: UIViewController {
        
    @IBOutlet weak var chartView: BarChartView!
    
    var dicMember = [[String:Any]]()
    
    @IBOutlet weak var lblChartDetails: UILabel!
    @IBOutlet weak var lblSNCountDetails: UILabel!
    
    var memberIds: String = ""
    var strMemberId : String!
    
    var suryaNamskarResponseDM : SuryaNamskarResponseDM?
    
    var suryaNamskarData : [SuryaNamskarData] {
        return suryaNamskarResponseDM?.suryaNamskarData ?? []
    }
    
    var suryaNamskarDataForAll : [SuryaNamskarData] = []
    var suryaNamskarDataForAll2 : [surynamaskarModel] = []
    
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var btnMember: UIButton!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var familyMemberHeightConstraint: NSLayoutConstraint!

    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sep", "Oct", "Nov"]
    let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 22.0, 14.0, 16.0, 30.0, 12.0, 5.5]
    let unitsBought = [10.0, 14.0, 60.0, 13.0, 2.0, 10.0, 14.0, 60.0, 13.0, 25.0, 6.6]

    lazy var loader : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        self.chartView.delegate = self

        view.addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.getSuryaNamskarDataAPI()


/*
        barChartView.delegate = self
        barChartView.noDataText = "You need to provide data for the chart."
        barChartView.chartDescription?.text = "sales vs bought "

        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;

        let xaxis = barChartView.xAxis
        //xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xaxis.granularity = 1

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false

        barChartView.rightAxis.enabled = false
       //axisFormatDelegate = self

        setChart()
*/
        
        self.getMemberAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
//        navigationBarDesign(txt_title: "Suryanamskar", showbtn: "back")
        navigationBarWithRightButtonDesign(txt_title: "Suryanamskar", showbtn: "back", rightImg: "plus_white", bagdeVal: "", isBadgeHidden: true)
        self.chartView.delegate = self

        view.addSubview(loader)
        self.getSuryaNamskarDataAPI()


    }

    override func rightBarItemClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSuryaNamskarCountVC") as! AddSuryaNamskarCountVC
        var dicMemberData = self.dicMember
        if self.dicMember.count > 0 {
            if dicMemberData[0]["name"] as! String == "All" {
                dicMemberData.remove(at: 0)
            }
        }
        vc.dicMember = dicMemberData
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func onMemberClick(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerTableViewWithSearchViewController") as! PickerTableViewWithSearchViewController
        vc.selectedItemCompletion = {dict in
            self.lblMember.text = dict["name"] as? String
            self.strMemberId = dict["id"] as? String
            self.getSuryaNamskarDataAPI()
        }
        vc.dataSource = dicMember
        vc.strNavigationTitle = "Family Member"
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func setChart() {
            barChartView.noDataText = "You need to provide data for the chart."
            var dataEntries: [BarChartDataEntry] = []
            var dataEntries1: [BarChartDataEntry] = []

            for i in 0..<self.months.count {

                let dataEntry = BarChartDataEntry(x: Double(i) , y: self.unitsSold[i])
                dataEntries.append(dataEntry)

                let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.self.unitsBought[i])
                dataEntries1.append(dataEntry1)

                //stack barchart
                //let dataEntry = BarChartDataEntry(x: Double(i), yValues:  [self.unitsSold[i],self.unitsBought[i]], label: "groupChart")
            }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Unit sold")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Unit Bought")

            let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
            chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
            //chartDataSet.colors = ChartColorTemplates.colorful()
            //let chartData = BarChartData(dataSet: chartDataSet)

            let chartData = BarChartData(dataSets: dataSets)

            let groupSpace = 0.3
            let barSpace = 0.05
            let barWidth = 0.3
            // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"

            let groupCount = self.months.count
            let startYear = 0


            chartData.barWidth = barWidth;
            barChartView.xAxis.axisMinimum = Double(startYear)
            let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
            print("Groupspace: \(gg)")
            barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)

            chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
            //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
            barChartView.notifyDataSetChanged()

            barChartView.data = chartData
            barChartView.setVisibleXRangeMaximum(7)

            //background color
            barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

            //chart animation
            barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)

        }

    // MARK: - Chart
    func setData() {

        self.chartView.clear()
        guard suryaNamskarData.count > 0 else {
            self.chartView.noDataText = "Data not available"
            self.lblSNCountDetails.text = "0"
                return
            }

        var objects: [surynamaskarModel] = []
            
        if self.lblMember.text == "All" {
            objects = self.suryaNamskarDataForAll2
        } else {
            for suryaNamskar in suryaNamskarData {
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from:suryaNamskar.count_date ?? "2022-01-01")!
                
                objects.append(surynamaskarModel(date: date, value: (suryaNamskar.count! as NSString).doubleValue, memberId: suryaNamskar.member_id ?? "0"))
            }
        }
        // Define the reference time interval
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (objects.map { $0.date.timeIntervalSince1970 }).min() {
                referenceTimeInterval = minTimeInterval
            }

            // Define chart xValues formatter
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.locale = Locale.current

            let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: formatter)

        var totalCount = 0
            // Define chart entries
            var entries = [ChartDataEntry]()
            for object in objects {
                let timeInterval = object.date.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)

                let yValue = object.value
                let entry = BarChartDataEntry(x: xValue,
                                              y: yValue,
                                              data: xValuesNumberFormatter.stringForValue(xValue, axis: nil))
                entries.append(entry)
                totalCount += Int(object.value)
            }
        self.lblChartDetails.text = "Total Count"
        self.lblSNCountDetails.text = " \(totalCount)"
        if totalCount < 0 {
            self.lblChartDetails.isHidden = true
            self.lblSNCountDetails.isHidden = true
        }
        

        let set1 = BarChartDataSet(entries: entries, label: "Suryanamskar")
        set1.colors = [Colors.yellow_button]
        let chartData = BarChartData(dataSet: set1)

        //legend
        let legend = self.chartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        legend.orientation = .vertical
        legend.drawInside = false
        legend.yOffset = -5.0;
        legend.xOffset = 5.0;
        legend.yEntrySpace = 0.0;
    

        let xaxis = self.chartView.xAxis
        //xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
//        xaxis.centerAxisLabelsEnabled = true
//        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xaxis.granularity = 1
        xaxis.labelRotationAngle = 0

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1

        let yaxis = self.chartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false

        self.chartView.rightAxis.enabled = false

        self.chartView.xAxis.valueFormatter = xValuesNumberFormatter 
        self.chartView.data = chartData
        //chart animation
        self.chartView.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .linear)
        self.chartView.notifyDataSetChanged()
//        self.chartView.setVisibleXRangeMaximum(30)
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.delegate = self
        self.chartView.xAxis.labelFont = UIFont(name:"SourceSansPro-Regular",size:10)!

    }

    func getSuryaNamskarDataAPI() {
        loader.startAnimating()
        var parameters: [String: Any] = [:]
        parameters["is_api"] = "true"
        parameters["member_id"] = self.strMemberId // "749,986,547" //  self.memberIds

        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.get_suryanamaskar, parameters: parameters) { (jsonData, error) in
            self.loader.stopAnimating()
            if error == nil
            {
                do {
                    self.suryaNamskarResponseDM = try JSONDecoder().decode(SuryaNamskarResponseDM.self, from: (jsonData?.rawData())!)
                    print(self.suryaNamskarResponseDM?.suryaNamskarData?.count as Any)
                    
                    for suryaNamskar in self.suryaNamskarData {
                        if let dateSuryaNamskar = suryaNamskar.count_date {
    
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let date = dateFormatter.date(from:dateSuryaNamskar )!
                            
                            let dicFilter1 = self.suryaNamskarDataForAll2.filter { $0.date == date }.map { $0 }

                            if dicFilter1.count <= 0 {
                                let dicFilter2 = self.suryaNamskarData.filter { $0.count_date! == dateSuryaNamskar }.map { $0 }
                                var member_id = ""
                                var count = 0
//                                var count_date = ""

                                for dic in dicFilter2 {
                                    member_id = dic.member_id ?? ""
//                                    count_date = dic.count_date ?? "2022-01-01"
                                    count += Int(dic.count!) ?? 0
                                }
                                
                                self.suryaNamskarDataForAll2.append(surynamaskarModel(date: date, value: Double(count), memberId: member_id))
                                print(self.suryaNamskarDataForAll2)
                            }
                        }
                    }

                    self.setData()
                } catch {
                    print("Error : \(error)")
                    if let strError = jsonData!["message"].string {
                        showAlert(title: APP.title, message: strError)
                    }
                }
            }
        }
    }

    func getMemberAPI() {
        loader.startAnimating()
        self.strMemberId = _appDelegator.dicDataProfile?[0]["member_id"] as? String
        self.lblMember.text = "\(_appDelegator.dicMemberProfile![0]["first_name"] as? String ?? "") \(_appDelegator.dicMemberProfile![0]["last_name"] as? String ?? "")"

        var parameters: [String: Any] = [:]
        parameters["user_id"] =  _appDelegator.dicMemberProfile![0]["user_id"] as? String //    dicUserDetails["user_id"]
        parameters["member_id"] = _appDelegator.dicDataProfile![0]["member_id"] as? String //  dicUserDetails["member_id"]
        parameters["tab"] = "family"   //  family or kendra or shakha
        parameters["status"] = "all"  //  status = all, 0 pending, 1 active, 3 rejected, 4 inactive
        parameters["start"] = "0"
        parameters["length"] = "20"
        parameters["search"] = ""

        print(parameters)

        APIManager.sharedInstance.callPostApi(url: APIUrl.get_listing, parameters: parameters) { (jsonData, error) in
            if error == nil
            {
                self.loader.stopAnimating()
                if let status = jsonData!["status"].int
                {
                    if status == 1
                    {
                        self.dicMember.removeAll()
                        let arr = jsonData!["data"]

                        var dictStatic = [String : Any]()
                        dictStatic["id"] = _appDelegator.dicDataProfile![0]["member_id"] as? String
                        dictStatic["name"] = "\(_appDelegator.dicMemberProfile![0]["first_name"] as? String ?? "") \(_appDelegator.dicMemberProfile![0]["last_name"] as? String ?? "")"
                        self.dicMember.append(dictStatic)
                        self.memberIds = _appDelegator.dicDataProfile![0]["member_id"] as? String ?? ""

                        for index in 0..<arr.count {
                            var dict = [String : Any]()
                            if _appDelegator.dicDataProfile![0]["member_id"] as? String != "\(arr[index]["member_id"])" {
                                dict["id"] = "\(arr[index]["member_id"])"
                                dict["name"] = "\(arr[index]["first_name"]) \(arr[index]["last_name"])"
                                self.dicMember.append(dict)
                                self.memberIds += ",\(arr[index]["member_id"])"
                            }
                        }
                        var dictStaticAll = [String : Any]()
                        dictStaticAll["id"] = self.memberIds
                        dictStaticAll["name"] = "All"
                        self.dicMember.insert(dictStaticAll, at: 0)
                        self.strMemberId = self.memberIds
                        self.lblMember.text = self.dicMember[0]["name"] as? String ?? ""
                        self.familyMemberHeightConstraint.constant = 90
                        self.getSuryaNamskarDataAPI()
                    }else {
                            self.dicMember.removeAll()
                            //  Add Static Recoard
//                            var dictStatic = [String : Any]()
//                            dictStatic["id"] = _appDelegator.dicDataProfile![0]["member_id"] as? String
//                            dictStatic["name"] = "\(_appDelegator.dicMemberProfile![0]["first_name"] as? String ?? "") \(_appDelegator.dicMemberProfile![0]["last_name"] as? String ?? "")"
//                            self.dicMember.append(dictStatic)
                        self.familyMemberHeightConstraint.constant = 0
                        self.memberIds = _appDelegator.dicDataProfile![0]["member_id"] as? String ?? ""
                        self.getSuryaNamskarDataAPI()
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
}

// MARK: - Chart Delegate Methods
extension SuryaNamskarVC : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print(chartView.xAxis.entries)
    }
}

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?

    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
        self.dateFormatter?.dateFormat = "dd.MMM"
    }
}

extension ChartXAxisFormatter: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
        let referenceTimeInterval = referenceTimeInterval
        else {
            return ""
        }

        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }
}

public extension Sequence {
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}

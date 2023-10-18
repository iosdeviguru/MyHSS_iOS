//
//  ListingTableViewController.swift
//  MyHHS_iOS
//
//  Created by Patel on 16/06/2021.
//

import UIKit

class ListingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var strNavigationTitle = ""
    var arrayData : [[String: Any]] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarDesign(txt_title: self.strNavigationTitle, showbtn: "back")
    }

    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = arrayData[indexPath.row]["name"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension   //Choose your custom row height
    }

}

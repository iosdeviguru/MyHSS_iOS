//
//  PickerTableViewWithSearchViewController.swift
//  MyHHS_iOS
//
//  Created by Patel on 12/03/2021.
//

import Foundation
import UIKit

class PickerTableViewWithSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var titleArray = [String]()
    var selected : Int = 0
    var strNavigationTitle = ""
    var index : Int = 0

    var dataSource : [[String: Any]] = []
    var selectionBlock : ((String) -> Void)?
    var selectedItemCompletion : (([String:Any]) -> Void)?
    
    
    var SearchBarValue:String!
    var searchActive : Bool = false
    var filteredArray : [[String: Any]] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarDesign(txt_title: strNavigationTitle, showbtn: "back")
        self.filteredArray = self.dataSource
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = filteredArray[indexPath.row]["name"] as? String
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedItemCompletion?(filteredArray[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension   //Choose your custom row height
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
        tableView.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        self.searchActive = true;
        self.searchBar.showsCancelButton = true
        
        self.filteredArray.removeAll()
        
        DispatchQueue.global(qos: .background).async {
//            print("This is run on the background queue")
            //  Filter technique 1
    //        self.filteredArray: [Any] = dataSource.filter { NSPredicate(format: "(name contains[c] %@)", searchText).evaluate(with: $0) }

            //  Filter technique 2
            self.filteredArray = self.dataSource.filter{
                let string = $0["name"] as! String

                return string.hasPrefix(searchText)
            }

            if self.filteredArray.isEmpty {
                self.searchActive = false
            } else {
                self.searchActive = true
            }
            
            DispatchQueue.main.async {
//                print("This is run on the main queue, after the previous code in outer block")
                self.tableView.reloadData()
            }
        }

    }
}

//
//  MasterViewController.swift
//  Spr21-Universities
//
//  Created by AV on 4/11/21.
//  Copyright © 2021 AV. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UISearchBarDelegate {

    var detailViewController: DetailViewController? = nil
    
    
    @IBOutlet weak var SearchBar: UISearchBar!

    var Uni: [String:String] = [:]
    var UFiltered: [String]!
    var UListFileURL: URL!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UListFileURL = Bundle.main.url(forResource: "UniList", withExtension: "plist")
        Uni = NSDictionary(contentsOf: UListFileURL) as! [String:String]
        
        SearchBar.delegate = self
        UFiltered = Array(Uni.keys).sorted()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = UFiltered[indexPath.row]
                controller.setNewAddr(Member: Uni[UFiltered[indexPath.row]]!, formap: Uni[UFiltered[indexPath.row]] ?? "")
                controller.Uni = Uni
                controller.UName = Array(Uni.keys).sorted()
                controller.OriginalUName = UFiltered[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UFiltered.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = UFiltered[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            UFiltered = Array(Uni.keys).sorted()
        } else {
            UFiltered = Uni.keys.filter({ $0.localizedCaseInsensitiveContains(searchText) }).sorted()
        }
        
        tableView.reloadData()
    }

}


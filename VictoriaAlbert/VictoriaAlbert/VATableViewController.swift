//
//  VATableViewController.swift
//  VictoriaAlbert
//
//  Created by Annie Tung on 11/10/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class VATableViewController: UITableViewController, UISearchBarDelegate {
    
    var victoriaAlbert: [VictoriaAlbert] = []
    let endPoint = "http://www.vam.ac.uk/api/json/museumobject/search?q=ring"
//    var imageURL = "http://media.vam.ac.uk/media/thira/collection_images/2006AM/\(imageID).jpg"
//    var thumbnailURL = "http://media.vam.ac.uk/media/thira/collection_images/2006AM/\(imageID)_jpg_o.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Victoria and Albert Museum"
        getVictoriaAlbertApi()
//        searchBar()
    }
    
    // MARK: - Method
    
    func getVictoriaAlbertApi() {
        APIRequestManager.manager.getData(apiEndPoint: endPoint) { (data: Data?) in
            guard let validData = data else { return }
            dump(validData)
            
            if let validVA = VictoriaAlbert.parseData(data: validData) {
                self.victoriaAlbert = validVA
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
//    func searchBar() {
//        let searchBar = UISearchBar()
//        searchBar.showsCancelButton = false
//        searchBar.placeholder = "Enter your search here"
//        searchBar.delegate = self
//        self.navigationItem.titleView = searchBar
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return victoriaAlbert.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VictoriaAlbertCell", for: indexPath)

        let row = victoriaAlbert[indexPath.row]
        cell.textLabel?.text = "\(row.object), \(row.dateText), \(row.place)"
        cell.detailTextLabel?.text = row.title
        
        

        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destinationVC = segue.destination as? VAViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
                destinationVC.victoria = victoriaAlbert[indexPath.row]
    }
}
    

}

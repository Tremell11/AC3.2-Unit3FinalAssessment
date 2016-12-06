//
//  VictoriaAlbertTableViewController.swift
//  VictoriaAlbert
//
//  Created by Tyler Newton on 12/4/16.
//  Copyright © 2016 Tyler Newton. All rights reserved.
//

import UIKit

class VictoriaAlbertTableViewController: UITableViewController{
    
    @IBOutlet weak var museumSearchBar: UISearchBar!
    
    let endpoint = "http://www.vam.ac.uk/api/json/museumobject/"
    let cellIdentifier = "ItemCell"
    let segueIdentifier = "ItemSegue"
    let cache = NSCache<NSString, UIImage>()
    var details = [VictoriaAlbertDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VictoriaAlbertAPIManager.getDetails(from: endpoint) { (alldetails: [VictoriaAlbertDetails]?) in
            
            guard let objectDetails = alldetails else { return }
            
            self.details = objectDetails
            
            self.navigationItem.title = "Victoria Albert Museum"
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let cellDetail = details[indexPath.row]
        
        cell.textLabel?.text = cellDetail.object
        cell.detailTextLabel?.text = "\(cellDetail.dateText) \(cellDetail.place)"
        cell.imageView?.image = UIImage(named: "NoImage")
        cell.imageView?.downloadImage(from: cellDetail.thumbnail, with: cache)
        
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let largestImageString = details[indexPath.row].largestImage
            let selectedRow = details[indexPath.row]
            
            let destination = segue.destination as! VAViewController
            
            _ = destination.view
            
            destination.selectedImageView.downloadImage(from: largestImageString, with: cache)
            
            destination.selectedArtistLabel.text = "Created By: \(selectedRow.artist)"
            
            destination.selectedImageLabel.text = selectedRow.object
        }
    }
}

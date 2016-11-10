//
//  ObjectTableViewController.swift
//  VictoriaAlbert
//
//  Created by Jason Gresh on 11/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ObjectTableViewController: UITableViewController {
    var objects = [Object]()
    var searchTerm = "ring"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = searchTerm
        APIRequestManager.manager.getData(endPoint: "http://www.vam.ac.uk/api/json/museumobject/search?q=\(searchTerm)&images=1")  { (data: Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options:[]) {
                    if let wholeDict = jsonData as? [String:Any],
                        let records = wholeDict["records"] as? [[String:Any]] {
                        self.objects = Object.parseObjects(from: records)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath)

        let object = self.objects[indexPath.row]
        
        cell.textLabel?.text = "\(object.object), \(object.place) — \(object.dateText)"
        cell.detailTextLabel?.text = object.title
        
        APIRequestManager.manager.getData(endPoint: object.imageURL(thumb: true))  { (data: Data?) in
            if let validData = data,
                let image = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.imageView?.image = image
                    cell.setNeedsLayout()
                }
            }
        }
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ovc = segue.destination as? ObjectViewController,
            let cell = sender as? UITableViewCell,
            let ip = tableView.indexPath(for: cell) {
            ovc.object = self.objects[ip.row]
        }
    }
}

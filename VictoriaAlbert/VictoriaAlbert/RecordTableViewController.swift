//
//  RecordTableViewController.swift
//  VictoriaAlbert
//
//  Created by Victor Zhong on 11/10/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController, UITextFieldDelegate {
	
	
	@IBOutlet weak var searchField: UITextField!
	
	var records = [Record]()
	var searchTerm = "ring"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = searchTerm
		self.searchField.delegate = self
		loadRecords(searchString: searchTerm)
	}
	
	internal func loadRecords(searchString: String) {
		let escapedString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		APIRequestManager.manager.getData(endPoint: "http://www.vam.ac.uk/api/json/museumobject/search?q=\(escapedString!)") { (data) in
			if data != nil {
				
				if let records = Record.getRecords(from: data!) {
					print("We've got Records!")
					self.records = records
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
			}
		}
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return records.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
		let record = records[indexPath.row]
		
		cell.textLabel?.text = "\(record.object), \(record.date) - \(record.place)"
		cell.detailTextLabel?.text = record.title
		
		if record.imageSmall != "" {
			APIRequestManager.manager.getData(endPoint: record.imageSmall ) { (data: Data?) in
				if  let validData = data,
					let validImage = UIImage(data: validData) {
					DispatchQueue.main.async {
						cell.imageView?.image = validImage
						cell.setNeedsLayout()
					}
				}
			}
		}
		else {
			cell.imageView?.image = #imageLiteral(resourceName: "placeholder")
		}
		
		return cell
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let tappedRecordCell: UITableViewCell = sender as? UITableViewCell {
			if segue.identifier == "recordSegue" {
				let recordViewController: RecordViewController = segue.destination as! RecordViewController
				let cellIndexPath: IndexPath = self.tableView.indexPath(for: tappedRecordCell)!
				recordViewController.recordSelected = records[cellIndexPath.row]
				// The below affects the title of the back button in the next view controller
				let backItem = UIBarButtonItem()
				backItem.title = "Back to \"\(searchTerm)\""
				navigationItem.backBarButtonItem = backItem

			}
		}
	}
	
	// MARK: - Textfield Stuff
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		if let search = searchField.text {
			searchTerm = search
			self.title = searchTerm
			loadRecords(searchString: search)
		}
		
		return true
	}
}

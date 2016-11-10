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
	var locationDict = [String : Int]()
	var locationArray = [String]()
	
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
					print("We've got Records! \(records.count)")
					self.records = records
					self.countLocations()
					DispatchQueue.main.async {
						self.tableView.reloadData()
					}
				}
			}
		}
	}
	
	internal func countLocations() {
		locationDict = [String : Int]()
		locationArray = [String]()
		for all in records {
			locationDict[all.place] = 0
		}
		
		locationArray = Array(locationDict.keys).sorted { $0 < $1 }
		print("\n\n\nLocation dict: \(locationDict.count)")
		print("\nLocation Array: \(locationArray)")
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return locationDict.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let recordsByLocation = records.filter { (record) -> Bool in
			(record.place) == locationArray[section]
		}
		
		return recordsByLocation.count
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "\(locationArray[section])"
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
		
		let recordsByLocation = records.filter { (record) -> Bool in
			(record.place) == locationArray[indexPath.section]
			}.sorted { $0.object < $1.object }
		
		let record = recordsByLocation[indexPath.row]
		
		cell.textLabel?.text = "\(record.object), \(record.date) - \(record.place)"
		cell.detailTextLabel?.text = record.title
		
		APIRequestManager.manager.getData(endPoint: record.imageSmall ) { (data: Data?) in
			if  let validData = data,
				let validImage = UIImage(data: validData) {
				DispatchQueue.main.async {
					cell.imageView?.image = validImage
					cell.setNeedsLayout()
				}
			}
		}
		
		return cell
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let tappedRecordCell: UITableViewCell = sender as? UITableViewCell {
			if segue.identifier == "recordSegue" {
				let recordViewController: RecordViewController = segue.destination as! RecordViewController
				let cellIndexPath: IndexPath = self.tableView.indexPath(for: tappedRecordCell)!
				
				let recordsByLocation = records.filter { (record) -> Bool in
					(record.place) == locationArray[cellIndexPath.section]
					}.sorted { $0.object < $1.object }
				
				recordViewController.recordSelected = recordsByLocation[cellIndexPath.row]
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

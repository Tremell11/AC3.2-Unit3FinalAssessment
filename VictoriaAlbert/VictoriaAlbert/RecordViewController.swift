//
//  RecordViewController.swift
//  VictoriaAlbert
//
//  Created by Victor Zhong on 11/10/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
	
	@IBOutlet weak var recordImage: UIImageView!
	var recordSelected: Record?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
	}
	
	func loadData() {
		guard let validRecord = recordSelected else { return }
		guard validRecord.imageBig != "" else {
			self.recordImage.image = #imageLiteral(resourceName: "404page-complex")
			return
		}
		
		APIRequestManager.manager.getData(endPoint: validRecord.imageBig) { (data: Data?) in
			if  let validData = data,
				let validImage = UIImage(data: validData) {
				DispatchQueue.main.async {
					self.recordImage.image = validImage
				}
			}
		}
	}
}


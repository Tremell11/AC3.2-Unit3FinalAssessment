//
//  ObjectViewController.swift
//  VictoriaAlbert
//
//  Created by Jason Gresh on 11/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ObjectViewController: UIViewController {
    var object: Object!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = object.object
        
        APIRequestManager.manager.getData(endPoint: object.imageURL())  { (data: Data?) in
            if let validData = data,
                let image = UIImage(data: validData) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}

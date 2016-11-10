//
//  VAViewController.swift
//  VictoriaAlbert
//
//  Created by Annie Tung on 11/10/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class VAViewController: UIViewController {

    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var objectLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    var victoria: VictoriaAlbert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let validVC = victoria {
            self.title = validVC.object
        }
       
        objectLabel.text = victoria!.object
        placeLabel.text = "Place originated: \(victoria!.place)"
        dateTextLabel.text = "Dated: \(victoria!.dateText)"
        locationLabel.text = "Located at: \(victoria!.location)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

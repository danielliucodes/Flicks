//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Daniel Liu on 11/1/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var seguePosterViewURL: URL!
    var segueOverviewLabelString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.posterView.setImageWith(seguePosterViewURL)
        self.overviewLabel.text = segueOverviewLabelString
        self.overviewLabel.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPosterViewURL(url: URL) {
        self.seguePosterViewURL = url
    }
    
    func setOverviewLabelString(text: String) {
        self.segueOverviewLabelString = text
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
 

}

//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Daniel Liu on 11/1/16.
//  Copyright © 2016 Daniel Liu. All rights reserved.
//

import UIKit
import AFNetworking
import CircularSpinner

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        CircularSpinner.show("Loading...", animated: true, type: .indeterminate)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            CircularSpinner.hide()
            
            if let data = dataOrNil {
                self.errorView.isHidden = true
                
                if let responseDictionary = try!JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                    
                }
            } else {
                self.errorView.isHidden = false
            }
        
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = URL(string: posterBaseUrl + posterPath)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterView.setImageWith(imageUrl!)
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let viewController = segue.destination as! MovieDetailViewController
        let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        
        if let row = indexPath?.row {
            let movie = movies![row]
            
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterPath = movie["poster_path"] as! String
            let imageUrl = URL(string:posterBaseUrl + posterPath)
            let overview = movie["overview"] as! String
            
            viewController.setPosterViewURL(url: imageUrl!)
            viewController.setOverviewLabelString(text: overview)


        }
        
        
    }
 
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest (request) ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (data, response, error) in
            refreshControl.endRefreshing()
        
            if let data = data {
                self.errorView.isHidden = true
                
                if let responseDictionary = try!JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                    
                }
            } else {
                self.errorView.isHidden = false
            }

        });
        task.resume()
        
        
        
        
    }

}

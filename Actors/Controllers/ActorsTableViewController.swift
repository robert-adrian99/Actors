//
//  ActorsTableViewController.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import UIKit

class ActorsTableViewController: UITableViewController, UISearchBarDelegate {

    // outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // model data
    var actors       : [String:[Actor]]!
    var visibleActors: [String:[Actor]]!
    var categories   : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        let actorsData = Actors(xmlFilename: "actors.xml")
        actors         = actorsData.data
        visibleActors  = actorsData.data
        categories     = actorsData.categories
        
        let image             = UIImage(named: "background")
        let imageView         = UIImageView(image: image)
        imageView.alpha       = CGFloat(0.5)
        imageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = imageView
    }
    
    // MARK: - Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        for index in visibleActors.values.indices {
            visibleActors.values[index] = []
        }
        
        if searchText == "" {
            visibleActors = actors
        } else {
            let lowerCaseSearchText = searchText.lowercased()
            
            for index in actors.values.indices {
                for actor in actors.values[index] {
                    if actor.name.lowercased().contains(lowerCaseSearchText) {
                        if visibleActors[visibleActors.keys[index]] == nil {
                            visibleActors[visibleActors.keys[index]] = []
                        }
                        visibleActors[visibleActors.keys[index]]?.append(actor)
                    }
                }
            }
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleActors[categories[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath)

        
        // Configure the cell...
        let actor = visibleActors[categories[indexPath.section]]?[indexPath.row] ?? Actor()
        
        cell.textLabel?.text       = actor.name
        cell.detailTextLabel?.text = "\(actor.age) years"
        cell.imageView?.image      = UIImage(named: actor.images[0])
        cell.backgroundColor       = .clear
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoActorInfo" {
            // Get the new view controller using segue.destination.
            let actorInfoVC = segue.destination as! ActorInfoViewController
            
            // Pass the selected object to the new view controller.
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            actorInfoVC.actor = visibleActors[categories[indexPath?.section ?? 0]]?[indexPath?.row ?? 0] ?? Actor()
            actorInfoVC.category = categories[indexPath?.section ?? 0]
        }
    }

}

//
//  ActorsTableViewController.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import UIKit

class ActorsTableViewController: UITableViewController {

    // outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // model data
    var actors       : [String:[Actor]]!
    var visibleActors: [String:[Actor]]!
    var categories   : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate         = self
        tabBarController?.delegate = self
        
        let selectedItem = tabBarController?.tabBar.selectedItem
        title = selectedItem?.title
        
        let actorsData = Actors(xmlFilename: "actors.xml")
        actors         = actorsData.data
        
        if selectedItem?.title == "Favourites" {
            let favouriteActors = actors.mapValues { $0.filter { $0.isFavourite } }
            visibleActors = favouriteActors
        } else {
            visibleActors = actorsData.data
        }
        
        categories     = actorsData.categories
        
        let image             = UIImage(named: "background")
        let imageView         = UIImageView(image: image)
        imageView.alpha       = CGFloat(0.5)
        imageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = imageView
        
        let items        = tabBarController?.tabBar.items
        
        updateItemImage(of: selectedItem, in: items)
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
        
        let favouriteButton = cell.contentView.viewWithTag(1) as! UIButton
        favouriteButton.addTarget(nil, action: #selector(didTapFavourite), for: .touchUpInside)
        let favouriteImage = UIImage(systemName: actor.isFavourite ? "star.fill" : "star")
        favouriteButton.setImage(favouriteImage, for: .normal)
        
        return cell
    }
    
    
    @objc func didTapFavourite(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)
        let actor = visibleActors[categories[indexPath?.section ?? 0]]?[indexPath?.row ?? 0] ?? Actor()

        if actor.isFavourite {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        actor.isFavourite = !actor.isFavourite
        tableView.reloadData()
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

// MARK: - Search bar delegate
extension ActorsTableViewController: UISearchBarDelegate {
    
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
}

// MARK: - Tab bar Controller Delegate
extension ActorsTableViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateItemImage(of: tabBarController.tabBar.selectedItem, in: tabBarController.tabBar.items)
    }
    
    func updateItemImage(of selectedItem: UITabBarItem?, in allItems: [UITabBarItem]?) {
        guard let item = selectedItem, let items = allItems else { return }
        
        if item.title == "Favourites" {
            item.image = UIImage(systemName: "star.fill")
            
            for item in items where item != selectedItem {
                item.image = UIImage(systemName: "person.circle")
            }
        } else {
            item.image = UIImage(systemName: "person.circle.fill")
            
            for item in items where item != selectedItem {
                item.image = UIImage(systemName: "star")
            }
        }
    }
}

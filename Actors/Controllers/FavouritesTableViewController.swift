//
//  FavouritesTableViewController.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 10/05/2022.
//

import UIKit
import CoreData

class FavouritesTableViewController: UITableViewController {
    
    // core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var frc: NSFetchedResultsController<NSFetchRequestResult>!
    var entityName: String!
    
    // outlets and actions
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func didTapPlus(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let addVC = storyboard.instantiateViewController(identifier: "EditAddActorViewController") as! EditAddActorViewContoller

        let navigationController = UINavigationController(rootViewController: addVC)
        
        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate         = self
        tabBarController?.delegate = self
        
        let selectedItem = tabBarController?.tabBar.selectedItem!
        title = selectedItem?.title
        
        frc = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: createRequest(withPredicate: nil), managedObjectContext: context, sectionNameKeyPath: "category", cacheName: nil)
        frc.delegate = self
        fetch()
        
        if frc.sections?.count == 0 {
            let actorRepo = ActorRepository(xmlFilename: "actors.xml")
            actorRepo.addFavouriteActors(to: context)
            fetch()
        }
        
        let image             = UIImage(named: "background")
        let imageView         = UIImageView(image: image)
        imageView.alpha       = CGFloat(0.5)
        imageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = imageView
        
        let items = tabBarController?.tabBar.items
        
        updateItemImage(of: selectedItem, in: items)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return frc.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return frc.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return frc.sections?[section].name
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "actorCell", for: indexPath)

        // Configure the cell...
        let actor = frc.object(at: indexPath) as! FavouriteActorCD
        cell.textLabel?.text       = actor.name
        cell.detailTextLabel?.text = "\(actor.age) years"
        cell.imageView?.image      = actor.images != nil && actor.images!.count > 0 ? UIImage(data: actor.images![0]) : UIImage(systemName: "photo")
        cell.backgroundColor       = .clear
        
        let favouriteImage = UIImage(systemName: actor.isFavourite ? "star.fill" : "star")
        let favouriteButton = cell.contentView.viewWithTag(1) as! UIButton
        favouriteButton.addTarget(nil, action: #selector(didTapFavourite), for: .touchUpInside)
        favouriteButton.setImage(favouriteImage, for: .normal)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let actorCD = frc.object(at: indexPath) as! FavouriteActorCD
            
            do {
                context.delete(actorCD)
                try context.save()
            } catch {
                print(error)
            }
            
            if searchBar.text != "" {
                searchBar.text = ""
                self.searchBar(searchBar, textDidChange: "")
            }
        }
    }
    
    // method called when favouriteButton is tapped
    @objc func didTapFavourite(_ sender: UIButton) {
        
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)
        let favActorCD = frc.object(at: indexPath!) as! FavouriteActorCD
        
        context.delete(favActorCD)
        
        tableView.reloadData()
        
        let actorFrc = NSFetchedResultsController<NSFetchRequestResult>(fetchRequest: createRequest(withPredicate: favActorCD.name!, entityName: "ActorCD"), managedObjectContext: context, sectionNameKeyPath: "category", cacheName: nil)
        
        do {
            try actorFrc.performFetch()
        } catch {
            print(error)
        }
        
        let actorCD = actorFrc.sections?[0].objects?[0] as! ActorCD
        actorCD.isFavourite = false
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoActorInfo" {
            // Get the new view controller using segue.destination.
            let actorInfoVC = segue.destination as! ActorInfoViewController
            
            // Pass the selected object to the new view controller.
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            actorInfoVC.favouriteActorCD = frc.object(at: indexPath!) as? FavouriteActorCD
        }
    }

}

// MARK: - Search bar delegate
extension FavouritesTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            frc = NSFetchedResultsController(fetchRequest: createRequest(withPredicate: nil), managedObjectContext: context, sectionNameKeyPath: "category", cacheName: nil)
        } else {
            let lowerCaseSearchText = searchText.lowercased()

            frc = NSFetchedResultsController(fetchRequest: createRequest(withPredicate: lowerCaseSearchText), managedObjectContext: context, sectionNameKeyPath: "category", cacheName: nil)
        }
        
        frc.delegate = self
        fetch()
        tableView.reloadData()
    }
}

// MARK: - Tab bar Controller Delegate
extension FavouritesTableViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        updateItemImage(of: tabBarController.tabBar.selectedItem, in: tabBarController.tabBar.items)
    }
    
    private func updateItemImage(of selectedItem: UITabBarItem?, in allItems: [UITabBarItem]?) {
        
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

// MARK:- Care Data
extension FavouritesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
    }
    
    func createRequest(withPredicate value: String?, entityName: String = "FavouriteActorCD") -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let categorySorter = NSSortDescriptor(key: "category", ascending: true)
        let nameSorter     = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [categorySorter, nameSorter]
        
        if value != nil {
            let predicate = NSPredicate(format: "name CONTAINS[c] %@", value!)
            request.predicate = predicate
        }

        return request
    }
    
    func fetch() {
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
    }
}

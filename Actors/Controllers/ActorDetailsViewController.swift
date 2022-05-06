//
//  ActorDetailsViewController.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import UIKit

class ActorDetailsViewController: UITableViewController {

    // model data
    var actor: Actor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let isLastCharS = actor.name.last == "s"
        title = actor.name + (isLastCharS ? "' details" : "'s details")
        
        let image             = UIImage(named: "background")
        let imageView         = UIImageView(image: image)
        imageView.alpha       = CGFloat(0.5)
        imageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = imageView
    }

    // MARK: -Table View Data Source
    
    let rowInSection0 = 6
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Details" : "Filmography"
    }
    
    // rowInSection0 represents the number of details displayed about the actor
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? rowInSection0 : actor.filmography.count
    }
    
    // configure heights for each individual detail cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 100
            case 4:
                return 150
            case 1...5:
                return 50
            default:
                return 0
            }
        }
        
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // configure each individual cell to display the proper details information about the actor
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.imageView?.image = UIImage(named: actor.images[0])
                cell.textLabel?.text = actor.name
                cell.detailTextLabel?.text = "\(actor.age) years old"
                cell.selectionStyle = .none
            case 1:
                cell.textLabel?.text = actor.cityOfBirth
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 2:
                cell.textLabel?.text = actor.phoneNo
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 3:
                cell.textLabel?.text = actor.email
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 4:
                cell.textLabel?.text = actor.description
                cell.textLabel?.numberOfLines = 10
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 5:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                let websiteButton = UIButton(type: .system)
                cell.addSubview(websiteButton)
                websiteButton.showsTouchWhenHighlighted = true
                websiteButton.frame = cell.bounds
                websiteButton.setTitle(actor.website, for: .normal)
                websiteButton.setTitleColor(.systemBlue, for: .normal)
                websiteButton.titleLabel?.font = UIFont(name: "system", size: 20)
                websiteButton.titleLabel?.numberOfLines = 5
                websiteButton.addTarget(nil, action: #selector(didTapCell), for: .touchUpInside)
            default:
                break
            }
        } else {
            cell.textLabel?.text = actor.filmography[indexPath.row]
            cell.detailTextLabel?.text = ""
            cell.selectionStyle = .none
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    // function called when websiteButton is touched up inside
    @objc func didTapCell() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let actorWebsiteVC = storyboard.instantiateViewController(identifier: "ActorWebsiteViewController") as! ActorWebsiteViewController

        actorWebsiteVC.actorName = actor.name
        actorWebsiteVC.actorWebsite = actor.website
        
        navigationController?.pushViewController(actorWebsiteVC, animated: true)
    }
}

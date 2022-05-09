//
//  ActorDetailsViewController.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import UIKit

class ActorDetailsViewController: UITableViewController {

    // model data
    var actor: ActorCD!
    var actorImageView = UIImageView()
    
    // variables for arranging cells in table view
    // rowsInSection0 represents the number of details displayed about the actor
    let rowsInSection0 = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let isLastCharS = actor.name!.last == "s"
        title = actor.name! + (isLastCharS ? "' details" : "'s details")
        actor.filmography?.sort()
        let image                       = UIImage(named: "background")
        let backgroundImageView         = UIImageView(image: image)
        backgroundImageView.alpha       = CGFloat(0.5)
        backgroundImageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = backgroundImageView
    }

    // MARK: -Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "Details" : "Filmography"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0
            ? rowsInSection0
            : actor.filmography?.count ?? 0
    }
    
    // configure heights for each individual detail cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 100
            case 5:
                return 150
            case 1..<5:
                return 50
            case 6:
                return 55
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
                cell.imageView?.image = actor.images != nil && actor.images!.count > 0 ? UIImage(data: actor.images![0]) : UIImage(systemName: "photo")
                cell.textLabel?.text = actor.name
                cell.detailTextLabel?.text = "\(actor.age) years"
                cell.selectionStyle = .none
            case 1:
                cell.textLabel?.text = actor.category
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 2:
                cell.textLabel?.text = actor.cityOfBirth
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 3:
                cell.textLabel?.text = actor.phoneNo
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 4:
                cell.textLabel?.text = actor.email
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 5:
                cell.textLabel?.text = actor.actorDescription
                cell.textLabel?.numberOfLines = 10
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            case 6:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                let websiteButton = UIButton(type: .system)
                cell.addSubview(websiteButton)
                websiteButton.frame = cell.bounds
                websiteButton.setTitle(actor.website, for: .normal)
                websiteButton.setTitleColor(.systemBlue, for: .normal)
                websiteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                websiteButton.titleLabel?.numberOfLines = 5
                websiteButton.addTarget(nil, action: #selector(didTapCell), for: .touchUpInside)
            default:
                break
            }
        } else {
            cell.textLabel?.text = actor.filmography![indexPath.row]
            cell.detailTextLabel?.text = ""
            cell.selectionStyle = .none
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    // method called when websiteButton is tapped
    @objc func didTapCell() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let actorWebsiteVC = storyboard.instantiateViewController(identifier: "ActorWebsiteViewController") as! ActorWebsiteViewController

        actorWebsiteVC.actorName = actor.name
        actorWebsiteVC.actorWebsite = actor.website
        
        navigationController?.pushViewController(actorWebsiteVC, animated: true)
    }

    // MARK:- Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoEditActor" {
            // Get the new view controller using segue.destination.
            let editAddActorVC = segue.destination as! EditAddActorViewContoller
            
            // Pass the selected object to the new view controller.
            editAddActorVC.actor = actor
        }
    }
}

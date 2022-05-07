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
    var actorImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if actor != nil {
            let isLastCharS = actor.name.last == "s"
            title = actor.name + (isLastCharS ? "' details" : "'s details")
        } else {
            title = "New Actor"
            actorImageView.image = UIImage(systemName: "photo")
        }
        
        let image                       = UIImage(named: "background")
        let backgroundImageView         = UIImageView(image: image)
        backgroundImageView.alpha       = CGFloat(0.5)
        backgroundImageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = backgroundImageView
    }

    // MARK: -Table View Data Source
    
    let rowsInSection0 = 6
    let rowsInSection1 = 4
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Details" : "Filmography"
    }
    
    // rowsInSection0 represents the number of details displayed about the actor
    // rowsInSection1 represents the default number of films
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0
            ? rowsInSection0
            : (actor != nil
                ? actor.filmography.count
                : rowsInSection1)
    }
    
    // configure heights for each individual detail cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 100
            case 4:
                return 150
            case 1...4:
                return 50
            case 5:
                return 55
            default:
                return 0
            }
        }
        
        return restorationIdentifier == "editAddVC" ? 50 : 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if restorationIdentifier == "editAddVC" {
            if actor != nil {
                if indexPath.section == 0 {
                    switch indexPath.row {
                    case 0:
                        let cellBounds = cell.contentView.bounds
                        
                        let nameTextView = UITextView()
                        let ageTextView  = UITextView()
                        
                        actorImageView.frame = CGRect(x: cellBounds.minX + 20, y: cellBounds.minY, width: cellBounds.width - 350, height: cellBounds.height)
                        actorImageView.image = UIImage(named: actor.images[0])
                        actorImageView.contentMode = .scaleAspectFit
                        let tap = UITapGestureRecognizer(
                            target: self,
                            action: #selector(didTapImage)
                        )
                        tap.numberOfTapsRequired = 1
                        actorImageView.isUserInteractionEnabled = true
                        actorImageView.addGestureRecognizer(tap)
                        
                        nameTextView.frame = CGRect(x: cellBounds.minX + 100, y: cellBounds.minY + 10, width: cellBounds.width - 130, height: cellBounds.height - 60)
                        nameTextView.text = actor.name
                        nameTextView.layer.cornerRadius = 5
                        nameTextView.font = UIFont.systemFont(ofSize: 20)
                        
                        ageTextView.frame = CGRect(x: cellBounds.minX + 100, y: cellBounds.minY + 60, width: cellBounds.width - 130, height: cellBounds.height - 70)
                        ageTextView.text = "\(actor.age) years"
                        ageTextView.layer.cornerRadius = 5
                        ageTextView.font = UIFont.systemFont(ofSize: 17)
                        
                        cell.contentView.addSubview(actorImageView)
                        cell.contentView.addSubview(nameTextView)
                        cell.contentView.addSubview(ageTextView)

                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        cell.selectionStyle = .none
                    case 1:
                        let cityTextView = UITextView()
                        cell.contentView.addSubview(cityTextView)
                        cityTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                        cityTextView.backgroundColor = .white
                        cityTextView.text = actor.cityOfBirth
                        cityTextView.layer.cornerRadius = 5
                        cityTextView.font = UIFont.systemFont(ofSize: 17)
                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        cell.selectionStyle = .none
                    case 2:
                        let phoneTextView = UITextView()
                        cell.contentView.addSubview(phoneTextView)
                        phoneTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                        phoneTextView.backgroundColor = .white
                        phoneTextView.text = actor.phoneNo
                        phoneTextView.layer.cornerRadius = 5
                        phoneTextView.font = UIFont.systemFont(ofSize: 17)
                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        cell.selectionStyle = .none
                    case 3:
                        let emailTextView = UITextView()
                        cell.contentView.addSubview(emailTextView)
                        emailTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                        emailTextView.backgroundColor = .white
                        emailTextView.text = actor.email
                        emailTextView.layer.cornerRadius = 5
                        emailTextView.font = UIFont.systemFont(ofSize: 17)
                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        cell.selectionStyle = .none
                    case 4:
                        let descriptionTextView = UITextView()
                        cell.contentView.addSubview(descriptionTextView)
                        descriptionTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                        descriptionTextView.backgroundColor = .white
                        descriptionTextView.text = actor.description
                        descriptionTextView.layer.cornerRadius = 5
                        descriptionTextView.font = UIFont.systemFont(ofSize: 17)
                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        cell.selectionStyle = .none
                    case 5:
                        let websiteTextView = UITextView()
                        
                        websiteTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                        websiteTextView.text = actor.website
                        websiteTextView.textColor = .systemBlue
                        websiteTextView.layer.cornerRadius = 5
                        websiteTextView.font = UIFont.systemFont(ofSize: 17)
                        
                        cell.addSubview(websiteTextView)
                        
                        cell.textLabel?.text = ""
                        cell.detailTextLabel?.text = ""
                        cell.selectionStyle = .none
                    default:
                        break
                    }
                } else {
                    let filmTextView = UITextView()
                    cell.contentView.addSubview(filmTextView)
                    filmTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 10, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 20)
                    filmTextView.backgroundColor = .white
                    filmTextView.text = actor.filmography[indexPath.row]
                    filmTextView.layer.cornerRadius = 5
                    filmTextView.font = UIFont.systemFont(ofSize: 15)
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                    cell.selectionStyle = .none
                }
            }
        } else {
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
    
    @objc func didTapImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK:- Navigation Delegate
extension ActorDetailsViewController: UINavigationControllerDelegate {
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoEditActor" {
            // Get the new view controller using segue.destination.
            let actorDetailsVC = segue.destination as! EditAddActorViewContoller
            
            // Pass the selected object to the new view controller.
            actorDetailsVC.actor = self.actor
        }
    }
}

// MARK:- Image Picker Delegate
extension ActorDetailsViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancelled
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        actorImageView.image = image
    }
}

//
//  EditAddActorViewContoller.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import UIKit

class EditAddActorViewContoller: UITableViewController {

    // model data
    var actor: Actor!
    var actorImageView = UIImageView()
    var textPlaceholder = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if actor != nil {
            let isLastCharS = actor.name.last == "s"
            title = "Edit " + actor.name + (isLastCharS ? "' details" : "'s details")
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
    
    // Actions
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
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
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if actor != nil {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    let cellBounds = cell.contentView.bounds
                    
                    let nameTextView = UITextView()
                    let ageTextView  = UITextView()
                    
                    actorImageView.frame = CGRect(x: cellBounds.minX + 20, y: cellBounds.minY, width: cellBounds.width - 350, height: cellBounds.height)
                    
                    let image = UIImageView(image: UIImage(named: actor.images[0]))
                    image.frame = actorImageView.bounds
                    image.alpha = 0.5
                    actorImageView.addSubview(image)
                    let photoImage = UIImageView(image: UIImage(systemName: "photo"))
                    photoImage.frame = CGRect(x: cellBounds.minX, y: cellBounds.minY, width: cellBounds.width - 350, height: cellBounds.height)
                    photoImage.contentMode = .scaleAspectFit
                    actorImageView.addSubview(photoImage)
                    
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
                    nameTextView.textColor = .lightGray
                    nameTextView.layer.cornerRadius = 5
                    nameTextView.font = UIFont.systemFont(ofSize: 20)
                    nameTextView.delegate = self
                    
                    ageTextView.frame = CGRect(x: cellBounds.minX + 100, y: cellBounds.minY + 60, width: cellBounds.width - 130, height: cellBounds.height - 70)
                    ageTextView.delegate = self
                    ageTextView.text = "\(actor.age) years"
                    ageTextView.textColor = .lightGray
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
                    cityTextView.delegate = self
                    cityTextView.text = actor.cityOfBirth
                    cityTextView.textColor = .lightGray
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
                    phoneTextView.delegate = self
                    phoneTextView.text = actor.phoneNo
                    phoneTextView.textColor = .lightGray
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
                    emailTextView.delegate = self
                    emailTextView.text = actor.email
                    emailTextView.textColor = .lightGray
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
                    descriptionTextView.delegate = self
                    descriptionTextView.text = actor.description
                    descriptionTextView.textColor = .lightGray
                    descriptionTextView.layer.cornerRadius = 5
                    descriptionTextView.font = UIFont.systemFont(ofSize: 17)
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                    cell.selectionStyle = .none
                case 5:
                    let websiteTextView = UITextView()
                    
                    websiteTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                    websiteTextView.delegate = self
                    websiteTextView.text = actor.website
                    websiteTextView.textColor = .lightGray
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
                filmTextView.delegate = self
                filmTextView.text = actor.filmography[indexPath.row]
                filmTextView.textColor = .lightGray
                filmTextView.layer.cornerRadius = 5
                filmTextView.font = UIFont.systemFont(ofSize: 15)
                
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            }
        } else {
            if indexPath.section == 0 {
                switch indexPath.row {
                case 0:
                    let cellBounds = cell.contentView.bounds
                    
                    let nameTextView = UITextView()
                    let ageTextView  = UITextView()
                    
                    actorImageView.frame = CGRect(x: cellBounds.minX + 20, y: cellBounds.minY, width: cellBounds.width - 350, height: cellBounds.height)
                    actorImageView.contentMode = .scaleAspectFit
                    let tap = UITapGestureRecognizer(
                        target: self,
                        action: #selector(didTapImage)
                    )
                    tap.numberOfTapsRequired = 1
                    actorImageView.isUserInteractionEnabled = true
                    actorImageView.addGestureRecognizer(tap)
                    
                    nameTextView.frame = CGRect(x: cellBounds.minX + 100, y: cellBounds.minY + 10, width: cellBounds.width - 130, height: cellBounds.height - 60)
                    nameTextView.layer.cornerRadius = 5
                    nameTextView.font = UIFont.systemFont(ofSize: 20)
                    nameTextView.delegate = self
                    nameTextView.text = "Name"
                    nameTextView.textColor = .lightGray
                    
                    ageTextView.frame = CGRect(x: cellBounds.minX + 100, y: cellBounds.minY + 60, width: cellBounds.width - 130, height: cellBounds.height - 70)
                    ageTextView.layer.cornerRadius = 5
                    ageTextView.font = UIFont.systemFont(ofSize: 17)
                    ageTextView.delegate = self
                    ageTextView.text = "Age"
                    ageTextView.textColor = .lightGray
                    
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
                    cityTextView.layer.cornerRadius = 5
                    cityTextView.font = UIFont.systemFont(ofSize: 17)
                    cityTextView.delegate = self
                    cityTextView.text = "City of birth"
                    cityTextView.textColor = .lightGray
                    
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                    cell.selectionStyle = .none
                case 2:
                    let phoneTextView = UITextView()
                    cell.contentView.addSubview(phoneTextView)
                    phoneTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                    phoneTextView.backgroundColor = .white
                    phoneTextView.layer.cornerRadius = 5
                    phoneTextView.font = UIFont.systemFont(ofSize: 17)
                    phoneTextView.delegate = self
                    phoneTextView.text = "Phone number"
                    phoneTextView.textColor = .lightGray
                    
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                    cell.selectionStyle = .none
                case 3:
                    let emailTextView = UITextView()
                    cell.contentView.addSubview(emailTextView)
                    emailTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                    emailTextView.backgroundColor = .white
                    emailTextView.layer.cornerRadius = 5
                    emailTextView.font = UIFont.systemFont(ofSize: 17)
                    emailTextView.delegate = self
                    emailTextView.text = "Email"
                    emailTextView.textColor = .lightGray
                    
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                    cell.selectionStyle = .none
                case 4:
                    let descriptionTextView = UITextView()
                    cell.contentView.addSubview(descriptionTextView)
                    descriptionTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                    descriptionTextView.backgroundColor = .white
                    descriptionTextView.layer.cornerRadius = 5
                    descriptionTextView.font = UIFont.systemFont(ofSize: 17)
                    descriptionTextView.delegate = self
                    descriptionTextView.text = "Description"
                    descriptionTextView.textColor = .lightGray
                    
                    cell.textLabel?.text = ""
                    cell.detailTextLabel?.text = ""
                    cell.selectionStyle = .none
                case 5:
                    let websiteTextView = UITextView()
                    
                    websiteTextView.frame = CGRect(x: cell.contentView.bounds.minX + 20, y: cell.contentView.bounds.minY + 5, width: cell.contentView.bounds.width - 40, height: cell.contentView.bounds.height - 10)
                    websiteTextView.textColor = .systemBlue
                    websiteTextView.layer.cornerRadius = 5
                    websiteTextView.font = UIFont.systemFont(ofSize: 17)
                    websiteTextView.delegate = self
                    websiteTextView.text = "Website"
                    websiteTextView.textColor = .lightGray
                    
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
                filmTextView.layer.cornerRadius = 5
                filmTextView.font = UIFont.systemFont(ofSize: 15)
                filmTextView.delegate = self
                filmTextView.text = "Film"
                filmTextView.textColor = .lightGray
                
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                cell.selectionStyle = .none
            }
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }

    @objc func didTapImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK:- Image Picker Delegate
extension EditAddActorViewContoller: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // cancelled
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        for subview in actorImageView.subviews {
            actorImageView.willRemoveSubview(subview)
            subview.removeFromSuperview()
        }
        
        actorImageView.image = image
        actorImageView.alpha = 1
    }
}

// MARK:- Text View Delegate
extension EditAddActorViewContoller: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textPlaceholder = textView.text
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

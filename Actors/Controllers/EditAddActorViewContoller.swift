//
//  EditAddActorViewContoller.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import UIKit
import CoreData

class EditAddActorViewContoller: UITableViewController {

    // model data
    var actorCD         : ActorCD!
    var favouriteActorCD: FavouriteActorCD!
    
    private var actor: Actor!
    
    // core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // variables for arranging cells in table view
    // rowsInSection0 represents the number of details displayed about the actor
    // rowsInSection1 represents the default number of films
    let rowsInSection0 = 8
    let rowsInSection1 = 4
    
    // other variables
    var actorImageView = UIImageView()
    var textPlaceholder = ""
    var indexTag = 1
    var isEditMode = false
    
    // outlets and actions
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        if isEditMode {
            if actorCD != nil{
                updateActor()
            } else {
                updateActor()
            }
            navigationController?.popToRootViewController(animated: true)
        } else {
            insertActor()
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isEditMode = actorCD != nil || favouriteActorCD != nil
        if isEditMode && actorCD != nil {
            actor = Actor(actorCD: actorCD)
        } else if isEditMode {
            actor = Actor(favActorCD: favouriteActorCD)
        }
        
        if isEditMode {
            let isLastCharS = actor.name.last == "s"
            title = "Edit " + actor.name + (isLastCharS ? "' details" : "'s details")
            actor.filmography.sort()
        } else {
            title = "New Actor"
        }
        
        saveButton.isEnabled = false
        
        let image                       = UIImage(named: "background")
        let backgroundImageView         = UIImageView(image: image)
        backgroundImageView.alpha       = CGFloat(0.5)
        backgroundImageView.contentMode = .scaleAspectFill
        
        tableView.backgroundView = backgroundImageView
    }
    
    // MARK:- Methods to deal CoreData
    func insertActor() {
        let entity = NSEntityDescription.entity(forEntityName: "ActorCD", in: context)
        let actorCD = ActorCD(entity: entity!, insertInto: context)
        var favouriteActorCD: FavouriteActorCD! = nil
        
        let favouriteSwitch = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UISwitch }.first as! UISwitch
        
        let isFavourite = favouriteSwitch.isOn
        
        if isFavourite {
            let favEntity = NSEntityDescription.entity(forEntityName: "FavouriteActorCD", in: context)
            favouriteActorCD = FavouriteActorCD(entity: favEntity!, insertInto: context)
        }
        
        let textViews = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UITextView }
        
        actorCD.filmography = ["", "", "", ""]
        actorCD.isFavourite = isFavourite
        
        if isFavourite {
            favouriteActorCD.filmography = ["", "", "", ""]
            favouriteActorCD.isFavourite = isFavourite
        }
        
        for subview in textViews {
            switch subview.tag {
            case 1:
                actorCD.name = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.name = (subview as! UITextView).text
                }
            case 2:
                actorCD.age = Int16((subview as! UITextView).text) ?? 0
                if isFavourite {
                    favouriteActorCD.age = Int16((subview as! UITextView).text) ?? 0
                }
            case 3:
                actorCD.category = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.category = (subview as! UITextView).text
                }
            case 4:
                actorCD.cityOfBirth = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.cityOfBirth = (subview as! UITextView).text
                }
            case 5:
                actorCD.phoneNo = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.phoneNo = (subview as! UITextView).text
                }
            case 6:
                actorCD.email = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.email = (subview as! UITextView).text
                }
            case 7:
                actorCD.actorDescription = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.actorDescription = (subview as! UITextView).text
                }
            case 8:
                actorCD.website = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.website = (subview as! UITextView).text
                }
            case 9:
                actorCD.filmography![0] = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.filmography![0] = (subview as! UITextView).text
                }
            case 10:
                actorCD.filmography![1] = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.filmography![1] = (subview as! UITextView).text
                }
            case 11:
                actorCD.filmography![2] = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.filmography![2] = (subview as! UITextView).text
                }
            case 12:
                actorCD.filmography![3] = (subview as! UITextView).text
                if isFavourite {
                    favouriteActorCD.filmography![3] = (subview as! UITextView).text
                }
            default:
                break
            }
        }
        
        let imageView = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UIImageView }.first as! UIImageView
        
        let imageData = imageView.image?.pngData()
        if imageData != nil {
            actorCD.images = [imageData!]
            if isFavourite {
                favouriteActorCD.images = [imageData!]
            }
        }
        
        // save changes
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func updateActor() {
        
        let textViews = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UITextView }
        var isChanged = false
        
        for subview in textViews {
            if !(subview as! UITextView).text.isEmpty {
                switch subview.tag {
                case 1:
                    let insertedName = (subview as! UITextView).text
                    if actorCD != nil && actorCD.name != insertedName {
                        actorCD.name = insertedName
                        isChanged = true
                    } else if favouriteActorCD != nil && favouriteActorCD.name != insertedName {
                        favouriteActorCD.name = insertedName
                        isChanged = true
                    }
                case 2:
                    let insertedAge = (subview as! UITextView).text
                    if actorCD != nil && "\(actorCD.age) years" != insertedAge {
                        actorCD.age = Int16(insertedAge!) ?? 0
                        isChanged = true
                    } else if favouriteActorCD != nil && "\(favouriteActorCD.age) years" != insertedAge {
                        favouriteActorCD.age = Int16(insertedAge!) ?? 0
                        isChanged = true
                    }
                case 3:
                    let insertedCategory = (subview as! UITextView).text
                    if actorCD != nil && actorCD.category != insertedCategory {
                        actorCD.category = insertedCategory
                        isChanged = true
                    } else if favouriteActorCD != nil && favouriteActorCD.category != insertedCategory{
                        favouriteActorCD.category = insertedCategory
                        isChanged = true
                    }
                case 4:
                    let insertedCityOfBirth = (subview as! UITextView).text
                    if actorCD != nil && actorCD.cityOfBirth != insertedCityOfBirth {
                        actorCD.cityOfBirth = insertedCityOfBirth
                        isChanged = true
                    } else if favouriteActorCD != nil && favouriteActorCD.cityOfBirth != insertedCityOfBirth {
                        favouriteActorCD.cityOfBirth = insertedCityOfBirth
                        isChanged = true
                    }
                case 5:
                    let insertedPhoneNo = (subview as! UITextView).text
                    if actorCD != nil && actorCD.phoneNo != insertedPhoneNo {
                        actorCD.phoneNo = insertedPhoneNo
                        isChanged = true
                    } else if favouriteActorCD != nil && favouriteActorCD.phoneNo != insertedPhoneNo {
                        favouriteActorCD.phoneNo = insertedPhoneNo
                        isChanged = true
                    }
                case 6:
                    let insertedEmail = (subview as! UITextView).text
                    if actorCD != nil && actorCD.email != insertedEmail {
                        actorCD.email = insertedEmail
                        isChanged = true
                    } else if favouriteActorCD != nil && favouriteActorCD.email != insertedEmail {
                        favouriteActorCD.email = insertedEmail
                        isChanged = true
                    }
                case 7:
                    let insertedDescription = (subview as! UITextView).text
                    if actorCD != nil && actorCD.actorDescription != insertedDescription {
                        actorCD.actorDescription = insertedDescription
                        isChanged = true
                    } else if favouriteActorCD != nil && favouriteActorCD.actorDescription != insertedDescription {
                        favouriteActorCD.actorDescription = insertedDescription
                        isChanged = true
                    }
                case 8:
                    let insertedWebsite = (subview as! UITextView).text
                    if actorCD != nil && actorCD.website != insertedWebsite {
                        actorCD.website = insertedWebsite
                        isChanged = true
                    } else if favouriteActorCD != nil && favouriteActorCD.website != insertedWebsite{
                        favouriteActorCD.website = insertedWebsite
                        isChanged = true
                    }
                case 9..<actor.filmography.count + 9:
                    let insertedFilm = (subview as! UITextView).text
                    if actorCD != nil && actorCD.filmography![subview.tag - 9] != insertedFilm {
                        actorCD.filmography![subview.tag - 9] = insertedFilm!
                        isChanged = true
                    } else if favouriteActorCD != nil && favouriteActorCD.filmography![subview.tag - 9] != insertedFilm {
                        favouriteActorCD.filmography![subview.tag - 9] = insertedFilm!
                        isChanged = true
                    }
                default:
                    break
                }
            }
        }
        
        let imageView = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UIImageView }.first as! UIImageView
        
        if imageView.alpha == 1 {
            isChanged = true
            let imageData = imageView.image?.pngData()
            if imageData != nil {
                isChanged = true
                if actorCD != nil {
                    if actorCD.images!.count > 0 {
                        actorCD.images![0] = imageData!
                    } else {
                        actorCD.images = [imageData!]
                    }
                } else {
                    if favouriteActorCD.images!.count > 0 {
                        favouriteActorCD.images![0] = imageData!
                    } else {
                        favouriteActorCD.images = [imageData!]
                    }
                }
            }
        }
        
        if isChanged {
            // save changes
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
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
            case 1:
                return isEditMode ? 0 : 50
            case 6:
                return 150
            case 2..<6:
                return 50
            case 7:
                return 55
            default:
                return 0
            }
        }
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                actorImageView = createImageView(
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetWidth: 350)
                
                let nameTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.name : "Name",
                    font: getFont(20),
                    bounds: cell.bounds,
                    offsetX: 100,
                    offsetY: 10,
                    offsetWidth: 130,
                    offsetHeight: 60)
                indexTag += 1
                
                let ageTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? "\(actor.age) years" : "Age",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 100,
                    offsetY: 60,
                    offsetWidth: 130,
                    offsetHeight: 70)
                indexTag += 1
                
                ageTextView.keyboardType = .numberPad
                
                cell.contentView.addSubview(actorImageView)
                cell.contentView.addSubview(nameTextView)
                cell.contentView.addSubview(ageTextView)
            case 1:
                let favouriteSwitch = UISwitch()
                favouriteSwitch.frame = CGRect(
                    x: cell.bounds.maxX - 80,
                    y: cell.bounds.minY + 10,
                    width: 50,
                    height: 50)
                favouriteSwitch.isOn = false
                favouriteSwitch.onTintColor = .systemBlue
                
                cell.textLabel?.text = "Is favourite"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
                cell.contentView.addSubview(favouriteSwitch)
            case 2:
                let categoryTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.category : "Category",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                cell.contentView.addSubview(categoryTextView)
            case 3:
                let cityTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.cityOfBirth : "City of birth",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                cell.contentView.addSubview(cityTextView)
            case 4:
                let phoneTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.phoneNo : "Phone number",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                cell.contentView.addSubview(phoneTextView)
            case 5:
                let emailTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.email : "Email",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                emailTextView.textContentType = .emailAddress
                emailTextView.autocapitalizationType = .none
                emailTextView.keyboardType = .emailAddress
                
                cell.contentView.addSubview(emailTextView)
            case 6:
                let descriptionTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.description : "Description",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                cell.contentView.addSubview(descriptionTextView)
            case 7:
                let websiteTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.website : "Website",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                websiteTextView.textContentType = .URL
                websiteTextView.autocapitalizationType = .none
                websiteTextView.autocorrectionType = .no
                websiteTextView.keyboardType = .URL
                
                cell.contentView.addSubview(websiteTextView)
            default:
                break
            }
        } else {
            if cell.contentView.subviews.filter({ $0 is UITextView }).count <= 0 {
                let filmTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.filmography[indexPath.row] : "Film",
                    font: getFont(15),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 10,
                    offsetWidth: 40,
                    offsetHeight: 20)
                indexTag += 1
                
                cell.contentView.addSubview(filmTextView)
            }
        }
        
        if indexPath.row != 1 {
            cell.textLabel?.text       = ""
        }
        cell.detailTextLabel?.text = ""
        cell.selectionStyle        = .none
        cell.backgroundColor       = .clear
        
        return cell
    }

    // method called when actorImage is tapped
    @objc func didTapImage() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func createImageView(bounds: CGRect, offsetX: CGFloat, offsetWidth: CGFloat) -> UIImageView {
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage)
        )
        tap.numberOfTapsRequired = 1
        
        let imageView = UIImageView()
        
        imageView.frame = CGRect(
            x: bounds.minX + offsetX,
            y: bounds.minY,
            width: bounds.width - offsetWidth,
            height: bounds.height)
        
        imageView.alpha = 0.5
        
        imageView.contentMode              = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        
        if isEditMode {
            imageView.image = actor.images.count > 0 ? UIImage(data: actor.images[0]) : UIImage(systemName: "photo")
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        return imageView
    }
    
    private func createTextView(withTag tag: Int, text: String, font: UIFont, bounds: CGRect, offsetX: CGFloat, offsetY: CGFloat, offsetWidth: CGFloat, offsetHeight: CGFloat) -> UITextView {
        
        let textView = UITextView()
        
        textView.tag = tag
        
        textView.frame = CGRect(
            x:      bounds.minX + offsetX,
            y:      bounds.minY + offsetY,
            width:  bounds.width - offsetWidth,
            height: bounds.height - offsetHeight)
        
        textView.font      = font
        textView.text      = text
        textView.textColor = .lightGray
        textView.delegate  = self
        
        textView.layer.cornerRadius = 5
        
        return textView
    }
    
    private func getFont(_ fontSize: CGFloat) -> UIFont {
        
        return UIFont.systemFont(ofSize: fontSize)
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
        
        if isEditMode {
            saveButton.isEnabled = true
        } else {
            let subviews = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UITextView || $0 is UIImageView }
            
            var isEnabled = true
            
            for subview in subviews {
                if (subview is UITextView && ((subview as! UITextView).textColor == .lightGray || (subview as! UITextView).text.isEmpty)) || (subview is UIImageView && (subview as! UIImageView).alpha == 0.5) {
                    isEnabled = false
                }
            }
            
            saveButton.isEnabled = isEnabled
        }
    }
}

// MARK:- Text View Delegate
extension EditAddActorViewContoller: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == .lightGray {
            textPlaceholder = textView.text
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = textPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if !textView.text.isEmpty {
            if isEditMode {
                saveButton.isEnabled = true
            } else {
                let subviews = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UITextView || $0 is UIImageView }
                
                var isEnabled = true
                
                for subview in subviews {
                    if (subview is UITextView && ((subview as! UITextView).textColor == .lightGray || (subview as! UITextView).text.isEmpty)) || (subview is UIImageView && (subview as! UIImageView).alpha == 0.5) {
                        isEnabled = false
                    }
                }
                
                saveButton.isEnabled = isEnabled
            }
        } else if isEditMode {
            let subviews = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UITextView || $0 is UIImageView }
            
            var isEnabled = false
            
            for subview in subviews {
                if subview is UITextView && ((subview as! UITextView).textColor != .lightGray && !(subview as! UITextView).text.isEmpty) || subview is UIImageView && (subview as! UIImageView).alpha != 0.5 {
                    isEnabled = true
                }
            }
            
            saveButton.isEnabled = isEnabled
        } else {
            saveButton.isEnabled = false
        }
    }
}

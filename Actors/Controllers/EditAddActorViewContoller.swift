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
    var actor: ActorCD!
    var actorImageView = UIImageView()
    var textPlaceholder = ""
    var indexTag = 1
    
    // core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // variables for arranging cells in table view
    // rowsInSection0 represents the number of details displayed about the actor
    // rowsInSection1 represents the default number of films
    let rowsInSection0 = 7
    let rowsInSection1 = 4
    
    var isEditMode = false
    
    // actions
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        if actor != nil {
            updateActor()
        } else {
            insertActor()
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isEditMode = actor != nil
        
        if isEditMode {
            let isLastCharS = actor.name!.last == "s"
            title = "Edit " + actor.name! + (isLastCharS ? "' details" : "'s details")
            actor.filmography?.sort()
        } else {
            title = "New Actor"
        }
        
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
        
        let textViews = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UITextView}
        
        actorCD.filmography = ["", "", "", ""]
        actorCD.isFavourite = false
        
        for subview in textViews {
            switch subview.tag {
            case 1:
                actorCD.name = (subview as! UITextView).text
            case 2:
                actorCD.age = Int16((subview as! UITextView).text) ?? 0
            case 3:
                actorCD.category = (subview as! UITextView).text
            case 4:
                actorCD.cityOfBirth = (subview as! UITextView).text
            case 5:
                actorCD.phoneNo = (subview as! UITextView).text
            case 6:
                actorCD.email = (subview as! UITextView).text
            case 7:
                actorCD.actorDescription = (subview as! UITextView).text
            case 8:
                actorCD.website = (subview as! UITextView).text
            case 9:
                actorCD.filmography![0] = (subview as! UITextView).text
            case 10:
                actorCD.filmography![1] = (subview as! UITextView).text
            case 11:
                actorCD.filmography![2] = (subview as! UITextView).text
            case 12:
                actorCD.filmography![3] = (subview as! UITextView).text
            default:
                break
            }
        }
        
        let imageView = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UIImageView}.first as! UIImageView
        
        let imageData = imageView.image?.pngData()
        if imageData != nil {
            actorCD.images = [imageData!]
        }
        
        // save changes
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func updateActor() {
        
        let textViews = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UITextView}
        var isChanged = false
        for subview in textViews {
            if !(subview as! UITextView).text.isEmpty {
                switch subview.tag {
                case 1:
                    actor.name = (subview as! UITextView).text
                    isChanged = true
                case 2:
                    if (subview as! UITextView).text != "\(actor.age) years" {
                        actor.age = Int16((subview as! UITextView).text) ?? 0
                        isChanged = true
                    } else {
                        isChanged = false
                    }
                case 3:
                    actor.category = (subview as! UITextView).text
                    isChanged = true
                case 4:
                    actor.cityOfBirth = (subview as! UITextView).text
                    isChanged = true
                case 5:
                    actor.phoneNo = (subview as! UITextView).text
                    isChanged = true
                case 6:
                    actor.email = (subview as! UITextView).text
                    isChanged = true
                case 7:
                    actor.actorDescription = (subview as! UITextView).text
                    isChanged = true
                case 8:
                    actor.website = (subview as! UITextView).text
                    isChanged = true
                case 9..<actor.filmography!.count + 9:
                    actor.filmography![subview.tag - 9] = (subview as! UITextView).text
                    isChanged = true
                default:
                    break
                }
            }
        }
        
        let imageView = view.subviews.filter { $0 is UITableViewCell }.flatMap { $0.subviews }.flatMap { $0.subviews }.filter { $0 is UIImageView}.first as! UIImageView
        
        if imageView.alpha == 1 {
            isChanged = true
            let imageData = imageView.image?.pngData()
            if imageData != nil {
                isChanged = true
                if actor.images != nil && actor.images!.count > 0 {
                    actor.images![0] = imageData!
                } else {
                    actor.images = [imageData!]
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
                ? actor.filmography?.count ?? 0
                : rowsInSection1)
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
                    text: isEditMode ? actor.name! : "Name",
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
                
                cell.contentView.addSubview(actorImageView)
                cell.contentView.addSubview(nameTextView)
                cell.contentView.addSubview(ageTextView)
            case 1:
                let categoryTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.category! : "Category",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                cell.contentView.addSubview(categoryTextView)
            case 2:
                let cityTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.cityOfBirth! : "City of birth",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                cell.contentView.addSubview(cityTextView)
            case 3:
                let phoneTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.phoneNo! : "Phone number",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                cell.contentView.addSubview(phoneTextView)
            case 4:
                let emailTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.email! : "Email",
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
            case 5:
                let descriptionTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.actorDescription! : "Description",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                cell.contentView.addSubview(descriptionTextView)
            case 6:
                let websiteTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.website! : "Website",
                    font: getFont(17),
                    bounds: cell.bounds,
                    offsetX: 20,
                    offsetY: 5,
                    offsetWidth: 40,
                    offsetHeight: 10)
                indexTag += 1
                
                websiteTextView.textContentType = .URL
                websiteTextView.autocapitalizationType = .none
                websiteTextView.keyboardType = .URL
                
                cell.contentView.addSubview(websiteTextView)
            default:
                break
            }
        } else {
            if cell.contentView.subviews.filter({ $0 is UITextView }).count <= 0 {
                let filmTextView = createTextView(
                    withTag: indexTag,
                    text: isEditMode ? actor.filmography![indexPath.row] : "Film",
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
        
        cell.textLabel?.text       = ""
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
            imageView.image = actor.images != nil && actor.images!.count > 0 ? UIImage(data: actor.images![0]) : UIImage(systemName: "photo")
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

//
//  ActorInfoViewController.swift
//  Actors
//
//  Created by Robert Adrian Bucur on 06/05/2022.
//

import UIKit

class ActorInfoViewController: UIViewController {
    
    // model data
    var actorCD         : ActorCD!
    var favouriteActorCD: FavouriteActorCD!
    
    private var actor: Actor!
    
    // outlets
    @IBOutlet weak var nameLabel     : UILabel!
    @IBOutlet weak var ageLabel      : UILabel!
    @IBOutlet weak var categoryLabel : UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // variables for arranging collection view cells
    let cellGap            : CGFloat = 10
    let leftGapToScreen    : CGFloat = 10
    let rightGapToScreen   : CGFloat = 10
    let minLineSpacing     : CGFloat = 10
    let minInterItemSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if actorCD != nil {
            actor = Actor(actorCD: actorCD)
        } else {
            actor = Actor(favActorCD: favouriteActorCD)
        }
        
        let isLastCharS = actor.name.last == "s"
        title = actor.name + (isLastCharS ? "' gallery" : "'s gallery")
        
        nameLabel.text     = actor.name
        ageLabel.text      = "\(actor.age) years"
        categoryLabel.text = "Category: " + actor.category
        
        collectionView.delegate   = self
        collectionView.dataSource = self
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoActorDetails" {
            // Get the new view controller using segue.destination.
            let actorDetailVC = segue.destination as! ActorDetailsViewController
            
            // Pass the selected object to the new view controller.
            actorDetailVC.actorCD          = actorCD
            actorDetailVC.favouriteActorCD = favouriteActorCD
        }
    }
}

// MARK: - Collection View Data Source
extension ActorInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return actor.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        for cellView in cell.subviews {
            cellView.removeFromSuperview()
        }
        
        let image = UIImage(data: actor.images[indexPath.row])
        let imageView = UIImageView(image: image)
        imageView.frame = cell.bounds
        imageView.contentMode = .scaleAspectFit
        cell.addSubview(imageView)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = UIScreen.main.bounds.width - (2 * cellGap) - leftGapToScreen - rightGapToScreen
        
        let cellWidth = availableWidth / 3
        let cellHeight = cellWidth
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: leftGapToScreen, bottom: 0, right: rightGapToScreen)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return minLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return minInterItemSpacing
    }
}

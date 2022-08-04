//
//  SearchCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import Combine
import SDWebImage
import PKHUD


protocol SearchCollectionViewCellDelegate {
    func addedToFavorites(recipe:SRecipe)
    func errorAddingToFavorites(err:Error)
    func showDetails(recipe:SRecipe)
}
class SearchCollectionViewCell: UICollectionViewCell {
    
    
    var recipe:SRecipe!
    var delegate:SearchCollectionViewCellDelegate!
    var subscriptions: Set<AnyCancellable> = []
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var favImageView: UIImageView!
    

    
    @IBAction func detailsAction(_ sender: Any) {
        delegate.showDetails(recipe: recipe)
    }
    @objc func addToFavorites(_ sender: Any) {
        print("Adding to favorites..")
        // adds to user favorites from cell click
        FirebaseManager.addToUserFavorites(category: .search,
                                           favorite: Favorite.init(name: recipe.name ?? "", recipeID: recipe.id ?? 0, image: recipe.image ?? "", link: recipe.link ?? "", content: recipe.content ?? "")) {[weak self] str, err in
            if let err = err {
                self?.delegate.errorAddingToFavorites(err: err)
                return
            }
            if let str = str {
                print(str)
                self?.delegate.addedToFavorites(recipe: self!.recipe)
            }
            
        }
    }
    
  
    override func prepareForReuse() {
        imageView.image = UIImage(systemName: "photo")
        favImageView.isUserInteractionEnabled = true
        subscriptions.removeAll()
    }
    
    

    func populate(with recipe: SRecipe, address: String){
        
        
        if let gr = favImageView.gestureRecognizers,
           gr.count > 0 {
            for g in gr {
                favImageView.removeGestureRecognizer(g)
            }
        }
        self.recipe = recipe
        favImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToFavorites)))
        guard let id = recipe.id,
              let name = recipe.name
              //let content = recipe.content
        
        else {return}
   
        
        idLabel.text = String(id)
        nameLabel.text = name
        recipe.image?.downLoadImage(imageView: imageView, subs: &subscriptions)
        
    }
    
}

//
//  RandomCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 26/03/2022.
//

import UIKit
import Combine

protocol RandomCollectionViewCellDelegate {
    func showDetails(recipe:RRecipe)
    func addToFavorites(recipe:RRecipe)
    func errorAddingToFavorites(err:Error)
}

class RandomCollectionViewCell: UICollectionViewCell {
    var recipe : RRecipe!
    var delegate: RandomCollectionViewCellDelegate!
    
    var subscriptions: Set<AnyCancellable> = []
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readyMinutesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var favImageView: UIImageView!
    
  
    
    @IBAction func showDetailsAction(_ sender: Any) {
        delegate.showDetails(recipe: recipe)
    }
    func populate(with recipe: RRecipe, address: String){
        self.recipe = recipe
        if let gr = favImageView.gestureRecognizers,
           gr.count > 0 {
            for g in gr {
                favImageView.removeGestureRecognizer(g)
            }
        }
        favImageView.isUserInteractionEnabled = true
        favImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToFavorites)))
        let minutes = " Minutes to prepare this recipe"
        
        guard let id = recipe.id,
              let title = recipe.name,
              let readyMinutes = recipe.readyInMinutes
        
        else {return}
    
        idLabel.text = String(id)
        
        titleLabel.text = title
        
        readyMinutesLabel.text = String(readyMinutes) + "\(minutes)"
        
        idLabel.textColor = .white
        
        titleLabel.textColor = .white
        
        readyMinutesLabel.textColor = .white
        
        guard let url = URL(string: address) else {return}
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main).sink { comp in
                switch comp {
                case .finished:
                    print("We have random item")
                case .failure(let err):
                    print(err)
                }
        } receiveValue: { data, res in
            let image = UIImage(data: data)
            self.imageView.image = image
        }.store(in: &subscriptions)


    }
    
    
    @objc func addToFavorites(_ sender: Any) {
    
        FirebaseManager.addToUserFavorites(category: .random,
                                           favorite: Favorite.init(name: recipe.name ?? "", recipeID: recipe.id ?? 0, image: recipe.image ?? "", link: recipe.link ?? "", content: recipe.content ?? "")) {[weak self] str, err in
            if let err = err {
                self?.delegate.errorAddingToFavorites(err: err)
                return
            }
            if let str = str {
                print(str)
                self?.delegate.addToFavorites(recipe: self!.recipe)
            }
            
        }
    }
    

        
        
    
    
}

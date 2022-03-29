//
//  RandomCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 26/03/2022.
//

import UIKit
import SDWebImage

class RandomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readyMinutesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBAction func webButton(_ sender: UIButton) {
        
    }
    
    @IBAction func favoritesButton(_ sender: UIButton) {
        
    }
    
    func populate(with recipe: RRecipe){
        let minutes = " Minutes making"
        
        idLabel.text = String(recipe.id)
        
        titleLabel.text = recipe.title
        
        readyMinutesLabel.text = String(recipe.readyInMinutes) + "\(minutes)"
        
        imageView.sd_setImage(with: recipe.image,
                          placeholderImage: UIImage(systemName: "photo"))
        
        summaryLabel.text = recipe.summary
        
        instructionsLabel.text = recipe.instructions
    }
    
}

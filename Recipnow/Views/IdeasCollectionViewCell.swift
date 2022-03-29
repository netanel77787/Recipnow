//
//  IdeasCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import SDWebImage

class IdeasCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func populate(with recipe: IRecipe){
        idLabel.text = String(recipe.id)
        nameLabel.text = recipe.title
        
        guard let url = URL(string: recipe.image ) else {return}
        
        
        image.sd_setImage(with: url,
                          placeholderImage: UIImage(systemName: "photo"))
    }
}

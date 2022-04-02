//
//  RandomCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 26/03/2022.
//

import UIKit
import SDWebImage
import Combine

class RandomCollectionViewCell: UICollectionViewCell {
    
    var subscriptions: Set<AnyCancellable> = []
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readyMinutesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var summaryLabel: UILabel!
//    @IBOutlet weak var instructionsLabel: UILabel!
    
 
    
    @IBAction func favoritesButton(_ sender: UIButton) {
        
    }
    
    func populate(with recipe: RRecipe, address: String){
        let minutes = " Minutes making"
        
        guard let id = recipe.id,
              let title = recipe.title,
              let readyMinutes = recipe.readyInMinutes
        
        else {return}
        
        idLabel.text = String(id)
        
        titleLabel.text = title
        
        readyMinutesLabel.text = String(readyMinutes) + "\(minutes)"
        
        guard let url = URL(string: address) else {return}
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main).sink { comp in
                switch comp {
                case .finished:
                    print("We have search")
                case .failure(let err):
                    print(err)
                }
        } receiveValue: { data, res in
            let image = UIImage(data: data)
            self.imageView.image = image
        }.store(in: &subscriptions)


    }
    

        
        
    
    
}

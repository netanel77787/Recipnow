//
//  SearchCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import Combine
import SafariServices

class SearchCollectionViewCell: UICollectionViewCell {
    
    
    var subscriptions: Set<AnyCancellable> = []
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
 
    
    
    @IBAction func addToFavorites(_ sender: UIButton) {
    }
    
  
    override func prepareForReuse() {
        imageView.image = UIImage(systemName: "photo")

        subscriptions.removeAll()
    }

    func populate(with recipe: SRecipe, address: String){
        
        guard let id = recipe.id,
              let name = recipe.name,
              let content = recipe.content
        
        else {return}
   
        idLabel.text = String(id)
        nameLabel.text = name
        contentLabel.text = content
        
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

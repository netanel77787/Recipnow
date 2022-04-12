//
//  IdeasCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import Combine

class IdeasCollectionViewCell: UICollectionViewCell {
    
    var subscriptions: Set<AnyCancellable> = []
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func populate(with recipe: IRecipe, address: String){
        
        guard let id = recipe.id,
              let title = recipe.title
        
        else {return}
        
        idLabel.text = String(id)
        nameLabel.text = title
        
        guard let url = URL(string: address) else {return}
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main).sink { comp in
                switch comp {
                case .finished:
                    print("We have idea items")
                case .failure(let err):
                    print(err)
                }
        } receiveValue: { data, res in
            let image = UIImage(data: data)
            self.image.image = image
        }.store(in: &subscriptions)
        
        
    }
}

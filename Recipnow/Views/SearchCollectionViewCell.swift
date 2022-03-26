//
//  SearchCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import Combine

class SearchCollectionViewCell: UICollectionViewCell {
    
    var subscriptions: Set<AnyCancellable> = []
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    override func prepareForReuse() {
        imageView.image = UIImage(systemName: "photo")
        
        subscriptions.removeAll()
    }
    
    func addressPopulate(address: String){
        guard let url = URL(string: address) else {return}
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main).sink { completion in
                switch completion{
                    
                case .finished:
                    print("Success")
                case .failure(_):
                    print("Failed")
                }
            } receiveValue: { data, res in
                let image = UIImage(data: data)
                self.imageView.image = image
            }.store(in: &subscriptions)

    }
    
    
    func populate(with recipe: SRecipe){
        
        guard let id = recipe.id else {return}
        guard let name = recipe.name else {return}
        guard let link = recipe.link else {return}
        guard let image = recipe.image else {return}
        guard let content = recipe.content else {return}
        
        idLabel.text = String(id)
        nameLabel.text = name
        
//        imageView.sd_setImage(with: image,
//                              placeholderImage: UIImage(systemName: "photo"))
        
        linkTextField.text = link
        
        contentTextField.text = content
        
    }
    
//    func populateAddress(address: String){
//        guard let url = URL(string: address) else {return}
//        
//        URLSession.shared.dataTaskPublisher(for: url)
//            .receive(on: DispatchQueue.main).sink { comp in
//                switch comp {
//                case .finished:
//                    print("We have search")
//                case .failure(let err):
//                    print(err)
//                }
//        } receiveValue: { data, res in
//            let image = UIImage(data: data)
//            self.imageView.image = image
//        }.store(in: &subscriptions)
//
//        
//        
//    }
}

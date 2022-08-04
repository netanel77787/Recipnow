//
//  FavoriteCollectionViewCell.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 19/05/2022.
//

import UIKit
import Combine


protocol FavoriteCollectionViewCellDelegate {
    
    func removedFromFavorites(recipe:Favorite)
    func errorRemovingFromFavorites(err:Error)
}
class FavoriteCollectionViewCell: UICollectionViewCell {
    
    
    var favorite:Favorite!
    var indexPath:IndexPath!
    var delegate:FavoriteCollectionViewCellDelegate!
    static let id = "favoriteCell"
    var subs =  Set<AnyCancellable>()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    lazy var removeBtn : UIImageView =  {
        let rmv = UIImageView(image:UIImage(systemName: "trash")!.withTintColor(UIColor.systemRed))
        rmv.bounds = CGRect(x: 0, y: 0, width: 25, height: 25)
        rmv.clipsToBounds = true
        rmv.contentMode = .center
        rmv.isUserInteractionEnabled = true
        
        rmv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                        action: #selector(removeFromFavorites)))
        return rmv
    }()
    
    
    lazy var stack =  {
        return UIStackView(arrangedSubviews: [imageView,titleLabel,idLabel,removeBtn])
    }()
    
    @objc func removeFromFavorites() {
        // removes from user favorite from cell trash icon click
        FirebaseManager.removeFromUserFavorites(category: indexPath.section == 0 ? .search : .random, favorite: favorite) { [weak self] str, err in
            guard let strong = self else {return}
            if let err = err {
                strong.delegate.errorRemovingFromFavorites(err: err)
                return
            }
            strong.delegate.removedFromFavorites(recipe: strong.favorite)
        }

    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        stack.bounds = contentView.bounds
        contentView.addSubview(stack)
        imageView.clipsToBounds = true
        contentView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
    }
    
    required init(coder:NSCoder) {
        super.init(coder: coder)!
    }
    
    func config() {
        titleLabel.text = favorite.name
        idLabel.text = String(favorite.recipeID)
        favorite.image.downLoadImage(imageView: imageView, subs: &subs) {[weak self] in
            self?.contentView.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        stack.axis = .vertical
        stack.spacing = 4
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        idLabel.textAlignment = .left
        idLabel.textColor = .black
        idLabel.font = .systemFont(ofSize: 14)
        titleLabel.font = .boldSystemFont(ofSize: 16)
        stack.distribution = .fill
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 8
        config()
 
    }
}


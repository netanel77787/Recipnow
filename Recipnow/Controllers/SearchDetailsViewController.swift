//
//  SearchDetailsViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 29/03/2022.
//

import UIKit
import SafariServices

class SearchDetailsViewController: UIViewController {
    
    var recipe: SRecipe?
    var recipeFav: Favorite?
    
    
    var selectedName: String?
    
    var selectedID: String?
    
    var selectedImage: UIImage?
    
    var selectedContent: String?
    
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func webSearch(_ sender: UIButton) {

        let webaddress = (recipe?.link ?? recipeFav?.link)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard
            let url = URL(string: webaddress!)
        else {return}

       let sfvc = SFSafariViewController(url: url)

        navigationController?.pushViewController(sfvc, animated: true)
    }
    
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: 200 , height: 300)
        
        
        idLabel.text = selectedID
        nameLabel.text = selectedName
        
        imageView.image = selectedImage ?? UIImage(systemName: "photo")
        
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        let c = [contentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                 contentLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 300)]
        NSLayoutConstraint.activate(c)
        contentLabel.text = recipe?.content ?? recipeFav?.content
        
        let style = "\"font-size:18px;\""
        
        contentLabel.attributedText = ("<p style = \(style)>\(recipe?.content ?? recipeFav?.content)</p>").htmlToAttributedString
        
        if recipeFav != nil {
            
        }
      
    }
    


}

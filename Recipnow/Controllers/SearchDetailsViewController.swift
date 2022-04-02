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
    
    var selectedName: String?
    
    var selectedID: String?
    
    var selectedImage: UIImage?
    
   
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func webSearch(_ sender: UIButton) {
      
        guard let webAddress = recipe?.link,
                     let url = URL(string: webAddress) else {return}
       
               let sfvc = SFSafariViewController(url: url)
       
              present(sfvc, animated: true)
    }
    
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedName = selectedName,
              let selectedID = selectedID,
              let image = selectedImage
        else {
            return
        }
        
        idLabel.text = selectedID
        nameLabel.text = selectedName
        
        imageView.image = image
        
      
      
    }
    


}

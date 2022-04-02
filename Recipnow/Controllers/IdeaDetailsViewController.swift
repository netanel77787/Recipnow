//
//  IdeaDetailsViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import SDWebImage

class IdeaDetailsViewController: UIViewController {
    
    var ideaRecipes: [IRecipe] = []
    
    var selectedTitle: String?
    
    var selectedID: String?
    
    var selectedImage: UIImage?
    
  
    @IBOutlet weak var ideaIDLabel: UILabel!
    
    @IBOutlet weak var ideaTitleLabel: UILabel!
    
    @IBOutlet weak var IdeaImageView: UIImageView!
    
  
    @IBAction func goToSearch(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedTitle = selectedTitle,
              let selectedID = selectedID,
              let image = selectedImage
        else {
            return
        }
        
        ideaTitleLabel.text = selectedTitle
        ideaIDLabel.text = selectedID
        
        IdeaImageView.image = image
        
      
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
  
        if segue.identifier == "search"{

            guard let selectedRecipe = sender as? UIButton else {return}

            guard let dest = segue.destination as? SearchCollectionViewController else {return}

            dest.title = "bye"
            
            dest.labelText = "HI"
            
            dest.search.searchBar.placeholder = "DDD"
            
            dest.search.navigationController?.navigationItem.searchController?.searchBar.placeholder = "DASDAD"

            dest.navigationItem.searchController?.searchBar.placeholder = "Hello"
        }
        
 
  
    
}
}

//
//  IdeaDetailsViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit

class IdeaDetailsViewController: UIViewController {
    
    var ideaRecipes: [IRecipe] = []
    
    var selectedTitle: String?
    
    var selectedID: String?
    
    var selectedImage: UIImage?
    
  
    @IBOutlet weak var ideaIDLabel: UILabel!
    
    @IBOutlet weak var ideaTitleLabel: UILabel!
    
    @IBOutlet weak var IdeaImageView: UIImageView!
    
    
    @IBAction func searchRecipe(_ sender: UIButton) {
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = 2
            if let searchNavController =  tabBarController.viewControllers?[2] as? UINavigationController {
            
                if let searchVC = searchNavController.viewControllers.first as? SearchCollectionViewController {
                    if searchVC.preSearchText != nil {
                        searchVC.preSearch(with: selectedTitle)
                    }else {
                        searchVC.preSearchText = selectedTitle
                    }
             
                }
            }
        }
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
    
    
}

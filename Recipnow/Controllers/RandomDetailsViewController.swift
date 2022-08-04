//
//  RandomDetailsViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 02/04/2022.
//

import UIKit
import SafariServices

class RandomDetailsViewController: UIViewController {
    
    var recipe: RRecipe?
    var recipeFav: Favorite?
    var selectedTitle: String?
    
    var selectedID: String?
    
    var selectedMinutes: String?
    
    var selectedImage: UIImage?
    
    var selectedSummary: String?
    
    var selectedInstructions: String?
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var readyMinutesLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var scrollContentStack: UIStackView!
    
    @IBAction func searchButton(_ sender: UIButton) {
        
        let webaddress = (recipe?.link ?? recipeFav?.link)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard
            let url = URL(string: webaddress!)
        else {return}

       let sfvc = SFSafariViewController(url: url)

        present(sfvc, animated: true)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1500)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        imageView.image = selectedImage ?? UIImage(systemName: "photo")
  
        if let id = recipe?.id {
            idLabel.text = "\(id)"
        }else if let id  = recipeFav?.recipeID  {
            idLabel.text =  "\(id)"
        }
        
        if let name = recipe?.name {
            titleLabel.text = name
        }else if let name  = recipeFav?.name  {
            titleLabel.text = name
        }
        if let recipe = recipe {
            readyMinutesLabel.text = "Ready in minutes: \(recipe.readyInMinutes ?? 0)"
        }else {
            readyMinutesLabel.text = ""
        }
        let instructions = recipe?.instructions ?? ""
        let summary = recipe?.content ?? recipeFav?.content ?? ""
        
        let style = "\"font-size:20px;\""
        summaryLabel.attributedText = ("<p style = \(style)> \(summary)</p>").htmlToAttributedString
        
       
        
        instructionsLabel.attributedText = instructions.htmlToAttributedString
        summaryLabel.numberOfLines =  summary.count
        instructionsLabel.numberOfLines =  instructions.count
        
        if recipeFav != nil {
            
            instructionsLabel.text = ""
        }
    }


}

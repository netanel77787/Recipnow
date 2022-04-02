//
//  RandomDetailsViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 02/04/2022.
//

import UIKit

class RandomDetailsViewController: UIViewController {
    
    var selectedTitle: String?
    
    var selectedID: String?
    
    var selectedMinutes: String?
    
    var selectedImage: UIImage?
    
    var selectedSummary: String?
    
    var selectedInstructions: String?
    
    
    

    @IBOutlet weak var readyMinutesLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
   
    @IBAction func searchButton(_ sender: UIButton) {
        
    }
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedTitle = selectedTitle,
              let selectedID = selectedID,
              let image = selectedImage,
              let minutes = selectedMinutes,
              let summary = selectedSummary,
              let instructions = selectedInstructions
        else {
            return
        }
        
        idLabel.text = selectedID
        titleLabel.text = selectedTitle
        
        readyMinutesLabel.text = minutes
        
        imageView.image = image
        imageView.sizeToFit()
        
        summaryLabel.text = summary
        
        instructionsLabel.text = instructions
      
    }


}

//
//  IdeaDetailsViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 12/03/2022.
//

import UIKit
import SDWebImage

class IdeaDetailsViewController: UIViewController {
    
    var selectedTitle: String?
    
    var selectedID: String?
    
    var selectedImage: UIImage?
    
    @IBOutlet weak var ideaIDLabel: UILabel!
    
    @IBOutlet weak var ideaTitleLabel: UILabel!
    
    @IBOutlet weak var IdeaImageView: UIImageView!
    
    @IBOutlet weak var searchButton: UIButton!
    
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

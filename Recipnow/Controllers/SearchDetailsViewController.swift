//
//  SearchDetailsViewController.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 29/03/2022.
//

//import UIKit
//
//class SearchDetailsViewController: UIViewController {
//    var selectedName: String?
//    
//    var selectedID: String?
//    
//    var selectedImage: UIImage?
//    
//    
//    @IBOutlet weak var idLabel: UILabel!
//    
//    @IBOutlet weak var nameLabel: UILabel!
//    
//    @IBOutlet weak var imageView: UIImageView!
//    
//    @IBAction func webSearch(_ sender: UIButton) {
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        guard let selectedName = selectedName,
//              let selectedID = selectedID,
//              let image = selectedImage
//        else {
//            return
//        }
//        
//        idLabel.text = selectedID
//        nameLabel.text = selectedName
//        
//        imageView.image = image
//        
//        
////        guard let webAddress = recipe?.link?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
////              let url = URL(string: webAddress) else {return}
////
////        let sfvc = SFSafariViewController(url: url)
////        sfvc.modalPresentationStyle = .popover
//      
//    }
//    
//
//
//}

//
//  Header.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 10/06/2022.
//

import UIKit

class Header: UICollectionViewCell {
    
    
    
    static let id = "headerCell"
   
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
  
    override init(frame:CGRect) {
        super.init(frame: frame)
        titleLabel.frame = CGRect(x: 16, y: -16, width: 200, height: 50)
        contentView.clipsToBounds = true
        contentView.addSubview(titleLabel)
   
    }
    
    required init(coder:NSCoder) {
        super.init(coder: coder)!
     
    }
    
    func config(sectionTitle:String) {
        titleLabel.text = sectionTitle

    }
    override func layoutSubviews() {
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 24)
     
    }
    
    
    
}

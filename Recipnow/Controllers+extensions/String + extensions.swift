//
//  String + extensions.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 10/06/2022.
//

import Foundation
import UIKit
import Combine
extension String {
    
    func downLoadImage(imageView: UIImageView,subs:inout Set<AnyCancellable>,comp: (() -> Void)? = nil) {
        guard let url = URL(string:self) else {return}
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main).sink { comp in
                switch comp {
                case .finished:
                    break;
                case .failure(let err):
                    print(err)
                    break;
                }
        } receiveValue: { data, res in
            let image = UIImage(data: data)
            imageView.image = image
            if let comp = comp {
                comp()
            }
        }.store(in: &subs)
    }

}

//
//  FirebaseModel.swift
//  Recipnow
//
//  Created by Netanel Mantsoor on 10/03/2022.
//

import Foundation

protocol FirebaseModel{
    var dict: [String: Any] {get}
    init?(dict: [String: Any])
}

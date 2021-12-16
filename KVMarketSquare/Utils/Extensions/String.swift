//
//  String.swift
//  KVMarketSquare
//
//  Created by Minseo Kwon on 2021-12-15.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        prefix(1).capitalized + dropFirst()
    }
}

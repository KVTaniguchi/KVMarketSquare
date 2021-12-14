//
//  Set.swift
//  KVMarketSquare
//
//  Created by Ka Hin Ng on 2021-12-14.
//

import Foundation

extension Set {
    mutating func delete(at offsets: IndexSet) {
        for offset in offsets {
            self.remove(at: self.index(self.startIndex, offsetBy: offset))
        }
    }
}

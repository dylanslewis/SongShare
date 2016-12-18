//
//  Array+Extra.swift
//  SongShare
//
//  Created by Dylan Lewis on 18/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

extension Array {
    mutating func appendIfNotNil<C: Collection>(contentsOf newElements: C?) where C.Iterator.Element == Element {
        guard let newElements = newElements else {
            return
        }
        append(contentsOf: newElements)
    }
}

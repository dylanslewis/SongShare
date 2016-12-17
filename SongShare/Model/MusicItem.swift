//
//  MusicItem.swift
//  SongShare
//
//  Created by Dylan Lewis on 11/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

enum MusicItemType {
    case track
}

struct MusicItem {
    let artists: [String]?
    let album: String?
    let track: String?
    let type: MusicItemType
}

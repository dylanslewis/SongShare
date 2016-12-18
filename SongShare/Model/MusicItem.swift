//
//  MusicItem.swift
//  SongShare
//
//  Created by Dylan Lewis on 11/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

enum MusicItemType {
    case track, artist, album
}

struct MusicItem {
    let artists: [String]?
    let album: String?
    let track: String?
    let type: MusicItemType
}

extension MusicItem {
    func sanitizedQuery() -> String {
        var queries = [String]()
        if let artists = artists {
            for artist in artists {
                queries.append(contentsOf: artist.sanitizedWords())
            }
        }
        
        //        if let album = musicItem.album {
        //            let sanitizedAlbumWords = sanitizedWords(for: album)
        //            queries.append(contentsOf: sanitizedAlbumWords)
        //        }
        
        if let track = track {
            // TODO: Do proper sanitization
            queries.append(contentsOf: track.sanitizedWords())
        }
        return queries.joined(separator: "+")
    }
}

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
        
        queries.appendIfNotNil(contentsOf: sanitizedArtistWords)
        
        if let sanitizedTrack = sanitizedTrack, sanitizedAlbum?.contains(sanitizedTrack) == true {
            // Track name is contained in the album name, so omit it.
            queries.appendIfNotNil(contentsOf: sanitizedTrackWords)
        }
        else {
            queries.appendIfNotNil(contentsOf: sanitizedAlbumWords)
            queries.appendIfNotNil(contentsOf: sanitizedTrackWords)
        }
        
        return queries.joined(separator: "+")
    }
    
    private var sanitizedArtistWords: [String]? {
        var sanitizedArtists = [String]()
        guard let artists = self.artists else {
            return nil
        }
        
        for artist in artists {
            sanitizedArtists.append(contentsOf: artist.sanitizedWords())
        }
        
        return sanitizedArtists
    }
    
    private var sanitizedAlbum: String? {
        guard let album = self.album else {
            return nil
        }
        return album.sanitized()
    }
    
    private var sanitizedAlbumWords: [String]? {
        guard let album = self.album else {
            return nil
        }
        return album.sanitizedWords()
    }
    
    private var sanitizedTrack: String? {
        guard let track = self.track else {
            return nil
        }
        return track.sanitized()
    }
    
    private var sanitizedTrackWords: [String]? {
        guard let track = self.track else {
            return nil
        }
        return track.sanitizedWords()
    }
}

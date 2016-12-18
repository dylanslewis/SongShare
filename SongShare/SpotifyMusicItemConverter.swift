//
//  SpotifyMusicItemConverter.swift
//  SongShare
//
//  Created by Dylan Lewis on 17/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

class SpotifyMusicItemConverter: MusicItemConverter {
    // MARK: - MusicItemToShareLinkConverter
    
    func queryLink(for musicItem: MusicItem) -> URL? {
        let searchQueryItem = URLQueryItem(name: "q", value: musicItem.sanitizedQuery())
        
        // TODO: Make dynamic based on music item type.
        let typeItem = URLQueryItem(name: "type", value: "track")
        
        // TODO: Consider removing common words
        
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/search")
        urlComponents?.queryItems = [searchQueryItem, typeItem]
        
        return urlComponents?.url
    }
    
    func shareLink(for data: Data) -> URL? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                return nil
            }
            return spotifyTrackShareLink(forSpotifyTrackJSON: json)
        } catch {
            return nil
        }
    }

    // MARK: - ShareLinkToMusicItemConverter
    
    func lookupLink(forShareLink shareLink: URL) -> URL? {
        return shareLink
    }
    
    func musicItem(for data: Data) -> MusicItem? {
        guard let html = String(data: data, encoding: String.Encoding.utf8) else {
            return nil
        }
        
        // TODO: Work out the type of MusicItem
        guard let musicItem = self.musicItem(forSpotifyHTML: html) else {
            return nil
        }
        
        return musicItem
    }
    
    // MARK: - Utilities

    private func spotifyTrackShareLink(forSpotifyTrackJSON json: [String: AnyObject]) -> URL? {
        guard let tracks = json["tracks"] as? [String: AnyObject], let items = tracks["items"] as? [[String: AnyObject]] else {
            return nil
        }
        
        // TODO: Consider getting the 'uri'
        
        var shareLinks = [URL]()
        for item in items {
            if let externalURLs = item["external_urls"] as? [String: AnyObject], let externalURLString = externalURLs["spotify"] as? String, let itemURL = URL(string: externalURLString) {
                shareLinks.append(itemURL)
            }
        }
        
        // TODO: Figure out what to do about multiple results
        
        return shareLinks.first
    }
    
    private func musicItem(forSpotifyHTML html: String) -> MusicItem? {
        guard let startIndex = html.range(of: "Spotify.Entity = ") else {
            return nil
        }
        
        let spotifyEntitySubstring = html.substring(from: startIndex.upperBound)
        
        guard let endIndex = spotifyEntitySubstring.range(of: "};") else {
            return nil
        }
        
        // TODO: Handle range correctly
        let spotifyEntity = spotifyEntitySubstring.substring(to: endIndex.lowerBound) + "}"
        
        guard let spotifyEntityData = spotifyEntity.data(using: .utf8) else {
            return nil
        }
        
        let spotifyEntityJSON: [String: AnyObject]?
        do {
            spotifyEntityJSON = try JSONSerialization.jsonObject(with: spotifyEntityData, options: .allowFragments) as? [String: AnyObject]
        } catch {
            spotifyEntityJSON = nil
        }
        
        guard let json = spotifyEntityJSON else {
            return nil
        }
        
        return musicItem(forSpotifyEntityJSON: json)
    }
    
    private func musicItem(forSpotifyEntityJSON json: [String: AnyObject]) -> MusicItem? {
        guard let type = json["type"] as? String else {
            return nil
        }
        
        switch type {
        case "track":
            return trackMusicItem(forSpotifyEntityJSON: json)
        default:
            return nil
        }
    }
    
    private func trackMusicItem(forSpotifyEntityJSON json: [String: AnyObject]) -> MusicItem {
        let trackName = json["name"] as? String
        let albumJSON = json["album"] as? [String: AnyObject]
        
        let albumName = albumJSON?["name"] as? String
        let artists: [String]?
        
        guard let artistsJSON = json["artists"] as? [[String: AnyObject]] else {
            return MusicItem(artists: nil, album: albumName, track: trackName, type: .track)
        }
        
        var artistsFromJSON = [String]()
        for artistJSON in artistsJSON {
            if let artist = artistJSON["name"] as? String {
                artistsFromJSON.append(artist)
            }
        }
        artists = artistsFromJSON

        return MusicItem(artists: artists, album: albumName, track: trackName, type: .track)
    }
}

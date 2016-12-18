//
//  AppleMusicMusicItemConverter.swift
//  SongShare
//
//  Created by Dylan Lewis on 17/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

class AppleMusicMusicItemConverter: MusicItemConverter {
    // MARK: - MusicItemToShareLinkConverter
    
    func queryLink(for musicItem: MusicItem) -> URL? {
        let searchQueryItem = URLQueryItem(name: "term", value: musicItem.sanitizedQuery())
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
        urlComponents?.queryItems = [searchQueryItem]
        
        return urlComponents?.url
    }

    func shareLink(for data: Data) -> URL? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                return nil
            }
            // TODO: Make dynamic for albums, artists...
            return appleMusicTrackShareLink(forAppleMusicJSON: json)
        } catch {
            return nil
        }
    }
    
    // MARK: - ShareLinkToMusicItemConverter

    func lookupLink(forShareLink shareLink: URL) -> URL? {
        guard let trackIdentifier = appleMusicTrackIdentifier(forAppleMusicShareLink: shareLink), let lookupURL = appleMusicLookupURL(forTrackIdentifier: trackIdentifier) else {
            return nil
        }
        return lookupURL
    }
    
    func musicItem(for data: Data) -> MusicItem? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                return nil
            }
            return self.musicItem(forAppleMusicJSON: json)
        } catch {
            return nil
        }
    }
    
    // MARK: Private
    
    private func appleMusicTrackShareLink(forAppleMusicJSON json: [String: AnyObject]) -> URL? {
        guard let results = json["results"] as? [[String: AnyObject]], let result = results.first, let shareLinkURL = result["trackViewUrl"] as? String else {
            return nil
        }
        
        let regionalShareLinkURL = shareLinkURL.replacingOccurrences(of: "/us", with: "/gb")
        return URL(string: regionalShareLinkURL)
    }
    
    private func appleMusicLookupURL(forTrackIdentifier trackIdentifier: String) -> URL? {
        // TODO: Make regional, potentially extracting the region from the original string
        var urlComponents = URLComponents(string: "https://itunes.apple.com/gb/lookup?id=281757416")
        let identifierItem = URLQueryItem(name: "id", value: trackIdentifier)
        urlComponents?.queryItems = [identifierItem]
        
        return urlComponents?.url
    }
    
    private func appleMusicTrackIdentifier(forAppleMusicShareLink shareLink: URL) -> String? {
        let urlSeparatedByEquals = shareLink.absoluteString.components(separatedBy: "=")
        let trackIdentifier = urlSeparatedByEquals.last
        return trackIdentifier
    }
    
    private func musicItem(forAppleMusicJSON json: [String: AnyObject]) -> MusicItem? {
        guard let results = json["results"] as? [[String: AnyObject]], let result = results.first else {
            return nil
        }
        
        let trackName = result["trackName"] as? String
        let albumName = result["collectionName"] as? String
        
        var artists: [String]?
        if let artistName = result["artistName"] as? String {
            artists = [artistName]
        }
        
        // TODO: Make dynamic types
        return MusicItem(artists: artists, album: albumName, track: trackName, type: .track)
    }
}

//
//  MusicItemToURLConverter.swift
//  SongShare
//
//  Created by Dylan Lewis on 11/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

class MusicItemToURLConverter {
    // MARK: - Public
    
    static func createSpotifyShareLink(for musicItem: MusicItem, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        guard let queryLink = spotifyQueryLink(for: musicItem) else {
            // TODO: Completion with an error
            completion(nil, nil)
            return
        }
        
        spotifyShareLink(forSpotifyQueryLink: queryLink) { (shareLink, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(shareLink, nil)
        }
    }
    
    static func createAppleMusicShareLink(for musicItem: MusicItem, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        guard let queryLink = appleMusicQueryLink(for: musicItem) else {
            // TODO: Completion with an error
            completion(nil, nil)
            return
        }
        
        appleMusicShareLink(forAppleMusicQueryLink: queryLink) { (shareLink, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            completion(shareLink, nil)
        }
    }
    
    // MARK: - Helpers
    // MARK: Spotify

    private static func spotifyQueryLink(for musicItem: MusicItem) -> URL? {
        let query = self.query(for: musicItem)
        let searchQueryItem = URLQueryItem(name: "q", value: query)
        
        // TODO: Make dynamic based on music item type.
        let typeItem = URLQueryItem(name: "type", value: "track")

        // TODO: Consider removing common words
        
        var urlComponents = URLComponents(string: "https://api.spotify.com/v1/search")
        urlComponents?.queryItems = [searchQueryItem, typeItem]
        
        return urlComponents?.url
    }
    
    private static func spotifyShareLink(forSpotifyQueryLink queryLink: URL, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: queryLink) { (data, urlResponse, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                    let shareLink = spotifyTrackShareLink(forSpotifyTrackJSON: json)
                    completion(shareLink, nil)
                }
            } catch {
                return
            }
            
            completion(nil, nil)
            }.resume()
    }
    
    private static func spotifyTrackShareLink(forSpotifyTrackJSON json: [String: AnyObject]) -> URL? {
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
    
    // MARK: Apple Music

    private static func appleMusicQueryLink(for musicItem: MusicItem) -> URL? {
        let query = self.query(for: musicItem)
        let searchQueryItem = URLQueryItem(name: "term", value: query)
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")
        urlComponents?.queryItems = [searchQueryItem]
        
        return urlComponents?.url
    }
    
    private static func appleMusicShareLink(forAppleMusicQueryLink queryLink: URL, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: queryLink) { (data, urlResponse, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                    // TODO: Make dynamic for albums, artists...
                    let shareLink = appleMusicTrackShareLink(forAppleMusicJSON: json)
                    completion(shareLink, nil)
                }
            } catch {
                return
            }
            
            completion(nil, nil)
        }.resume()
    }
    
    private static func appleMusicTrackShareLink(forAppleMusicJSON json: [String: AnyObject]) -> URL? {
        guard let results = json["results"] as? [[String: AnyObject]], let result = results.first, let shareLinkURL = result["trackViewUrl"] as? String else {
            return nil
        }
        
        let regionalShareLinkURL = shareLinkURL.replacingOccurrences(of: "/us", with: "/gb")
        return URL(string: regionalShareLinkURL)
    }
    
    // MARK: - Utility
    
    private static func query(for musicItem: MusicItem) -> String {
        var queries = [String]()
        if let artists = musicItem.artists {
            for artist in artists {
                let sanitizedArtistWords = sanitizedWords(for: artist)
                queries.append(contentsOf: sanitizedArtistWords)
            }
        }
        
//        if let album = musicItem.album {
//            let sanitizedAlbumWords = sanitizedWords(for: album)
//            queries.append(contentsOf: sanitizedAlbumWords)
//        }
        
        if let track = musicItem.track {
            // TODO: Do proper sanitization
            let sanitizedTrackWords = sanitizedWords(for: track)
            queries.append(contentsOf: sanitizedTrackWords)
        }
        return queries.joined(separator: "+")
    }
    
    private static func sanitizedWords(for string: String) -> [String] {
        // TODO: Consider removing common words

        var sanitizedString = string.replacingOccurrences(of: "(", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: ")", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "- ", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: ".", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "& ", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "feat ", with: "")
        return sanitizedString.components(separatedBy: " ")
    }
}

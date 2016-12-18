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

    
    
    // MARK: Apple Music

    private static func appleMusicQueryLink(for musicItem: MusicItem) -> URL? {
        
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
    
    
}

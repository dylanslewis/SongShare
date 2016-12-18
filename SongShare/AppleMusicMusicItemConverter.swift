//
//  AppleMusicMusicItemConverter.swift
//  SongShare
//
//  Created by Dylan Lewis on 17/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

private extension URL {
    func queryItemValue(forKey key: String) -> String? {
        let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        return urlComponents?.queryItems?.filter({ $0.name == key }).first?.value
    }
    
    func urlComponent(preceededByKey key: String) -> String? {
        let urlSeparatedByIdentifier = absoluteString.components(separatedBy: key)
        let identifierComponent = urlSeparatedByIdentifier.last
        let identifierComponentSeparatedByQuestionMark = identifierComponent?.components(separatedBy: "?")
        let urlComponent = identifierComponentSeparatedByQuestionMark?.first
        return urlComponent
    }
}

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

    func lookupLink(forShareLink shareLink: URL, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        guard let lookupLink = lookupLink(forExpandedShareLink: shareLink) else {
            // Make a request to the URL to get an expanded version containing
            // an identifier.
            getLookupLink(forCompactShareLink: shareLink, withCompletion: completion)
            return
        }
        completion(lookupLink, nil)
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
        
        // TODO: Make regional
        let regionalShareLinkURL = shareLinkURL.replacingOccurrences(of: "/us", with: "/gb")
        return URL(string: regionalShareLinkURL)
    }
    
    private func lookupLink(forExpandedShareLink shareLink: URL) -> URL? {
        guard
            let itemIdentifier = itemIdentifier(forShareLink: shareLink),
            let lookupURL = lookupLink(forItemIdentifier: itemIdentifier) else {
                return nil
        }
        return lookupURL
    }
    
    private func getLookupLink(forCompactShareLink shareLink: URL, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: shareLink) { (data, urlResponse, error) in
            guard let httpURLResponse = urlResponse as? HTTPURLResponse, error == nil else {
                completion(nil, error)
                return
            }
            
            let headerFields = httpURLResponse.allHeaderFields
            guard
                let expandedShareLinkString = headerFields["x-apple-orig-url"] as? String,
                let expandedShareLink = URL(string: expandedShareLinkString),
                let lookupLink = self.lookupLink(forExpandedShareLink: expandedShareLink) else {
                    // TODO: Create error
                    completion(nil, error)
                    return
            }
            
            completion(lookupLink, nil)
        }.resume()
    }
    
    private func lookupLink(forItemIdentifier identifier: String) -> URL? {
        // TODO: Make regional, potentially extracting the region from the original string
        var urlComponents = URLComponents(string: "https://itunes.apple.com/gb/lookup")
        let identifierItem = URLQueryItem(name: "id", value: identifier)
        urlComponents?.queryItems = [identifierItem]
        
        return urlComponents?.url
    }
    
    private func itemIdentifier(forShareLink shareLink: URL) -> String? {
        // First lookup the key 'i' query item because it specifies a track.
        let identifier = shareLink.queryItemValue(forKey: "i") ?? shareLink.urlComponent(preceededByKey: "id")
        
        let nonPermittedCharacterSet = CharacterSet.decimalDigits.inverted
        return identifier?.rangeOfCharacter(from: nonPermittedCharacterSet) == nil ? identifier : nil
    }
    
    private func musicItem(forAppleMusicJSON json: [String: AnyObject]) -> MusicItem? {
        guard
            let results = json["results"] as? [[String: AnyObject]],
            let result = results.first,
            let type = musicItemType(forJSON: result) else {
            return nil
        }
        
        let trackName = result["trackName"] as? String
        let albumName = result["collectionName"] as? String
        
        var artists: [String]?
        if let artistName = result["artistName"] as? String {
            artists = [artistName]
        }
        
        return MusicItem(artists: artists, album: albumName, track: trackName, type: type)
    }
    
    private func musicItemType(forJSON json: [String: AnyObject]) -> MusicItemType? {
        guard json["trackName"] == nil else {
            return .track
        }

        guard let collectionType = json["collectionType"] as? String, let musicType = self.musicType(forValue: collectionType) else {
            return nil
        }
        
        return musicType
    }
    
    private func musicType(forValue value: String) -> MusicItemType? {
        switch value {
        case "Track":
            return .track
        case "Album":
            return .album
        case "Artist":
            return .artist
        default:
            return nil
        }
    }
}

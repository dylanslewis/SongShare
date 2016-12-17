//
//  URLToMusicItemConverter.swift
//  SongShare
//
//  Created by Dylan Lewis on 11/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

class URLToMusicItemConverter {
    static func createMusicItem(forSpotifyShareLink shareLink: URL, withCompletion completion: @escaping (MusicItem?, Error?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: shareLink) { (data, urlResponse, error) in
            guard let data = data, error == nil else {
                print(error)
                completion(nil, error)
                return
            }
            
            if let html = String(data: data, encoding: String.Encoding.utf8), let musicItem = self.musicItem(forSpotifyHTML: html) {
                completion(musicItem, nil)
            }
            else {
                // TODO: Create parsing error
                return
            }
        }.resume()
    }
    
    private static func musicItem(forSpotifyHTML html: String) -> MusicItem? {
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
    
    private static func musicItem(forSpotifyEntityJSON json: [String: AnyObject]) -> MusicItem? {
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
    
    static func createMusicItem(forAppleMusicShareLink shareLink: URL, withCompletion completion: @escaping (MusicItem?, Error?) -> Void) {
        guard let lookupURL = appleMusicLookupURL(forShareLink: shareLink) else {
            // TODO: Create error
            completion(nil, nil)
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: lookupURL) { (data, urlResponse, error) in
            guard let data = data, error == nil else {
                print(error)
                completion(nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] {
                    let musicItem = self.musicItem(forAppleMusicJSON: json)
                    completion(musicItem, nil)
                    return
                }
            } catch {
                return
            }
            
            completion(nil, nil)
        }.resume()
    }
        
    private static func appleMusicLookupURL(forShareLink shareLink: URL) -> URL? {
        guard let trackIdentifier = appleMusicTrackIdentifier(forAppleMusicShareLink: shareLink), let lookupURL = appleMusicLookupURL(forTrackIdentifier: trackIdentifier) else {
            return nil
        }
        return lookupURL
    }

    private static func appleMusicLookupURL(forTrackIdentifier trackIdentifier: String) -> URL? {
        // TODO: Make regional, potentially extracting the region from the original string
        var urlComponents = URLComponents(string: "https://itunes.apple.com/gb/lookup?id=281757416")
        let identifierItem = URLQueryItem(name: "id", value: trackIdentifier)
        urlComponents?.queryItems = [identifierItem]
        
        return urlComponents?.url
    }

    private static func appleMusicTrackIdentifier(forAppleMusicShareLink shareLink: URL) -> String? {
        let urlSeparatedByEquals = shareLink.absoluteString.components(separatedBy: "=")
        let trackIdentifier = urlSeparatedByEquals.last
        return trackIdentifier
    }
    
    private static func musicItem(forAppleMusicJSON json: [String: AnyObject]) -> MusicItem? {
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
    
    private static func trackMusicItem(forSpotifyEntityJSON json: [String: AnyObject]) -> MusicItem {
        let trackName = json["name"] as? String
        let albumJSON = json["album"] as? [String: AnyObject]
        
        let albumName = albumJSON?["name"] as? String
        let artists: [String]?
        
        if let artistsJSON = json["artists"] as? [[String: AnyObject]] {
            var artistsFromJSON = [String]()
            for artistJSON in artistsJSON {
                if let artist = artistJSON["name"] as? String {
                    artistsFromJSON.append(artist)
                }
            }
            artists = artistsFromJSON
        }
        else {
            artists = nil
        }
        
        return MusicItem(artists: artists, album: albumName, track: trackName, type: .track)
    }
}

class URLDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(request)
    }
}

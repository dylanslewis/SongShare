//
//  MusicItemConverter.swift
//  SongShare
//
//  Created by Dylan Lewis on 17/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

protocol MusicItemConverter: MusicItemToShareLinkConverter, ShareLinkToMusicItemConverter { }

protocol MusicItemToShareLinkConverter {
    func queryLink(for musicItem: MusicItem) -> URL?
    func shareLink(for data: Data) -> URL?
}

protocol ShareLinkToMusicItemConverter {
    func lookupLink(forShareLink shareLink: URL, withCompletion completion: @escaping (URL?, Error?) -> Void)
    func musicItem(for data: Data) -> MusicItem?
}

extension MusicItemToShareLinkConverter {
    func createShareLink(for musicItem: MusicItem, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        guard let queryLink = queryLink(for: musicItem) else {
            // TODO: Create error
            completion(nil, nil)
            return
        }
        
        shareLink(forQueryLink: queryLink) { (shareLink, error) in
            completion(shareLink, error)
        }
    }
    
    func shareLink(forQueryLink queryLink: URL, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: queryLink) { (data, urlResponse, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            guard let shareLink = self.shareLink(for: data) else {
                // TODO: Create error
                completion(nil, nil)
                return
            }
            
            completion(shareLink, nil)
        }.resume()
    }
}

extension ShareLinkToMusicItemConverter {
    func createMusicItem(forShareLink shareLink: URL, withCompletion completion: @escaping (MusicItem?, Error?) -> Void) {
        self.lookupLink(forShareLink: shareLink) { (lookupURL, error) in
            guard let lookupURL = lookupURL, error == nil else {
                completion(nil, error)
                return
            }
            
            let session = URLSession.shared
            session.dataTask(with: lookupURL) { (data, urlResponse, error) in
                guard let data = data, let musicItem = self.musicItem(for: data) else {
                    completion(nil, error)
                    return
                }
                completion(musicItem, error)
            }.resume()
        }
    }
}

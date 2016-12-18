//
//  MusicItemConverterTests.swift
//  SongShare
//
//  Created by Dylan Lewis on 18/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import XCTest
@testable import SongShare

struct UnknownError: Error {
    var localizedDescription: String = "Unknown error"
}

extension XCTestCase {
    static let unknownError = UnknownError()
}

class MusicItemConverterTests: XCTestCase {
    var converter: MusicItemConverter!
    
    func testConverter(convertsShareLink shareLink: URL, withCompletion completion: @escaping (MusicItem?, Error?) -> Void) {
        converter.createMusicItem(forShareLink: shareLink) { (musicItem, error) in
            guard let musicItem = musicItem else {
                guard let error = error else {
                    completion(nil, XCTestCase.unknownError)
                    return
                }
                completion(nil, error)
                return
            }
            
            completion(musicItem, error)
            return
        }
    }
    
    func testConverter(converts musicItem: MusicItem, withCompletion completion: @escaping (URL?, Error?) -> Void) {
        converter.createShareLink(for: musicItem, withCompletion: { (shareLink, error) in
            guard let shareLink = shareLink else {
                guard let error = error else {
                    completion(nil, XCTestCase.unknownError)
                    return
                }
                completion(nil, error)
                return
            }
            
            completion(shareLink, error)
            return
        })
    }
}

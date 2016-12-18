//
//  SpotifyMusicItemConverterTests.swift
//  SongShare
//
//  Created by Dylan Lewis on 18/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import XCTest
@testable import SongShare

class SpotifyMusicItemConverterTests: MusicItemConverterTests {
    // MARK: - Override
    
    override func setUp() {
        super.setUp()
        converter = SpotifyMusicItemConverter()
    }
    
    // MARK: - Share Link to Music Item Tests
    
    func testSpotifyConverterConvertsTrackShareLinkToMusicItem() {
        let trackShareLink = URL(string: "https://open.spotify.com/track/5yEPxDjbbzUzyauGtnmVEC")!
        let expectedMusicItem = MusicItem(artists: ["The Verve"], album: "Urban Hymns", track: "Bitter Sweet Symphony", type: .track)
        
        let completionExpectation = expectation(description: "Conversion completes")
        
        testConverter(convertsShareLink: trackShareLink, withCompletion: { (musicItem, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            guard let musicItem = musicItem else {
                XCTFail("Nil Music Item")
                return
            }
            
            XCTAssertEqual(musicItem.artists ?? [String](), expectedMusicItem.artists ?? [String]())
            XCTAssertEqual(musicItem.album, expectedMusicItem.album)
            XCTAssertEqual(musicItem.track, expectedMusicItem.track)
            XCTAssertEqual(musicItem.type, expectedMusicItem.type)
            
            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSpotifyConverterConvertsTrackWithMultipleArtistsShareLinkToMusicItem() {
        // FIXME: Add URL
        let trackShareLink = URL(string: "www.apple.com")!
        let expectedMusicItem = MusicItem(artists: ["The Verve"], album: "Urban Hymns", track: "Bitter Sweet Symphony", type: .track)
        
        let completionExpectation = expectation(description: "Conversion completes")
        
        testConverter(convertsShareLink: trackShareLink, withCompletion: { (musicItem, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            guard let musicItem = musicItem else {
                XCTFail("Nil Music Item")
                return
            }
            
            XCTAssertEqual(musicItem.artists ?? [String](), expectedMusicItem.artists ?? [String]())
            XCTAssertEqual(musicItem.album, expectedMusicItem.album)
            XCTAssertEqual(musicItem.track, expectedMusicItem.track)
            XCTAssertEqual(musicItem.type, expectedMusicItem.type)
            
            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSpotifyConverterConvertsAlbumShareLinkToMusicItem() {
        let albumShareLink = URL(string: "https://open.spotify.com/album/09fggMHib4YkOtwQNXEBII")!
        let expectedMusicItem = MusicItem(artists: ["The Weeknd"], album: "Starboy", track: nil, type: .album)
        
        let completionExpectation = expectation(description: "Conversion completes")
        
        testConverter(convertsShareLink: albumShareLink, withCompletion: { (musicItem, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            guard let musicItem = musicItem else {
                XCTFail("Nil Music Item")
                return
            }
            
            XCTAssertEqual(musicItem.artists ?? [String](), expectedMusicItem.artists ?? [String]())
            XCTAssertEqual(musicItem.album, expectedMusicItem.album)
            XCTAssertEqual(musicItem.track, expectedMusicItem.track)
            XCTAssertEqual(musicItem.type, expectedMusicItem.type)
            
            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSpotifyConverterConvertsAlbumWithMultipleArtistsShareLinkToMusicItem() {
        // FIXME: Add URL
        let albumShareLink = URL(string: "www.apple.com")!
        let expectedMusicItem = MusicItem(artists: ["The Weeknd"], album: "Starboy", track: nil, type: .album)
        
        let completionExpectation = expectation(description: "Conversion completes")
        
        testConverter(convertsShareLink: albumShareLink, withCompletion: { (musicItem, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            guard let musicItem = musicItem else {
                XCTFail("Nil Music Item")
                return
            }
            
            XCTAssertEqual(musicItem.artists ?? [String](), expectedMusicItem.artists ?? [String]())
            XCTAssertEqual(musicItem.album, expectedMusicItem.album)
            XCTAssertEqual(musicItem.track, expectedMusicItem.track)
            XCTAssertEqual(musicItem.type, expectedMusicItem.type)
            
            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSpotifyConverterConvertsArtistShareLinkToMusicItem() {
        let artistShareLink = URL(string: "https://open.spotify.com/artist/1Xyo4u8uXC1ZmMpatF05PJ")!
        let expectedMusicItem = MusicItem(artists: ["The Weeknd"], album: nil, track: nil, type: .artist)
        
        let completionExpectation = expectation(description: "Conversion completes")

        testConverter(convertsShareLink: artistShareLink, withCompletion: { (musicItem, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            guard let musicItem = musicItem else {
                XCTFail("Nil Music Item")
                return
            }
            
            XCTAssertEqual(musicItem.artists ?? [String](), expectedMusicItem.artists ?? [String]())
            XCTAssertEqual(musicItem.album, expectedMusicItem.album)
            XCTAssertEqual(musicItem.track, expectedMusicItem.track)
            XCTAssertEqual(musicItem.type, expectedMusicItem.type)
            
            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // MARK: - Music Item to Share Link Tests
    
    func testSpotifyConverterConvertsTrackMusicItemToShareLink() {
        let trackMusicItem = MusicItem(artists: ["The Verve"], album: "Urban Hymns", track: "Bitter Sweet Symphony", type: .track)
        let expectedShareLink = URL(string: "https://open.spotify.com/track/5yEPxDjbbzUzyauGtnmVEC")!
        
        let completionExpectation = expectation(description: "Conversion completes")

        testConverter(converts: trackMusicItem) { (shareLink, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            XCTAssertEqual(shareLink, expectedShareLink)
            completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSpotifyConverterConvertsAlbumMusicItemToShareLink() {
        let albumMusicItem = MusicItem(artists: ["The Weeknd"], album: "Starboy", track: nil, type: .album)
        let expectedShareLink = URL(string: "https://open.spotify.com/album/09fggMHib4YkOtwQNXEBII")!
        
        let completionExpectation = expectation(description: "Conversion completes")
        
        testConverter(converts: albumMusicItem) { (shareLink, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            XCTAssertEqual(shareLink, expectedShareLink)
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSpotifyConverterConvertsArtistMusicItemToShareLink() {
        let artistMusicItem = MusicItem(artists: ["The Weeknd"], album: nil, track: nil, type: .artist)
        let expectedShareLink = URL(string: "https://open.spotify.com/artist/1Xyo4u8uXC1ZmMpatF05PJ")!
        
        let completionExpectation = expectation(description: "Conversion completes")
        
        testConverter(converts: artistMusicItem) { (shareLink, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            
            XCTAssertEqual(shareLink, expectedShareLink)
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

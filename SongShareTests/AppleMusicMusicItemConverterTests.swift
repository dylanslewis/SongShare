//
//  AppleMusicMusicItemConverterTests.swift
//  SongShare
//
//  Created by Dylan Lewis on 18/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import XCTest
@testable import SongShare

class AppleMusicMusicItemConverterTests: MusicItemConverterTests {
    // MARK: - Override
    
    override func setUp() {
        super.setUp()
        converter = AppleMusicMusicItemConverter()
    }
    
    // MARK: - Share Link to Music Item Tests
    
    func testAppleMusicConverterConvertsTrackGBShortShareLinkToMusicItem() {
        let trackShareLink = URL(string: "https://itun.es/gb/r-C1p?i=265670554")!
        let expectedMusicItem = MusicItem(artists: ["A Tribe Called Quest"], album: "Midnight Marauders", track: "Award Tour", type: .track)
        
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

    func testAppleMusicConverterConvertsTrackGBLongShareLinkToMusicItem() {
        let trackShareLink = URL(string: "https://geo.itunes.apple.com/gb/album/thiago-silva/id1113013332?i=1113013670")!
        let expectedMusicItem = MusicItem(artists: ["Dave & AJ Tracey"], album: "Thiago SIlva - Single", track: "Thiago Silva", type: .track)
        
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
    
    func testAppleMusicConverterConvertsTrackGBLongShareLinkWithExtensionToMusicItem() {
        // FIXME: Add URL
        let trackShareLink = URL(string: "https://geo.itunes.apple.com/gb/album/thiago-silva/id1113013332?i=1113013670&mt=1&app=music")!
        let expectedMusicItem = MusicItem(artists: ["Dave & AJ Tracey"], album: "Thiago SIlva - Single", track: "Thiago Silva", type: .track)
        
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
    
    func testAppleMusicConverterConvertsAlbumGBShortShareLinkToMusicItem() {
        let albumShareLink = URL(string: "https://itun.es/gb/r-C1p")!
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
    
    func testAppleMusicConverterConvertsAlbumGBLongShareLinkToMusicItem() {
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
    
    func testAppleMusicConverterConvertsArtistGBShortShareLinkToMusicItem() {
        // FIXME: Add URL
        let artistShareLink = URL(string: "www.apple.com")!
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
    
    func testAppleMusicConverterConvertsArtistGBLongShareLinkToMusicItem() {
        // FIXME: Add URL
        let artistShareLink = URL(string: "www.apple.com")!
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
    
    func testAppleMusicConverterConvertsTrackMusicItemToShareLink() {
        // FIXME: Add URL
        let trackMusicItem = MusicItem(artists: ["The Verve"], album: "Urban Hymns", track: "Bitter Sweet Symphony", type: .track)
        let expectedShareLink = URL(string: "www.apple.com")!
        
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
    
    func testAppleMusicConverterConvertsAlbumMusicItemToShareLink() {
        // FIXME: Add URL
        let albumMusicItem = MusicItem(artists: ["The Weeknd"], album: "Starboy", track: nil, type: .album)
        let expectedShareLink = URL(string: "www.apple.com")!
        
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
    
    func testAppleMusicConverterConvertsArtistMusicItemToShareLink() {
        // FIXME: Add URL
        let artistMusicItem = MusicItem(artists: ["The Weeknd"], album: nil, track: nil, type: .artist)
        let expectedShareLink = URL(string: "www.apple.com")!
        
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

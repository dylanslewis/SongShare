//
//  SpotifyMusicItemConverterTests.swift
//  SongShare
//
//  Created by Dylan Lewis on 18/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import XCTest
@testable import SongShare

class SpotifyMusicItemConverterTests: XCTestCase {
    private let spotifyConverter = SpotifyMusicItemConverter()

    func testSpotifyConverterConvertsTrackShareLinkToMusicItem() {
        let trackShareLink = URL(string: "https://open.spotify.com/track/5yEPxDjbbzUzyauGtnmVEC")!
        let expectedMusicItem = MusicItem(artists: ["The Verve"], album: "Urban Hymns", track: "Bitter Sweet Symphony", type: .track)
        
        testSpotifyConverter(convertsShareLink: trackShareLink, toExpectedMusicItem: expectedMusicItem)
    }
    
    func testSpotifyConverterConvertsAlbumShareLinkToMusicItem() {
        let albumShareLink = URL(string: "https://open.spotify.com/album/09fggMHib4YkOtwQNXEBII")!
        let expectedMusicItem = MusicItem(artists: ["The Weeknd"], album: "Starboy", track: nil, type: .album)
        
        testSpotifyConverter(convertsShareLink: albumShareLink, toExpectedMusicItem: expectedMusicItem)
    }
    
    func testSpotifyConverterConvertsArtistShareLinkToMusicItem() {
        let artistShareLink = URL(string: "https://open.spotify.com/artist/1Xyo4u8uXC1ZmMpatF05PJ")!
        let expectedMusicItem = MusicItem(artists: ["The Weeknd"], album: nil, track: nil, type: .artist)
        
        testSpotifyConverter(convertsShareLink: artistShareLink, toExpectedMusicItem: expectedMusicItem)
    }
    
    func testSpotifyConverterConvertsTrackMusicItemToShareLink() {
        let trackMusicItem = MusicItem(artists: ["The Verve"], album: "Urban Hymns", track: "Bitter Sweet Symphony", type: .track)
        let expectedShareLink = URL(string: "https://open.spotify.com/track/5yEPxDjbbzUzyauGtnmVEC")!
        
        testSpotifyConverter(converts: trackMusicItem, toExpectedShareLink: expectedShareLink)
    }
    
    func testSpotifyConverterConvertsAlbumMusicItemToShareLink() {
        let albumMusicItem = MusicItem(artists: ["The Weeknd"], album: "Starboy", track: nil, type: .album)
        let expectedShareLink = URL(string: "https://open.spotify.com/album/09fggMHib4YkOtwQNXEBII")!
        
        testSpotifyConverter(converts: albumMusicItem, toExpectedShareLink: expectedShareLink)
    }
    
    func testSpotifyConverterConvertsArtistMusicItemToShareLink() {
        let artistMusicItem = MusicItem(artists: ["The Weeknd"], album: nil, track: nil, type: .artist)
        let expectedShareLink = URL(string: "https://open.spotify.com/artist/1Xyo4u8uXC1ZmMpatF05PJ")!
        
        testSpotifyConverter(converts: artistMusicItem, toExpectedShareLink: expectedShareLink)
    }
    
    // MARK: - Utility
    
    private func testSpotifyConverter(convertsShareLink shareLink: URL, toExpectedMusicItem expectedMusicItem: MusicItem) {
        let completionExpectation = expectation(description: "Conversion completes")
        
        spotifyConverter.createMusicItem(forShareLink: shareLink) { (musicItem, error) in
            guard let musicItem = musicItem else {
                guard let error = error else {
                    XCTFail("Unknown failure")
                    return
                }
                XCTFail(error.localizedDescription)
                return
            }
            
            completionExpectation.fulfill()
            XCTAssertEqual(musicItem.artists ?? [String](), expectedMusicItem.artists ?? [String]())
            XCTAssertEqual(musicItem.album, expectedMusicItem.album)
            XCTAssertEqual(musicItem.track, expectedMusicItem.track)
            XCTAssertEqual(musicItem.type, expectedMusicItem.type)
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    private func testSpotifyConverter(converts musicItem: MusicItem, toExpectedShareLink expectedShareLink: URL) {
        let completionExpectation = expectation(description: "Conversion completes")
        
        spotifyConverter.createShareLink(for: musicItem, withCompletion: { (shareLink, error) in
            guard let shareLink = shareLink else {
                guard let error = error else {
                    XCTFail("Unknown failure")
                    return
                }
                XCTFail(error.localizedDescription)
                return
            }
            
            completionExpectation.fulfill()
            XCTAssertEqual(shareLink, expectedShareLink)
        })
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}

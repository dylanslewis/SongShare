//
//  ViewController.swift
//  SongShare
//
//  Created by Dylan Lewis on 11/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let spotifyConverter = SpotifyMusicItemConverter()
    private let appleMusicConverter = AppleMusicMusicItemConverter()
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var spotifyButton: UIButton!
    @IBOutlet var appleMusicButton: UIButton!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        spotify()
//        appleMusic()
    }
    
    // MARK: - Actions
    
    @IBAction func didSelectSpotifyButton(_ sender: AnyObject) {
        openShareURL(from: textField.text, usingMusicItemToShareLinkConverter: spotifyConverter)
    }

    
    @IBAction func didSelectAppleMusicButton(_ sender: AnyObject) {
        openShareURL(from: textField.text, usingMusicItemToShareLinkConverter: appleMusicConverter)
    }

    // MARK: - Testing
    
    func spotify() {
        let shareLink = URL(string: "https://open.spotify.com/track/5yEPxDjbbzUzyauGtnmVEC")!
        test(converter: appleMusicConverter, withOriginalShareLink: shareLink)
    }
    
    func appleMusic() {
        let shareLink = URL(string: "https://itun.es/gb/mnDP_?i=1067833273")!
        test(converter: appleMusicConverter, withOriginalShareLink: shareLink)
    }
    
    func test(converter: AppleMusicMusicItemConverter, withOriginalShareLink originalShareLink: URL) {
        converter.createMusicItem(forShareLink: originalShareLink) { (musicItem, error) in
            guard let musicItem = musicItem else {
                return
            }
            
            converter.createShareLink(for: musicItem, withCompletion: { (shareLink, error) in
                if let shareLink = shareLink {
                    print("INPUT:  \(originalShareLink)")
                    print("OUTPUT: \(shareLink)")
                }
            })
        }
    }
    
    // MARK: - Utility
    
    func openShareURL(from text: String?, usingMusicItemToShareLinkConverter musicItemToShareLinkConverter: MusicItemToShareLinkConverter) {
        guard let text = text, let shareLink = URL(string: text) else {
            return
        }
        
        if text.contains("spotify") {
            openShareLink(forOriginalShareLink: shareLink,
                          usingShareLinkToMusicItemConverter: spotifyConverter,
                          usingMusicItemToShareLinkConverter: musicItemToShareLinkConverter)
        } else if text.contains("apple") || text.contains("itun") {
            openShareLink(forOriginalShareLink: shareLink,
                          usingShareLinkToMusicItemConverter: appleMusicConverter,
                          usingMusicItemToShareLinkConverter: musicItemToShareLinkConverter)
        }
    }
    
    private func openShareLink(forOriginalShareLink originalShareLink: URL,
                               usingShareLinkToMusicItemConverter shareLinkToMusicItemConverter: ShareLinkToMusicItemConverter,
                               usingMusicItemToShareLinkConverter musicItemToShareLinkConverter: MusicItemToShareLinkConverter) {
        shareLinkToMusicItemConverter.createMusicItem(forShareLink: originalShareLink) { (musicItem, error) in
            guard let musicItem = musicItem else {
                return
            }
            
            self.updateLabel(with: musicItem)
            
            musicItemToShareLinkConverter.createShareLink(for: musicItem, withCompletion: { (shareLink, error) in
                guard let shareLink = shareLink else {
                    return
                }
                
                self.updateTextField(withShareLink: shareLink)
                UIApplication.shared.open(shareLink, options: [:], completionHandler: nil)
            })
        }
    }
    
    private func updateLabel(with musicItem: MusicItem) {
        DispatchQueue.main.async {
            self.label.text = "\(musicItem.track),\n\(musicItem.artists),\n\(musicItem.album)"
        }
    }
    
    private func updateTextField(withShareLink shareLink: URL) {
        DispatchQueue.main.async {
            self.textField.text = shareLink.absoluteString
        }
    }
}

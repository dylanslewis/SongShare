//
//  ViewController.swift
//  SongShare
//
//  Created by Dylan Lewis on 11/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
        guard let textFieldText = textField.text, let originalURL = URL(string: textFieldText) else {
            return
        }

        if textFieldText.contains("spotify") {
            URLToMusicItemConverter.createMusicItem(forSpotifyShareLink: originalURL) { (musicItem, error) in
                guard let musicItem = musicItem else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.label.text = "\(musicItem.track),\n\(musicItem.artists),\n\(musicItem.album)"
                }
                MusicItemToURLConverter.createSpotifyShareLink(for: musicItem, withCompletion: { (shareLink, error) in
                    if let shareLink = shareLink {
                        DispatchQueue.main.async {
                            self.textField.text = shareLink.absoluteString
                        }
                        UIApplication.shared.open(shareLink, options: [:], completionHandler: nil)
                    }
                })
            }
        } else if textFieldText.contains("apple") || textFieldText.contains("itun") {
            URLToMusicItemConverter.createMusicItem(forAppleMusicShareLink: originalURL) { (musicItem, error) in
                guard let musicItem = musicItem else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.label.text = "\(musicItem.track),\n\(musicItem.artists),\n\(musicItem.album)"
                }
                MusicItemToURLConverter.createSpotifyShareLink(for: musicItem, withCompletion: { (shareLink, error) in
                    if let shareLink = shareLink {
                        DispatchQueue.main.async {
                            self.textField.text = shareLink.absoluteString
                        }
                        UIApplication.shared.open(shareLink, options: [:], completionHandler: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func didSelectAppleMusicButton(_ sender: AnyObject) {
        guard let textFieldText = textField.text, let originalURL = URL(string: textFieldText) else {
            return
        }
        
        if textFieldText.contains("spotify") {
            URLToMusicItemConverter.createMusicItem(forSpotifyShareLink: originalURL) { (musicItem, error) in
                guard let musicItem = musicItem else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.label.text = "\(musicItem.track),\n\(musicItem.artists),\n\(musicItem.album)"
                }
                MusicItemToURLConverter.createAppleMusicShareLink(for: musicItem, withCompletion: { (shareLink, error) in
                    if let shareLink = shareLink {
                        DispatchQueue.main.async {
                            self.textField.text = shareLink.absoluteString
                        }
                        UIApplication.shared.open(shareLink, options: [:], completionHandler: nil)
                    }
                })
            }
        } else if textFieldText.contains("apple") || textFieldText.contains("itun") {
            URLToMusicItemConverter.createMusicItem(forAppleMusicShareLink: originalURL) { (musicItem, error) in
                guard let musicItem = musicItem else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.label.text = "\(musicItem.track),\n\(musicItem.artists),\n\(musicItem.album)"
                }
                
                MusicItemToURLConverter.createAppleMusicShareLink(for: musicItem, withCompletion: { (shareLink, error) in
                    if let shareLink = shareLink {
                        DispatchQueue.main.async {
                            self.textField.text = shareLink.absoluteString
                        }
                        UIApplication.shared.open(shareLink, options: [:], completionHandler: nil)
                    }
                })
            }
        }
    }
    
    func spotify() {
        let spotifyURL = URL(string: "https://open.spotify.com/track/5yEPxDjbbzUzyauGtnmVEC")!
        URLToMusicItemConverter.createMusicItem(forSpotifyShareLink: spotifyURL) { (musicItem, error) in
            guard let musicItem = musicItem else {
                return
            }

            MusicItemToURLConverter.createSpotifyShareLink(for: musicItem, withCompletion: { (shareLink, error) in
                if let shareLink = shareLink {
                    print("INPUT:  \(spotifyURL)")
                    print("OUTPUT: \(shareLink)")
                }
            })
        }
    }
    
    func appleMusic() {
        let appleMusicURL = URL(string: "https://itun.es/gb/mnDP_?i=1067833273")!
        URLToMusicItemConverter.createMusicItem(forAppleMusicShareLink: appleMusicURL) { (musicItem, error) in
            guard let musicItem = musicItem else {
                return
            }
            
            MusicItemToURLConverter.createAppleMusicShareLink(for: musicItem, withCompletion: { (shareLink, error) in
                if let shareLink = shareLink {
                    print("INPUT:  \(appleMusicURL)")
                    print("OUTPUT: \(shareLink)")
                }
            })
        }
    }
}


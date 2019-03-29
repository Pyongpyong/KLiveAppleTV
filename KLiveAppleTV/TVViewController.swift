//
//  TVViewController.swift
//  KLiveAppleTV
//
//  Created by sangpyo hong on 30/03/2019.
//  Copyright © 2019 sangpyo hong. All rights reserved.
//

import UIKit
import AVKit

class TVViewController: UIViewController, VLCMediaPlayerDelegate {
    var url:String = ""
    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoURL = URL(string: url)
        let media = VLCMedia(url: videoURL!)
        
        self.mediaPlayer.media = media
        self.mediaPlayer.delegate = self
        self.mediaPlayer.drawable = self.view
        self.mediaPlayer.media.addOptions([
            "network-caching": 1 * 1000,
            "sout-mux-caching": 30 * 1000,
            "mtu": 1500,
            "cr-average": 10 * 1000,
            "clock-jitter": 60 * 1000,//60 * 1000,
            "clock-synchro": 0,
            "force-dolby-surround": 1,
            "high-priority": true
            ])
        self.mediaPlayer.play()
    }
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        switch mediaPlayer.state {
        case .error:
            fallthrough
        case .ended:
            fallthrough
        case .stopped:
            self.mediaPlayer.play()
        case .paused:
            print("paused")
            break
        case .playing:
            print("playing")
            break
        case .buffering:
            print("buffering")
            break
        default:
            break
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  Iron Log
//
//  Created by Christian Cruz on 2/15/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var videoLayer: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var manage: UIButton!
    @IBOutlet weak var stack: UIStackView!
    
    var player: AVPlayer!
    var playerLooper: NSObject?
    var playerLayer:AVPlayerLayer!
    var queuePlayer: AVQueuePlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playVideo()
        videoLayer.bringSubviewToFront(logoImage)
        videoLayer.bringSubviewToFront(start)
        videoLayer.bringSubviewToFront(create)
        videoLayer.bringSubviewToFront(manage)
        videoLayer.bringSubviewToFront(stack)
    }

    func playVideo() {
        guard let path = Bundle.main.path(forResource: "background", ofType: "mp4") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        
        let playerItem = AVPlayerItem(url: url as URL)
        self.player = AVQueuePlayer(items: [playerItem])
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLooper = AVPlayerLooper(player: self.player! as! AVQueuePlayer, templateItem: playerItem)
        self.videoLayer.layer.addSublayer(self.playerLayer!)
        self.playerLayer?.frame = self.view.frame
        self.player?.play()
        
    }
    
    
    
    
}


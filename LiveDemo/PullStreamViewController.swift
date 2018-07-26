//
//  PullStreamViewController.swift
//  TestIjkplayerSDK
//
//  Created by Jason Fan on 2018/7/25.
//  Copyright © 2018 zyFan. All rights reserved.
//

import UIKit
import IJKMediaFramework

class PullStreamViewController: UIViewController {
    var player: IJKMediaPlayback!
    var playerView: UIView!
    var playBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !player.isPlaying() {
            player.prepareToPlay()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeMovieNotificationObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Pull Stream"
        self.view.backgroundColor = .white
        
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        //视频地址
        //        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        //        player = IJKAVMoviePlayerController(contentURL: videoURL)
        
        //直播地址 - http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8
        //        本地nginx服务器地址: - rtmp://localhost:1935/rtmplive/room
//        let url = URL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8")
        let url = URL(string: "rtmp://192.168.50.13:1935/rtmplive/room")
        //        let option = IJKFFOptions.byDefault()
        //        option?.setOptionIntValue(2, forKey: "videotoolbox", of: kIJKFFOptionCategoryPlayer)
        player = IJKFFMoviePlayerController(contentURL: url, with: nil)
        
        
        let displayView = UIView(frame: CGRect(x: 0, y: 64, width: screenW, height: screenH - 64))
        playerView = displayView
        playerView.backgroundColor = .black
        view.addSubview(playerView)
        
        let tempPlayerView = player.view
        tempPlayerView?.frame = playerView.bounds
        tempPlayerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.insertSubview(tempPlayerView!, at: 1)
        player.scalingMode = .aspectFill
        addMovieNotificationObservers()
        
        playBtn = UIButton(frame: CGRect(x: (screenW - 100) / 2, y: 350, width: 100, height: 40))
        playBtn.setTitle("Play/Pause", for: .normal)
        playBtn.backgroundColor = .black
        playBtn.addTarget(self, action: #selector(playBtnOnClick), for: .touchUpInside)
        view.addSubview(playBtn)
    }
    
    @objc func loadStateDidChange(_ note: NSNotification) {
        let loadState: IJKMPMovieLoadState = player.loadState
        switch loadState {
        case .playthroughOK:
            print("loadStateDidChange playthroughOK")
        case .stalled:
            print("loadStateDidChange stalled")
        default:
            return
        }
        
    }
    
    @objc func moviePlayBackFinish(_ note: NSNotification) {
        let reason: Int = note.userInfo![IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as! Int
        switch reason {
        case 0:
            print("ended")
        case 1:
            print("Error")
        case 2:
            print("exited")
        default:
            return
        }
    }
    
    @objc func moviePlayBackStateDidChange(_ notification: Notification?) {
        switch player.playbackState {
        case .stopped:
            print("IJKMPMoviePlayBackStateDidChange  stoped")
        case .playing:
            print("IJKMPMoviePlayBackStateDidChange  playing")
        case .paused:
            print("IJKMPMoviePlayBackStateDidChange  paused")
        case .interrupted:
            print("IJKMPMoviePlayBackStateDidChange  interrupted")
        case .seekingForward, .seekingBackward:
            print("IJKMPMoviePlayBackStateDidChange  seeking")
        }
    }
    
    @objc func mediaIsPrepared(toPlayDidChange: NSNotification) {
        print("mediaIsPrepared")
    }
    
    @objc func playBtnOnClick() {
        if player.isPlaying() {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func addMovieNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadStateDidChange(_:)), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackFinish(_:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.mediaIsPrepared(toPlayDidChange:)), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackStateDidChange(_:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }
    
    func removeMovieNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


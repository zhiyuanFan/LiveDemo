//
//  PushStreamViewController.swift
//  TestIjkplayerSDK
//
//  Created by Jason Fan on 2018/7/25.
//  Copyright © 2018 zyFan. All rights reserved.
//

import UIKit
import LFLiveKit

class PushStreamViewController: UIViewController {

    var playBtn: UIButton!
    var preView: UIView!
    
    //MARK: - Getters and Setters
    var session: LFLiveSession!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLive()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Push Stream"
        self.view.backgroundColor = .white
        let screenW = UIScreen.main.bounds.size.width
        let screenH = UIScreen.main.bounds.size.height
        
        preView = UIView(frame: view.bounds)
        preView.backgroundColor = .clear
        view.insertSubview(preView, at: 0)
        
        playBtn = UIButton(frame: CGRect(x: (screenW - 100) / 2, y: 350, width: 100, height: 40))
        playBtn.backgroundColor = .black
        playBtn.setTitle("play", for: .normal)
        playBtn.setTitle("stop", for: .selected)
        playBtn.addTarget(self, action: #selector(playBtnOnClick(btn:)), for: .touchUpInside)
        view.addSubview(playBtn)
        
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low1, outputImageOrientation: .portrait)
//        let videoConfiguration = LFLiveVideoConfiguration()
//        videoConfiguration.videoSize = CGSize(width: screenW, height: screenH)
//        videoConfiguration.videoBitRate = LFLiveAudioBitRate._128Kbps.rawValue
//        videoConfiguration.videoMaxBitRate = 1000*1024
//        videoConfiguration.videoMinBitRate = 300*1024
//        videoConfiguration.videoFrameRate = 60
//        videoConfiguration.videoMaxKeyframeInterval = 60
//        videoConfiguration.videoMinFrameRate = 15
//        videoConfiguration.outputImageOrientation = .portrait
//        videoConfiguration.autorotate = false
//        videoConfiguration.sessionPreset = .captureSessionPreset720x1280
        
        session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        
        session.delegate = self
        session.preView = preView
//        session.running = true
        session.captureDevicePosition = .front
    }
    
    
    //MARK: - Event
    @objc func playBtnOnClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            startLive()
            requestAccessForAudio()
            requestAccessForVideo()
        } else {
            stopLive()
        }
    }
    
    func startLive() -> Void {
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://192.168.50.13:1935/rtmplive/room"
        session.startLive(stream)
    }
    
    func stopLive() -> Void {
        session.stopLive()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestAccessForVideo()  {
        weak var _self = self
        let state = AVCaptureDevice.authorizationStatus(for: .video)
        switch state {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (grandted) in
                guard grandted else { return }
                DispatchQueue.main.async(execute: {
                    _self?.session.running = true
                })
            })
        case.authorized:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (grandted) in
                guard grandted else { return }
                DispatchQueue.main.async(execute: {
                    _self?.session.running = true
                })
            })
            break
        case.denied:break
        case.restricted:break
            
            
        }
        
    }
    
    func requestAccessForAudio()  {
        let state = AVCaptureDevice.authorizationStatus(for:.audio)
        switch state {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted) in
                guard granted else{
                    return
                }
            })
        case .authorized: break
        case .denied: break
        case .restricted: break
            
        }
    }
}

extension PushStreamViewController: LFLiveSessionDelegate {
    //MARK: - Callback
    private func liveSession(session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.uploadUrl ?? "uploadUrl")")
    }
    
    private func liveSession(session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode)")
    }
    
    private func liveSession(session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        switch state {
        case .ready:
            print("准备...")
        case .pending:
            print("连接中...")
        case .start:
            print("开始直播")
        case .refresh:
            print("重新加载...")
        case .stop:
            print("停止直播")
        case .error:
            print("错误...")
        }
    }
}

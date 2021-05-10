//
//  HQVideoPlayerView.swift
//  VideoPlayerDemo
//
//  Created by 陈阳 on 2020/9/26.
//  Copyright © 2020 InHim. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

enum HQVideoPlayerSiwpeDirection {
    case swipeLeft
    case swipeRight
    case swipeUp
    case swipeDown
    case swipeNone
}

enum HQVideoPlayerPlayTypeDirection {
    case videoToPlay
    case audioToPlay
}

typealias HQVideoPlayerViewPlayEndBlock = ()->()
//typealias HQVideoPlayerViewAudioPlayEndBlock = ()->()

class HQVideoPlayerView: UIView {
    
    var playEndBlock : HQVideoPlayerViewPlayEndBlock?
  //  var audioPlayEndBlock : HQVideoPlayerViewAudioPlayEndBlock?
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var playerSuperView : UIView?
    
    lazy var coverImageView : UIImageView = {
        let imgView = UIImageView()
        
        return imgView
    }()
    
    lazy var fullBackButton : UIButton = {
        let but  = UIButton()
        but.setImage(UIImage(named: "whiteback"), for: UIControlState.normal)
        but.addTarget(self, action: #selector(gobackMiniScreen), for: UIControlEvents.touchUpInside)
        but.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        return but
    }()
    
    @objc func gobackMiniScreen(){
        toolBarView.fullScreenBut.isSelected = !toolBarView.fullScreenBut.isSelected
        dealForNormalScreenPlayer()
    }
    
    lazy var fullscreenTitleLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = UIColor.white
        return lb
    }()
    
    //AMRK:--** 全屏播放处理*/
     func dealForFullScreenPlayer(orientationChange: Bool = false)  {
        
        
        if orientationChange {
            let orient = UIDevice.current.orientation
            
            if orient == .landscapeRight {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            } else if orient == .landscapeLeft {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }else{
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            }
        } else {
            
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        
        addSubview(fullBackButton)
        addSubview(fullscreenTitleLabel)
        fullscreenTitleLabel.isHidden = toolBarView.isHidden
        fullBackButton.isHidden = toolBarView.isHidden
        fullBackButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(15)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        fullscreenTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fullBackButton.snp.right).offset(-30)
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(35)
        }
        
        toolBarView.fullScreenBut.snp.remakeConstraints { (make) in
            
        }
        
        toolBarView.fullScreenBut.snp.updateConstraints { (make) in
            /*
             make.right.equalToSuperview()
             make.centerY.equalToSuperview()
             //make.width.height.equalTo(14.5)
             make.width.height.equalTo(45)
             */
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(45)
        }
        
        removeFromSuperview()
        UIApplication.shared.windows.first?.addSubview(self)
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    //AMRK:-- 回到小屏播放处理*/
     func dealForNormalScreenPlayer() {
        
        
        
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        fullBackButton.removeFromSuperview()
        fullscreenTitleLabel.removeFromSuperview()
        toolBarView.fullScreenBut.snp.remakeConstraints { (make) in
            
        }
        
        toolBarView.fullScreenBut.snp.updateConstraints { (make) in
            
             make.right.equalToSuperview()
             make.centerY.equalToSuperview()
             //make.width.height.equalTo(14.5)
             make.width.height.equalTo(45)
             
        }
        removeFromSuperview()
        playerSuperView?.addSubview(self)
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    //MARK:--toolBarActions
    lazy var toolBarView : HQVideoToolBar = {
        let toolbar = HQVideoToolBar()
        weak var weakSelf = self
        toolbar.didPlayVideoBlock = { toolbar,isPlay in
            if isPlay {
                switch weakSelf?.playTypeDirection {
                case .videoToPlay:
                    weakSelf?.player.play()
                    weakSelf?.isPlaying = true
                    weakSelf?.playBut.isSelected = false
                    weakSelf?.player.rate = weakSelf!.currentRate
                    break
                default:
                    weakSelf?.audioPlayer.play()
                    weakSelf?.isAudioPlaying = true
                    weakSelf?.playBut.isSelected = false
                    weakSelf?.audioPlayer.rate = weakSelf!.currentRate
                    break
                }
                
            }else{
                
                switch weakSelf?.playTypeDirection {
                case .videoToPlay:
                    weakSelf?.player.pause()
                    weakSelf?.isPlaying = false
                    weakSelf?.playBut.isSelected = true
//                    weakSelf?.player.rate = weakSelf!.currentRate
                    break
                default:
                    weakSelf?.audioPlayer.pause()
                    weakSelf?.isAudioPlaying = false
                    weakSelf?.playBut.isSelected = true
//                    weakSelf?.audioPlayer.rate = weakSelf!.currentRate
                    break
                }
                
                
            }
        }
        
        toolbar.shouldFullScreenBlock = { toolbar,isFullSgreen in
            
            switch weakSelf?.playTypeDirection {
            case .videoToPlay:
                if isFullSgreen {
                    weakSelf?.dealForFullScreenPlayer()
                }else{
                    weakSelf?.dealForNormalScreenPlayer()
                }
                break
            default:
                break
            }
            
            
        }
        
        toolbar.didDragSliderBlock = { toolbar,slider in
            
            switch weakSelf?.playTypeDirection {
            case .videoToPlay:
                weakSelf?.player.pause()
                weakSelf?.isPlaying = false
                weakSelf?.playBut.isSelected = true
                //weakSelf?.player.rate = weakSelf!.currentRate
                break
            default:
                weakSelf?.audioPlayer.pause()
                weakSelf?.isAudioPlaying = false
                weakSelf?.playBut.isSelected = true
                //weakSelf?.audioPlayer.rate = weakSelf!.currentRate
                break
            }
            
        }
        toolbar.didReplayVideoBlock = { toolbar,slider in

        }
        toolbar.didChangeValueBlock = { toolbar,slider in
            let currentTime = slider.value
            
            
            switch weakSelf?.playTypeDirection {
            case .videoToPlay:
                weakSelf?.player.seek(to: CMTimeMakeWithSeconds(Float64(currentTime), Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                weakSelf?.player.play()
                weakSelf?.player.rate = weakSelf!.currentRate
                weakSelf?.isPlaying = true
                weakSelf?.playBut.isSelected = false
                
                break
            default:
                weakSelf?.audioPlayer.seek(to: CMTimeMakeWithSeconds(Float64(currentTime), Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                weakSelf?.audioPlayer.play()
                weakSelf?.audioPlayer.rate = weakSelf!.currentRate
                weakSelf?.isAudioPlaying = true
                weakSelf?.playBut.isSelected = false
                
                break
            }
            
        }
        
        toolbar.showRateSelectBlock = {
            weakSelf!.rateSelectView.isHidden = !(weakSelf!.rateSelectView.isHidden)
        }
        
        return toolbar
    }()
    
    lazy var playBut : UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "puse-icon"), for: UIControl.State.normal)
        but.setImage(UIImage(named: "play-icon"), for: UIControl.State.selected)
        but.addTarget(self, action: #selector(clickPlayBut(sender:)), for: UIControl.Event.touchUpInside)
        
        return but
    }()
    
    @objc func clickPlayBut(sender : UIButton){
        
        if sender.isSelected {
            switch playTypeDirection {
            case .videoToPlay:
                player.play()
                isPlaying = true
                player.rate = currentRate
                break
            default:
                audioPlayer.play()
                isAudioPlaying = true
                audioPlayer.rate = currentRate
                break
            }
        }else{
            switch playTypeDirection {
            case .videoToPlay:
                player.pause()
                isPlaying = false
                //player.rate = currentRate
                break
            default:
                audioPlayer.pause()
                isAudioPlaying = false
                //audioPlayer.rate = currentRate
                break
            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    //MARK:--rateSelectView
    var currentRate : Float = 1.0
    lazy var rateSelectView : HQVideoRateView = {
        let view = HQVideoRateView()
        view.isHidden = true
        view.isUserInteractionEnabled = true
        weak var weakSelf = self
        view.clickItemBlock = { rate in
            
            
            weakSelf?.currentRate = rate
            
            if weakSelf!.changeToAudioPlayButton.isSelected {

                weakSelf?.stopPlay()
                weakSelf?.startAudioPlay()
                weakSelf?.audioPlayer.rate = rate
                print("audio")
            }else{

                weakSelf?.stopAudioPlay()
                weakSelf?.startPlay()
                weakSelf?.player.rate = rate
                print("video")
            }
            
            
            
            //weakSelf?.player.rate = rate
            
            weakSelf?.rateSelectView.isHidden = true
            weakSelf?.toolBarView.rateSelectButton.setTitle("倍速:\(rate)", for: UIControlState.normal)
            
            
            
            
        }
        return view
    }()
    
    
    lazy var player : AVPlayer = {
        let player = AVPlayer()
        
        return player
    }()
    
    var playerItem : AVPlayerItem?
    
    var playerLayer : AVPlayerLayer?
    
    var progressTimer : Timer?
    
    var PlayerItemStatusContext : String?
    var PlayerItemLoadedTimeRangesContext : String?
    
    var  isPlaying = false
    
    //MARK:--touches相关属性
    
    
    
    // 获取设置声音的slider
    private lazy var volumeSlider: UISlider? = {
        let v = MPVolumeView()
//        v.showsRouteButton = true
        v.showsVolumeSlider = true
        v.sizeToFit()
        v.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        for v in v.subviews {
            if (v.classForCoder.description() == "MPVolumeSlider") {
                return v as? UISlider
            }
        }
        return nil
    }()
    
    
    
    private var swipeDirection : HQVideoPlayerSiwpeDirection?
    private var startPoint : CGPoint?
    private var startBrightness : CGFloat?
    private var volumeValue : Float?
    private var startVideoRate : CMTime?
    private var startPlayerSliderValue : Float?
    
    //MARK:--audioPlayer
    
    
    private var playTypeDirection : HQVideoPlayerPlayTypeDirection = .videoToPlay
    
    lazy var changeToAudioPlayButton : UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "earphone-active"), for: UIControlState.normal)
        but.addTarget(self, action: #selector(changeToAudioPlayAction(sender:)), for: UIControlEvents.touchUpInside)
        return but
    }()
    
    @objc func changeToAudioPlayAction(sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            if (audioPlayerItem != nil) {
                changeToAudioPlayer()
                audioWaveIcon.isHidden = !sender.isSelected
            }else{
//                ZSProgressHUD.showDpromptText("暂无音频")
                
            }
            
            
        }else{
            if playerItem != nil {
                changeToVideoPlayer()
                audioWaveIcon.isHidden = !sender.isSelected
            }else{
//                ZSProgressHUD.showDpromptText("暂无视频")
            }
            
        }
        
        
        
    }
    
    
     func changeToVideoPlayer(){
        audioWaveIcon.isHidden = true
        playTypeDirection = .videoToPlay
        stopAudioPlay()
        startPlay()
        playerLayer?.player = player
        audioPlayerLayer?.player = nil
        
        player.rate = currentRate
    }
    
     func changeToAudioPlayer(){
        
        audioWaveIcon.isHidden = false
        playTypeDirection = .audioToPlay
        stopPlay()
        startAudioPlay()
        playerLayer?.player = nil
        audioPlayerLayer?.player = audioPlayer
        audioPlayer.rate = currentRate
    }
    
    
    private lazy var audioWaveIcon : UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "audio-wave-defult")//audio-wave-active
        imgView.isHidden = true
        return imgView
    }()
    
   private lazy var audioPlayer : AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    var audioPlayerItem : AVPlayerItem?
    
   private var audioPlayerLayer : AVPlayerLayer?
    
   private var isAudioPlaying = false
    
   private var AudioPlayerItemStatusContext : String?
   private var AudioPlayerItemLoadedTimeRangesContext : String?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.black
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resize
        
        audioPlayerLayer = AVPlayerLayer(player: audioPlayer)
        
        coverImageView.layer.addSublayer(playerLayer ?? AVPlayerLayer())
        
        coverImageView.layer.addSublayer(audioPlayerLayer ?? AVPlayerLayer())
        
        self.addSubview(coverImageView)
        self.addSubview(toolBarView)
        self.addSubview(audioWaveIcon)
        self.addSubview(playBut)
        
        self.addSubview(rateSelectView)
        
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            
        }
        
        toolBarView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        rateSelectView.snp.makeConstraints { (make) in
            make.centerX.equalTo(toolBarView.rateSelectButton.snp.centerX)
            make.bottom.equalTo(toolBarView.snp.top).offset(8)
            make.width.equalTo(40)
            make.height.equalTo(100)
        }
        
        audioWaveIcon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(204)
            make.height.equalTo(30)
        }
        
        playBut.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(55)
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        self.addGestureRecognizer(tap)
        
        self.addSubview(fastForwardLabel)
        fastForwardLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.addSubview(changeToAudioPlayButton)
        
        changeToAudioPlayButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(45)
        }
        
        audioWaveIcon.image = UIImage(named: "audio-wave-active")
        
//        weak var weakSelf = self
//        UIView.animateKeyframes(withDuration: 0.5, delay: 0.5, options: UIViewKeyframeAnimationOptions.repeat) {
//            weakSelf?.audioWaveIcon.alpha = 0.2
//            weakSelf?.audioWaveIcon.image = UIImage(named: "audio-wave-active")
//        } completion: { (finished) in
//            if finished {
//                UIView.animate(withDuration: 0.5) {
//                    weakSelf?.audioWaveIcon.alpha = 1
//                    weakSelf?.audioWaveIcon.image = UIImage(named: "audio-wave-defult")
//                }
//            }
//        }
        
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
   
    
    func replaceAVPlayerItemWithUrl(url:URL){
        
        
        
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.play()
        toolBarView.playBut.isSelected = true
        addPlayerItemObserverWith(item: item)
        addNotification()
        playerItem = item
        
        changeToVideoPlayer()
        
    }
    
    func replaceAudioAVPlayerItemWithUrl(url:URL){
        
        let item = AVPlayerItem(url: url)
        audioPlayer.replaceCurrentItem(with: item)
        addAudioPlayerItemObserverWith(item: item)
        
        addNotification()
        audioPlayerItem = item
        
        changeToAudioPlayer()
        
    }
    
    //MARK: -KVO 观察AVPlayerItme的属性
    func addPlayerItemObserverWith(item:AVPlayerItem){
        self.removePlayerItemObserver()
        item.addObserver(self, forKeyPath: "status", options: .new, context: &PlayerItemStatusContext)
        item.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: &PlayerItemLoadedTimeRangesContext)
    }
    
    func removePlayerItemObserver(){
        
        
        
        if let _ = playerItem {
            playerItem?.removeObserver(self, forKeyPath: "status")
            playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
            playerItem = nil
        }
        
        
    }
    
    func addAudioPlayerItemObserverWith(item:AVPlayerItem){
        self.removeAudioPlayerItemObserver()
        item.addObserver(self, forKeyPath: "audiostatus", options: .new, context: &AudioPlayerItemStatusContext)
        item.addObserver(self, forKeyPath: "audioloadedTimeRanges", options: .new, context: &AudioPlayerItemLoadedTimeRangesContext)
    }
    
    func removeAudioPlayerItemObserver(){
        
        
        if let _ = audioPlayerItem {
            audioPlayerItem?.removeObserver(self, forKeyPath: "audiostatus")
            audioPlayerItem?.removeObserver(self, forKeyPath: "audioloadedTimeRanges")
            audioPlayerItem = nil
        }
        
    }
    
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if keyPath == "status" {
            
            
            
            if playerItem?.status == AVPlayerItem.Status.readyToPlay{
                
                if let plItem = playerItem {
                    let durition : Double  = CMTimeGetSeconds(plItem.duration)
                    if !durition.isNaN {
                        toolBarView.playerSlider.maximumValue = Float(durition)
                    }
                    
                    isPlaying = true
                    addTimer()
                }
                
                
            }else if playerItem?.status == AVPlayerItem.Status.unknown {
                print("未知状态")
            }else{
                print("错误状态---->\(playerItem?.error?.localizedDescription ?? "")")
            }
            
            
            
        }else if keyPath == "loadedTimeRanges" {
            
        }else if keyPath == "audiostatus" {
            if audioPlayerItem?.status == AVPlayerItem.Status.readyToPlay{
                
                if let plItem = audioPlayerItem {
                    let durition : Double  = CMTimeGetSeconds(plItem.duration)
                    if !durition.isNaN {
                        toolBarView.playerSlider.maximumValue = Float(durition)
                    }
                    
                    isAudioPlaying = true
                    addTimer()
                }
                    
                    
                
                
                
            }else if audioPlayerItem?.status == AVPlayerItem.Status.unknown {
                print("未知状态")
            }else{
                print("错误状态---->\(audioPlayerItem?.error?.localizedDescription ?? "")")
            }
        }else if keyPath == "audioloadedTimeRanges"{
            
        }
        
        
        
        
        
    }
    
    //MARK: -添加定时器
    func addTimer(){
        if progressTimer == nil {
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgressInfo), userInfo: nil, repeats: true)
            RunLoop.main.add(progressTimer!, forMode: RunLoopMode.commonModes)
        }
        
        progressTimer?.fire()
    }
    
    func startProgressTimer(){
        if progressTimer != nil {
            progressTimer?.fire()
        }
    }
    
    func stopProgressTimer(){
        if progressTimer != nil {
            progressTimer?.invalidate()
        }
    }
    
    func removeProgressTimer(){
        if progressTimer != nil {
            progressTimer?.invalidate()
            progressTimer = nil
        }
    }
    
    @objc func updateProgressInfo(){
        
        switch playTypeDirection {
        case .videoToPlay:
            
            if !isPlaying {
                return
            }
            updateTimeString()
            if let plItem = playerItem {
                let durition : Double  = CMTimeGetSeconds(plItem.duration)
                if !durition.isNaN {
                    toolBarView.playerSlider.maximumValue = Float(durition)
                }
                
            }
            let currentTime = CMTimeGetSeconds(player.currentItem?.currentTime() ?? CMTime(value: CMTimeValue(0), timescale: 0) )
            toolBarView.playerSlider.value = Float(currentTime)
            break
        default:
            
            if !isAudioPlaying {
                return
            }
            
            updateTimeString()
            let currentTime = CMTimeGetSeconds(audioPlayer.currentItem?.currentTime() ?? CMTime(value: CMTimeValue(0), timescale: 0)  )
            toolBarView.playerSlider.value = Float(currentTime)
            break
        }
        
        
        
    }
    
    //MARK: -将当前时间转换成时间 显示
    func updateTimeString(){
        switch playTypeDirection {
        case .videoToPlay:
            let currentTime = CMTimeGetSeconds(player.currentItem?.currentTime() ?? CMTime(value: CMTimeValue(0), timescale: 0))
            let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(value: CMTimeValue(0), timescale: 0))
            showTimeStringWith(currentTime: currentTime, duration: duration)
            break
        default:
            let currentTime = CMTimeGetSeconds(audioPlayer.currentItem?.currentTime() ?? CMTime(value: CMTimeValue(0), timescale: 0) )
            let duration = CMTimeGetSeconds(audioPlayer.currentItem?.duration ?? CMTime(value: CMTimeValue(0), timescale: 0) )
            showTimeStringWith(currentTime: currentTime, duration: duration)
            break
        }
        
    }
    
    func showTimeStringWith(currentTime : TimeInterval , duration :  TimeInterval){
        if currentTime.isNaN  || duration.isNaN{
            toolBarView.timeLabel.text = "00:00/00:00"
        }else{
            let dMin : Int = Int(duration / 60)
            let dSec : Int = Int(duration.truncatingRemainder(dividingBy: 60))
            let cMin : Int = Int(currentTime / 60)
            let cSec : Int = Int(currentTime.truncatingRemainder(dividingBy: 60))
            
            let dMinStr = ("\(dMin)".count == 1) ? "0\(dMin)" : "\(dMin)"
            let dSecStr = ("\(dSec)".count == 1) ? "0\(dSec)" : "\(dSec)"
            let cMinStr = "\(cMin)".count == 1 ?   "0\(cMin)" : "\(cMin)"
            let cSecStr = "\(cSec)".count == 1 ?   "0\(cSec)" : "\(cSec)"
            toolBarView.timeLabel.text = "\(cMinStr):\(cSecStr)/\(dMinStr):\(dSecStr)"
        }
        
        
        
    }
    
    //MARK: -添加通知
    func addNotification(){
        removeNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay(noti:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay(noti:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayerItem)
        NotificationCenter.default.addObserver(self, selector: #selector(removePlayerOnPlayerLayer(noti:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetPlayerToPlayerLayer(noti:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    
    func removeNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func removeAllObserver(){
        removeNotification()
        removeProgressTimer()
        removePlayerItemObserver()
        removeAudioPlayerItemObserver()
    }
    
    @objc func playerEndPlay(noti : Notification){
        
        switch playTypeDirection {
        case .videoToPlay:
            player.pause()
            isPlaying = false
            if let block = playEndBlock {
                block()
            }
            player.rate = currentRate
            break
        default:
            audioPlayer.pause()
            isAudioPlaying = false
            if let block = playEndBlock {
                block()
            }
            audioPlayer.rate = currentRate
            break
        }
        
        
    }
    
    @objc func removePlayerOnPlayerLayer(noti : Notification){
        playerLayer?.player = nil
        audioPlayerLayer?.player = nil
    }
    
    @objc func resetPlayerToPlayerLayer(noti : Notification){
        playerLayer?.player = player
        audioPlayerLayer?.player = audioPlayer
        
        if changeToAudioPlayButton.isSelected {
            changeToAudioPlayer()
            startAudioPlay()
            audioPlayer.rate = currentRate
        }else{
            changeToVideoPlayer()
            startPlay()
            player.rate = currentRate
        }
        
    }
    
    
    func distroyPlayer(){
        print("HQVideoPlayer--deinit")
        player.currentItem?.cancelPendingSeeks()
        player.currentItem?.asset.cancelLoading()
        audioPlayer.currentItem?.cancelPendingSeeks()
        audioPlayer.currentItem?.asset.cancelLoading()
        removeAllObserver()
        self.removeFromSuperview()
    }
    
    deinit {
        print("HQVideoPlayer--deinit")
        player.currentItem?.cancelPendingSeeks()
        player.currentItem?.asset.cancelLoading()
        audioPlayer.currentItem?.cancelPendingSeeks()
        audioPlayer.currentItem?.asset.cancelLoading()
        removeAllObserver()
    }
    
    func startPlay(){
        player.play()
        isPlaying = true
        playBut.isSelected = !isPlaying
    }
    
    func stopPlay(){
        player.pause()
        isPlaying = false
        playBut.isSelected = !isPlaying
    }
    
    func startAudioPlay(){
        audioPlayer.play()
        isAudioPlaying = true
        playBut.isSelected = !isAudioPlaying
    }
    
    func stopAudioPlay(){
        audioPlayer.pause()
        isAudioPlaying = false
        playBut.isSelected = !isAudioPlaying
    }
    
    //MARK:--手势
    
    @objc func handleTap(tap:UITapGestureRecognizer){
        
        let tapY = tap.location(in: self).y
        if tapY < self.bounds.size.height - 45 {
            hideItems()
        }
    }
    //MARK:--hideItems
    func hideItems(){
        toolBarView.isHidden = !toolBarView.isHidden
        playBut.isHidden = !playBut.isHidden
        fullBackButton.isHidden = !fullBackButton.isHidden
        fullscreenTitleLabel.isHidden = !fullscreenTitleLabel.isHidden
        if !rateSelectView.isHidden  {
            rateSelectView.isHidden = true
        }
    }
    //MARK:--touches系列
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            startPoint = point
            if point.x <= self.bounds.size.width/2 {
               startBrightness = UIScreen.main.brightness
                
            }
            
            startVideoRate = player.currentTime()
            switch playTypeDirection {
            case .videoToPlay:
                startPlayerSliderValue = Float(CMTimeGetSeconds(player.currentTime()))
                break
            default:
                startPlayerSliderValue = Float(CMTimeGetSeconds(audioPlayer.currentTime()))
                break
            }
            
        }
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if swipeDirection == HQVideoPlayerSiwpeDirection.swipeNone {
            //hideItems()
            return
        }else if swipeDirection == HQVideoPlayerSiwpeDirection.swipeLeft || swipeDirection == HQVideoPlayerSiwpeDirection.swipeRight {
            switch playTypeDirection {
            case .videoToPlay:
                
                startPlay()
                player.rate = currentRate
                fastForwardLabel.isHidden = true
                break
            default:
                
                startAudioPlay()
                audioPlayer.rate = currentRate
                fastForwardLabel.isHidden = true
                break
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if swipeDirection == HQVideoPlayerSiwpeDirection.swipeNone {
            //hideItems()
            return
        }else if swipeDirection == HQVideoPlayerSiwpeDirection.swipeLeft || swipeDirection == HQVideoPlayerSiwpeDirection.swipeRight {
            switch playTypeDirection {
            case .videoToPlay:
                player.seek(to: CMTimeMakeWithSeconds(Float64(toolBarView.playerSlider.value), Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                startPlay()
                fastForwardLabel.isHidden = true
                player.rate = currentRate
                break
            default:
                audioPlayer.seek(to: CMTimeMakeWithSeconds(Float64(toolBarView.playerSlider.value), Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                startAudioPlay()
                fastForwardLabel.isHidden = true
                audioPlayer.rate = currentRate
                break
            }
            
        }
        
        
    }
    
    lazy var fastForwardLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.white
        lb.isHidden = true
        return lb
    }()
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let point = touches.first?.location(in: self),let startP = startPoint {
            let panPoint = CGPoint(x: point.x - startP.x , y: point.y - startP.y)
            
            if panPoint.x >= 30 {
                swipeDirection = .swipeRight
            }else if panPoint.x <= -30 {
                swipeDirection = .swipeLeft
            }else if panPoint.y >= 30 {
                swipeDirection = .swipeDown
            }else if panPoint.y <= -30 {
                swipeDirection = .swipeUp
            }else {
                swipeDirection = .swipeNone
            }
            
            
            switch swipeDirection {
            case .swipeLeft:
                
                
                switch playTypeDirection {
                case .videoToPlay:
                    stopPlay()
                    toolBarView.playerSlider.value = (startPlayerSliderValue ?? Float(CMTimeGetSeconds(player.currentTime()))) + Float(panPoint.x/15)
                    break
                default:
                    stopAudioPlay()
                    toolBarView.playerSlider.value = (startPlayerSliderValue ?? Float(CMTimeGetSeconds(audioPlayer.currentTime()))) + Float(panPoint.x/15)
                    break
                }
                
                fastForwardLabel.isHidden = false
                fastForwardLabel.text = "快退\(Int(panPoint.x/15))S"
                
                
                startVideoRate = (startVideoRate ?? player.currentTime()) - CMTime(value: CMTimeValue(-panPoint.x/15), timescale: 1)
                
                
                
                break
            case .swipeRight:
                switch playTypeDirection {
                case .videoToPlay:
                    stopPlay()
                    toolBarView.playerSlider.value = (startPlayerSliderValue ?? Float(CMTimeGetSeconds(player.currentTime()))) + Float(panPoint.x/15)
                    break
                default:
                    stopAudioPlay()
                    toolBarView.playerSlider.value = (startPlayerSliderValue ?? Float(CMTimeGetSeconds(audioPlayer.currentTime()))) + Float(panPoint.x/15)
                    break
                }
                fastForwardLabel.isHidden = false
                fastForwardLabel.text = "快进\(Int(panPoint.x/15))S"
                
                startVideoRate = (startVideoRate ?? player.currentTime()) + CMTime(value: CMTimeValue(panPoint.x/15), timescale: 1)
                
                break
            case .swipeUp , .swipeDown:
                if startP.x <= self.bounds.size.width/2 {
                    UIScreen.main.brightness = (startBrightness ?? 0) - panPoint.y/30/10
                }else{
                    
                    if volumeValue == nil {
                        volumeValue = volumeSlider?.value
                    }
                    
                    let speedyNum = Float(panPoint.y/80 )
                    
                    var speedyVolume = volumeValue! - speedyNum
                    
                    if speedyVolume < 0 {
                        speedyVolume = 0
                    } else if speedyVolume > 1 {
                        speedyVolume = 1
                    }
                    
                    if speedyVolume >= 0 && speedyVolume <= 1 {
                        volumeSlider?.setValue(speedyVolume, animated: false)
                    }
                    
                    
                    
                }
                break
            
            default:
                break
            }
            
            
            
            
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension HQVideoPlayerView : UIGestureRecognizerDelegate {
    
}

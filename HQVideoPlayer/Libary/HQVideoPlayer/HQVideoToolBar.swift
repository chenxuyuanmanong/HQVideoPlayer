//
//  HQVideoToolBar.swift
//  VideoPlayerDemo
//
//  Created by 陈阳 on 2020/9/26.
//  Copyright © 2020 InHim. All rights reserved.
//

import UIKit

typealias hqToolBarViewDidPlayVideoBlock = (_ tollBar : HQVideoToolBar,_ isPlay : Bool )->()
typealias hqToolBarViewShouldFullScreenBlock = (_ tollBar : HQVideoToolBar,_ isFull : Bool )->()
typealias hqToolBarViewDidDragSliderBlock = (_ tollBar : HQVideoToolBar,_ slider : UISlider )->()
typealias hqToolBarViewDidReplayVideoBlock = (_ tollBar : HQVideoToolBar,_ slider : UISlider )->()
typealias hqToolBarViewDidChangeValueBlock = (_ tollBar : HQVideoToolBar,_ slider : UISlider )->()

typealias hqToolBarViewShowRateSelectBlock = ()->()

class HQVideoToolBar: UIView {
    
    var didPlayVideoBlock : hqToolBarViewDidPlayVideoBlock?
    var shouldFullScreenBlock : hqToolBarViewShouldFullScreenBlock?
    var didDragSliderBlock : hqToolBarViewDidDragSliderBlock?
    var didReplayVideoBlock : hqToolBarViewDidReplayVideoBlock?
    var didChangeValueBlock : hqToolBarViewDidChangeValueBlock?
    
    var showRateSelectBlock : hqToolBarViewShowRateSelectBlock?
    
    lazy var playBut : UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "play-icon"), for: UIControl.State.normal)
        but.setImage(UIImage(named: "puse-icon"), for: UIControl.State.selected)
        but.addTarget(self, action: #selector(clickPlayBut(sender:)), for: UIControl.Event.touchUpInside)
        return but
    }()
    
    @objc func clickPlayBut(sender : UIButton){
        sender.isSelected = !sender.isSelected
        if let block = didPlayVideoBlock {
            block(self,sender.isSelected)
        }
    }
    
    lazy var playerSlider : UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "thum-icon"), for: UIControl.State.normal)
        slider.tintColor = UIColor.white
        slider.isContinuous = false
        //slider.maximumTrackTintColor = UIColor.white
        slider.minimumTrackTintColor = UIColor.white
        slider.addTarget(self, action: #selector(didDragSlider(sender:)), for: UIControl.Event.touchDown)
        slider.addTarget(self, action: #selector(didReplay(sender:)), for: UIControl.Event.touchUpInside)
        slider.addTarget(self, action: #selector(didReplay(sender:)), for: UIControl.Event.touchUpOutside)
        slider.addTarget(self, action: #selector(touchCancel(sender:)), for: UIControlEvents.touchCancel)
        slider.addTarget(self, action: #selector(didChangeValue(sender:)), for: UIControl.Event.valueChanged)
        return slider
    }()
    
    @objc func didDragSlider(sender:UISlider){
        if let block = didDragSliderBlock {
            block(self,sender)
        }
    }
    
    @objc func touchCancel(sender:UISlider){
        if let block = didChangeValueBlock {
            block(self,sender)
        }
    }
    
    @objc func didReplay(sender:UISlider){
        
        if let block = didReplayVideoBlock {
            block(self,sender)
        }
    }
    
    @objc func didChangeValue(sender : UISlider){
        
        if let block = didChangeValueBlock {
            block(self,sender)
        }
    }

    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00/00:00"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var fullScreenBut : UIButton = {
        let but = UIButton()
        but.setImage(UIImage(named: "fullScreen-icon"), for: UIControl.State.normal)
        but.setImage(UIImage(named: "narrow-icon"), for: UIControl.State.selected)
        but.addTarget(self, action: #selector(clickFullBut(sender:)), for: UIControl.Event.touchUpInside)
        return but
    }()
    @objc func clickFullBut(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if let block = shouldFullScreenBlock {
            block(self,sender.isSelected)
        }
    }
    
    lazy var rateSelectButton : UIButton = {
        let but = UIButton()
        but.setTitle("倍速:1.0", for: UIControlState.normal)
        but.setTitleColor(UIColor.white, for: UIControlState.normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        but.addTarget(self, action: #selector(showRateSelectView), for: UIControlEvents.touchUpInside)
        return but
    }()
    
    @objc func showRateSelectView(){
        if let block = showRateSelectBlock {
            block()
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        
        //self.addSubview(playBut)
        self.addSubview(playerSlider)
        self.addSubview(timeLabel)
        self.addSubview(rateSelectButton)
        self.addSubview(fullScreenBut)
        
        
//        playBut.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.centerY.equalToSuperview()
//            make.width.height.equalTo(45)
//        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
        }
        
       
        
        fullScreenBut.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            //make.width.height.equalTo(14.5)
            make.width.height.equalTo(45)
        }
        
        rateSelectButton.snp.makeConstraints { (make) in
            make.right.equalTo(fullScreenBut.snp.left).offset(-4)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(60)
        }
        
        playerSlider.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.right).offset(8)
            make.right.equalTo(rateSelectButton.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

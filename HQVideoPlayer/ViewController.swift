//
//  ViewController.swift
//  HQVideoPlayer
//
//  Created by 陈阳 on 2021/5/9.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var avPlayer : HQVideoPlayerView = {
        let player = HQVideoPlayerView()
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(avPlayer)
        avPlayer.snp.makeConstraints { (make) in
            make.top.equalTo(84)
            make.left.right.equalToSuperview()
            make.height.equalTo(400)
        }
        
        avPlayer.replaceAVPlayerItemWithUrl(url: URL(string: "https://vd2.bdstatic.com/mda-mcp1qxhp736zz7z0/720p/h264_cae/1620474459887664253/mda-mcp1qxhp736zz7z0.mp4?v_from_s=sz_haokan_4469&auth_key=1620656662-0-0-c6c61ba0b49dc8dcbae457060e721f7a&bcevod_channel=searchbox_feed&pd=1&pt=3&abtest=")!)
        avPlayer.replaceAudioAVPlayerItemWithUrl(url: URL(string: "https://m801.music.126.net/20210510223224/0274897011e634e4541f05481871db7d/jdymusic/obj/wo3DlMOGwrbDjj7DisKw/7937681993/d14b/8f71/1390/e694a66f322ff46b6945edc18a621966.mp3")!)
    }


}


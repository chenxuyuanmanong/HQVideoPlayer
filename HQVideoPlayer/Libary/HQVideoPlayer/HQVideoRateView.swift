//
//  HQVideoRateView.swift
//  InHim
//
//  Created by kaiya on 2021/3/9.
//  Copyright © 2021 InHim. All rights reserved.
//

import UIKit

typealias HQVideoRateViewClickItemBlock = (_ rate:Float)->()

class HQVideoRateView: UIView {
    
    var clickItemBlock : HQVideoRateViewClickItemBlock?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        for i in 0..<5 {
            let but = UIButton(frame: CGRect(x: 0, y: 20 * i, width: 40, height: 20))
            switch i {
            case 0:
                but.setTitle("1.2", for: UIControlState.normal)
                break
            case 1:
                let line = UIView(frame: CGRect(x: 0, y: 20, width: 40, height: 0.5))
                line.backgroundColor = UIColor.white
                self.addSubview(line)
                but.setTitle("1.1", for: UIControlState.normal)
                break
            case 2:
                let line = UIView(frame: CGRect(x: 0, y: 40, width: 40, height: 0.5))
                line.backgroundColor = UIColor.white
                self.addSubview(line)
                but.setTitle("1.0", for: UIControlState.normal)
                break
            case 3:
                let line = UIView(frame: CGRect(x: 0, y: 60, width: 40, height: 0.5))
                line.backgroundColor = UIColor.white
                self.addSubview(line)
                but.setTitle("0.9", for: UIControlState.normal)
                break
            default:
                let line = UIView(frame: CGRect(x: 0, y: 80, width: 40, height: 0.5))
                line.backgroundColor = UIColor.white
                self.addSubview(line)
                but.setTitle("0.8", for: UIControlState.normal)
                break
            }
            
            but.setTitleColor(UIColor.white, for: UIControlState.normal)
            but.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            but.tag = i
            but.addTarget(self, action: #selector(clickItem(sender:)), for: UIControlEvents.touchUpInside)
            
            self.addSubview(but)
            
            
            
        }
        
        self.layer.cornerRadius = 5
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
    }
    
    @objc func clickItem(sender:UIButton){
        //print("选择了===>\(sender.tag)")
        
        if let block = clickItemBlock {
            switch sender.tag {
            case 0:
                block(1.2)
                break
            case 1:
                block(1.1)
                break
            case 2:
                block(1.0)
                break
            case 3:
                block(0.9)
                break
            default:
                block(0.8)
                break
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

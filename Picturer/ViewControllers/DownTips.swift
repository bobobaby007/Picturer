//
//  DownTips.swift
//  Picturer
//
//  Created by Bob Huang on 16/3/31.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation

protocol DownTips_delegate:NSObjectProtocol{
    func _DownTipsDidClose()
    func _DownTipsDidShow()
}

class DownTips: UIView {
    var _bg:UIView?
    var _title:UITextField?
    var _isOpened:Bool = false
    
    var _timer:NSTimer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
        _bg = UIView(frame: CGRect(x: 0, y: 10, width: frame.width, height: frame.height-10))
        
        _title = UITextField(frame: _bg!.frame)
        
        _bg!.backgroundColor = Config._color_yellow
        _bg!.alpha = 0.95
        self.addSubview(_bg!)
    }
    
    
    func _show(){
        if _isOpened{
            return
        }
        self.alpha = 0
        _isOpened = true
        
        
        
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.alpha = 1

        }) { [weak self](stop) -> Void in
            if self != nil{
                self!._timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self!, selector: #selector(DownTips._timerHander(_:)), userInfo: nil, repeats: false)
                //self!._timer?.fire()
            }
            
        }
    }
    
    func _timerHander(__timer:NSTimer) -> Void {
       
        _close()
    }
    
    func _close(){
        if !_isOpened{
            return
        }
        
        _isOpened = false
        
        UIView.animateWithDuration(0.4, animations: {[weak self] () -> Void in
            self?.alpha = 0
        }) { [weak self] (stop) -> Void in
            if self?._timer != nil{
                self?._timer?.invalidate()
                self?._timer = nil
            }
            
            
         self?.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

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
    var _title:UILabel?
    var _isOpened:Bool = false
    
    var _timer:NSTimer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
        _bg = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        let _rectBg:UIView = UIView(frame: CGRect(x: 10, y: 8, width: frame.width-10*2, height: 75))
        _rectBg.layer.cornerRadius = 2
        _rectBg.backgroundColor =  Config._color_yellow
        
        let _sanjiao:UIImageView = UIImageView(image: UIImage(named: "sanjiao.png"))
        _sanjiao.frame = CGRect(x: (frame.width-12)/2, y: 8/2, width: 12, height: 8)
       
        
        _bg?.addSubview(_rectBg)
        _bg?.addSubview(_sanjiao)
        
        _title = UILabel(frame: _bg!.frame)
        _title?.textColor = Config._color_black_title
        _title?.font = Config._font_cell_title_normal
        _title?.text = "试试向下滑动"
        _title?.textAlignment = NSTextAlignment.Center
        
        
        _bg!.alpha = 0.95
        
        self.addSubview(_bg!)
        self.addSubview(_title!)
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
                self!._timer = NSTimer.scheduledTimerWithTimeInterval(6, target: self!, selector: #selector(DownTips._timerHander(_:)), userInfo: nil, repeats: false)
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
        if self._timer != nil{
            self._timer?.invalidate()
            self._timer = nil
        }
        
        UIView.animateWithDuration(0.4, animations: {[weak self] () -> Void in
            self?.alpha = 0
        }) { [weak self] (stop) -> Void in
         self?.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

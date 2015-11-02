//
//  LogoAnimation.swift
//  Picturer
//
//  Created by Bob Huang on 15/8/18.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class LogoAnimation:UIViewController {
    let _w:CGFloat = 7
    var _type:String = "white"
    override func viewDidLoad() {
        super.viewDidLoad()
        _setup()
    }
    
    func _setup(){
        let color:UIColor
        
        switch _type{
            case "white":
                color = UIColor.whiteColor()
            break
        default:
                color = UIColor.blackColor()
            break
        }
        
        
        for i in 1...7{
            let _v:UIView = UIView(frame: CGRect(x: CGFloat(7-i)*_w, y: 0, width: _w, height: _w))
            _v.tag = 100+i
            _v.backgroundColor = color
            _v.alpha = 0
            self.view.addSubview(_v)
        }
        for i in 8...13{
            let _v:UIView = UIView(frame: CGRect(x: 0, y:CGFloat(i-7)*_w, width: _w, height: _w))
            _v.tag = 100+i
            _v.backgroundColor = color
            _v.alpha = 0
            self.view.addSubview(_v)
        }
        for i in 14...17{
            let _v:UIView = UIView(frame: CGRect(x: CGFloat(i-13)*_w, y:6*_w, width: _w, height: _w))
            _v.tag = 100+i
            _v.backgroundColor = color
            _v.alpha = 0
            self.view.addSubview(_v)
        }
        for i in 18...19{
            let _v:UIView = UIView(frame: CGRect(x: 4*_w, y:CGFloat(19-i+4)*_w, width: _w, height: _w))
            _v.tag = 100+i
            _v.backgroundColor = color
            _v.alpha = 0
            self.view.addSubview(_v)
        }
        for i in 20...21{
            let _v:UIView = UIView(frame: CGRect(x: CGFloat(4+i-19)*_w, y:4*_w, width: _w, height: _w))
            _v.tag = 100+i
            _v.backgroundColor = color
            _v.alpha = 0
            self.view.addSubview(_v)
        }
        for i in 22...24{
            let _v:UIView = UIView(frame: CGRect(x: 6*_w, y:CGFloat(25-i)*_w, width: _w, height: _w))
            _v.tag = 100+i
            _v.backgroundColor = color
            _v.alpha = 0
            self.view.addSubview(_v)
        }
        let _v:UIImageView = UIImageView(frame: CGRect(x: 5*_w, y: 5*_w, width: _w*2, height: _w*2))
        _v.image = UIImage(named: "logo_triangle.png")
        _v.tag = 100+25
        _v.alpha = 0
        self.view.addSubview(_v)
    }
    
    
    func _changeTo(__to:Int){
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            for i in 1...25{
                let _v = self.view.viewWithTag(100+i)
                if i<=__to{
                    _v?.alpha = 1
                }else{
                    _v?.alpha = 0
                }
            }
        })
    }
    func _reset(){
        for i in 1...25{
            let _v = self.view.viewWithTag(100+i)
            if _v == nil{
                return
            }
            
            _v?.alpha = 0
            
        }
    }
    
}
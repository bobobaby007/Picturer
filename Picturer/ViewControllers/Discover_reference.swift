//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Discover_search: UIViewController {
    let _gap:CGFloat = 10
    let _gapH:CGFloat = 5
    let _sectionGap:CGFloat = 5
    let _barH:CGFloat = 64
    var _sliderH:CGFloat = 168
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _sliderShower:SliderShower?
    
    var _SectionH:CGFloat = 20
    var _picW:CGFloat = 20
    var _hotAlbumView:UIView?
    var _hotUserView:UIView?
    var _referenceView:UIView?
    
    var _hotAlbumArray:NSArray?
    var _hotUserArray:NSArray?
    var _referenceArray:NSArray?
    
    var _btn_more_hotAlbum:UIButton?
    var _btn_more_hotUser:UIButton?
    var _btn_referenceAlbum:UIButton?
    
    var _setuped:Bool=false
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        
        _btn_cancel?.setTitle("返回", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _sliderShower = SliderShower(frame:CGRect(x: 0, y: 62, width: self.view.frame.width, height: _sliderH))
        self.view.addSubview(_sliderShower!)
        
        _SectionH = (self.view.frame.height-_barH-_sliderH-3*_sectionGap)/3
        _picW = (self.view.frame.width - 4*_gap+10)/4
        
        var _labelH = 3*(_SectionH-_picW)/4
        
        
        var _view:UIView = UIView(frame: CGRect(x: 0, y: _barH+_sliderH+_sectionGap, width: self.view.frame.width, height: _SectionH))
        _view.backgroundColor = UIColor.whiteColor()
        var _label:UILabel = UILabel(frame: CGRect(x: _gap, y: 0, width: 200, height:_labelH ))
        _label.text = "热门图册"//"热门图册\u{00AE}"
        _label.textColor=UIColor.blackColor()
        _label.font=UIFont.systemFontOfSize(14)
        _view.addSubview(_label)
        
        _btn_more_hotAlbum = UIButton.buttonWithType(UIButtonType.InfoLight) as? UIButton
        _btn_more_hotAlbum?.frame=CGRect(x: self.view.frame.width-160, y: 0, width: 200, height: _labelH)
        _btn_more_hotAlbum?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        _btn_more_hotAlbum?.titleLabel?.font = UIFont.systemFontOfSize(12)
        _btn_more_hotAlbum?.setTitle("更多", forState: UIControlState.Normal)
        _view.addSubview(_btn_more_hotAlbum!)
        
        self.view.addSubview(_view)
        
        
        
        _view = UIView(frame: CGRect(x: 0, y: _barH+_sliderH+2*_sectionGap+_SectionH, width: self.view.frame.width, height: _SectionH))
        _view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(_view)
        
        _view = UIView(frame: CGRect(x: 0, y: _barH+_sliderH+3*_sectionGap+2*_SectionH, width: self.view.frame.width, height: _SectionH))
        _view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(_view)
        
        _getDatas()
        
        _setuped=true
    }
    
    func _getDatas(){
        MainAction._getAdvertisiongs { (array) -> Void in
            _sliderShower?._setup(array)
        }
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_more_hotAlbum!:
            break
        case _btn_more_hotAlbum!:
            break
        case _btn_more_hotAlbum!:
            break
        default:
            return
        }
        
    }
    
}



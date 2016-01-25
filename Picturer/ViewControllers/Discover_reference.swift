//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Discover_search: UIViewController,ClickItemDelegate{
    let _gap:CGFloat = 10
    let _gapH:CGFloat = 5
    let _sectionGap:CGFloat = 5
    let _barH:CGFloat = 64
    var _sliderH:CGFloat = 168
    var _sliderGapH:CGFloat = 12
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
        _topBar?.backgroundColor=Config._color_black_bar
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.titleLabel?.font=Config._font_topButton
        _btn_cancel?.setTitle("返回", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _sliderShower = SliderShower(frame:CGRect(x: 0, y: 62, width: self.view.frame.width, height: _sliderH))
        self.view.addSubview(_sliderShower!)
        
        _SectionH = (self.view.frame.height-_barH-_sliderH-3*_sectionGap)/3
        _picW = (self.view.frame.width - 4*_gap+10)/4
        _sliderGapH = (_SectionH-_picW)/4
        
        let _labelH = 3*_sliderGapH
        
        
        var _view:UIView = UIView(frame: CGRect(x: 0, y: _barH+_sliderH+_sectionGap, width: self.view.frame.width, height: _SectionH))
        _view.backgroundColor = UIColor.whiteColor()
        var _label:UILabel = UILabel(frame: CGRect(x: _gap, y: 0, width: 200, height:_labelH ))
        _label.text = "热门图册"//"热门图册\u{00AE}"
        _label.textColor=UIColor.blackColor()
        _label.font=UIFont.systemFontOfSize(14)
        _view.addSubview(_label)
        
        _btn_more_hotAlbum = UIButton(type: UIButtonType.Custom)
        _btn_more_hotAlbum?.frame=CGRect(x: self.view.frame.width-50-_gap, y: 0, width: 80, height: _labelH)
        _btn_more_hotAlbum?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        _btn_more_hotAlbum?.titleLabel?.font = UIFont.systemFontOfSize(12)
        _btn_more_hotAlbum?.setTitle("更多>", forState: UIControlState.Normal)
        _view.addSubview(_btn_more_hotAlbum!)
        
        _hotAlbumView = _view
        self.view.addSubview(_view)
        
        
        
        _view = UIView(frame: CGRect(x: 0, y: _barH+_sliderH+2*_sectionGap+_SectionH, width: self.view.frame.width, height: _SectionH))
        _view.backgroundColor = UIColor.whiteColor()
        _label = UILabel(frame: CGRect(x: _gap, y: 0, width: 200, height:_labelH ))
        _label.text = "热门用户"//"热门图册\u{00AE}"
        _label.textColor=UIColor.blackColor()
        _label.font=UIFont.systemFontOfSize(14)
        _view.addSubview(_label)
        
        _btn_more_hotUser = UIButton(type: UIButtonType.Custom)
        _btn_more_hotUser?.frame=CGRect(x: self.view.frame.width-50-_gap, y: 0, width: 80, height: _labelH)
        _btn_more_hotUser?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        _btn_more_hotUser?.titleLabel?.font = UIFont.systemFontOfSize(12)
        _btn_more_hotUser?.setTitle("更多>", forState: UIControlState.Normal)
        _view.addSubview(_btn_more_hotUser!)
        
        
        _hotUserView = _view
        self.view.addSubview(_view)
        
        
        
        _view = UIView(frame: CGRect(x: 0, y: _barH+_sliderH+3*_sectionGap+2*_SectionH, width: self.view.frame.width, height: _SectionH))
        _view.backgroundColor = UIColor.whiteColor()
        _label = UILabel(frame: CGRect(x: _gap, y: 0, width: 200, height:_labelH ))
        _label.text = "推荐相册"//"热门图册\u{00AE}"
        _label.textColor=UIColor.blackColor()
        _label.font=UIFont.systemFontOfSize(14)
        _view.addSubview(_label)
        
        _btn_more_hotUser = UIButton(type: UIButtonType.Custom)
        _btn_more_hotUser?.frame=CGRect(x: self.view.frame.width-50-_gap, y: 0, width: 80, height: _labelH)
        _btn_more_hotUser?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        _btn_more_hotUser?.titleLabel?.font = UIFont.systemFontOfSize(12)
        _btn_more_hotUser?.setTitle("更多>", forState: UIControlState.Normal)
        _view.addSubview(_btn_more_hotUser!)
        
        _referenceView = _view
        self.view.addSubview(_view)
        
        _getDatas()
        
        _setuped=true
    }
    
    
    func _getDatas(){
        Social_Main._getAdvertisiongs { (array) -> Void in
            self._sliderShower?._setup(array)
        }
        Social_Main._getHotAlbums { (array) -> Void in
            self._hotAlbumArray = array
            self._hotAlbumsIn()
        }
        
        Social_Main._getReferenceAlbums{ (array) -> Void in
            self._referenceArray = array
            self._referenceAlbumsIn()
        }
        Social_Main._getHotUsers { (array) -> Void in
            self._hotUserArray = array
            self._hotUsersIn()
        }
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_more_hotAlbum!:
            break
        case _btn_more_hotUser!:
            break
        case _btn_referenceAlbum!:
            break
        default:
            return
        }
        
    }
    
    
    func _hotAlbumsIn(){
        let _n:Int = _hotAlbumArray!.count
        let _scrollView:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 3*_sliderGapH, width: self.view.frame.width, height: _picW))
        _scrollView.contentSize = CGSize(width: CGFloat(_n-1)*(_picW+_gap)+_gap, height: _picW)
        _scrollView.showsHorizontalScrollIndicator=false
        _scrollView.showsVerticalScrollIndicator=false
        
        for var i:Int = 0; i<_n-1;++i{
            let _pic:ClickPicItem = ClickPicItem(frame: CGRect(x: CGFloat(i)*(_picW+_gap)+_gap, y: 0, width: _picW, height: _picW))
            _pic._index = i
            _pic._type = "hotAlbum"
            _pic._delegate = self
           _pic._setPic((_hotAlbumArray?.objectAtIndex(i) as! NSDictionary).objectForKey("pic") as! NSDictionary)
            _scrollView.addSubview(_pic)
        }
        _hotAlbumView!.addSubview(_scrollView)
        
    }
    func _hotUsersIn(){
        let _n:Int = _hotUserArray!.count
        let _scrollView:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 3*_sliderGapH, width: self.view.frame.width, height: _picW))
        _scrollView.contentSize = CGSize(width: CGFloat(_n-1)*(_picW+_gap)+_gap, height: _picW)
        _scrollView.showsHorizontalScrollIndicator=false
        _scrollView.showsVerticalScrollIndicator=false
        
        for var i:Int = 0; i<_n-1;++i{
            let _pic:ClickUserItem = ClickUserItem(frame: CGRect(x: CGFloat(i)*(_picW+_gap)+_gap, y: 0, width: _picW, height: _picW))
            _pic._index = i
            _pic._type = "hotUser"
            _pic._delegate = self
            _pic._setAlbumImage((_hotUserArray?.objectAtIndex(i) as! NSDictionary).objectForKey("pic") as! NSDictionary)
            _pic._setUserName((_hotUserArray?.objectAtIndex(i) as! NSDictionary).objectForKey("userName") as! String)
            _pic._setUserImg((_hotUserArray?.objectAtIndex(i) as! NSDictionary).objectForKey("userImg") as! NSDictionary)
            _scrollView.addSubview(_pic)
        }
        _hotUserView!.addSubview(_scrollView)
    }
    func _referenceAlbumsIn(){
        let _n:Int = _referenceArray!.count
        let _scrollView:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 3*_sliderGapH, width: self.view.frame.width, height: _picW))
        _scrollView.contentSize = CGSize(width: CGFloat(_n-1)*(_picW+_gap)+_gap, height: _picW)
        _scrollView.showsHorizontalScrollIndicator=false
        _scrollView.showsVerticalScrollIndicator=false
        
        for var i:Int = 0; i<_n-1;++i{
            let _pic:ClickPicItem = ClickPicItem(frame: CGRect(x: CGFloat(i)*(_picW+_gap)+_gap, y: 0, width: _picW, height: _picW))
            _pic._index = i
            _pic._type = "referenceAlbum"
            _pic._delegate = self
            _pic._setPic((_referenceArray?.objectAtIndex(i) as! NSDictionary).objectForKey("pic") as! NSDictionary)
            _scrollView.addSubview(_pic)
        }
        _referenceView!.addSubview(_scrollView)
    }
    
    
    //------图片点击代理
    
    func _picTaped(__dict: NSDictionary) {
        switch __dict.objectForKey("type") as! String{
            case "hotAlbum":
                Social_Main._getPicsListAtAlbumId((_referenceArray!.objectAtIndex(__dict.objectForKey("index") as! Int) as! NSDictionary).objectForKey("albumId") as? String, __block: { (array) -> Void in
                    
                    let _controller:Social_pic = Social_pic()
                    _controller._showIndexAtPics(0, __array: array)
                    
                   
                    (self.parentViewController?.view.superview?.nextResponder() as! UIViewController).navigationController?.pushViewController(_controller, animated: true)
                })
            return
        case "hotUser":            
            let _controller:MyHomepage = MyHomepage()
            _controller._userId = (_hotUserArray!.objectAtIndex(__dict.objectForKey("index") as! Int) as! NSDictionary).objectForKey("userId") as! String
            (self.parentViewController?.view.superview?.nextResponder() as! UIViewController).navigationController?.pushViewController(_controller, animated: true)
            
            return
        case "referenceAlbum":
            
            Social_Main._getPicsListAtAlbumId((_referenceArray!.objectAtIndex(__dict.objectForKey("index") as! Int) as! NSDictionary).objectForKey("albumId") as? String, __block: { (array) -> Void in
                let _controller:Social_pic = Social_pic()
                _controller._showIndexAtPics(0, __array: array)
                (self.parentViewController?.view.superview?.nextResponder() as! UIViewController).navigationController?.pushViewController(_controller, animated: true)
            })
            return
        default:
            return
        }
    }
    
}





//---=========================----

protocol ClickItemDelegate:NSObjectProtocol{
    func _picTaped(__dict:NSDictionary)
}

class ClickPicItem: UIView {
    var _pic:PicView?
    weak var _delegate:ClickItemDelegate?
    var _type:String?
    var _index:Int?
    var _tapG:UITapGestureRecognizer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _pic = PicView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        _pic?.maximumZoomScale=1
        _pic?.minimumZoomScale=1
        _pic?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _pic?._imgView?.layer.masksToBounds = true
        _pic?._imgView?.layer.cornerRadius = 5
        
        
        
        _tapG = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        self.addGestureRecognizer(_tapG!)
        addSubview(_pic!)
    }
    func tapHander(__sender:UITapGestureRecognizer){
        
        _delegate!._picTaped(NSDictionary(objects: [_type!,_index!], forKeys: ["type","index"]))
    }
    
    func _setPic(__pic:NSDictionary){
        _pic?._setPic(__pic, __block: { (dict) -> Void in
            
        })
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ClickUserItem:ClickPicItem {
    var _userImg:PicView?
    var _nameLabel:UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        let _overV:UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        _overV.layer.cornerRadius = 5
        _overV.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(_overV)
        
        _userImg = PicView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        _userImg?.maximumZoomScale=1
        _userImg?.minimumZoomScale=1
        _userImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        _userImg?._imgView?.layer.masksToBounds = true
        _userImg?._imgView?.layer.cornerRadius = 25
        
        _userImg?.center = CGPoint(x: frame.width/2, y: frame.height/2)
        addSubview(_userImg!)
        
        _nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width-4, height: 20))
        _nameLabel?.center = CGPoint(x: frame.width/2, y: frame.height/2+25+8)
        _nameLabel?.textColor = UIColor.whiteColor()
        _nameLabel?.font = UIFont.systemFontOfSize(12)
        
        _nameLabel?.textAlignment = NSTextAlignment.Center
        addSubview(_nameLabel!)
        
        _pic?.tintAdjustmentMode = UIViewTintAdjustmentMode.Automatic
        _pic?.tintColor = UIColor.redColor()
       // _pic?.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        
    }
    func _setUserName(__str:String){
        _nameLabel?.text = __str
    }
    func _setUserImg(__pic:NSDictionary){
        _userImg?._setPic(__pic, __block: { (dict) -> Void in
            
        })
    }
    func _setAlbumImage(__pic:NSDictionary){
        super._setPic(__pic)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



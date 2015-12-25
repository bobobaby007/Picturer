//
//  Manage_imagePicker.swift
//  Picturer
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

//----弹出选择相册

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation



protocol NewFromWeb_delegate:NSObjectProtocol{
    func _newFromWeb_selected(images:NSArray)
}

class NewFromWeb:UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,PicsSelecter_deletegate,UIWebViewDelegate{
    
    weak var _delegate:NewFromWeb_delegate?
    
    let _gap:CGFloat=10
    let _barH:CGFloat = 64
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    
    
    var _btn_close:UIButton?
    
    var _searchBar:UIView = UIView()
    var _searchT:UITextField = UITextField()

    var _setuped:Bool=false
    
    var _picsSelecter:PicsSelecter?
    
    var _webView:UIWebView?
    
    var _btn_getImages:UIButton?
    var _btn_goForward:UIButton?
    var _btn_goBack:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor = UIColor.grayColor()
        
        _searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH)
        _searchBar.backgroundColor = UIColor.blackColor()
        
        _btn_cancel=UIButton(frame:CGRect(x: _gap, y: (_barH-15)/2+12, width: 15, height: 15))
        _btn_cancel?.setImage(UIImage(named: "icon_close.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)

        
        let _searchLableV:UIView = UIView(frame: CGRect(x: _btn_cancel!.frame.width + 2*_gap, y: (_barH-28)/2+12, width: self.view.frame.width-7.5-2*_gap-_btn_cancel!.frame.width, height: 28))
        _searchLableV.backgroundColor = UIColor.whiteColor()
        _searchLableV.layer.cornerRadius=5
        
        //        let _icon:UIImageView = UIImageView(image: UIImage(named: "search_icon.png"))
        //        _icon.frame=CGRect(x: _gap, y: 10, width: 13, height: 13)
        
        _searchT.frame = CGRect(x: _gap, y: 0, width: self.view.frame.width-7.5-2*_gap-_btn_cancel!.frame.width-2*_gap, height: _searchLableV.frame.height)
        _searchT.addTarget(self, action: "textDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        _searchT.attributedPlaceholder = NSAttributedString(string:"输入网址",
            attributes:[NSForegroundColorAttributeName: MainAction._color_gray_time])
        _searchT.font = MainAction._font_input
        _searchT.delegate = self
        _searchT.returnKeyType = UIReturnKeyType.Search
        
        _webView = UIWebView(frame: CGRect(x: 0, y: _searchBar.frame.origin.y+_searchBar.frame.height, width: self.view.frame.width, height: self.view.frame.height-_searchBar.frame.origin.y-_searchBar.frame.height))
        
        _webView?.delegate = self
        
        _btn_getImages = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-48, width: self.view.frame.width, height: 48))
        _btn_getImages?.backgroundColor = MainAction._color_black_bottom
        _btn_getImages?.setTitle("抓取", forState: UIControlState.Normal)
        _btn_getImages?.titleLabel?.font = MainAction._font_topbarTitle
        _btn_getImages?.setTitleColor(MainAction._color_white_title, forState: UIControlState.Normal)
        _btn_getImages?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        //        _searchLableV.addSubview(_icon)
        
        _btn_goBack = UIButton(frame: CGRect(x: 10, y: _searchBar.frame.origin.y+_searchBar.frame.height+10, width: 20, height: 20))
        _btn_goBack?.backgroundColor = MainAction._color_yellow
        _btn_goBack?.setTitle("<", forState: UIControlState.Normal)
        _btn_goBack?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_goForward = UIButton(frame: CGRect(x: 40, y: _searchBar.frame.origin.y+_searchBar.frame.height+10, width: 20, height: 20))
        _btn_goForward?.backgroundColor = MainAction._color_yellow
        _btn_goForward?.setTitle(">", forState: UIControlState.Normal)
        _btn_goForward?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _searchLableV.addSubview(_searchT)
        _searchBar.addSubview(_searchLableV)
        _searchBar.addSubview(_btn_cancel!)
        
        
        self.view.addSubview(_searchBar)
        self.view.addSubview(_webView!)
        self.view.addSubview(_btn_getImages!)
        self.view.addSubview(_btn_goBack!)
       // self.view.addSubview(_btn_goForward!)
        
        
        
        
        
        _setuped = true
        
    }
    //----网页代理
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //print(request.URL?.absoluteString)
        _searchT.text = request.URL?.absoluteString
        return true
    }
    
    //---文字代理
    func textDidChanged(sender:UITextField){
     
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print(_searchT.text)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //_pickFromUrl(textField.text!)
        
        var _str:String = textField.text!
        
        let range = _str.rangeOfString("http")
        if range?.count==nil{
            _str = "http://"+_str
        }
        
        _webView?.loadRequest(NSURLRequest(URL: NSURL(string: _str)!))
        return true
    }
    
    func _pickFromUrl(__url:String){
        CoreAction._getImagesFromUrl(__url) { (__dict) -> Void in
            let recode:Int = __dict.objectForKey("recode") as! Int
            if recode == 200{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let _images:NSArray = __dict.objectForKey("images") as! NSArray
                    let _arr:NSMutableArray = []
                    for var i:Int = 0;i<_images.count; ++i{
                        
                        if let _str:String = DoubanApis._getLargeImageOfUrl(_images.objectAtIndex(i) as! String){
                            _arr.addObject(NSDictionary(objects: [_str,"file"], forKeys: ["url","type"]))
                        }
                        
                    }
                    print(_arr)
                    self._picsSelecter = PicsSelecter()
                    self._picsSelecter?._delegate = self
                    self._picsSelecter?._setImages(_arr)
                    self.navigationController?.pushViewController(self._picsSelecter!, animated: true)
                })               
            }else{
                
            }
        }
    }
    //-----图片选择代理
    func imagePickerDidSelected(images: NSArray) {
        _delegate?._newFromWeb_selected(images)
    }
    
    
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
            break
        case _btn_goBack!:
            _webView?.goBack()
            break
        case _btn_goForward!:
            print("gogooooo")
            _webView?.goForward()
            break
        case _btn_getImages!:
            _pickFromUrl(_searchT.text!)
            break
        default:
            break
        }
    }
    
}











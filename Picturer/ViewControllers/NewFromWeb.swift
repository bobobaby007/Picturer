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

class NewFromWeb:UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,PicsSelecter_deletegate{
    
    weak var _delegate:NewFromWeb_delegate?
    
    let _gap:CGFloat=15
    let _barH:CGFloat = 64
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    
    
    var _btn_close:UIButton?
    
    var _searchBar:UIView = UIView()
    var _searchT:UITextField = UITextField()

    var _setuped:Bool=false
    
    var _picsSelecter:PicsSelecter?
    
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
        
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 30, height: 62))
        _btn_cancel?.setTitle("x", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)

        
        let _searchLableV:UIView = UIView(frame: CGRect(x: _btn_cancel!.frame.width + _gap, y: 8+12, width: self.view.frame.width-_btn_cancel!.frame.width-_gap, height: _barH-16-12))
        _searchLableV.backgroundColor = UIColor.whiteColor()
        _searchLableV.layer.cornerRadius=5
        
        //        let _icon:UIImageView = UIImageView(image: UIImage(named: "search_icon.png"))
        //        _icon.frame=CGRect(x: _gap, y: 10, width: 13, height: 13)
        
        _searchT.frame = CGRect(x: 5, y: 0, width: self.view.frame.width-2*5, height: _searchLableV.frame.height)
        _searchT.addTarget(self, action: "textDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        _searchT.placeholder = "输入网址"
        _searchT.font = UIFont.systemFontOfSize(13)
        _searchT.delegate = self
        _searchT.returnKeyType = UIReturnKeyType.Search
        
        
        
        //        _searchLableV.addSubview(_icon)
        
        
        
        _searchLableV.addSubview(_searchT)
        _searchBar.addSubview(_searchLableV)
        _searchBar.addSubview(_btn_cancel!)
        
        
        self.view.addSubview(_searchBar)
        
        
        
        
        
        
        _setuped = true
        
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
        _pickFromUrl(textField.text!)
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
        default:
            break
        }
    }
    
}











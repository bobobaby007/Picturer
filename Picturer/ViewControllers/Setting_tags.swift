//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol Setting_tagsDelegate:NSObjectProtocol{
    func canceld()
    func saved(dict:NSDictionary)
}

class Setting_tags: UIViewController,UITextFieldDelegate {
    let _gap:CGFloat=30
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    var _title_label:UILabel?
    var _delegate:Setting_tagsDelegate?
    
    
    var _inputText:UITextField?
    
    var _selectedId:Int=0
    var _tags:NSMutableArray?
    
    
    let _maxC:Int = 15 //最大字数
    
    var _defaultTags:NSArray=["电影","美食","旅行","时尚","艺术","建筑","设计","摄影","健康","家居","宠物","娱乐","动漫","科技","成长","运动","情感","故事"]
    
    
    
    override func viewDidLoad() {
        setup()
        refreshView()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_save=UIButton(frame:CGRect(x: self.view.frame.width-50, y: 5, width: 40, height: 62))
        _btn_save?.setTitle("完成", forState: UIControlState.Normal)
        _btn_save?.setTitleColor(UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1), forState: UIControlState.Normal)
        _btn_save?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 5, width: self.view.frame.width-100, height: 62))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="标签"
        
        
        _inputText=UITextField(frame:CGRectMake(0,80,self.view.frame.width,50))
       
        var _leftV:UIView=UIView(frame: CGRectMake(0, 0, _gap, 40))
        _inputText?.leftView=_leftV
        _inputText?.leftViewMode=UITextFieldViewMode.Always
        
        
        _inputText?.backgroundColor=UIColor.whiteColor()
        _inputText?.placeholder="标签(请用逗号分开)"
        _inputText?.delegate=self
        
        _tagsIn()
        
       _defaultTagsIn()
        
        
        
        
        self.view.addSubview(_inputText!)
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_save!)
        _topBar?.addSubview(_title_label!)
        
        
        _setuped=true
    }
    
    
    
    //----设置位置
    func refreshView(){
       
    }
    
    func _defaultTagsIn(){
        
        
        
        for var i:Int=0; i<_defaultTags.count; ++i{
            
            let _gapX:CGFloat = 10
            let _width:CGFloat = (self.view.frame.width - 2*_gap - 4*_gapX)/5
            
            let _gapY:CGFloat = 40
            
            var _text:UILabel = UILabel(frame: CGRectMake(_gap+CGFloat(i%5)*(_gapX+_width), 150+floor(CGFloat(i/5))*_gapY, _width, 30))
            _text.backgroundColor=UIColor(white: 0.8, alpha: 0.3)
            _text.textAlignment=NSTextAlignment.Center
            _text.layer.masksToBounds=true
            _text.layer.cornerRadius=5
            _text.text=_defaultTags.objectAtIndex(i) as? String
            
            _text.userInteractionEnabled=true
            
            var _tapRec:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
            _text.addGestureRecognizer(_tapRec)
            
            
            self.view.addSubview(_text)
            
        }
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        
        
        
        let _text:UILabel = tap.view as! UILabel
        
        _tagPutIn(_text.text!)
        
    }
    
    func _tagsIn(){
        if _tags == nil{
            return
        }
        for var i:Int=0; i<_tags!.count; ++i{
            _tagPutIn(_tags!.objectAtIndex(i) as! String)
        }
    }
    
    func _tagPutIn(__str:String){
        let _str:String = _inputText!.text
        let _strLeng:Int=_str.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        
        if (_strLeng+__str.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2)>_maxC{
            return
        }
        if _strLeng>0{
            let _t:NSString = (_str as NSString).substringFromIndex(_strLeng-1)
            if _t.isEqualToString(","){
                _inputText!.text=_str + __str
            }else{
                _inputText!.text=_str + "," + __str
            }
            
        }else{
            _inputText!.text=__str
        }
    }
    //---限制字数
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let _str:String = _inputText!.text
        let _strLeng:Int=_str.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        println(_strLeng)
        if _strLeng > _maxC{
            _inputText!.text = (_str as NSString).substringToIndex(_maxC)
        }
        return true
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
            _delegate?.canceld()
        case _btn_save!:
            var _dict:NSMutableDictionary=NSMutableDictionary()
            _dict.setObject("tags", forKey: "Action_Type")
            
            let _str:String = _inputText!.text
            let _tagArray:NSArray = _str.componentsSeparatedByString(",")
            
            _dict.setObject(_tagArray, forKey: "tags")
            
            _delegate?.saved(_dict)
            self.navigationController?.popViewControllerAnimated(true)
        default:
            println(sender)
        }
        
    }
}


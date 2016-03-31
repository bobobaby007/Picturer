//
//  Manage_description.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/14.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


protocol ContentEditer_delegate:NSObjectProtocol{
    func canceld()
    func saved(dict:NSDictionary)
}

class ContentEditer: UIViewController,UITextViewDelegate {
    weak var _delegate:ContentEditer_delegate?
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    var _title_label:UILabel?
    var _desInput:UITextView?
    var _desAlert:UILabel?
    
    var _type:String = "text"//----text/selecter 类型，文字／选择
    
    var _maxNum:Int=20
    var _titleStr:String = ""
    var _content:String = ""
    
    var _tapRec:UITapGestureRecognizer?
    
    var _gap:CGFloat=15
    var _desPlaceHold:String?
    
    var _setuped:Bool=false
    
    var _whiteBg:UIView = UIView()
    var _lineNum:CGFloat = 1
    
    var _selecterArray:NSArray?
    var _selectedIndex:Int = 0
    var _selectedTagFrom:Int = 100
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=Config._color_bg_gray
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: Config._barH ))
        _topBar?.backgroundColor=Config._color_black_bar
        
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.titleLabel?.font = Config._font_topButton
        
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: #selector(ContentEditer.clickAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_save=UIButton(frame:CGRect(x: self.view.frame.width-50, y: 5, width: 40, height: 62))
        _btn_save?.setTitle("保存", forState: UIControlState.Normal)
        _btn_save?.setTitleColor(Config._color_yellow, forState: UIControlState.Normal)
        _btn_save?.titleLabel?.font = Config._font_topButton
        _btn_save?.addTarget(self, action: #selector(ContentEditer.clickAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = Config._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text=_titleStr
        //_desPlaceHold =
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_save!)
        _topBar?.addSubview(_title_label!)
        self.view.addSubview(_topBar!)
        switch _type{
            case "text":
                _setupForText()
            break
            case "selecter":
                _setupForSelecter()
            break
        default:
            break
        }
        self.view.addSubview(_whiteBg)
        
        _setuped=true
    }
    
    func _setupForText(){
                
        _whiteBg = UIView(frame: CGRect(x: 0, y: _topBar!.frame.height+_gap, width: self.view.frame.width, height: _lineNum*(45)))
        _whiteBg.backgroundColor = UIColor.whiteColor()
        var _line:UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0.3))
        _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _whiteBg.addSubview(_line)
        self.view.addSubview(_line)
        _line = UIView(frame: CGRect(x: 0, y: _whiteBg.frame.height, width: self.view.frame.width, height: 0.5))
        _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _whiteBg.addSubview(_line)
        
        _desInput=UITextView(frame: CGRect(x: _gap, y: _gap, width: self.view.frame.width-2*_gap, height: _lineNum*45))
        //_desInput?.textAlignment = NSTextAlignment.Left
        if _desPlaceHold != nil{
            _desInput?.text=_desPlaceHold
        }
        
        _desInput?.backgroundColor=UIColor.clearColor()
        _desInput?.font=Config._font_description_at_bottom
        _desInput?.textContainerInset = UIEdgeInsetsZero
        _desInput?.textContainer.lineFragmentPadding = 0
        _desInput?.text = _content
        //_desInput?.keyboardAppearance=UIKeyboardAppearance.Dark
        //_desInput?.returnKeyType=UIReturnKeyType.Done
        
        _desInput?.delegate=self
        _desInput?.becomeFirstResponder()
        
        _whiteBg.addSubview(_desInput!)
        
        //----字数提示
        _desAlert=UILabel(frame:CGRect(x: _gap, y: _whiteBg.frame.height-22.5, width: self.view.frame.width-2*_gap, height: 20) )
        _desAlert?.text=String(_maxNum)
        _desAlert?.font=UIFont(name: "Helvetica", size: 14)
        
        _desAlert?.textColor=UIColor(white: 0.3, alpha: 1)
        _desAlert?.textAlignment=NSTextAlignment.Right
        
        if _lineNum>1{
            _whiteBg.addSubview(_desAlert!)
        }
        //---
        
        
        
        
        _tapRec=UITapGestureRecognizer(target: self, action: #selector(ContentEditer.tapHander(_:)))
    }
    
    func _setupForSelecter(){
        _lineNum = CGFloat(_selecterArray!.count)
        _whiteBg = UIView(frame: CGRect(x: 0, y: _topBar!.frame.height+_gap, width: self.view.frame.width, height: _lineNum*(45)))
        _whiteBg.backgroundColor = UIColor.whiteColor()
        
        for i:Int in 0 ..< _selecterArray!.count+1{
            let _line:UIView = UIView(frame: CGRect(x: 0, y: CGFloat(i)*45, width: self.view.frame.width, height: 0.5))
            _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
            _whiteBg.addSubview(_line)
            if i<_selecterArray?.count{
                let _btn:UIButton = UIButton(frame: CGRect(x: 0, y: CGFloat(i)*45, width: self.view.frame.width, height:45))
                _btn.tag = i
                _btn.backgroundColor = UIColor.clearColor()
                _btn.addTarget(self, action: #selector(ContentEditer._btnHander(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                _whiteBg.addSubview(_btn)
                
                let _label:UILabel = UILabel(frame: CGRect(x: Config._gap, y: CGFloat(i)*45, width: self.view.frame.width-Config._gap-26, height: 45))
                
                _label.font = Config._font_cell_title_normal
                _label.backgroundColor = UIColor.clearColor()
                _label.userInteractionEnabled = false
                _label.textColor = Config._color_social_gray
                _label.text = _selecterArray?.objectAtIndex(i) as? String
                _whiteBg.addSubview(_label)
                
                let _sign:UIImageView = UIImageView(frame: CGRect(x: self.view.frame.width-26, y: CGFloat(i)*45+18, width: 12.5, height: 9.5))
                _sign.tag = _selectedTagFrom+i
                _sign.userInteractionEnabled = false
                _sign.image = UIImage(named: "selected.png")
                if i == _selectedIndex{
                    _sign.hidden = false
                }else{
                    _sign.hidden = true
                }
                _whiteBg.addSubview(_sign)
                
            }
            
        }
        
    }
    
    
    func _btnHander(sender:UIButton){
        let _tag:Int = sender.tag
        _selectedAt(_tag)
    }
    func _selectedAt(_tag:Int){
        _selectedIndex = _tag
        print(_selectedIndex)
        for i:Int in 0  ..< _selecterArray!.count {
            
            if i == _selectedIndex{
                _whiteBg.viewWithTag(_selectedTagFrom+i)?.hidden = false
            }else{
                _whiteBg.viewWithTag(_selectedTagFrom+i)?.hidden = true
            }
        }
    }
    
    
    //----文字输入代理
    func textViewDidBeginEditing(textView: UITextView) {
        //        if _desInput?.text == _desPlaceHold{
        //            _desInput?.text=""
        //        }
        self.view.addGestureRecognizer(_tapRec!)
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let _n:Int=_desInput!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        
        if (_n+text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2)>_maxNum{
            return false
        }
        // println(text)
        return true
    }
    func textViewDidChange(textView: UITextView) {
        
        if _desInput?.text == _desPlaceHold{
            _desAlert?.text=String(_maxNum)
            return
        }
        
        var _n:Int=_desInput!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        if _n>=_maxNum{
            _n=_maxNum
            let _str:NSString=_desInput!.text as NSString
            _desInput!.text=_str.substringToIndex(_maxNum)
        }
        _desAlert?.text=String(_maxNum-_n)
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        
        _desInput?.resignFirstResponder()
        
        if _desInput?.text == ""{
            _desInput?.text=_desPlaceHold
        }
        self.view.removeGestureRecognizer(_tapRec!)
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
            _delegate?.canceld()
        case _btn_save!:
            let _dict:NSMutableDictionary=NSMutableDictionary()
            switch _type{
                case "text":
                    if _desInput?.text != _desPlaceHold{
                        _dict.setObject(_desInput!.text, forKey: "content")
                    }
                    _dict.setObject(_desInput!.text, forKey: "")
                break
                case "selecter":
                    _dict.setObject(_selectedIndex, forKey: "content")
                break
            default:
                break
            }
            _delegate?.saved(_dict)
            self.navigationController?.popViewControllerAnimated(true)
        default:
            print(sender)
        }
        
    }
}

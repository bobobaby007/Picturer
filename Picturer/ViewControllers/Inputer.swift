//
//  Inputer.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/23.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol Inputer_delegate:NSObjectProtocol{
    func _inputer_send(__dict:NSDictionary)
    func _inputer_changed(__dict:NSDictionary)
    func _inputer_closed()
    func _inputer_opened()
}
//-------------

class Inputer: UIView,UITextViewDelegate {
    
    weak var _delegate:Inputer_delegate?
    
    var _placeHold:String = "输入文字"{
        didSet{
            if _placeHoldText != nil{
                self._placeHoldText?.text = self._placeHold
            }
        }
    }
    var _placeHoldText:UILabel?
    var _maxNum:Int = 200
    
    var _barView:UIView?
    //var _inputView:UIInputView
    var _inputText:UITextView?
    var _inputBg:UIView?
    var _setuped:Bool = false
    
    var _tapC:UITapGestureRecognizer?
    
    var _heightOfClosed:CGFloat? = 40
    
    var _btn_send:UIButton?
    
    var _heightOfBar:CGFloat?{
        get{
            return _barView!.frame.height+_keboardFrame!.height
        }
    }
    
    var _keboardFrame:CGRect?
    
    
    func setup(){
        if _setuped{
            return
        }
        _keboardFrame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 0)
        self.backgroundColor = UIColor.clearColor()
        //self.userInteractionEnabled=false
        
        _tapC = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        
        _barView = UIView(frame: CGRect(x: 0, y: self.frame.height-_heightOfClosed!, width: self.frame.width, height: _heightOfClosed!))
        _barView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        
        
        _placeHoldText = UILabel(frame: CGRect(x: 5+5, y: 5, width: self.frame.width-90-10, height: 30))
        _placeHoldText?.font = UIFont.systemFontOfSize(15)
        _placeHoldText?.text=_placeHold
        _placeHoldText?.textColor = UIColor(white: 0.8, alpha: 1)
        _placeHoldText?.backgroundColor = UIColor.clearColor()
        
        
        _inputText = UITextView(frame: CGRect(x: 5, y: 5, width: self.frame.width-90, height: 30))
        _inputText?.delegate = self
        _inputText?.backgroundColor = UIColor.clearColor()
        _inputBg = UIView(frame: CGRect(x: 5, y: 5, width: self.frame.width-90, height: 30))
        _inputBg?.backgroundColor = UIColor.whiteColor()
        _inputBg?.layer.masksToBounds = true
        _inputBg?.layer.cornerRadius = 5
        _inputBg?.layer.borderWidth = 1
        _inputBg?.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        
        _btn_send = UIButton(frame:  CGRect(x: self.frame.width-80, y: 5, width: 70, height: 30))
        _btn_send?.backgroundColor = UIColor(red: 254/255, green: 221/255, blue: 62/255, alpha: 1)
        _btn_send?.layer.cornerRadius = 5
        _btn_send?.layer.masksToBounds = true
        _btn_send?.layer.borderWidth = 1
        _btn_send?.layer.borderColor = UIColor.lightGrayColor().CGColor
        _btn_send?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        _btn_send?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_send?.setTitle("发送", forState: UIControlState.Normal)
        
        
        _barView?.addSubview(_inputBg!)
        _barView?.addSubview(_placeHoldText!)
        _barView?.addSubview(_inputText!)
        
        
        
        self.addSubview(_barView!)
        _barView!.addSubview(_btn_send!)
        
       // _barView?.userInteractionEnabled=true
        
        _setuped = true
        
        
        
        
    }
    //-----改变点击方式
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let _hitView = super.hitTest(point, withEvent: event)
        if _hitView==self{
            _close()
            return nil
        }else{
            return _hitView
        }
    }
    
    func keyboardWillAppear(notification:NSNotification) {
        
        let userInfo = notification.userInfo!
        
        //let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //let animationCurve:UIViewAnimationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSString).
        //let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //println(keyboardScreenBeginFrame)
        //println(keyboardScreenBeginFrame)
        
        _keboardFrame = keyboardScreenEndFrame
        
        _refresshView()
        
    }
        
    func keyboardWillHide() {
       _keboardFrame = CGRect(x: 0,y: self.frame.height,width: self.frame.width,height: 0)
    }
    
    func _refresshView(){
        var _h:CGFloat = _inputText!.contentSize.height
        
        if _h < _heightOfClosed!-10{
            _h = _heightOfClosed!-10
        }
        
        if _h>200{
            _h = 200
        }
        
        UIView.beginAnimations("open", context: nil)
        UIView.setAnimationDuration(0.35)
        _barView?.frame = CGRect(x: 0, y: _keboardFrame!.origin.y-_h-10, width: self.frame.width, height: _h+10)
        //UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        //self.hidden=false
        
        
        _inputText!.frame = CGRect(x: 5, y: 5, width: self.frame.width-90, height: _h)
       
        _inputBg!.frame = CGRect(x: 5, y: 5, width: self.frame.width-90, height: _inputText!.frame.height)
        
        UIView.commitAnimations()

    }
    
    
    override func willMoveToSuperview(newSuperview: UIView?) {
       // print(" i in")
        if newSuperview != nil{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillAppear:"), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide"), name: UIKeyboardWillHideNotification, object: nil)
        }
        
    }
    override func removeFromSuperview() {
        print("i out", terminator: "")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        super.removeFromSuperview()
    }
    
    
    //----文字输入代理
    
    func textViewDidBeginEditing(textView: UITextView) {
                if _inputText?.text == _placeHold{
                    _inputText?.text=""
                    
                }
        //self.view.addGestureRecognizer(_tapRec!)
    }
    
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let _n:Int=_inputText!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        
        if (_n+text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2)>_maxNum{
            return false
        }
        // println(text)
        
        
        return true
    }
    func textViewDidChange(textView: UITextView) {
        
        if _inputText?.text == ""{
            _placeHoldText?.text=_placeHold
        }else{
            _placeHoldText?.text = ""
        }
        
        
        var _n:Int=_inputText!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        if _n>=_maxNum{
            _n=_maxNum
            let _str:NSString=_inputText!.text as NSString
            _inputText!.text=_str.substringToIndex(_maxNum)
        }
        
        _refresshView()
        //_desAlert?.text=String(_n)+"/"+String(_maxNum)
    }
    //----
    
    
    func btnHander(__sender:UIButton){
        
        _delegate?._inputer_send(NSDictionary(objects: [_inputText!.text], forKeys: ["text"]))
        _reset()
    }
    func _reset(){
        _inputText?.text=""
        _close()
    }
    func tapHander(__tap:UITapGestureRecognizer){
        _close()
    }
    
    
    func _close(){
        _inputText?.resignFirstResponder()
        _refresshView()
        
        self.superview!.removeGestureRecognizer(_tapC!)
        
        _delegate?._inputer_closed()
        //self.removeFromSuperview()
        //self.userInteractionEnabled=false
    }
    func _closeStop(){
        print("out", terminator: "")
    }
    
    
    
    
}
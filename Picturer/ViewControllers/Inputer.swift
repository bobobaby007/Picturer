//
//  Inputer.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/23.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol Inputer_delegate:NSObjectProtocol, UITextViewDelegate{
    func _inputer_send(__dict:NSDictionary)
    func _inputer_changed(__dict:NSDictionary)
    func _inputer_closed()
}


class Inputer: UIView {
    
    var _delegate:Inputer_delegate?
    
    var _placeHold:String = "输入文字"
    var _maxNum:Int = 20
    
    var _barView:UIView?
    //var _inputView:UIInputView
    var _inputText:UITextView?
    var _setuped:Bool = false
    
    var _tapC:UITapGestureRecognizer?
    
    var _heightOfClosed:CGFloat? = 40
    
    var _btn_send:UIButton?
    
    var _heightOfBar:CGFloat?{
        get{
            return _barView?.frame.height
        }
    }
    
    func setup(){
        if _setuped{
            return
        }
        
        self.backgroundColor = UIColor.clearColor()
        //self.userInteractionEnabled=false
        
        _tapC = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        
        _barView = UIView(frame: CGRect(x: 0, y: self.frame.height-_heightOfClosed!, width: self.frame.width, height: _heightOfClosed!))
        _barView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        _inputText = UITextView(frame: CGRect(x: 5, y: 5, width: self.frame.width-90, height: 30))
        _inputText?.text = _placeHold
        _inputText?.layer.masksToBounds = true
        _inputText?.layer.cornerRadius = 5
        _inputText?.layer.borderWidth = 1
        _inputText?.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        _btn_send = UIButton(frame:  CGRect(x: self.frame.width-80, y: 5, width: 70, height: 30))
        _btn_send?.backgroundColor = UIColor(red: 254/255, green: 221/255, blue: 62/255, alpha: 1)
        _btn_send?.layer.cornerRadius = 5
        _btn_send?.layer.masksToBounds = true
        _btn_send?.layer.borderWidth = 1
        _btn_send?.layer.borderColor = UIColor.lightGrayColor().CGColor
        _btn_send?.addTarget(self, action: Selector("btnHander:"), forControlEvents: UIControlEvents.TouchUpInside)
        _btn_send?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _btn_send?.setTitle("发送", forState: UIControlState.Normal)
        
        
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
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //let animationCurve:UIViewAnimationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSString).
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //println(keyboardScreenBeginFrame)
        //println(keyboardScreenBeginFrame)
        
        
        _barView?.frame = CGRect(x: 0, y: keyboardScreenBeginFrame.origin.y-_heightOfClosed!, width: self.frame.width, height: _heightOfClosed!)
        UIView.beginAnimations("open", context: nil)
        UIView.setAnimationDuration(animationDuration+0.15)
        _barView?.frame = CGRect(x: 0, y: keyboardScreenEndFrame.origin.y-_heightOfClosed!, width: self.frame.width, height: _heightOfClosed!)
        //UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        //self.hidden=false
       
        UIView.commitAnimations()
    }
        
    func keyboardWillHide() {
        println("Keyboard hidden")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        print(" i in")
        if newSuperview != nil{
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillAppear:"), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide"), name: UIKeyboardWillHideNotification, object: nil)
        }
        
    }
    override func removeFromSuperview() {
        print("i out")
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
        
        if _inputText?.text == _placeHold{
            //_desAlert?.text="0"+"/"+String(_maxNum)
            //return
        }
        if _inputText?.text == ""{
            _inputText?.text=_placeHold
        }
        
        
        var _n:Int=_inputText!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        if _n>=_maxNum{
            _n=_maxNum
            let _str:NSString=_inputText!.text as NSString
            _inputText!.text=_str.substringToIndex(_maxNum)
        }
        //_desAlert?.text=String(_n)+"/"+String(_maxNum)
    }
    //----
    
    
    func btnHander(__sender:UIButton){
        _delegate?._inputer_send(NSDictionary(objects: [_inputText!.text], forKeys: ["text"]))
    }
    
    func tapHander(__tap:UITapGestureRecognizer){
        _close()
    }
    
    func _open(){
        _inputText?.text=_placeHold
        
        
        _inputText?.becomeFirstResponder()
        self.superview!.addGestureRecognizer(_tapC!)
    }
    func _close(){
        _inputText?.resignFirstResponder()
        UIView.setAnimationDidStopSelector(Selector("_closeStop"))
        UIView.beginAnimations("close", context: nil)
        //self.hidden=true
        _barView?.frame = CGRect(x: 0, y: self.frame.height-_heightOfClosed!, width: self.frame.width, height: _heightOfClosed!)
       
        //UIView.setAnimationDidStopSelector(<#selector: Selector#>)
        UIView.commitAnimations()
        
        self.superview!.removeGestureRecognizer(_tapC!)
        
        _delegate?._inputer_closed()
        //self.removeFromSuperview()
        //self.userInteractionEnabled=false
    }
    func _closeStop(){
        print("out")
    }
    
    
    
    
}
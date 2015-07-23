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
    
}


class Inputer: UIView {
    
    var _delegate:Inputer_delegate?
    
    var _barView:UIView?
    //var _inputView:UIInputView
    var _inputText:UITextView?
    var _setuped:Bool = false
    
    var _tapC:UITapGestureRecognizer?
    
    
    
    func setup(){
        if _setuped{
            return
        }
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        _tapC = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        
        _barView = UIView(frame: CGRect(x: 0, y: self.frame.height-40, width: self.frame.width, height: 40))
        _barView?.backgroundColor = UIColor(white: 0.9, alpha: 1)
        _inputText = UITextView(frame: CGRect(x: 5, y: 5, width: self.frame.width-90, height: 30))
        _inputText?.layer.masksToBounds = true
        _inputText?.layer.cornerRadius = 5
        _inputText?.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        _barView?.addSubview(_inputText!)
        
        self.addSubview(_barView!)
        
        
        _setuped = true
        
        
        
        
    }
    
    func keyboardWillAppear(notification:NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //let animationCurve:UIViewAnimationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSString).
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        println(keyboardScreenBeginFrame)
        println(keyboardScreenBeginFrame)
        
        
        _barView?.frame = CGRect(x: 0, y: keyboardScreenBeginFrame.origin.y-40, width: self.frame.width, height: 40)
        UIView.beginAnimations("open", context: nil)
        UIView.setAnimationDuration(animationDuration+0.15)
        
        //UIView.setAnimationCurve(UIViewAnimationCurve.EaseOut)
        //self.hidden=false
        _barView?.frame = CGRect(x: 0, y: keyboardScreenEndFrame.origin.y-40, width: self.frame.width, height: 40)
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
    
    func tapHander(__tap:UITapGestureRecognizer){
        _close()
        
    }
    func _open(){
        _inputText?.text=""
        _inputText?.becomeFirstResponder()
        self.addGestureRecognizer(_tapC!)
    }
    func _close(){
        _inputText?.resignFirstResponder()
        UIView.beginAnimations("close", context: nil)
        //self.hidden=true
        _barView?.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 40)
        UIView.setAnimationDidStopSelector(Selector("_closeStop"))
        //UIView.setAnimationDidStopSelector(<#selector: Selector#>)
        UIView.commitAnimations()
        
        self.removeGestureRecognizer(_tapC!)
        self.removeFromSuperview()
        //self.userInteractionEnabled=false
    }
    func _closeStop(){
        print("out")
        
        
    }
    
    
}
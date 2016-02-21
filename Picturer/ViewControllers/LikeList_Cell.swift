//
//  AlbumListCell.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/18.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

protocol LikeList_Cell_delegate:NSObjectProtocol{
    func _viewUser(__userId:String)
}


class LikeList_Cell :  UITableViewCell,UITextViewDelegate{
    var _defaultWidth:CGFloat?
    var _imageView:PicView?
    var _titleT:UITextView?
    var _desT:UITextView?
    var _timeLable:UILabel?
    var _setuped:Bool=false
    weak var _delegate:LikeList_Cell_delegate?
    override func didMoveToSuperview() {
        _refreshView()
    }
    func _refreshView(){
        
    }
    func setUp(__width:CGFloat){
        if _setuped {
            return
        }
        _defaultWidth=__width
        
        _imageView=PicView(frame: CGRectMake(10, 5, 40, 40))
        _imageView!._imgView!.contentMode=UIViewContentMode.ScaleAspectFill
        _imageView!._imgView!.layer.cornerRadius=20
        _imageView!._imgView!.layer.masksToBounds=true
        self.addSubview(_imageView!)
        
        _titleT=UITextView(frame: CGRectMake(60, 0, _defaultWidth!-26, 25))
        _titleT?.editable=false
        _titleT?.scrollEnabled = false
        self.addSubview(_titleT!)
        
        
        _desT=UITextView(frame: CGRectMake(60, 22, _defaultWidth!-100, 30))
        //_desT?.textColor=UIColor(white: 0.5, alpha: 1)
        _desT?.font=UIFont(name: "Helvetica", size: 12)
        _desT?.selectable=false
        _desT?.editable=false
        _desT?.userInteractionEnabled = false
        self.addSubview(_desT!)
        
        _timeLable=UILabel(frame: CGRectMake(_defaultWidth!-80, 0, 60, 30))
        _timeLable?.textColor=UIColor(white: 0.8, alpha: 1)
        _timeLable?.font=UIFont(name: "Helvetica", size: 15)
        self.addSubview(_timeLable!)
        _setuped=true
    }
    //----赋值
    func _setComment(__dict:NSDictionary){
        //setUp()
        
        _imageView!._setPic(__dict.objectForKey("userImg") as! NSDictionary, __block: { (_dict) -> Void in
            
        })
        _titleT!.attributedText = linkString((__dict.objectForKey("from_userName") as! String) , withURLString: "user:" + (__dict.objectForKey("from_userId") as! String))
        
        _desT?.attributedText = commentString(__dict)
        
        _timeLable!.text = __dict.objectForKey("time") as? String
        
        let _size:CGSize = _desT!.sizeThatFits(CGSize(width: _desT!.frame.width,height: CGFloat.max))
        _desT!.frame = CGRect(x: _desT!.frame.origin.x, y: _desT!.frame.origin.y, width: _desT!.frame.width, height: _size.height)
    }
    
    func commentString(_commentDict:NSDictionary) -> NSAttributedString {
        //let boldFont = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
        //var boldAttr = [NSFontAttributeName: boldFont]
        //let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),
        //   NSBackgroundColorAttributeName : UIColor.whiteColor()]
        let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor()]
        
        let astr:NSMutableAttributedString = NSMutableAttributedString()
        
        
        
        var attrString: NSAttributedString = NSAttributedString()
        
        if _commentDict.objectForKey("to_userName") == nil || _commentDict.objectForKey("to_userName") as! String == "" {
            
        }else{
            
            //attrString = linkString(_commentDict.objectForKey("from_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("from_userId") as! String))
            //var astr:NSMutableAttributedString = NSMutableAttributedString()
            //astr.appendAttributedString(attrString)
            
            attrString = NSAttributedString(string: "回复", attributes:normalAttr)
            astr.appendAttributedString(attrString)
            astr.appendAttributedString(linkString(_commentDict.objectForKey("to_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("to_userId") as! String)))
            attrString = NSAttributedString(string: ": ", attributes:normalAttr)
            astr.appendAttributedString(attrString)
            
        }
        
        // println(attrString)
        attrString = NSAttributedString(string: _commentDict.objectForKey("comment") as! String, attributes:normalAttr)
        astr.appendAttributedString(attrString)
        
        return astr
    }
    func linkString(string:String, withURLString:String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: string )
        // the entire string
        let range:NSRange = NSMakeRange(0, attrString.length)
        attrString.beginEditing()
        attrString.addAttribute(NSLinkAttributeName, value:withURLString, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor.blueColor(), range:range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: range)
        attrString.endEditing()
        return attrString
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let _action:String = URL.scheme
        print(_action)
        switch _action{
        case "user":
            let _str:String = URL.absoluteString
            let _userId:NSString =  (_str as NSString).substringFromIndex(5)
            _delegate!._viewUser(String(_userId))
        case "reply":
            print("hahahah")
        default:
            print("")
        }
        //println(URL.absoluteString)
        //println(URL.scheme)
        //println(URL.path)
        //println("clcik")
        return false
    }
    func _Height()->CGFloat{
        let _size:CGSize = _desT!.sizeThatFits(CGSize(width: _desT!.frame.width,height: CGFloat.max))
        //print(_size)
        return _size.height+50
    }
}

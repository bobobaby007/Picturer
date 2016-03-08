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

protocol CommentList_Cell_delegate:NSObjectProtocol{
    func _viewUser(__userId:String)    
}

class CommentList_Cell :  UITableViewCell,UITextViewDelegate{
    var _userId:String?
    var _defaultWidth:CGFloat?
    var _imageView:PicView?
    var _titleT:UILabel?
    var _desT:UITextView?
    var _timeLable:UILabel?
    var _setuped:Bool=false
    weak var _delegate:CommentList_Cell_delegate?
    var _tapG:UITapGestureRecognizer?
    var _likeIcon:UIImageView?
    var _collectIcon:UIImageView?
    
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
        
        _imageView=PicView(frame: CGRectMake(10, 10, 35, 35))
        _imageView!._imgView!.contentMode=UIViewContentMode.ScaleAspectFill
        _imageView!._imgView!.layer.cornerRadius=35/2
        _imageView!._imgView!.layer.masksToBounds=true
        self.addSubview(_imageView!)
        
        _titleT=UILabel(frame: CGRectMake(55, 8, _defaultWidth!-26, 17))
        _titleT?.font = Config._font_cell_subTitle
        _titleT?.textColor = Config._color_social_blue
        
        self.addSubview(_titleT!)
        
        
        _desT=UITextView(frame: CGRectMake(55, 28, _defaultWidth!-55-25, 0))
        _desT?.textColor=Config._color_social_gray
        _desT?.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        _desT?.textContainer.lineFragmentPadding = 0
        _desT?.font=Config._font_social_cell_name
        _desT?.selectable=false
        _desT?.editable=false
        _desT?.userInteractionEnabled = false
        
        
        _desT?.linkTextAttributes = [NSForegroundColorAttributeName:Config._color_social_blue]
        
        self.addSubview(_desT!)
        
        _timeLable=UILabel()
        _timeLable?.textColor=Config._color_gray_time
        _timeLable?.font=Config._font_social_time
        self.addSubview(_timeLable!)
        
        
        
        _likeIcon = UIImageView(image: UIImage(named: "like.png"))
        _likeIcon?.frame = CGRect(x: 55.5, y: 33.5, width: 12.5, height: 10.5)
        _likeIcon?.hidden = true
        self.addSubview(_likeIcon!)
        
        _collectIcon = UIImageView(image: UIImage(named: "collect.png"))
        _collectIcon?.frame = CGRect(x: 55.5, y: 34, width: 10.5, height: 10.5)
        _collectIcon?.hidden = true
        self.addSubview(_collectIcon!)
        
        _tapG = UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        _imageView!.addGestureRecognizer(_tapG!)
        
        
        //println(_defaultWidth)
        _setuped=true
    }
    
    func _setDict(__dict:NSDictionary){
        //setUp()
        
        _imageView!._setPic(__dict.objectForKey("userImg") as! NSDictionary, __block: { (_dict) -> Void in
            
        })
        //_titleT!.attributedText = CommentList_Cell.linkString((__dict.objectForKey("from_userName") as! String) , withURLString: "user:" + (__dict.objectForKey("from_userId") as! String))
        
        _titleT?.text = (__dict.objectForKey("from_userName") as! String)
        
        _titleT?.sizeToFit()
        
        _timeLable?.frame = CGRect(x:_titleT!.frame.origin.x+_titleT!.frame.width+11,y:14.5,width: 100,height: 9)
        _timeLable?.text = __dict.objectForKey("time") as? String
        
        
        _desT?.attributedText = CommentList_Cell.commentString(__dict)
        let _size:CGSize = _desT!.sizeThatFits(CGSize(width: _desT!.frame.width,height: CGFloat.max))
        _desT!.frame = CGRect(x: _desT!.frame.origin.x, y: _desT!.frame.origin.y, width: _desT!.frame.width, height: _size.height)
        _desT?.hidden=false
        _likeIcon?.hidden=true
        _collectIcon?.hidden=true
        
        self._userId = __dict.objectForKey("from_userId") as? String
        
        
        
    }
    
    static func commentString(_commentDict:NSDictionary) -> NSAttributedString {
        //let boldFont = UIFont.boldSystemFontOfSize(UIFont.systemFontSize())
        //var boldAttr = [NSFontAttributeName: boldFont]
        //let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),
        //   NSBackgroundColorAttributeName : UIColor.whiteColor()]
        let normalAttr = [NSForegroundColorAttributeName : Config._color_social_gray,NSFontAttributeName: Config._font_social_cell_name]
        
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
            attrString = NSAttributedString(string: "：", attributes:normalAttr)
            astr.appendAttributedString(attrString)
            
        }
        
        // println(attrString)
        attrString = NSAttributedString(string: _commentDict.objectForKey("comment") as! String, attributes:normalAttr)
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        astr.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, astr.length))
        
        astr.appendAttributedString(attrString)
        
        return astr
    }
    static func linkString(string:String, withURLString:String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: string )
        // the entire string
        let range:NSRange = NSMakeRange(0, attrString.length)
        attrString.beginEditing()
        attrString.addAttribute(NSFontAttributeName, value:Config._font_social_cell_name, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:Config._color_social_blue, range:range)
        attrString.addAttribute(NSLinkAttributeName, value:withURLString, range:range)
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
            _delegate?._viewUser(String(_userId))
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
    
    
    
    //-----点击侦听
    
    func tapHander(__tap:UITapGestureRecognizer){
        
        switch __tap.view! as UIView{
        case _imageView!:
            _delegate?._viewUser(_userId!)
            return
        default:
            return
        }
    }
    //----返回高度
    static func _getHeihtWidthDict(__dict:NSDictionary,_defaultWidth:CGFloat)->CGFloat{
        var _h:CGFloat = 55
        let _desT=UITextView(frame: CGRectMake(55, 28, _defaultWidth-55-25, 0))
    
        _desT.attributedText = commentString(__dict)
        
        _desT.textColor=Config._color_social_gray
        _desT.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        _desT.textContainer.lineFragmentPadding = 0
        _desT.font=Config._font_social_cell_name
        
        let _size:CGSize = _desT.sizeThatFits(CGSize(width: _desT.frame.width,height: CGFloat.max))
        
        _h = _size.height+36
        
        
        return _h
    }
}

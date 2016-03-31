//
//  PicAlbumMessageItem.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

protocol CollectItem_delegate:NSObjectProtocol{
    func _resized(__indexId:Int,__height:CGFloat)
    func _moreComment(__indexId:Int)
    func _viewUser(__userId:String)
    func _viewAlbum(__albumIndex:Int)
    func _moreLike(__indexId:Int)
    func _buttonAction(__action:String,__dict:NSDictionary)
}


class CollectItem:  UITableViewCell,UITextViewDelegate{
    
    let _gapForPic:CGFloat = 2
    
    var _bottomOfPic:CGFloat = 0 //---到图片底部的位置
    
    let _gap:CGFloat = 15
    var _indexId:Int = 0
    var _indexString:String?
    
    var _user:NSDictionary?
    var _userId:String?
    var _setuped:Bool = false
    var _picV:PicView?
    
    
    var _userImg:PicView?
    var _userBtn:UIButton?
    
    var _updateTime_label:UILabel?
    var _albumTitle_labelV:UIView?
    var _albumTitle_label:UITextView?
    var _description:UITextView?
    
    
    var _btn_like:UIButton = UIButton()
    var _btn_comment:UIButton = UIButton()
    var _btn_share:UIButton = UIButton()
    var _btn_collect:UIButton?
    
    weak var _delegate:CollectItem_delegate?
    
    var _cellH:CGFloat?
    
    var _defaultSize:CGSize?
    
    
    var _attributeStr:NSMutableAttributedString?
    
    
    var _tapC:UITapGestureRecognizer?
    
    var _buttonTap:UITapGestureRecognizer?
    
    
    var _bgV:UIView?
    var _container:UIView?
    
    
    var _pics:NSArray?
    var _album:NSDictionary?
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        //setup()
    }
    override func didMoveToSuperview() {
        // println(self.frame.width)
        //setup()
    }
    
    
    func setup(__size:CGSize){
        if _setuped{
            return
        }
        _defaultSize=__size
        self.backgroundColor = UIColor.clearColor()
        
        _tapC = UITapGestureRecognizer(target: self, action: Selector("_tapHander:"))
        _buttonTap = UITapGestureRecognizer(target: self, action: #selector(CollectItem._buttonTapHander(_:)))
        //println(_defaultSize!.width)
        
        _userImg = PicView(frame: CGRect(x: 11+_gap, y: 5+_gap, width: 35, height: 35))
        _userImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _userImg?.maximumZoomScale = 1
        _userImg?.minimumZoomScale = 1
        _userImg?.layer.masksToBounds=true
        _userImg?.layer.cornerRadius = 35/2
        
        _userImg?.addGestureRecognizer(_buttonTap!)
        
        _btn_collect = UIButton(frame: CGRect(x:_defaultSize!.width -  _gap - _gap - 22, y: 13+_gap, width: 22, height: 20))
        _btn_collect?.setImage(UIImage(named: "collect_on"), forState: UIControlState.Normal)
        
        
        
        
        
        
        
        _userBtn = UIButton(frame: CGRect(x: 55+_gap, y: 5+_gap, width: _defaultSize!.width -  2*_gap - 2*55, height: 12))
        _userBtn?.contentEdgeInsets = UIEdgeInsetsZero
        
        _userBtn?.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
        _userBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        _userBtn?.titleLabel?.font = Config._font_social_cell_name
        _userBtn?.setTitleColor(Config._color_social_blue, forState: UIControlState.Normal)
        
        

        
        
        
        _updateTime_label = UILabel(frame: CGRect(x: 55+_gap, y: 26+_gap, width: _defaultSize!.width -  2*_gap - 2*55, height: 12))
        _updateTime_label?.textColor = Config._color_gray_time
        //_updateTime_label?.textAlignment = NSTextAlignment.Right
        _updateTime_label?.font = Config._font_social_time
   
        _picV = PicView(frame: CGRect(x: _gap, y: _gap+45, width: _defaultSize!.width-2*_gap-2, height:_defaultSize!.width-2*_gap-2))
        _picV?._setImage("noPic.png")
        _picV?.scrollEnabled=false
        _picV?.maximumZoomScale = 1
        _picV?.minimumZoomScale = 1
        _picV?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _picV?.layer.masksToBounds = true
        
        _bottomOfPic = _picV!.frame.origin.y + _picV!.frame.height
        
        let _tapPic:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CollectItem._buttonTapHander(_:)))
        _picV?.addGestureRecognizer(_tapPic)
        
        _albumTitle_labelV = UIView(frame: CGRect(x: _gap-1, y: _bottomOfPic-30, width: _defaultSize!.width-2*_gap-2, height: 30))
        
        _albumTitle_labelV?.backgroundColor = UIColor(white: 0, alpha: 0.8)
        _albumTitle_labelV?.userInteractionEnabled=false
        _albumTitle_label = UITextView(frame: CGRect(x: 15+_gap, y: 8, width: _defaultSize!.width-2*_gap, height: 12))
        _albumTitle_label?.pagingEnabled=false
        _albumTitle_label?.textContainer.lineFragmentPadding=0
        _albumTitle_label?.textContainerInset = UIEdgeInsetsZero
        _albumTitle_label?.backgroundColor = UIColor.clearColor()
        _albumTitle_label?.editable=false
        _albumTitle_label?.selectable=false
        _albumTitle_label?.userInteractionEnabled=false
        
        
        _description = UITextView()
        _description?.frame = CGRect(x: _gap, y: _bottomOfPic+_gap, width: _defaultSize!.width-_gap*2, height: 40)
        
        //_description?.backgroundColor = Config._color_social_blue
        
        _description?.textContainerInset =  UIEdgeInsetsMake(-3, 0, 0, 0)  //{{-10,-5},{0,0}} // UIEdgeInsetsZero
        
        _description?.textContainer.lineFragmentPadding = 0
        _description?.textAlignment = NSTextAlignment.Left
        //_description?.backgroundColor = UIColor.grayColor()
        _description?.editable=false
        _description?.selectable=false
        _description?.font = Config._font_social_album_description
        _description?.textColor = Config._color_social_gray
        
        
        _bgV = UIView()
        _bgV?.layer.cornerRadius = 5
        _bgV?.layer.borderColor = Config._color_social_gray_border.CGColor
        _bgV?.layer.borderWidth=0.5
        _bgV?.backgroundColor=UIColor.whiteColor()
        
        self.addSubview(_bgV!)
        
        self.addSubview(_picV!)
        
        self.addSubview(_userImg!)
        self.addSubview(_userBtn!)
        self.addSubview(_updateTime_label!)
        self.addSubview(_albumTitle_labelV!)
        self.addSubview(_description!)
        self.addSubview(_btn_collect!)
        
        
        
        
//        self.addSubview(_toolsPanel!)
//        self.addSubview(_commentsPanel!)
        _albumTitle_labelV?.addSubview(_albumTitle_label!)
        _setuped=true
    }
    
    
    
    

func _getPics(){
    Social_Main._getPicsListAtAlbumId(self._album!.objectForKey("_id") as? String, __block: { (array) -> Void in
        self._pics = array
        dispatch_async(dispatch_get_main_queue(), {[weak self] () -> Void in
            self?._getPicsOk()
        })
    })
    
}
    func _getPicsOk(){
        _setAlbumTitle(_album!.objectForKey("title") as! String, __num: _pics!.count)
        
        if let _cover = _album!.objectForKey("cover") as? NSDictionary{
            _setPic(_cover)
        }else{
            let _pic:NSDictionary = _pics!.objectAtIndex(0) as! NSDictionary
            _setPic(_pic)
        }
        
    }
    //-------------------------调整布局-----------------
    func _refreshView(){
        var _desH:CGFloat = 0
        if _description!.text == ""{
            
        }else{
            let size:CGSize = _description!.sizeThatFits(CGSize(width: _defaultSize!.width-_gap*2, height: CGFloat.max))
            _desH = size.height
        }
        
        //_desH = 100
        
        _description?.frame = CGRect(x: _gap+_gap, y: _bottomOfPic+_gap, width: _defaultSize!.width-_gap*2-_gap*2, height: _desH)
        
        _bgV!.frame = CGRect(x: _gap, y: _gap, width: _picV!.frame.width, height: _description!.frame.origin.y + _description!.frame.height)
        
        _delegate?._resized(_indexId, __height:_bgV!.frame.height+_gap)
    }
    ///-------------------评论-----------------------------
    func commentString(_commentDict:NSDictionary) -> NSAttributedString {
       // let boldFont = UIFont.boldSystemFontOfSize(14)
        
       // var boldAttr = [NSFontAttributeName: boldFont]
        //let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),
        //   NSBackgroundColorAttributeName : UIColor.whiteColor()]
        let normalAttr = [NSForegroundColorAttributeName : UIColor.blackColor(),NSFontAttributeName: UIFont.systemFontOfSize(14)]
        
        var attrString: NSAttributedString = linkString(_commentDict.objectForKey("from_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("from_userId") as! String))
        
        let astr:NSMutableAttributedString = NSMutableAttributedString()
        astr.appendAttributedString(attrString)
        
        if _commentDict.objectForKey("to_userName") == nil || _commentDict.objectForKey("to_userName") as! String == "" {
            
        }else{
            attrString = NSAttributedString(string: "回复", attributes:normalAttr)
            astr.appendAttributedString(attrString)
            astr.appendAttributedString(linkString(_commentDict.objectForKey("to_userName") as! String,withURLString: "user:"+(_commentDict.objectForKey("to_userId") as! String)))
        }
        attrString = NSAttributedString(string: ": ", attributes:normalAttr)
        astr.appendAttributedString(attrString)
        attrString = NSAttributedString(string: _commentDict.objectForKey("comment") as! String, attributes:normalAttr)
        astr.appendAttributedString(attrString)
        return astr
    }
    func linkString(string:String, withURLString:String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: string )
        // the entire string
        let range:NSRange = NSMakeRange(0, attrString.length)
        attrString.beginEditing()
        
        attrString.addAttribute(NSFontAttributeName, value:UIFont.systemFontOfSize(14, weight: 0.1), range:range)
        
        attrString.addAttribute(NSLinkAttributeName, value:withURLString, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor(red: 44/255, green: 61/255, blue: 89/255, alpha: 1), range:range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: range)
        attrString.endEditing()
        return attrString
    }
    
    //-----文字链接代理
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        let _action:String = URL.scheme
        print(_action)
        switch _action{
        case "user":
            let _str:String = URL.absoluteString
            let _userId:NSString =  (_str as NSString).substringFromIndex(5)
            _delegate?._viewUser(_userId as String)
        case "moreComment":
            //println("hahahah")
            _delegate?._moreComment(_indexId)
        case "moreLike":
            _delegate?._moreLike(_indexId)
        default:
            print("")
        }
        //println(URL.absoluteString)
        //println(URL.scheme)
        //println(URL.path)
        //println("clcik")
        return false
    }
    
    //--------------------------------------------------------
    
    
    
    
    
    func _buttonTapHander(__tap:UITapGestureRecognizer){
        switch __tap.view!{
        case _userImg!:
            _delegate?._viewUser(_userId!)
            return
        case _picV!:
            _delegate?._viewAlbum(_indexId)
            
        default:
            return
        }
    }
    override func removeFromSuperview() {
        //print("out")
        self.superview?.removeGestureRecognizer(_tapC!)
    }
    //-------点赞人
    func _setLikes(__likes:NSArray,__allNum:Int){
        var _attrStr:NSMutableAttributedString = NSMutableAttributedString(string: "")
        if __allNum > 10{
            _attrStr = NSMutableAttributedString(attributedString: linkString(String(__allNum)+"个赞", withURLString:"moreLike:"))
        }else{
            var _lineLength:Int=0
            let _maxNum:Int = Int(_defaultSize!.width/5)
            //println(_maxNum)
            
            for var i:Int = 0; i < __likes.count ; i += 1{
                if i>0 {
                    _attrStr.appendAttributedString(NSAttributedString(string: ", "))
                }
                
                let _likeDict = __likes.objectAtIndex(i) as! NSDictionary
                
                let _addingStr:String = _likeDict.objectForKey("userName") as! String
                
                let _addingLength:Int = _addingStr.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)
                
                if (_addingLength+_lineLength)>_maxNum{
                    //_attrStr.appendAttributedString(NSMutableAttributedString(string: "\n"))
                    _lineLength = _addingLength
                }else{
                    _lineLength = _lineLength + _addingLength
                }
                
                let attrString: NSAttributedString = linkString(_addingStr,withURLString: "user:"+(_likeDict.objectForKey("userId") as! String))
                _attrStr.appendAttributedString(attrString)
            }
            
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        // paragraphStyle.headIndent = 50
        paragraphStyle.firstLineHeadIndent = 20
        _attrStr.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, _attrStr.length))
       
        //_likeTextView?.selectable=false
        //_likeTextView?.bounces=false
        //_likeTextView?.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    }
    
    //-----－－－－－－－－－－－按钮侦听
    
    
    func buttonAction(__button:UIButton){
        switch __button{
        case _btn_like:
            _delegate?._buttonAction("like", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_comment:
            _delegate?._buttonAction("comment", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_share:
            _delegate?._buttonAction("share", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        case _btn_collect!:
            _delegate?._buttonAction("collect", __dict: NSDictionary(objects: [_indexId], forKeys: ["indexId"]))
        default:
            break
        }
    }
    //------------------
    
    
    
    func _setDescription(__str:String){
        //print("描述：",__str)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 1
        let attributes = [NSParagraphStyleAttributeName : style,NSFontAttributeName:Config._font_social_album_description,NSForegroundColorAttributeName:Config._color_social_gray]
        //_description?.font = Config._font_social_album_description
        //_description?.textColor = Config._color_social_gray
        _description?.attributedText = NSAttributedString(string: __str, attributes:attributes)
    }
    func _setAlbumTitle(__str:String,__num:Int){
        var _str:String
        if __str==""{
            //_albumTitle_label?.hidden=true
            //_albumTitle_labelV?.hidden=true
            _str="未命名图册"
        }else{
            _str=__str
            
        }
        
        let attrString = NSMutableAttributedString(string: _str )
        // the entire string
        let range:NSRange = NSMakeRange(0, attrString.length)
        attrString.beginEditing()
        
        attrString.addAttribute(NSFontAttributeName, value:Config._font_cell_title, range:range)
        attrString.addAttribute(NSForegroundColorAttributeName, value:UIColor.whiteColor(), range:range)
        attrString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: range)
        attrString.endEditing()
        
        let _numString = NSMutableAttributedString(string: "   "+String(__num)+"张")
        let _numRange = NSMakeRange(0,_numString.length)
        _numString.addAttribute(NSFontAttributeName, value: Config._font_social_album_description, range: _numRange)
        _numString.addAttribute(NSForegroundColorAttributeName, value: Config._color_gray_description, range: _numRange)
        
        attrString.appendAttributedString(_numString)
        
        _albumTitle_label?.attributedText = attrString
        
        _albumTitle_label?.hidden=false
        _albumTitle_labelV?.hidden=false
        
        let _size:CGSize = _albumTitle_label!.sizeThatFits(CGSize(width: _defaultSize!.width-2*_gap, height: CGFloat.max))
        var _lineNum:CGFloat = 1
        if _size.height>24{
            _lineNum = 2
        }
        
        _albumTitle_labelV?.frame = CGRect(x: _gap, y: _bottomOfPic-30*_lineNum, width: _defaultSize!.width-2*_gap-3, height: 30*_lineNum)
        _albumTitle_label?.frame = CGRect(x: 15, y: (_albumTitle_labelV!.frame.height-_size.height)/2, width: _size.width, height: _size.height)
        
        
    }
    func _setUserName(__str:String){
        _userBtn?.setTitle(__str, forState: UIControlState.Normal)
    }
    func _setUpdateTime(__str:String){
        _updateTime_label?.text=__str
    }
    func _setUserImge(__pic:NSDictionary){
        _userImg?._setPic(__pic, __block: { (__dict) -> Void in
           // self._refreshView()
        })
    }
    
    func _setPic(__pic:NSDictionary){
        if let _url = __pic.objectForKey("thumbnail") as? String{
            _picV!._setPic(NSDictionary(objects:[MainInterface._imageUrl(_url),"file"], forKeys: ["url","type"]), __block:{[weak self] _ in
                //                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //                    self?._refreshView()
                //                })
                })
            return
        }else{
            _picV!._setPic(__pic, __block:{[weak self] _ in
                //                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //                    self?._refreshView()
                //                })
                })
        }
    }
    
    func _setPics(__pics:NSArray){
        
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // println("ww")
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





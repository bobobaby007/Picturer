//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

protocol Manage_newDelegate:NSObjectProtocol{
    func canceld()
    func saved(dict:NSDictionary)
}


class Manage_new: UIViewController, ImagePickerDeletegate, UICollectionViewDelegate, UICollectionViewDataSource,UITextViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,Setting_rangeDelegate,Setting_powerDelegate,Setting_replyDelegate,Setting_sampleDelegate,Setting_tagsDelegate,Manage_pic_delegate{
    let _gap:CGFloat=15
    let _barH:CGFloat = 64
    let _space:CGFloat=5
    let _titleViewH:CGFloat=45
    let _desInputViewH:CGFloat=135
    let _tableViewCellH:CGFloat=45
    var _setuped:Bool=false
    let _maxNum:Int=140
    let _buttonH:CGFloat=135
    
    let _titlePlaceHold:String="图册标题"
    var _desPlaceHoldLabel:UILabel?
    let _desPlaceHold:String="图册描述"
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    
    var _tableView:UITableView?
    
    
    var _line_imageBox_b:UIView? = UIView()
    var _line_titleView_t:UIView? = UIView()
    var _line_titleView_b:UIView? = UIView()
    var _line_desView_t:UIView? = UIView()
    var _line_desView_b:UIView? = UIView()
    var _line_tableView_t:UIView? = UIView()
    
    
    var _scrollView:UIScrollView?
    var _imagesBox:UIView?
    var _addButton:UIButton?
    var _imagesCollection:UICollectionView?
    var _imagesArray:NSMutableArray!=[]
    var _collectionLayout:UICollectionViewFlowLayout?
    
    var _titleView:UIView?
    var _titleInput:UITextField?
    
    var _desView:UIView?
    var _desInput:UITextView?
    var _desAlert:UILabel?
    
    var _delegate:Manage_newDelegate?
    
    var _textsIsEditing:Bool=false
    var _tapRec:UITapGestureRecognizer?
    
    var _settings:NSMutableArray=[["title":"标签","des":""],["title":"图片显示顺序","des":"按创建时间倒序排列"],["title":"私密性","des":"所有人"],["title":"回复权限","des":"允许回复"]]
    
    var _savingDict:NSMutableDictionary?

    
    //
    var _Action_Type:String="new_album"
    
    var _albumIndex:Int?
    var _album:NSMutableDictionary?
    
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        setup()
        refreshView()
    }
    func setup(){
        if _setuped{
            return
        }
        
        _collectionLayout=UICollectionViewFlowLayout()
       _imagesCollection=UICollectionView(frame: CGRect(x: _gap, y: 200, width: self.view.frame.width-2*_gap, height: 362), collectionViewLayout: _collectionLayout!)
        _imagesCollection?.backgroundColor=UIColor.clearColor()
        _imagesCollection!.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
        _imagesCollection!.userInteractionEnabled=true
        _imagesCollection?.delegate=self
        _imagesCollection?.dataSource=self
        _imagesCollection?.scrollEnabled=false
        
        _scrollView=UIScrollView()
        _scrollView?.bounces=false
        
        //_scrollView?.scrollEnabled=true
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=UIColor(white:0.1, alpha: 0.98)
        _btn_cancel=UIButton(frame:CGRect(x: _gap-3, y: 20, width: 40, height: _barH-20))
        _btn_cancel?.titleLabel?.textAlignment = NSTextAlignment.Left
        _btn_cancel?.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_save=UIButton(frame:CGRect(x: self.view.frame.width-40-_gap+3, y: 20, width: 40, height: _barH-20))
        _btn_save?.titleLabel?.textAlignment = NSTextAlignment.Right
        _btn_save?.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        
        _btn_save?.setTitle("保存", forState: UIControlState.Normal)
        _btn_save?.setTitleColor(UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1), forState: UIControlState.Normal)
        _btn_save?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
       
        _titleInput=UITextField(frame: CGRect(x: _gap, y: 0, width: self.view.frame.width, height: _titleViewH))
        _titleInput?.placeholder=_titlePlaceHold
        _titleInput?.delegate=self
        _titleInput?.font = UIFont.systemFontOfSize(16)
        
        _titleView = UIView()
        
        _titleView?.backgroundColor=UIColor.whiteColor()
       
        
        _titleView?.addSubview(_titleInput!)
        
        
        
        _desView=UIView()
        
        _desPlaceHoldLabel = UILabel(frame: CGRect(x: _gap+2, y: _gap+1, width: self.view.frame.width-2*_gap, height: 15))
        _desPlaceHoldLabel?.text = _desPlaceHold
        _desPlaceHoldLabel?.textColor = UIColor(white: 0.75, alpha: 1)
        _desPlaceHoldLabel?.font=UIFont.systemFontOfSize(16)
        
        _desView?.backgroundColor=UIColor.whiteColor()
        
        _desInput=UITextView(frame: CGRect(x: _gap, y: 6, width: self.view.frame.width-2*_gap, height: _desInputViewH-20))
        //_desInput?.text=_desPlaceHold
        _desInput?.backgroundColor = UIColor.clearColor()
        _desInput?.font=UIFont.systemFontOfSize(16)
        //_desInput?.keyboardAppearance=UIKeyboardAppearance.Dark
        //_desInput?.returnKeyType=UIReturnKeyType.Done
        _desInput?.delegate=self
        
        
        _desAlert=UILabel(frame:CGRect(x: _gap, y: _desInputViewH-19, width: self.view.frame.width-2*_gap, height: 12) )
        _desAlert?.text=String(0)+"/"+String(_maxNum)
        _desAlert?.font=UIFont(name: "Helvetica", size: 14)
        _desAlert?.textColor=UIColor(white: 0.75, alpha: 1)
        _desAlert?.textAlignment=NSTextAlignment.Right
        
        _desView?.addSubview(_desPlaceHoldLabel!)
        _desView?.addSubview(_desInput!)
        _desView?.addSubview(_desAlert!)
        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "table_cell")
        _tableView?.scrollEnabled=false
        //_tableView?.userInteractionEnabled=true
        
        _imagesBox=UIView()
        _imagesBox?.backgroundColor=UIColor.whiteColor()
        _addButton=UIButton()
        _addButton?.backgroundColor=UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)
        _addButton?.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        _addButton?.contentMode = UIViewContentMode.ScaleAspectFill
        _addButton?.setImage(UIImage(named: "addIcon.png"), forState: UIControlState.Normal)
        
       
        _imagesBox?.addSubview(_addButton!)
        _imagesBox?.addSubview(_imagesCollection!)
        _scrollView?.addSubview(_imagesBox!)
        _scrollView?.addSubview(_tableView!)
        _scrollView?.addSubview(_titleView!)
        _scrollView?.addSubview(_desView!)
        
        _scrollView?.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        _scrollView?.delegate=self
        _scrollView?.bounces=true
        _scrollView?.clipsToBounds=false
        _tapRec=UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        
        
        self.view.addSubview(_scrollView!)
        self.view.addSubview(_topBar!)
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_save!)
        
       
        
        if (_albumIndex != nil){
            _album = NSMutableDictionary(dictionary: MainAction._getAlbumAtIndex(_albumIndex!)!)
            //----图片单独提取，异步于相册其他信息
            _imagesArray = NSMutableArray(array: MainAction._getImagesOfAlbumIndex(_albumIndex!)!)
        }else{
            _album = NSMutableDictionary()
            MainAction._setDefault(_album!)
                        
        }
        
        _titleInput?.text=_album!.objectForKey("title") as! String
        
        if _album!.objectForKey("description") != nil{
            _desInput?.text=_album!.objectForKey("description") as! String
        }
        
        
        
        _line_imageBox_b?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _line_titleView_t?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _line_titleView_b?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _line_desView_t?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _line_desView_b?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _line_tableView_t?.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        
        _scrollView?.addSubview(_line_imageBox_b!)
        _scrollView?.addSubview(_line_titleView_t!)
        _scrollView?.addSubview(_line_titleView_b!)
        _scrollView?.addSubview(_line_desView_t!)
        _scrollView?.addSubview(_line_desView_b!)
        _scrollView?.addSubview(_line_tableView_t!)
        
        _setuped=true
    }
    
    
    //设置栏代理
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        var cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "table_cell")
    
        cell.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        cell.separatorInset=UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins=false
        cell.layoutMargins = UIEdgeInsetsZero
        
        cell.textLabel?.font = UIFont.systemFontOfSize(16)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(15)
        switch indexPath.row{
        case 0:
            cell.textLabel?.text="标签"
            //println(_album!.objectForKey("tags"))
            let  _array:NSArray = _album!.objectForKey("tags") as! NSArray
            var _str:String = ""
            for var i:Int = 0; i<_array.count;++i{
                if i==0{
                    _str = (_array.objectAtIndex(i) as! String)
                }else{
                    _str = _str+","+(_array.objectAtIndex(i) as! String)
                }
                
            }
            
            cell.detailTextLabel?.text=_str
        case 1:
            cell.textLabel?.text="图片显示顺序"
            
            switch _album!.objectForKey("range") as! Int{
            case  0:
                cell.detailTextLabel?.text="按上传时间顺序排列"
            case 1:
                cell.detailTextLabel?.text="按上传时间倒序排列"
            default:
                println()
            }
            
        case 2:
            cell.textLabel?.text="私密性"
            switch _album!.objectForKey("powerType") as! Int{
            case  0:
                cell.detailTextLabel?.text="所有人可见"
            case 1:
                cell.detailTextLabel?.text="仅自己可见"
            case 2:
                cell.detailTextLabel?.text="所有朋友可见"
            case 3:
                cell.detailTextLabel?.text="选中朋友可见"
            case 4:
                cell.detailTextLabel?.text="选中朋友不可见"
            default:
                println()
            }
        case 3:
            cell.textLabel?.text="评论权限"
            
            switch _album!.objectForKey("reply") as! Int{
            case  0:
                cell.detailTextLabel?.text="允许评论"
            case 1:
                cell.detailTextLabel?.text="不允许评论"
            default:
                println()
            }

        default:
            println("")
        }
        
//        var _view:UIView=UIView()
//        _view.backgroundColor=UIColor.whiteColor()
//        cell.selectedBackgroundView=_view
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return _tableViewCellH
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row{
        case 0:
            let _controller:Setting_tags=Setting_tags()
            _controller._delegate=self
            _controller._tags = NSMutableArray(array: _album?.objectForKey("tags") as! NSArray)
            self.navigationController?.pushViewController(_controller, animated: true)
        case 1:
            let _controller:Setting_range=Setting_range()
            _controller._delegate=self
            _controller._selectedId = _album?.objectForKey("range") as! Int
            self.navigationController?.pushViewController(_controller, animated: true)
        case 2:
            let _controller:Setting_power=Setting_power()
            _controller._delegate=self
            _controller._selectedId = _album?.objectForKey("powerType") as! Int
            self.navigationController?.pushViewController(_controller, animated: true)
        case 3:
            let _controller:Setting_reply=Setting_reply()
            _controller._delegate=self
            _controller._selectedId = _album?.objectForKey("reply") as! Int
            self.navigationController?.pushViewController(_controller, animated: true)
        default:
            println("")
        }
    }
   
    //----设置代理
    func saved(dict: NSDictionary) {
        switch dict.objectForKey("Action_Type") as! String{
        case "tags":
            _album?.setObject(dict.objectForKey("tags")!, forKey:"tags")
        case "range":
            _album?.setObject(dict.objectForKey("selectedId")!, forKey:"range")
            _imagesCollection?.reloadData()
            
        case "reply":
            _album?.setObject(dict.objectForKey("selectedId")!, forKey:"reply")
        case "power":
            _album?.setObject(dict.objectForKey("selectedId")!, forKey:"powerType")
        default:
            println("")
        }
        _tableView?.reloadData()
    }
    func canceld() {
        _tableView?.reloadData()
    }
    //---图片单张查看代理
    
    func _setCover(picIndex: Int) {
        _album?.setObject(_imagesArray.objectAtIndex(picIndex), forKey: "cover")
    }
    func _deletePic(picIndex: Int) {
        _imagesArray.removeObjectAtIndex(picIndex)
        
    }
    func canceled(){
        _tableView?.reloadData()
    }
    //-----图片代理
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _imagesArray.count
        
        
        //return 30
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var _pic:Manage_pic? = Manage_pic()
        //let storyboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
        //_pic=storyboard.instantiateViewControllerWithIdentifier("Manage_pic") as? Manage_pic
        _pic?._delegate=self
        _pic?._range = _album?.objectForKey("range") as! Int
        _pic?._showIndexAtPics(indexPath.item, __array: _imagesArray)
        self.navigationController?.pushViewController(_pic!, animated: true)
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identify:String = "PicsShowCell"
        let cell = self._imagesCollection?.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! PicsShowCell
        
        
        
        //let _al:ALAsset=_imagesArray.objectAtIndex(indexPath.item) as! ALAsset
        
        
        let _pic:NSDictionary
        
        
        if _album?.objectForKey("range")! as! Int == 1{
            
            _pic = _imagesArray.objectAtIndex(_imagesArray.count - indexPath.item - 1) as! NSDictionary
        }else{
            _pic = _imagesArray.objectAtIndex(indexPath.item) as! NSDictionary
        }
        cell._setPic(_pic)
        
        
        
        
        return cell
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        _titleInput?.resignFirstResponder()
        _desInput?.resignFirstResponder()
        
        if _desInput?.text == ""{
            //_desInput?.text=_desPlaceHold
            _desPlaceHoldLabel?.hidden=false
        }
        _scrollView?.removeGestureRecognizer(_tapRec!)
    }
    
    
    
    //----文字输入代理
    func textFieldDidBeginEditing(textField: UITextField) {
        _scrollView?.addGestureRecognizer(_tapRec!)
    }
    func textViewDidEndEditing(textView: UITextView) {
        _titleInput?.resignFirstResponder()
        _desInput?.resignFirstResponder()
        
        if _desInput?.text == ""{
            //_desInput?.text=_desPlaceHold
            _desPlaceHoldLabel?.hidden=false
        }
        _scrollView?.removeGestureRecognizer(_tapRec!)
    }
    func textViewDidBeginEditing(textView: UITextView) {
        
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        let _addH:CGFloat=self.view.frame.height-216-_barH-20-_desInputViewH
        var _offset:CGFloat = _desView!.frame.origin.y
        
        _offset=_offset-_addH
        //_scrollView?.frame=CGRect(x: 0, y: CGFloat(_offset!), width: self.view.frame.width, height: self.view.frame.height-_barH)
        _scrollView?.contentOffset=CGPoint(x: 0, y: _offset)
        UIView.commitAnimations()
        
        _scrollView?.addGestureRecognizer(_tapRec!)
        //return true
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
        
        if _desInput?.text == ""{
            _desPlaceHoldLabel?.hidden=false
        }else{
            _desPlaceHoldLabel?.hidden = true
        }
        
        if _desInput?.text == _desPlaceHold{
            _desAlert?.text="0"+"/"+String(_maxNum)
            return
        }
        
        var _n:Int=_desInput!.text.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)/2
        if _n>=_maxNum{
            _n=_maxNum
            let _str:NSString=_desInput!.text as NSString
            _desInput!.text=_str.substringToIndex(_maxNum)
            
        }
         _desAlert?.text=String(_n)+"/"+String(_maxNum)
    }
    
    //-----选择相册代理
    func imagePickerDidSelected(images: NSArray) {
        _imagesArray.addObjectsFromArray(images as [AnyObject])
        //_imagesArray=NSMutableArray(array: images)
        _imagesCollection?.reloadData()
        refreshView()
        
        //println(images)
    }
    
    
    
    func refreshView(){
        
        
        let _imagesW:CGFloat=(self.view.frame.width-2*_gap-3*_space)/4
        let _imagesH:CGFloat=ceil(CGFloat(_imagesArray.count)/4)*(_imagesW+_space)
        
        _collectionLayout?.minimumInteritemSpacing=_space
        _collectionLayout?.minimumLineSpacing=_space
        _collectionLayout!.itemSize=CGSize(width: _imagesW, height: _imagesW)
        _imagesCollection?.frame=CGRect(x: _gap, y: _buttonH+2*_gap, width: self.view.frame.width-2*_gap, height: _imagesH)
       
       
        
        var _imageBoxH:CGFloat!
        if _imagesArray.count<1{
            _imageBoxH=_imagesH+_buttonH+2*_gap
        }else{
            _imageBoxH=_imagesH+_buttonH+3*_gap-_space
        }
        
        
        
        _addButton?.frame=CGRect(x: _gap, y: _gap, width: self.view.frame.width-2*_gap, height: _buttonH)
        
        _imagesBox?.frame=CGRect(x: 0, y: 0, width: self.view.frame.width, height:_imageBoxH)
        
        _titleView?.frame = CGRect(x: 0, y: _imageBoxH+_gap, width: self.view.frame.width, height: _titleViewH)
        _desView?.frame = CGRect(x: 0, y: _imageBoxH+2*_gap+_titleViewH, width: self.view.frame.width, height: _desInputViewH)
        
        _tableView?.frame = CGRect(x: 0, y: _imageBoxH+3*_gap+_titleViewH+_desInputViewH, width: self.view.frame.width, height: _tableViewCellH*4)
        
        
        let _scrollH=_imageBoxH+3*_gap+_titleViewH+_desInputViewH+_tableViewCellH*4+_tableViewCellH/2
        _scrollView?.frame=CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH)
        _scrollView?.contentSize=CGSize(width: self.view.frame.width, height: _scrollH)
        
        
        _line_imageBox_b?.frame = CGRect(x: 0, y: _imageBoxH, width: self.view.frame.width, height: 0.5)
        _line_titleView_t?.frame = CGRect(x: 0, y: _imageBoxH+_gap, width: self.view.frame.width, height: 0.5)
        _line_titleView_b?.frame = CGRect(x: 0, y: _imageBoxH+_gap+_titleViewH, width: self.view.frame.width, height: 0.5)
        _line_desView_t?.frame = CGRect(x: 0, y: _imageBoxH+2*_gap+_titleViewH, width: self.view.frame.width, height: 0.5)
        _line_desView_b?.frame = CGRect(x: 0, y: _imageBoxH+2*_gap+_titleViewH+_desInputViewH, width: self.view.frame.width, height: 0.5)
        _line_tableView_t?.frame = CGRect(x: 0, y: _imageBoxH+3*_gap+_titleViewH+_desInputViewH, width: self.view.frame.width, height: 0.5)
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            _delegate?.canceld()
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_save!:
            if treckDict(){
               _delegate?.saved(_savingDict!)
                self.navigationController?.popViewControllerAnimated(true)
            }
        case _addButton!:
            let storyboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
            var _controller:Manage_imagePicker?
            _controller=storyboard.instantiateViewControllerWithIdentifier("Manage_imagePicker") as? Manage_imagePicker
            _controller?._delegate=self
            //self.view.window!.rootViewController!.presentViewController(_controller!, animated: true, completion: nil)
            self.navigationController?.pushViewController(_controller!, animated: true)
        default:
            println(sender)
        }
        
    }
    
    func treckDict()->Bool{
        _savingDict=NSMutableDictionary(dictionary: _album!)
        
        if (_albumIndex != nil){
            _savingDict?.setObject(_albumIndex!, forKey: "albumIndex")
            _savingDict?.setObject("edite_album", forKey: "Action_Type")
        }else{
            _savingDict?.setObject("new_album", forKey: "Action_Type")
        }
        
        if _album?.objectForKey("cover") == nil && _imagesArray.count>0{
            _savingDict?.setObject(_imagesArray.objectAtIndex(0), forKey: "cover")
        }
        
        //_savingDict?.setObject(_titleInput?.text!, forKey: "title")
        //_savingDict?.setObject(_desInput?.text!, forKey: "des")
        //_savingDict?.setObject(_imagesArray, forKey: "images")
        let _t=_titleInput?.text!
        _savingDict?.setObject(_t!, forKey: "title")
        
        _savingDict!.setObject(_desInput!.text, forKey: "description")
        
        
        _savingDict?.setObject(_imagesArray, forKey: "images")
        
//        let a:_Action_Type=_Action_Type.PicsIn
//        println(a.rawValue)
//        println(_Action_Type(rawValue: 10)?.rawValue)
//        _savingDict?.setObject(a.rawValue, forKey: "actionType")
        
        
        return true
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
}


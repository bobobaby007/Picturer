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

class Manage_new: UIViewController, ImagePickerDeletegate, UICollectionViewDelegate, UICollectionViewDataSource,UITextViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, SettingDelegate{
    let _gap:CGFloat=15
    let _space:CGFloat=5
    let _titleViewH:CGFloat=40
    let _desInputViewH:CGFloat=100
    let _tableViewH:CGFloat=200
    var _setuped:Bool=false
    let _maxNum:Int=140
    let _buttonH:CGFloat=150
    
    let _titlePlaceHold:String="图册标题（必填）"
    let _desPlaceHold:String="图册描述"
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    
    var _scrollView:UIScrollView?
    var _imagesBox:UIView?
    var _addButton:UIButton?
    var _imagesCollection:UICollectionView?
    var _selectedImages:NSMutableArray!=[]
    var _collectionLayout:UICollectionViewFlowLayout?
    
    var _titleView:UIView?
    var _titleInput:UITextField?
    
    var _desView:UIView?
    var _desInput:UITextView?
    var _desAlert:UILabel?
    
    
    var _textsIsEditing:Bool=false
    var _tapRec:UITapGestureRecognizer?
    
    var _settings:NSArray=[["title":"标签","des":""],["title":"图片显示顺序","des":"按创建时间倒序排列"],["title":"私密性","des":"所有人"],["title":"回复权限","des":"允许回复"]]
    
    
//    enum Settings{
//        var tt:String="hahah"
//    }
    
    override func viewDidLoad() {
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
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
       
        _titleInput=UITextField(frame: CGRect(x: _gap, y: 0, width: self.view.frame.width, height: _titleViewH))
        _titleInput?.placeholder=_titlePlaceHold
        _titleInput?.delegate=self
        //_titleInput.
        
        _titleView = UIView()
        _titleView?.backgroundColor=UIColor.whiteColor()
        _titleView?.addSubview(_titleInput!)
        
        
        _desView=UIView()
        
        _desView?.backgroundColor=UIColor.whiteColor()
        _desInput=UITextView(frame: CGRect(x: _gap, y: 0, width: self.view.frame.width-2*_gap, height: _desInputViewH-20))
        _desInput?.text=_desPlaceHold
        _desInput?.font=UIFont(name: "Helvetica", size: 15)
        //_desInput?.keyboardAppearance=UIKeyboardAppearance.Dark
        //_desInput?.returnKeyType=UIReturnKeyType.Done
        _desInput?.delegate=self
        
        
        _desAlert=UILabel(frame:CGRect(x: _gap, y: _desInputViewH-20, width: self.view.frame.width-2*_gap, height: 20) )
        _desAlert?.text=String(0)+"/"+String(_maxNum)
        _desAlert?.font=UIFont(name: "Helvetica", size: 12)
        
        _desAlert?.textColor=UIColor(white: 0.3, alpha: 1)
        _desAlert?.textAlignment=NSTextAlignment.Right
        
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
       
        _addButton?.setImage(UIImage(named: "addIcon.png"), forState: UIControlState.Normal)
        
       
        _imagesBox?.addSubview(_addButton!)
        _imagesBox?.addSubview(_imagesCollection!)
        _scrollView?.addSubview(_imagesBox!)
        _scrollView?.addSubview(_tableView!)
        _scrollView?.addSubview(_titleView!)
        _scrollView?.addSubview(_desView!)
        
        _scrollView?.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        _scrollView?.delegate=self
        _tapRec=UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        
        
        self.view.addSubview(_scrollView!)
        self.view.addSubview(_topBar!)
        _topBar?.addSubview(_btn_cancel!)
        
        
        
        _setuped=true
    }
    
    //设置栏代理
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        var cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "table_cell")
    
        cell.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.textLabel?.text=_settings.objectAtIndex(indexPath.row).objectForKey("title") as? String
        cell.detailTextLabel?.text=_settings.objectAtIndex(indexPath.row).objectForKey("des") as? String
        
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
        return _tableViewH/4+0.3
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row{
        case 0:
            let _controller:Setting_tags=Setting_tags()
            _controller._delegate=self
            self.navigationController?.pushViewController(_controller, animated: true)
        case 1:
            let _controller:Setting_range=Setting_range()
            _controller._delegate=self
            self.navigationController?.pushViewController(_controller, animated: true)
        case 2:
            let _controller:Setting_power=Setting_power()
            _controller._delegate=self
            self.navigationController?.pushViewController(_controller, animated: true)
        case 3:
            let _controller:Setting_reply=Setting_reply()
            _controller._delegate=self
            self.navigationController?.pushViewController(_controller, animated: true)
        default:
            println("")
        }
    }
   
    //----设置代理
    func settingSaved(sender: AnyObject, settings: NSDictionary) {
        println(settings)
        _tableView?.reloadData()
    }
    func settingCanceled() {
        _tableView?.reloadData()
    }
    //-----图片代理
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _selectedImages.count
        
        
        //return 30
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("")
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identify:String = "PicsShowCell"
        let cell = self._imagesCollection?.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! PicsShowCell
        
        let _al:ALAsset=_selectedImages.objectAtIndex(indexPath.item) as! ALAsset
        
        cell._setImageByImage(UIImage(CGImage: _al.thumbnail().takeUnretainedValue())!)
        
        return cell
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        _titleInput?.resignFirstResponder()
        _desInput?.resignFirstResponder()
        
        if _desInput?.text == ""{
            _desInput?.text=_desPlaceHold
        }
        _scrollView?.removeGestureRecognizer(_tapRec!)
    }
    
    
    
    //----文字输入代理
    func textFieldDidBeginEditing(textField: UITextField) {
        _scrollView?.addGestureRecognizer(_tapRec!)
    }
    func textViewDidBeginEditing(textView: UITextView) {
        if _desInput?.text == _desPlaceHold{
            _desInput?.text=""
        }
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        let _addH:CGFloat=self.view.frame.height-216-62-20-_desInputViewH
        var _offset:CGFloat = _desView!.frame.origin.y
        
        _offset=_offset-_addH
        //_scrollView?.frame=CGRect(x: 0, y: CGFloat(_offset!), width: self.view.frame.width, height: self.view.frame.height-62)
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
        _selectedImages.addObjectsFromArray(images as [AnyObject])
        //_selectedImages=NSMutableArray(array: images)
        _imagesCollection?.reloadData()
        refreshView()
        
        //println(images)
    }
    
    
    
    func refreshView(){
        
        
        let _imagesW:CGFloat=(self.view.frame.width-2*_gap-3*_space)/4
        let _imagesH:CGFloat=ceil(CGFloat(_selectedImages.count)/4)*(_imagesW+_space)
        
        _collectionLayout?.minimumInteritemSpacing=_space
        _collectionLayout?.minimumLineSpacing=_space
        _collectionLayout!.itemSize=CGSize(width: _imagesW, height: _imagesW)
        _imagesCollection?.frame=CGRect(x: _gap, y: _buttonH+2*_gap, width: self.view.frame.width-2*_gap, height: _imagesH)
       
       
        
        var _imageBoxH:CGFloat!
        if _selectedImages.count<1{
            _imageBoxH=_imagesH+_buttonH+2*_gap
        }else{
            _imageBoxH=_imagesH+_buttonH+3*_gap-_space
        }
        
        
        
        _addButton?.frame=CGRect(x: _gap, y: _gap, width: self.view.frame.width-2*_gap, height: _buttonH)
        
        _imagesBox?.frame=CGRect(x: 0, y: 0, width: self.view.frame.width, height:_imageBoxH)
        
        _titleView?.frame = CGRect(x: 0, y: _imageBoxH+_gap, width: self.view.frame.width, height: _titleViewH)
        _desView?.frame = CGRect(x: 0, y: _imageBoxH+2*_gap+_titleViewH, width: self.view.frame.width, height: _desInputViewH)
        
        _tableView?.frame = CGRect(x: 0, y: _imageBoxH+3*_gap+_titleViewH+_desInputViewH, width: self.view.frame.width, height: _tableViewH)
        
        
        let _scrollH=_imageBoxH+3*_gap+_titleViewH+_desInputViewH+_tableViewH
        _scrollView?.frame=CGRect(x: 0, y: 43, width: self.view.frame.width, height: self.view.frame.height-32)
        _scrollView?.contentSize=CGSize(width: self.view.frame.width, height: _scrollH)
        
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
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
}


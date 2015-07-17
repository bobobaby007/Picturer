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

protocol Manage_PicsToAlbumDelegate:NSObjectProtocol{
    func canceld()
    func saved(dict:NSDictionary)
}


class Manage_PicsToAlbum: UIViewController, ImagePickerDeletegate, UICollectionViewDelegate, UICollectionViewDataSource,UITextViewDelegate,UIScrollViewDelegate{
    let _gap:CGFloat=15
    let _space:CGFloat=5
    var _setuped:Bool=false
    let _maxNum:Int=140
    let _buttonH:CGFloat=150
    
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    
    
    var _scrollView:UIScrollView?
    var _imagesBox:UIView?
    var _addButton:UIButton?
    var _imagesCollection:UICollectionView?
    var _imagesArray:NSMutableArray!=[]
    var _collectionLayout:UICollectionViewFlowLayout?
    
    var _albumCollection:UICollectionView?
    
    
    var _delegate:Manage_PicsToAlbumDelegate?
    
    
    var _savingDict:NSMutableDictionary?
    
    
    //
    var _Action_Type:String="pics_to_album"
    
    var _albumIndex:Int?
    var _album:NSMutableDictionary?
    
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
        
        _btn_save=UIButton(frame:CGRect(x: self.view.frame.width-50, y: 5, width: 40, height: 62))
        _btn_save?.setTitle("完成", forState: UIControlState.Normal)
        _btn_save?.setTitleColor(UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1), forState: UIControlState.Normal)
        _btn_save?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
       
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
        _scrollView?.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        _scrollView?.delegate=self
        
        
        self.view.addSubview(_scrollView!)
        self.view.addSubview(_topBar!)
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_save!)
        
        
        
        _setuped=true
    }
    
    
    //-----图片代理
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == _albumCollection{
            return 3
        }
        
        return _imagesArray.count
        
        
        //return 30
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var _pic:Manage_pic?
        
        let storyboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
        
        _pic=storyboard.instantiateViewControllerWithIdentifier("Manage_pic") as? Manage_pic
        
        self.navigationController?.pushViewController(_pic!, animated: true)
        
        _pic?._showIndexAtPics(indexPath.item, __array: _imagesArray)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identify:String = "PicsShowCell"
        let cell = self._imagesCollection?.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! PicsShowCell
        
        
        
        //let _al:ALAsset=_imagesArray.objectAtIndex(indexPath.item) as! ALAsset
        
        
        let _pic:NSDictionary
        
        _pic = _imagesArray.objectAtIndex(indexPath.item) as! NSDictionary
        
        
        
        cell._setPic(_pic)
        return cell
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
        
        
        
        
        let _scrollH=_imageBoxH+3*_gap+60
        _scrollView?.frame=CGRect(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height-40)
        _scrollView?.contentSize=CGSize(width: self.view.frame.width, height: _scrollH)
        
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            _delegate?.canceld()
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_save!:
            if treckDict(){
                self.navigationController?.popViewControllerAnimated(true)
                _delegate?.saved(_savingDict!)
                
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
        _savingDict=NSMutableDictionary()
        
        if (_albumIndex != nil){
            _savingDict?.setObject(_albumIndex!, forKey: "albumIndex")
            _savingDict?.setObject("pics_to_album", forKey: "Action_Type")
        }else{
            _savingDict?.setObject("pics_to_album_new", forKey: "Action_Type")
        }
        _savingDict?.setObject(_imagesArray, forKey: "images")
        
        return true
    }
}


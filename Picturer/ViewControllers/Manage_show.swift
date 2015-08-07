//
//  Manage_show.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol Manage_show_delegate:NSObjectProtocol{
    func didDeletedPics(__dict:NSDictionary)
    func didAddPics(__dict:NSDictionary)
    func canceld()
}

class Manage_show: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PicsShowCellDelegate,UIAlertViewDelegate,ImagePickerDeletegate,Manage_pic_delegate{
    
    @IBOutlet weak var _btn_back:UIButton?
    @IBOutlet weak var _collectionView:UICollectionView!
    @IBOutlet weak var _titleButton:UIButton?
    @IBOutlet weak var _btn_edit:UIButton?
    
    
    let _barH:CGFloat = 64
    var _delegate:Manage_show_delegate?
    
    let _action_normal:String="normal"
    let _action_delete:String="delete"
    let _action_share:String="share"
    
    var _currentAction:String="normal"
    
    var _imagesArray:NSMutableArray = []
    var _SelectedIndexs:NSMutableArray=[]
    
    var _albumIndex:Int?
    var _title:String?
    var _setuped:Bool=false
    
    var _range:Int = 0
    
    func setup(){
        if _setuped{
            return
        }
        _btn_back?.titleLabel?.font = UIFont.systemFontOfSize(16)
        _btn_edit?.titleLabel?.font = UIFont.systemFontOfSize(16)
        
        _imagesArray = NSMutableArray(array:  MainAction._getImagesOfAlbumIndex(_albumIndex!)!)
        
        let layout = CustomLayout()
        _collectionView.collectionViewLayout=layout
        _collectionView.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
        _collectionView.userInteractionEnabled=true
        _setuped=true
        
        if _title == ""{
            _titleButton?.setTitle("未命名相册", forState: UIControlState.Normal)

        }else{
            _titleButton?.setTitle(_title, forState: UIControlState.Normal)

        }
    }
    
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _imagesArray.count;
    }
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
           
            //println(indexPath)
            let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
                "PicsShowCell", forIndexPath: indexPath) as! PicsShowCell
            cell._index = indexPath.row
            let _pic:NSDictionary
            if _range == 0{
              _pic  = _imagesArray.objectAtIndex(indexPath.item) as! NSDictionary
            }else{
                _pic  = _imagesArray.objectAtIndex(_imagesArray.count-indexPath.item-1) as! NSDictionary
            }
            cell._setPic(_pic)
            
            cell._selected = _selectedAtIndex(indexPath.item)
            
            cell._delegate = self
            
            switch _currentAction{
            case _action_normal:
               cell._hasTag=false
            case _action_delete:
               cell._hasTag=true
            default:
               cell._hasTag=false
            }
            
            return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
          
        switch _currentAction{
        case _action_normal:
            println("")
        case _action_delete:
           println("")
        default:
            println("not set action")
        }
        
        var _controller:Manage_pic = Manage_pic()
        _controller._showIndexAtPics(indexPath.item, __array: _imagesArray)
        if _albumIndex != nil{
            _controller._albumIndex = _albumIndex
        }
        _controller._range = _range
        _controller._delegate=self
        
        self.navigationController?.pushViewController(_controller, animated: true)
       // _pic?._setPic(_imagesArray[indexPath.item] as! NSDictionary)
        //_pic?._setImage(_imagesArray[indexPath.item] as! String)
    }
    
    //------图片单张展示代理
    func canceled() {
        _collectionView.reloadData()
    }
    func _deletePic(picIndex: Int) {
        _SelectedIndexs.addObject(picIndex)
        _deleteSelectedPics()
    }
    func _setCover(picIndex: Int) {
        var _dict:NSDictionary = NSDictionary(object: _imagesArray.objectAtIndex(picIndex), forKey: "cover") as NSDictionary
        MainAction._changeAlbumAtIndex(_albumIndex!, dict: _dict)
    }
    
    
    //---瀑布流时图片cell选择代理
    
    func PicDidSelected(pic: PicsShowCell) {
        var _pic:NSMutableDictionary=NSMutableDictionary(dictionary: _imagesArray[pic._index!] as! NSDictionary)
        _pic.setObject(pic._selected, forKey: "selected")
        _imagesArray[pic._index!]=_pic
        if(pic._selected){
            _SelectedIndexs.addObject(pic._index!)
        }else{
            _SelectedIndexs.removeObject(pic._index!)
            
            
        }
        if _SelectedIndexs.count>0{
            _btn_edit?.setTitleColor(UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1), forState: UIControlState.Normal)
        }else{
            _btn_edit?.setTitleColor(UIColor(white: 0.7, alpha: 1), forState: UIControlState.Normal)
        }
        
        
        
    }
    func _selectedAtIndex(__index:Int)->Bool{
        var _has:Bool=false
        if _SelectedIndexs.count<1{
            return false
        }
        for i in 0..._SelectedIndexs.count-1{
            if Int(_SelectedIndexs.objectAtIndex(i) as! NSNumber) == __index{
                return true
            }
        }
        
        return _has
    }
    
    
    @IBAction func clickAction(_btn:UIButton)->Void{
        switch _btn{
        case _btn_back!:
            switch _currentAction{
            case _action_normal:
                self.navigationController?.popViewControllerAnimated(true)
                _delegate?.canceld()
            case _action_delete:
                self._changeActionTo(_action_normal)
            default:
                println("")
            }
            
        case _btn_edit!:
            switch _currentAction{
            case _action_normal:
                self.openActions()
            case _action_delete:
                if _SelectedIndexs.count<=0{
                    return
                }
                
                var _alert:UIAlertView = UIAlertView()
                _alert.delegate=self
                _alert.title="确定删除图片？"
                _alert.addButtonWithTitle("确定")
                _alert.addButtonWithTitle("取消")
                _alert.show()
            default:
                println("")
            }
            
        default:
            println("")
        }
        
    }
    //-----提示按钮
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch _currentAction{
            case _action_delete:
                if buttonIndex==0{
                    _deleteSelectedPics()
                }
        default:
            println("")
        }
        
    }
    //-----删除当前选中的图片
    func _deleteSelectedPics(){
        var _dict:NSMutableDictionary = NSMutableDictionary(dictionary: _getSelectedAndRestArray())
        _dict.setValue(_albumIndex, forKey: "albumIndex")
        _delegate?.didDeletedPics(_dict)
        var _indexs:NSMutableIndexSet = NSMutableIndexSet()
        var _itemsIndexs:NSMutableArray=[]
        for i in _SelectedIndexs{
            _indexs.addIndex(Int(i as! NSNumber))
            _itemsIndexs.addObject(NSIndexPath(forItem: Int(i as! NSNumber), inSection: 0))
        }
        // println(_itemsIndexs)
        
        
        _changeActionTo(_action_normal)
        
        _imagesArray.removeObjectsAtIndexes(_indexs)
        _collectionView.deleteItemsAtIndexPaths(_itemsIndexs as [AnyObject])

        _SelectedIndexs=[]
    }
    func _changeActionTo(_action:String){
        _currentAction=_action
        
        switch _currentAction{
        case _action_normal:
            _SelectedIndexs=[]
            
            //_collectionView.reloadData()
            _btn_back?.setTitle("", forState: UIControlState.Normal)
            _btn_edit?.setTitle("", forState: UIControlState.Normal)
            _btn_back?.setBackgroundImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
            _btn_edit?.setBackgroundImage(UIImage(named: "edit.png"), forState: UIControlState.Normal)
            _btn_back?.frame=CGRect(x: 11, y: _barH-21-11, width: 51, height: 21)
            _btn_edit?.frame=CGRect(x: self.view.frame.width-50, y: _barH-44, width: 50, height: 44)
            
            _needToSelect(false)
        
        case _action_delete:
            _SelectedIndexs=[]
            _btn_back?.setBackgroundImage(UIImage(), forState: UIControlState.Normal)
            _btn_edit?.setBackgroundImage(UIImage(), forState: UIControlState.Normal)
            _btn_back?.frame=CGRect(x: self.view.frame.width-50, y: _barH-44, width: 50, height: 44)
            _btn_edit?.frame=CGRect(x: self.view.frame.width-40-15+3, y: 20, width: 40, height: _barH-20)
            _btn_edit?.setTitleColor(UIColor(white: 0.7, alpha: 1), forState: UIControlState.Normal)
            _btn_edit?.setTitle("删除", forState: UIControlState.Normal)
            _btn_back?.setTitle("取消", forState: UIControlState.Normal)
            //self._collectionView.reloadData()
            _needToSelect(true)
        default:
            return
        }
        
    }
    
    func _needToSelect(__set:Bool){
        var _n:Int = _collectionView.numberOfItemsInSection(0)
        
        for var i = 0; i < _n; ++i{
            let cell:PicsShowCell? = _collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as? PicsShowCell
            if cell != nil{
                cell?._hasTag=__set
            }
            
        }
    }
    
    func _getSelectedAndRestArray()->NSDictionary{
        var _selectedA:NSMutableArray=[]
        var _restA:NSMutableArray=[]
        var _n:Int = _imagesArray.count
        for var i = 0;i<_n;++i{
            var _pic:NSDictionary
            
            if _range == 0{
               _pic  = _imagesArray.objectAtIndex(i) as! NSDictionary
            }else{
                _pic  = _imagesArray.objectAtIndex(_imagesArray.count-i-1) as! NSDictionary
            }
           
            
            if _selectedAtIndex(i){
                _selectedA.addObject(_pic)
            }else{
                _restA.addObject(_pic)
            }
        }
        var _dict:NSDictionary=NSDictionary(objects: [_selectedA,_restA], forKeys: ["selectedImages","restImages"])
        return _dict
    }
    
    //-----弹出选择按钮
    func openActions()->Void{
        //let rateMenu = UIAlertController(title: "新建相册", message: "选择一种新建方式", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let menu=UIAlertController()
        
        let action1 = UIAlertAction(title: "添加", style: UIAlertActionStyle.Default, handler: gotoAdd)
        let action2 = UIAlertAction(title: "删除", style: UIAlertActionStyle.Default, handler: gotoDelete)
        let action3 = UIAlertAction(title: "分享", style: UIAlertActionStyle.Default, handler: gotoShare)
        let action4 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        menu.addAction(action1)
        menu.addAction(action2)
        menu.addAction(action3)
        menu.addAction(action4)
        self.presentViewController(menu, animated: true, completion: nil)
    }
    
    //-----选择相册代理
    func imagePickerDidSelected(images: NSArray) {
        _imagesArray.addObjectsFromArray(images as [AnyObject])
        
        var _dict:NSMutableDictionary = NSMutableDictionary()
        
        _dict.setValue(_albumIndex, forKey: "albumIndex")
        _dict.setValue(images, forKey: "addedImages")
        _dict.setValue(_imagesArray, forKey: "allImages")
        
        _delegate?.didAddPics(_dict)
        
        _collectionView.reloadData()
        //_imagesArray=NSMutableArray(array: images)
       // _imagesCollection?.reloadData()
       // refreshView()
        
        //println(images)
    }

    //---打开添加窗口
    func gotoAdd(action:UIAlertAction!) -> Void{
        let storyboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
        var _controller:Manage_imagePicker?
        _controller=storyboard.instantiateViewControllerWithIdentifier("Manage_imagePicker") as? Manage_imagePicker
        _controller?._delegate=self
        //self.view.window!.rootViewController!.presentViewController(_controller!, animated: true, completion: nil)
        self.navigationController?.pushViewController(_controller!, animated: true)
    }
    func gotoDelete(action:UIAlertAction!)->Void{
        _changeActionTo(_action_delete)
    }
    func gotoShare(action:UIAlertAction!)->Void{
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden=false
    }
    
    

}

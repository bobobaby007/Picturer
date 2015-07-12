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
    
}

class Manage_show: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PicsShowCellDelegate,UIAlertViewDelegate{
    
    @IBOutlet weak var _btn_back:UIButton?
    @IBOutlet weak var _collectionView:UICollectionView!
    
    @IBOutlet weak var _btn_edit:UIButton?
    
    var _delegate:Manage_show_delegate?
    
    let _action_normal:String="normal"
    let _action_delete:String="delete"
    let _action_share:String="share"
    
    var _currentAction:String="normal"
    
    var _collectionArray:NSMutableArray = []
    var _SelectedIndexs:NSMutableArray=[]
    
    var _albumIndex:Int?
    
    var _setuped:Bool=false
    func setup(){
        if _setuped{
            return
        }
        _collectionArray = NSMutableArray(array:  MainAction._getImagesOfAlbumIndex(_albumIndex!)!)
        
        let layout = CustomLayout()
        _collectionView.collectionViewLayout=layout
        _collectionView.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
        _collectionView.userInteractionEnabled=true
        _setuped=true
    }
    
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collectionArray.count;
    }
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let identify:String = "PicsShowCell"
            //println(indexPath)
            let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath) as! PicsShowCell
            cell._index = indexPath.row
            let _pic:NSDictionary = _collectionArray[indexPath.item] as! NSDictionary
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
        
        var _pic:Manage_pic?
        _pic=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_pic") as? Manage_pic
        self.navigationController?.pushViewController(_pic!, animated: true)
        
        _pic?._showIndexAtPics(indexPath.item, __array: _collectionArray)
       // _pic?._setPic(_collectionArray[indexPath.item] as! NSDictionary)
        //_pic?._setImage(_collectionArray[indexPath.item] as! String)
    }
    
    //---图片选择代理
    
    func PicDidSelected(pic: PicsShowCell) {
        var _pic:NSMutableDictionary=NSMutableDictionary(dictionary: _collectionArray[pic._index!] as! NSDictionary)
        _pic.setObject(pic._selected, forKey: "selected")
        _collectionArray[pic._index!]=_pic
        if(pic._selected){
            _SelectedIndexs.addObject(pic._index!)
        }else{
            _SelectedIndexs.removeObject(pic._index!)
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
                
            case _action_delete:
                _currentAction=_action_normal
                _btn_back?.setTitle("返回", forState: UIControlState.Normal)
                _btn_edit?.setTitle("编辑", forState: UIControlState.Normal)
                self._collectionView.reloadData()
            default:
                println("")
            }
            
        case _btn_edit!:
            switch _currentAction{
            case _action_normal:
                self.openActions()
            case _action_delete:
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
                    _getSelectedAndRestArray()
                    
                }
        default:
            println("")
        }
        
    }
    
    func _getSelectedAndRestArray()->NSDictionary{
        var _selectedA:NSMutableArray=[]
        var _restA:NSMutableArray=[]
        var _n:Int = _collectionArray.count
        for var i = 0;i<_n;++i{
            var _pic:NSDictionary = _collectionArray.objectAtIndex(i) as! NSDictionary
            
            if _pic.objectForKey("selected") == nil{
                
            }else{
                
            }
            
        }
        var _dict:NSDictionary=NSDictionary(objects: [_selectedA,_restA], forKeys: ["selected","rest"])
        return _dict
    }
    //
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
    
    
    //---打开添加窗口
    func gotoAdd(action:UIAlertAction!) -> Void{
        var _controller:Manage_new?
        _controller=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_new") as? Manage_new
        self.navigationController?.pushViewController(_controller!, animated: true)
    }
    func gotoDelete(action:UIAlertAction!)->Void{
        _currentAction=_action_delete
        _btn_edit?.setTitle("删除", forState: UIControlState.Normal)
        _btn_back?.setTitle("取消", forState: UIControlState.Normal)
        self._collectionView.reloadData()
        
    }
    func gotoShare(action:UIAlertAction!)->Void{
        
        
    }
    
    
    
    

}

//
//  Manage_show.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class Manage_show: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var _btn_back:UIButton?
    @IBOutlet weak var _collectionView:UICollectionView!
    
    @IBOutlet weak var _btn_edit:UIButton?
    
    
    let _action_normal:String="normal"
    let _action_delete:String="delete"
    let _action_share:String="share"
    
    var _currentAction:String="normal"
    
    var _collectionArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = CustomLayout()
        _collectionView.collectionViewLayout=layout
        _collectionView.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
    }
    func _setPicArray(__array:NSMutableArray){
        _collectionArray=__array
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _collectionArray.count;
    }
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let identify:String = "PicsShowCell"
            let cell = self._collectionView?.dequeueReusableCellWithReuseIdentifier(
                identify, forIndexPath: indexPath) as! PicsShowCell
           // let cell = PicsShowCell()
            
            cell._setImage( _collectionArray[indexPath.item] as! String)
            
            switch _currentAction{
            case _action_normal:
               cell._hasTag=false
            case _action_delete:
               cell._hasTag=true
            default:
               cell._hasTag=false
            }
            
            cell._selected=false
           
           
            
            return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // println(_show)
        //  var _show = self.storyboard?.instantiateViewControllerWithIdentifier("Manage_show") as? Manage_show
        
       // _pic?._setImage(_collectionArray[indexPath.item])
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PicsShowCell
        
        switch _currentAction{
        case _action_normal:
            var _pic:Manage_pic?
            _pic=self.storyboard?.instantiateViewControllerWithIdentifier("Manage_pic") as? Manage_pic
            self.navigationController?.pushViewController(_pic!, animated: true)
            _pic?._setImage(_collectionArray[indexPath.item] as! String)
        case _action_delete:
            cell._selected = !cell._selected
            
        default:
            println("not set action")
        }
        
        
        
        
        
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
                self._collectionView.reloadData()
            default:
                println("")
            }
            
        case _btn_edit!:
            switch _currentAction{
            case _action_normal:
                self.openActions()
            case _action_delete:
                var _alert:UIAlertView
            default:
                println("")
            }
            
        default:
            println("")
        }
        
    }
    
    
    
    //---新建
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

//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class SearchResult: UIView,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    var _gap:CGFloat = 10
    var _setuped:Bool=false
    
    var _tabBtnView:UIView = UIView()
    var _tab_reference:UIButton = UIButton()
    var _tab_search:UIButton = UIButton()
    
    let _space:CGFloat = 1.5
    var _userArray:NSArray = NSArray()
    var _albumArray:NSArray = []
    var _userTableView:UITableView?
    var _albumCollectionView:UICollectionView?
    var _collectionLayout:UICollectionViewFlowLayout?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        _tab_reference = UIButton()
        _tab_reference.setTitleColor(Config._color_social_gray, forState: UIControlState.Normal)
        _tab_reference.titleLabel?.font = Config._font_social_cell_name
    
        _tab_reference.setTitle("图册", forState: UIControlState.Normal)
        _tab_reference.frame=CGRect(x: 0, y: 0, width: frame.width/2, height: 40)
        _tab_reference.layer.borderColor = Config._color_gray_subTitle.CGColor
        _tab_reference.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _tab_search = UIButton()
        _tab_search.setTitle("用户", forState: UIControlState.Normal)
        _tab_search.setTitleColor(Config._color_social_gray, forState: UIControlState.Normal)
        _tab_search.titleLabel?.font = Config._font_social_cell_name
        _tab_search.frame=CGRect(x: frame.width/2, y: 0, width: frame.width/2, height: 40)
        _tab_search.layer.borderColor = Config._color_gray_subTitle.CGColor
        _tab_search.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _tabBtnView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 40))
        _tabBtnView.layer.masksToBounds = true
        _tabBtnView.addSubview(_tab_reference)
        _tabBtnView.addSubview(_tab_search)
        
        var line:UIView = UIView(frame: CGRect(x: 0, y: 40-0.3, width: frame.width, height: 0.3))
        line.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _tabBtnView.addSubview(line)
        
        line = UIView(frame: CGRect(x: (frame.width-0.3)/2, y: 0, width: 0.5, height: 40))
        line.backgroundColor = UIColor(white: 0.8, alpha: 1)
        _tabBtnView.addSubview(line)
        
        let _imagesW:CGFloat = (frame.width-2*_space)/3
        
        _collectionLayout = UICollectionViewFlowLayout()
        _collectionLayout?.minimumInteritemSpacing=_space
        _collectionLayout?.minimumLineSpacing=_space
        _collectionLayout?.itemSize=CGSize(width: _imagesW, height: _imagesW)
        
        
        _albumCollectionView = UICollectionView(frame: CGRect(x: 0, y: 40, width: frame.width, height: frame.height-40), collectionViewLayout: _collectionLayout!)
        _albumCollectionView?.backgroundColor = UIColor.whiteColor()
        _albumCollectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        _albumCollectionView?.dataSource = self
        _albumCollectionView?.delegate = self
        
        
        
        _userTableView = UITableView(frame: CGRect(x: 0, y: 40, width: frame.width, height: frame.height-40))
        _userTableView?.registerClass(FocusListCell.self, forCellReuseIdentifier: "FocusListCell")
        
        _userTableView?.dataSource = self
        _userTableView?.delegate = self
        
        
        _switchTo(0)
        
        self.addSubview(_tabBtnView)
    }
    
    func _searchForStr(__str:String)->Void{
        
        _albumArray = []
        _albumCollectionView?.reloadData()
        
        Social_Main._getResultOfAlbum(__str, block: { (array) -> Void in
            
            self._albumArray = array
            self._albumCollectionView?.reloadData()
        })
        Social_Main._getResultOfUser(__str, block: { (array) -> Void in
            self._userArray = array
            self._userTableView?.reloadData()
        })
    }
    
    func _switchTo(__num:Int){
        switch __num{
        case 0:
            _tab_reference.setTitleColor(UIColor(white: 0.1, alpha: 1), forState: UIControlState.Normal)
            _tab_search.setTitleColor(UIColor(white: 0.8, alpha: 1), forState: UIControlState.Normal)
            
            _userTableView?.removeFromSuperview()
            addSubview(_albumCollectionView!)
            
            return
        case 1:
            _tab_reference.setTitleColor(UIColor(white: 0.8, alpha: 1), forState: UIControlState.Normal)
            _tab_search.setTitleColor(UIColor(white: 0.1, alpha: 1), forState: UIControlState.Normal)
            
            _albumCollectionView!.removeFromSuperview()
            
            addSubview(_userTableView!)
            
            return
        default:
            return
        }
    }
    
    //----table代理
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _userArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:FocusListCell = tableView.dequeueReusableCellWithIdentifier("FocusListCell", forIndexPath: indexPath) as! FocusListCell
        //if cell.respondsToSelector("setSeparatorInset:") {
        if indexPath.row == _userArray.count - 1 {
            cell.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0)
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0)
        }
        
        //}
        //if cell.respondsToSelector("setLayoutMargins:") {
        cell.layoutMargins = UIEdgeInsetsZero
        //}
        //if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
        cell.preservesSuperviewLayoutMargins = false
        //}
        
        cell._index = indexPath.row
        if let _user = _userArray.objectAtIndex(indexPath.row) as? NSDictionary{
            
           
            cell._setFocusType(0)
            
            cell._setPic(MainInterface._userAvatar(_user))
            cell._setTitle(_user.objectForKey("userName") as! String)
            
            
            //---to do list
            
            //cell._setDes(_user.objectForKey("sign") as! String)
            
            if indexPath.row%3 == 1{
                cell._setDes("picturerId")
            }else{
                cell._setDes("")
            }
            
        }
        return cell
        
        
//        
//        let cell:SearchResult_user_Cell = tableView.dequeueReusableCellWithIdentifier("SearchResult_user_Cell", forIndexPath: indexPath) as! SearchResult_user_Cell
//        cell.setup(self.frame.width)
//        cell._setUserImg((_userArray.objectAtIndex(indexPath.item) as! NSDictionary).objectForKey("userImg") as! NSDictionary)
//        
//        cell._setName((_userArray.objectAtIndex(indexPath.item) as! NSDictionary).objectForKey("userName") as! String)
//        cell._setDes((_userArray.objectAtIndex(indexPath.item) as! NSDictionary).objectForKey("sign") as! String)
//            
//        
//        return cell
    }
    
    
    
    //----collection代理
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _albumArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) 
        
        let _picV:PicView = PicView(frame:CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        _picV._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _picV.maximumZoomScale = 1
        _picV.minimumZoomScale = 1
        _picV.userInteractionEnabled = false
        
        _picV._setPic(((_albumArray.objectAtIndex(indexPath.item) as! NSDictionary).objectForKey("pic") as! NSDictionary), __block: { (_dict) -> Void in
            
            })
        cell.addSubview(_picV)
        //cell.backgroundColor = UIColor.blueColor()
        
        return cell
    }
    
    
    
    func clickAction(sender:UIButton){
        switch sender{
            
        case _tab_reference:
            _switchTo(0)
            return
        case _tab_search:
            _switchTo(1)
            return
        default:
            return
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




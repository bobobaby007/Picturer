//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Discover_reference: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource, UITableViewDelegate{
    let _gap:CGFloat = 15
    let _gapH:CGFloat = 5
    let _sectionGap:CGFloat = 5
    let _barH:CGFloat = 64
    var _sliderH:CGFloat = 184.5
    var _sliderGapH:CGFloat = 12
    let _space:CGFloat=3
    var _sliderShower:SliderShower?
    
    var _picW:CGFloat = 20
    
    var _dataArray:NSArray = []
    
    var _setuped:Bool=false
    
    var _tableView:UITableView?
    
    var _scrollerView:UIScrollView?
    
    var _collectionLayout:UICollectionViewFlowLayout?
    var _imagesCollection:UICollectionView?
    var _showType:String = "collection"// "pic" // collection
    var _sectionBar:UIView?
    var _sectionBarH:CGFloat = 43.5
    
    var _sectionTitle:UILabel?
    
    var _btn_changeType:UIButton?
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor.whiteColor()
        
        _scrollerView = UIScrollView(frame: CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH))
        _sliderShower = SliderShower(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _sliderH))
        _scrollerView!.addSubview(_sliderShower!)
        
        _sectionBar =  UIView(frame: CGRect(x: 0, y: _sliderH, width: self.view.frame.width, height: _sectionBarH))
        _sectionBar?.backgroundColor = UIColor.whiteColor()
        
        
        _sectionTitle = UILabel(frame: CGRect(x: _gap, y: _gap, width: 100, height: 13))
       _sectionTitle?.textColor = Config._color_social_gray
        _sectionTitle?.font = Config._font_social_cell_name
        _sectionTitle?.userInteractionEnabled = false
        _sectionTitle?.backgroundColor = UIColor.clearColor()
        _sectionTitle?.text = "热门图册"
        
        _sectionBar?.addSubview(_sectionTitle!)
        
        _btn_changeType=UIButton(frame:CGRect(x: self.view.frame.width-36.5, y: 13, width: 18, height: 18))
        _btn_changeType?.setImage(UIImage(named: "changeToCollect_icon_yellow.png"), forState: UIControlState.Normal)
        _btn_changeType?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let line:UIView = UIView(frame: CGRect(x: 0, y: _sectionBarH-0.3, width: self.view.frame.width, height: 0.3))
        line.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        _sectionBar!.addSubview(line)
        _sectionBar!.addSubview(_btn_changeType!)

        
        
        _scrollerView!.addSubview(_sectionBar!)
        
        
        self.view.addSubview(_scrollerView!)
        
        _tableView=UITableView()
        
        _tableView?.backgroundColor=UIColor.clearColor()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.frame = CGRect(x: 0, y: _sliderH+_sectionBarH, width: self.view.frame.width, height: self.view.frame.width-_sliderH-_sectionBarH-_barH)
        _tableView?.registerClass(ReferenceAlbumItem.self, forCellReuseIdentifier: "ReferenceAlbumItem")
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.separatorStyle = UITableViewCellSeparatorStyle.None
        //_tableView?.separatorColor=UIColor.clearColor()
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -400, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        
        _collectionLayout=UICollectionViewFlowLayout()
        let _imagesW:CGFloat=(self.view.frame.width-2*_space)/3
        //let _imagesH:CGFloat=ceil(CGFloat(_picsArray!.count)/4)*(_imagesW+_space)
        
        _collectionLayout?.minimumInteritemSpacing=_space
        _collectionLayout?.minimumLineSpacing=_space
        _collectionLayout!.itemSize=CGSize(width: _imagesW, height: _imagesW)
        
        _imagesCollection=UICollectionView(frame: CGRect(x: 0, y: _sliderH+_sectionBarH, width: self.view.frame.width, height: self.view.frame.width-_sliderH-_sectionBarH-_barH), collectionViewLayout: _collectionLayout!)
        
        //_imagesCollection?.frame=CGRect(x: _gap, y: _buttonH+2*_gap, width: self.view.frame.width-2*_gap, height: _imagesH)
        
        _imagesCollection?.backgroundColor=UIColor.clearColor()
        _imagesCollection!.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
        
        _imagesCollection?.delegate=self
        _imagesCollection?.dataSource=self
        
        
        _getDatas()
        _changeTo("collection")
        _setuped=true
    }
    
    
    
    func _getDatas(){
        Social_Main._getAdvertisiongs { (array) -> Void in
            self._sliderShower?._setup(array)
        }
        Social_Main._getHotAlbums { (array) -> Void in
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self._dataArray = array
                self._refreshView()
            })
        }
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_changeType!:
            switch _showType{
            case "pic":
                _changeTo("collection")
                return
            case "collection":
                _changeTo("pic")
                return
            default:
                return
                
            }
            
        default:
            print(sender)
        }
        
    }
    
    //-----切换查看模式，瀑布流或单张
    func _changeTo(__type:String){
        
        _showType = __type
        switch _showType{
        case "pic"://单张
            _imagesCollection?.removeFromSuperview()
            _scrollerView?.addSubview(_tableView!)
            _btn_changeType?.setImage(UIImage(named: "changeToCollect_icon_yellow.png"), forState: UIControlState.Normal)
            
            break
        case "collection":
            _tableView?.removeFromSuperview()
            _scrollerView?.addSubview(_imagesCollection!)
            _btn_changeType?.setImage(UIImage(named: "changeToPic.png"), forState: UIControlState.Normal)
            break
        default:
            break
            
        }
        
        _refreshView()
    }
    
    
    
    //---table代理
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //println(_heighArray.objectAtIndex(indexPath.row))
        return 375
    }
    
    //---------
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let _dict:NSDictionary = _dataArray.objectAtIndex(indexPath.row) as! NSDictionary
        
        
        var cell:ReferenceAlbumItem?
        //cell = tableView.viewWithTag(100+indexPath.row) as? ReferenceAlbumItem
        
        
        
        cell = tableView.dequeueReusableCellWithIdentifier("ReferenceAlbumItem") as? ReferenceAlbumItem
        cell!.setup(CGSize(width: self.view.frame.width, height: 375))
        
        cell!.separatorInset = UIEdgeInsetsZero
        cell!.preservesSuperviewLayoutMargins = false
        cell!.layoutMargins = UIEdgeInsetsZero
        
        
        cell!._setUserImge(NSDictionary(objects: ["user_1.jpg","file"], forKeys: ["url","type"]))
        cell!._setUserName("小小白")
        
        if let _title:String = _dict.objectForKey("title") as? String{
            cell!._setAlbumTitle(_title)
        }else{
            cell!._setAlbumTitle("")
        }
        if let _cover:NSDictionary = _dict.objectForKey("cover") as? NSDictionary{
            cell!._setPic(_cover)
        }else{
            //cell!._setDescription("")
        }
        
        
        
        return cell!
    }
    
    func _refreshView(){
        switch _showType{
            case "pic":
                _tableView?.reloadData()
                _tableView?.frame = CGRect(x: 0, y: _sliderH+_sectionBarH, width:  self.view.frame.width, height: _tableView!.contentSize.height)
                _tableView?.scrollEnabled = false
                _scrollerView?.contentSize = CGSize(width: self.view.frame.width, height: _tableView!.frame.height+_sliderH+_sectionBarH)
            break
        case "collection":
            _imagesCollection?.reloadData()
            
            let _imagesW:CGFloat=(self.view.frame.width-2*_space)/3
            let _h:CGFloat = CGFloat(ceil(CGFloat(_dataArray.count)/3))*(_imagesW+_space)
            
            _imagesCollection?.frame = CGRect(x: 0, y: _sliderH+_sectionBarH, width:  self.view.frame.width, height: _h)
            _imagesCollection?.scrollEnabled = false
            _scrollerView?.contentSize = CGSize(width: self.view.frame.width, height: _imagesCollection!.frame.height+_sliderH+_sectionBarH)
            break
        default:
            break
        }
        
        
    }
    
    //-----瀑布流代理
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _dataArray.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "PicsShowCell"
        let cell = self._imagesCollection?.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! PicsShowCell
        
        
        let _dict:NSDictionary = _dataArray.objectAtIndex(indexPath.row) as! NSDictionary
        
        
        if let _cover:NSDictionary = _dict.objectForKey("cover") as? NSDictionary{
            cell._setPic(_cover)
        }else{
            //cell!._setDescription("")
        }
        
        
       //cell._setPic(_pic)
        return cell
    }
    
    func _hotAlbumsIn(){
    }
    
}









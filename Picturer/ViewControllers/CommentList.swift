//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit



class CommentList: UIViewController, UITableViewDelegate,UITableViewDataSource,Inputer_delegate,CommentList_Cell_delegate{
    let _barH:CGFloat = 64
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    var _tableView:UITableView?
    var _selectedId:Int = -1
    
    
    
    var _dataArray:NSMutableArray?=NSMutableArray()
    
    var _heightArray:NSMutableArray? = NSMutableArray()
    
    var _inputer:Inputer?
    
    static let _Type_pic:String = "pic"
    static let _Type_album:String = "album"
    static let _Type_timeline:String = "timeline"
    
    var _type:String = "pic" //----评论类型 pic/album/timeline
    var _id:String = "" //-----评论的id，根据类型区分
    
    
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
       
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _inputer = Inputer(frame: self.view.frame)
        _inputer?._delegate=self
        _inputer!._placeHold = "添加评论..."
        _inputer?.setup()
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=Config._color_black_bar
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 20, width: self.view.frame.width-100, height: _barH-20))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.font = Config._font_topbarTitle
        _title_label?.text="评论"
        
        self.view.addSubview(_topBar!)
        
        
        
        //_dealWidthDatas(_dataArray!)
        
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.registerClass(CommentList_Cell.self, forCellReuseIdentifier: "CommentList_Cell")
        //_tableView?.scrollEnabled=false
        //_tableView?.separatorColor = UIColor.clearColor()
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        
        refreshView()
        
        ImageLoader.sharedLoader._removeAllTask()
        _getDatas()
//
//        
//        
        self.view.addSubview(_tableView!)
        self.view.addSubview(_inputer!)
        
        _setuped=true
    }
    
    
    func _getDatas(){
//        Social_Main._getMessages { (array) -> Void in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self._dealWidthDatas(array)
//            })
//            
//        }
        
        switch _type{
        case CommentList._Type_pic:
            Social_Main._getPicCommentAndLikes(_id, __block: { [weak self](__dict) -> Void in
                self?._getCommentsOk(__dict)
            })
            break
        case CommentList._Type_album:
            Social_Main._getAlbumCommentAndLikes(_id, __block: { [weak self](__dict) -> Void in
                self?._getCommentsOk(__dict)
                })
            break
        case CommentList._Type_timeline:
            Social_Main._getTimelineCommentAndLikes(_id, __block: { [weak self](__dict) -> Void in
                self?._getCommentsOk(__dict)
                })
            break
        default:
            break
        }
        
    }
    func _getCommentsOk(__dict:NSDictionary){
        let _comments:NSArray = __dict.objectForKey("comment") as! NSArray
        let _array:NSMutableArray = NSMutableArray()
        for var i:Int = 0 ; i < _comments.count ; ++i{
            let _com:NSDictionary = _comments.objectAtIndex(i) as! NSDictionary
            let _by:NSDictionary = _com.objectForKey("by") as! NSDictionary
            print("评论:",_com)
            
            let from_userName:String = _by.objectForKey("nickname") as! String
            let from_userId:String = _by.objectForKey("_id") as! String
            let userImg:NSDictionary = MainInterface._userAvatar(_by)
            
            var to_userName:String = ""
            
            var to_userId:String = ""
            
            if let _re:NSDictionary = _com.objectForKey("re") as? NSDictionary{
                to_userName = _re.objectForKey("nickname") as! String
                to_userId = _re.objectForKey("_id") as! String
            }
            let comment:String = _com.objectForKey("text") as! String
            let _d:NSDictionary = NSDictionary(objects: [from_userName,to_userName,from_userId,to_userId,comment,userImg,CoreAction._dateDiff(_com.objectForKey("create_at") as! String) ], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","userImg","time"])
            _array.addObject(_d)
        }
        //print("评论:",_array)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self._dealWidthDatas(_array)
            self._tableView?.reloadData()
        })
    }
    func _dealWidthDatas(__array:NSArray){
        
        self._dataArray = NSMutableArray(array: __array)
        self._heightArray = NSMutableArray()
        for var i:Int = 0 ;i < __array.count; ++i{
            _heightArray?.addObject(CommentList_Cell._getHeihtWidthDict(_dataArray!.objectAtIndex(i) as! NSDictionary,_defaultWidth: self.view.frame.width))
        }
        //self._tableView?.reloadData()
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        let cell:CommentList_Cell = _tableView!.dequeueReusableCellWithIdentifier("CommentList_Cell", forIndexPath: indexPath) as! CommentList_Cell
        cell.setUp(self.view.frame.width)
        
        let _dict:NSDictionary = _dataArray!.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! NSDictionary
        print("评论：",_dict)
        cell._setDict(_dict)
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        cell._delegate = self
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _dataArray!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        return _heightArray?.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! CGFloat
        
        
        //return CGFloat(((_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("comment") as! String).lengthOfBytesUsingEncoding(NSUnicodeStringEncoding))
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        
        let cell:CommentList_Cell = _tableView!.cellForRowAtIndexPath(indexPath) as! CommentList_Cell
        cell.selected = false
        
        //_tableView?.reloadData()
        let _dict:NSDictionary = _dataArray!.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! NSDictionary
        let _userId:String = _dict.objectForKey("from_userName") as! String
        if _userId != Social_Main._currentUser.objectForKey("userId") as! String{
             _selectedId=indexPath.row
            _inputer!._placeHold = "回复"+(_dict.objectForKey("from_userName") as! String)
        }else{
            _selectedId = -1
            _inputer!._placeHold = "添加评论..."
        }
    }
    
    //----cell 代理
    
    func _viewUser(__userId: String) {
        let _controller:MyHomepage = MyHomepage()
        _controller._userId = __userId
        self.navigationController?.pushViewController(_controller, animated: true)
        
    }
    //----输入框代理
    
    func _inputer_changed(__dict: NSDictionary) {
        
    }
    
    func _inputer_closed() {
        
    }
    func _inputer_opened() {
        
    }
    func _inputer_send(__dict: NSDictionary) {
        
        var _to_userName:String = ""
        var _to_userId:String = ""
        
        if _selectedId >= 0{
            var _dict:NSMutableDictionary
            _dict = NSMutableDictionary(dictionary: _dataArray!.objectAtIndex(_dataArray!.count - 1 - _selectedId) as! NSDictionary)
            _to_userName = (_dict.objectForKey("from_userName") as? String)!
            _to_userId = (_dict.objectForKey("from_userId") as? String)!
        }else{
            
        }
       
        
        
        switch _type{
            case CommentList._Type_pic:
                Social_Main._commentPic(_id, __text: __dict.objectForKey("text") as! String, __re: _to_userId, __block: { (__dict) -> Void in
                    
                })
            break
        case CommentList._Type_album:
            Social_Main._commentAlbum(_id, __text: __dict.objectForKey("text") as! String, __re: _to_userId, __block: { (__dict) -> Void in
                
            })
            break
        case CommentList._Type_timeline:
            Social_Main._commentTimeline(_id, __text: __dict.objectForKey("text") as! String, __re: _to_userId, __block: { (__dict) -> Void in
                
            })
            break
        default:
            break
        }
        
        Social_Main._currentUser
        print(MainInterface._userInfo!)
        
        let _d:NSDictionary = NSDictionary(objects:
            
            
            [MainInterface._userInfo!.objectForKey("nickname") as! String,_to_userName,MainInterface._userInfo!.objectForKey("_id") as! String,_to_userId,__dict.objectForKey("text") as! String,MainInterface._userAvatar(MainInterface._userInfo!)], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","userImg"])
        
        
        
        
        _dataArray?.addObject(_d)
        
        _dealWidthDatas(_dataArray!)
        _tableView?.reloadData()
        refreshView()
        
        
        
        
    }
    //----设置位置
    func refreshView(){
        _tableView?.frame = CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH-40)
    }
    
    
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        default:
            print(sender)
        }
        
    }
}


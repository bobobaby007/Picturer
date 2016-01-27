//
//  Manage_pic.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation

protocol Social_pic_delegate:NSObjectProtocol{
    func canceled()
    func delete(picIndex:Int)
    func setCover(picIndex:Int)
    
}

class Social_pic: UIViewController,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate{
    let _barH:CGFloat = 64
    let _gap:CGFloat=15
    let _space:CGFloat=5
    var _titleBase:String = ""
    
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_moreAction:UIButton?
    var _titleT:UITextView?
    
    var _dataArray:NSMutableArray?=NSMutableArray()
    
    var _tapG:UITapGestureRecognizer?
    
    var _currentIndex:Int? = 0
    
    var _picsArray:NSMutableArray?
    var _pic:NSMutableDictionary?
    
    weak var _delegate:Social_pic_delegate?
    var _scrollView:UIScrollView!
    
    var _viewType:String="view"//---view 浏览编辑，标题显示张数 //---select 选择 //--edit 编辑
    
    var _desView:UIView?
    var _desText:UITextView?
    var _desH:CGFloat=0//-----描述面板高度
    
    var _isScrolling:Bool = false
    
    var _range:Int = 0
    
    var _collectionLayout:UICollectionViewFlowLayout?
    var _imagesCollection:UICollectionView?
    
    var _showType:String = "pic" // collection
    
    
    var _like_iconT:UILabel = UILabel()
    var _comment_iconT:UILabel = UILabel()
    var _like_numT:UILabel = UILabel()
    var _comment_numT:UILabel = UILabel()
    
    var _currentPic:PicView?
    
    var _frameH:CGFloat?
    
    var _btn_like:UIButton = UIButton()
    var _btn_comment:UIButton = UIButton()
    var _btn_toShare:UIButton = UIButton()
    var _likeIcon:UIImageView?
    var _likeNumLable:UILabel?
    var _commentIcon:UIImageView?
    var _commentNumLable:UILabel?
    
    var _showingBar:Bool=true{
        didSet{
            UIView.beginAnimations("topA", context: nil)
            UIView.setAnimationDuration(0.2)
            if (_showingBar == true){
                _topBar?.frame=CGRect(x: 0, y: 0, width: _topBar!.frame.width, height: _topBar!.frame.height)
                
                _bottomBar?.frame=CGRect(x: 0, y: self.view.frame.height-_toolsBarH, width: self.view.frame.width, height: _desH)
                UIApplication.sharedApplication().statusBarHidden=false
            }else{
                _topBar?.frame=CGRect(x: 0, y: -_barH, width: _topBar!.frame.width, height: _topBar!.frame.height)
                _bottomBar?.frame=CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: _desH)
                UIApplication.sharedApplication().statusBarHidden=true
            }
            
            UIView.commitAnimations()
        }
    }
    
    var _bottomBar:UIView?
    var _toolsBarH:CGFloat = 39
    var _toolsBar:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.automaticallyAdjustsScrollViewInsets=false
        _getDatas()
        
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor.blackColor()
        
        _bottomBar=UIView(frame:CGRect(x: 0, y: self.view.frame.height-_toolsBarH, width: self.view.frame.width, height: 58))
        _bottomBar?.clipsToBounds = false
        _bottomBar?.backgroundColor=UIColor(white: 0.2, alpha: 0.6)
        
        _desView = UIView(frame: CGRect(x: 0, y: -_desH, width: self.view.frame.width, height: _desH))
        
        _desView?.backgroundColor=UIColor(white: 0, alpha: 0.8)
        
        _desText=UITextView(frame: CGRect(x: 5, y: 5, width: self.view.frame.width-10, height: 0))
        _desText?.textColor = UIColor.whiteColor()
        _desText?.backgroundColor=UIColor.clearColor()
        _desText?.textColor=UIColor.whiteColor()
        _desText?.font = Config._font_social_button
        
        
        _desView?.addSubview(_desText!)
        
        _bottomBar?.addSubview(_desView!)
        
        //self.view.addSubview(_desView!)
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=Config._color_black_bar
        
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_moreAction=UIButton(frame:CGRect(x: self.view.frame.width-30, y: 30, width: 18, height: 18))
        _btn_moreAction?.setImage(UIImage(named: "changeToCollect_icon.png"), forState: UIControlState.Normal)
        _btn_moreAction?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _topBar?.addSubview(_btn_moreAction!)
        
        
        
        
        
        _titleT=UITextView(frame:CGRect(x: 50, y: 10, width: self.view.frame.width-100, height: 60))
        _titleT?.editable = false
        _titleT?.font = Config._font_topbarTitle_at_one_pic
        _titleT?.textColor = Config._color_white_title
        _titleT?.backgroundColor = UIColor.clearColor()
        _titleT?.textColor=UIColor.whiteColor()
        _titleT?.scrollEnabled = false
        _titleT?.textAlignment=NSTextAlignment.Center
        _titleT?.text=""
        
        
        
        _toolsBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: _toolsBarH))
        _toolsBar?.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        
        _bottomBar?.addSubview(_toolsBar!)
        
        
        _btn_like = UIButton(frame: CGRect(x: 14, y: 11, width: 22, height: 18))
        
        _btn_like.setImage(UIImage(named: "like_off"), forState: UIControlState.Normal)
        _btn_like.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_comment = UIButton(frame: CGRect(x: 58, y: 10, width: 24, height: 20))
        _btn_comment.setImage(UIImage(named: "message_icon"), forState: UIControlState.Normal)
        _btn_comment.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_toShare = UIButton(frame: CGRect(x: 109, y: 10, width: 18, height: 17))
        _btn_toShare.setImage(UIImage(named: "to_share_icon"), forState: UIControlState.Normal)
        _btn_toShare.addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _likeIcon = UIImageView(frame: CGRect(x: self.view.frame.width - 95, y: 15, width: 12, height: 10))
        _likeIcon?.image = UIImage(named: "like_sign.png")
        
        _likeNumLable = UILabel(frame: CGRect(x: self.view.frame.width - 21, y: 2.5, width: 12, height: 10))
        _likeNumLable?.textColor = Config._color_social_blue
        _likeNumLable?.font = Config._font_social_button
        
        
        _commentIcon = UIImageView(frame: CGRect(x: self.view.frame.width - 75, y: 15, width: 12, height: 10))
        _commentIcon?.image = UIImage(named: "commentIcon.png")
        
        _commentNumLable = UILabel(frame: CGRect(x: self.view.frame.width - 21, y: 2.5, width: 12, height: 10))
        _commentNumLable?.textColor = Config._color_social_blue
        _commentNumLable?.font = Config._font_social_button
        
        
        _toolsBar?.addSubview(_btn_like)
        _toolsBar?.addSubview(_btn_comment)
        _toolsBar?.addSubview(_btn_toShare)
        _toolsBar?.addSubview(_likeIcon!)
        _toolsBar?.addSubview(_likeNumLable!)
        _toolsBar?.addSubview(_commentIcon!)
        _toolsBar?.addSubview(_commentNumLable!)
        
        
        
       // _like_iconT.frame = CGRect(x: self.view.frame.width-20, y: <#CGFloat#>, width: <#CGFloat#>, height: <#CGFloat#>)
        
        
        
        _collectionLayout=UICollectionViewFlowLayout()
        let _imagesW:CGFloat=(self.view.frame.width-2*_space)/3
        //let _imagesH:CGFloat=ceil(CGFloat(_picsArray!.count)/4)*(_imagesW+_space)
        
        
        _collectionLayout?.minimumInteritemSpacing=_space
        _collectionLayout?.minimumLineSpacing=_space
        _collectionLayout!.itemSize=CGSize(width: _imagesW, height: _imagesW)
        
        _imagesCollection=UICollectionView(frame: CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH), collectionViewLayout: _collectionLayout!)
        
        //_imagesCollection?.frame=CGRect(x: _gap, y: _buttonH+2*_gap, width: self.view.frame.width-2*_gap, height: _imagesH)
        
        
        _imagesCollection?.backgroundColor=UIColor.clearColor()
        _imagesCollection!.registerClass(PicsShowCell.self, forCellWithReuseIdentifier: "PicsShowCell")
        
        _imagesCollection?.delegate=self
        _imagesCollection?.dataSource=self
        
        
       // self.view.addSubview(_imagesCollection!)
        
        self.view.addSubview(_topBar!)
        self.view.addSubview(_bottomBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_titleT!)
        
        
        
        _scrollView=UIScrollView()
        _scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        self.view.insertSubview(_scrollView!, atIndex: 0)
        _scrollView!.bounces=false
        //_scrollView!.bouncesZoom=true
        _scrollView!.maximumZoomScale=1
        _scrollView!.minimumZoomScale = 1
        _scrollView!.showsVerticalScrollIndicator=false
        _scrollView!.showsHorizontalScrollIndicator=false
        _scrollView!.pagingEnabled=true
        
        _scrollView!.delegate=self
        
        _frameH = self.view.bounds.height - 60
        
        //println(_frameH!)
        
        _scrollView!.contentSize=CGSize(width: CGFloat(_picsArray!.count)*self.view.frame.width, height:_frameH! )
        _scrollView?.contentOffset.x = CGFloat(_currentIndex!)*_scrollView!.frame.width
        
        
        _tapG=UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        //_scrollView?.addGestureRecognizer(_tapG!)
        
        _moveToPicByIndex(_currentIndex!)
        
        
        _setLikeNum(120)
        _setComNum(130)
        
        _setuped=true
    }
    
    //-----根据排列顺序调出图片
    func _getPicAtIndex(__index:Int)->NSDictionary{
        var _dict:NSDictionary
        
        if _range == 0{
            _dict = _picsArray?.objectAtIndex(__index) as! NSDictionary
        }else{
            _dict = _picsArray?.objectAtIndex(_picsArray!.count-__index-1) as! NSDictionary
        }
        return _dict
    }
    //外部调用直接到达指定图片
    func _showIndexAtPics(__index:Int,__array:NSArray){
        _picsArray=NSMutableArray(array: __array)
        _currentIndex=__index
        
        if _currentIndex > _picsArray!.count-1{
            _currentIndex = _picsArray!.count-1
        }
        if _currentIndex < 0{
            _currentIndex = 0
        }
    }
    
    func _setLikeNum(_num:Int){
        _likeNumLable?.text = String(_num)
    }
    func _setComNum(_num:Int){
        _commentNumLable?.text = String(_num)
    }
    
    //----设置描述
    func _setDescription(_str:String){
        let __str = _str
        //var __str = "山东阿甘陪我难过的是谁的根是代购嗯孤收到两个色更难过的事都是个"
        _desText?.text = __str
        print("设置描述")
        if  __str == ""{
            _desView?.hidden = true
        }else{
            _desView?.hidden = false
        }
        let _size:CGSize = _desText!.sizeThatFits(CGSize(width: self.view.frame.width-2*_gap, height: CGFloat.max))
        
        _desText?.frame =  CGRect(x: _gap, y: _gap/2, width: self.view.frame.width-2*_gap, height: _size.height)
        _desH = (_desText?.frame.height)!+_gap/2+_gap
        
        _desView?.frame = CGRect(x: 0, y: -_desH, width: self.view.frame.width, height: _desH)
        
        if _showingBar{
            _showingBar = true
        }else{
            _showingBar = false
        }
    }
    
    func _clear(){
        //let _n = _scrollView.subviews.count
        
        for view in _scrollView.subviews{
            view.removeFromSuperview()
            print("remove")
        }
        _scrollView?.removeFromSuperview()
        
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        _showingBar = !_showingBar
    }
    
    func _moveToPicByIndex(__index:Int){
        _currentIndex=__index
        if (_currentIndex!>_picsArray!.count-1){
            _currentIndex=_picsArray!.count-1
        }
        var _str:String = ""
        if _titleBase == ""{
            _str = _titleBase+"\n"+String(_currentIndex!+1)+"/"+String(_picsArray!.count)
        }else{
            _str = _titleBase+"\n"+String(_currentIndex!+1)+"/"+String(_picsArray!.count)
        }
        _titleT?.text = _str
        
        //print(_str)
        
        _pic = NSMutableDictionary(dictionary: (_getPicAtIndex(_currentIndex!)))
        if _pic!.objectForKey("description") != nil{
            _setDescription(_pic!.objectForKey("description") as! String)
        }else{
            _setDescription("")
        }
        _viewInAtIndex(__index)
        _viewInAtIndex(__index+1)
        _viewInAtIndex(__index-1)
    }
    
    //---正在挪动的时候
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView == _scrollView{
            _showingBar = false
            return
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    //---停止挪动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == _scrollView{
            _isScrolling=false
            
            
            let _p:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
            
            _moveToPicByIndex(_p)
            
            //_scrollView?.addGestureRecognizer(_tapG!)
            return
        }
        
    }
    
    func _viewInAtIndex(__index:Int){
        if __index<0{
            return
        }
        if __index>_picsArray!.count-1{
            return
        }
        var _picV:PicView!
        if (_scrollView?.viewWithTag(100+__index) != nil){
            _picV=_scrollView?.viewWithTag(100+__index) as! PicView
            
            //println(_picV.superview?.isEqual(self.view))
        }else{
            _picV=PicView(frame: CGRect(x: CGFloat(__index)*_scrollView!.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            _picV._scaleType = PicView._ScaleType_Fit
            _picV.tag=100+__index
        }
        
        
        if __index == _currentIndex{
            _picV.addGestureRecognizer(_tapG!)
            _currentPic = _picV
        }
        _scrollView!.addSubview(_picV)
        
        
        let __pic:NSDictionary = _getPicAtIndex(__index)
        
        if let _url = __pic.objectForKey("link") as? String{
            _picV!._setPic(NSDictionary(objects: [MainInterface._imageUrl(_url),"file"], forKeys: ["url","type"]), __block:{_ in
            })
            return
        }
        _picV._setPic(__pic,__block: { (__dict) -> Void in
            
        })
    }
    //-----瀑布流代理
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _picsArray!.count
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        _currentIndex = indexPath.item
        _changeTo("pic")
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identify:String = "PicsShowCell"
        let cell = self._imagesCollection?.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as! PicsShowCell
        
        let _pic:NSDictionary
        _pic = _getPicAtIndex(indexPath.item)
        cell._setPic(_pic)
        return cell
    }
    
    func _getDatas(){
        
    }
    
    
    
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_moreAction!:
            
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
    
    func _changeTo(__type:String){
        
        _showType = __type
        switch _showType{
        case "pic":
            _imagesCollection?.removeFromSuperview()
            self.view.insertSubview(_scrollView, atIndex: 0)
            _bottomBar?.hidden=false
            _titleT?.hidden=false
            _moveToPicByIndex(_currentIndex!)
            _scrollView.setContentOffset(CGPoint(x: CGFloat(_currentIndex!)*self.view.frame.width, y: 0), animated: false)
            _btn_moreAction?.setImage(UIImage(named: "changeToCollect_icon.png"), forState: UIControlState.Normal)
            return
        case "collection":
            _scrollView.removeFromSuperview()
            _bottomBar?.hidden=true
            _titleT?.hidden=true
            self.view.insertSubview(_imagesCollection!, atIndex: 0)
            //_imagesCollection?.reloadData()
            _imagesCollection?.scrollToItemAtIndexPath(NSIndexPath(forItem: _currentIndex!, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            _btn_moreAction?.setImage(UIImage(named: "changeToPic.png"), forState: UIControlState.Normal)
            //_showingBar = true
            return
        default:
            return
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //_currentPic?.removeGestureRecognizer(_tapG!)
    }
}

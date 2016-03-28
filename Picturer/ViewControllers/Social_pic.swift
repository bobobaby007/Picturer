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
    let _space:CGFloat=2
    var _titleBase:String = "" //----标题文字
    
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_moreAction:UIButton?
    var _titleT:UITextView?
    
    
    
    var _tapG:UITapGestureRecognizer?
    
    var _currentIndex:Int? = 0
    
    var _picsArray:NSArray?//---图片们
    var _pic:NSDictionary? //----当前图片
    var _commentsArray:NSMutableArray?//---所有图片的评论列表数组
    
    var _likedArray:NSMutableArray?
    
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
    

    
    var _currentPic:PicView?
    
    var _frameH:CGFloat?
    
    var _btn_like:UIButton = UIButton()
    var _btn_comment:UIButton = UIButton()
    var _btn_toShare:UIButton = UIButton()
    var _likeIcon:UIImageView?
    var _likeNumLable:UILabel?//---点赞数字
    var _commentIcon:UIImageView?
    var _commentNumLable:UILabel?//--消息数字
    
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
        
        ImageLoader.sharedLoader._removeAllTask()
        _getDatas()
        
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor.blackColor()
        
        _bottomBar=UIView(frame:CGRect(x: 0, y: self.view.frame.height-_toolsBarH, width: self.view.frame.width, height: 58))
        _bottomBar?.clipsToBounds = false
        _bottomBar?.backgroundColor=UIColor.clearColor()
        
        _desView = UIView(frame: CGRect(x: 0, y: -_desH, width: self.view.frame.width, height: _desH))
        
        _desView?.backgroundColor=UIColor(white: 0, alpha: 0.5)
        
        _desText=UITextView(frame: CGRect(x: 5, y: 4, width: self.view.frame.width-10, height: _desH))
        _desText?.textContainer.lineFragmentPadding = 0
        _desText?.textContainerInset = UIEdgeInsetsZero
        
        _desText?.textAlignment = NSTextAlignment.Justified
        _desText?.backgroundColor=UIColor.clearColor()
        _desText?.textColor=UIColor.whiteColor()
        _desText?.editable = false
        _desText?.selectable = false
        _desText?.font = Config._font_description_at_bottom
        
        
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
        _toolsBar?.backgroundColor = Config._color_black_bar
        
        _bottomBar?.addSubview(_toolsBar!)
        
        
        _btn_like = UIButton(frame: CGRect(x: 15, y: 9.5, width: 23, height: 20))
        
        _btn_like.setImage(UIImage(named: "like_off"), forState: UIControlState.Normal)
        _btn_like.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_comment = UIButton(frame: CGRect(x: 59, y: 9.5, width: 26, height: 20))
        _btn_comment.setImage(UIImage(named: "message_icon"), forState: UIControlState.Normal)
        _btn_comment.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_toShare = UIButton(frame: CGRect(x: 108, y: 11, width: 18, height: 17))
        _btn_toShare.setImage(UIImage(named: "to_share_icon"), forState: UIControlState.Normal)
        _btn_toShare.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _likeIcon = UIImageView(frame: CGRect(x: self.view.frame.width - 95, y: 11, width: 13, height: 20))
        _likeIcon?.image = UIImage(named: "like_sign.png")
        
        _likeNumLable = UILabel()
        _likeNumLable?.textColor = Config._color_social_gray_border
        _likeNumLable?.font =  Config._font_cell_subTitle
        
        
        _commentIcon = UIImageView(frame: CGRect(x: self.view.frame.width - 75, y: 11+4, width: 13, height: 11))
        _commentIcon?.image = UIImage(named: "commentIcon.png")
        
        _commentNumLable = UILabel()
        _commentNumLable?.textColor = Config._color_social_gray_border
        _commentNumLable?.font = Config._font_cell_subTitle
        
        
        _toolsBar?.addSubview(_btn_like)
        _toolsBar?.addSubview(_btn_comment)
        _toolsBar?.addSubview(_btn_toShare)
        _toolsBar?.addSubview(_likeIcon!)
        _toolsBar?.addSubview(_likeNumLable!)
        _toolsBar?.addSubview(_commentIcon!)
        _toolsBar?.addSubview(_commentNumLable!)
        
        
        
       // _like_iconT.frame = CGRect(x: self.view.frame.width-20, y: <#CGFloat#>, width: <#CGFloat#>, height: <#CGFloat#>)
        
        
        
        _collectionLayout=UICollectionViewFlowLayout()
        let _imagesW:CGFloat=(self.view.frame.width-3*_space)/4
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
        
        
        
        
        _setuped=true
    }
    
    //-----根据排列顺序调出图片
    func _getPicAtIndex(__index:Int)->NSDictionary{
        let   _dict = _picsArray?.objectAtIndex(_realIndex(__index)) as! NSDictionary
        print("调出图片:",_dict)
        return _dict
    }
    //----根据排列顺序返回实际index
    func _realIndex(__index:Int)->Int{
        if _range == 0{
            return __index
        }else{
            return _picsArray!.count-__index-1
        }
    }
    
    
    //外部调用直接到达指定图片
    func _showIndexAtPics(__index:Int,__array:NSArray){
        _picsArray=__array
        _currentIndex=__index
        if _currentIndex > _picsArray!.count-1{
            _currentIndex = _picsArray!.count-1
        }
        if _currentIndex < 0{
            _currentIndex = 0
        }
        
        
        _likedArray = []
        
        for var i:Int = 0 ; i<_picsArray?.count ; ++i{
            _likedArray?.addObject(false)
        }
        
    }
    //---消息数字//---点赞数字
    func _setComNumAndLikeNum(__comNum:Int,__LikeNum:Int){
        var _comX:CGFloat
        if __comNum<1{
            _commentIcon?.hidden = true
            _commentNumLable?.hidden = true
            _comX = self.view.frame.width - Config._gap
        }else{
            _commentIcon?.hidden=false
            _commentNumLable?.hidden = false
            
            if __comNum<10000{
                _commentNumLable?.text = String(__comNum)
            }else{
                _commentNumLable?.text = String(Int(__comNum/10000))+"万"
            }
            
            let size:CGSize =  _commentNumLable!.sizeThatFits(CGSize(width: CGFloat.max, height: 17))
            _commentNumLable?.frame = CGRect(x: self.view.frame.width - Config._gap - size.width, y: 10, width: size.width, height: size.height)
            _commentIcon!.frame.origin.x = _commentNumLable!.frame.origin.x - _commentIcon!.frame.width - 5
            _comX = _commentIcon!.frame.origin.x - 13
        }
        
        if __LikeNum<1{
            _likeNumLable?.hidden = true
            _likeIcon?.hidden = true
        }else{
            _likeNumLable?.hidden = false
            _likeIcon?.hidden=false
            
            if __LikeNum<10000{
                _likeNumLable?.text = String(__LikeNum)
            }else{
                _likeNumLable?.text = String(Int(__LikeNum/10000))+"万"
            }
            let size:CGSize =  _likeNumLable!.sizeThatFits(CGSize(width: CGFloat.max, height: 17))
            _likeNumLable?.frame = CGRect(x:_comX - size.width , y: 10, width: size.width, height: size.height)
            _likeIcon!.frame.origin.x = _likeNumLable!.frame.origin.x - _likeIcon!.frame.width - 5
           
        }
        
        
    }
    //---设置是否点赞
    func _setLiked(__set:Bool){
        if __set{
            _btn_like.setImage(UIImage(named: "like_on"), forState: UIControlState.Normal)
        }else{
            _btn_like.setImage(UIImage(named: "like_off"), forState: UIControlState.Normal)
        }
    }
    
    //----设置描述
    func _setDescription(_str:String){
        let __str = _str
        _desText?.text = __str
        //print("设置描述：",__str)
        if  __str == ""{
            _desView?.hidden = true
        }else{
            _desView?.hidden = false
        }
        let _size:CGSize = _desText!.sizeThatFits(CGSize(width: self.view.frame.width-2*_gap, height: CGFloat.max))
        
        _desText?.frame =  CGRect(x: _gap, y: 4, width: self.view.frame.width-2*_gap, height: _size.height)
        
        _desH = (_desText?.frame.height)!+2+_gap
        
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
        
        _pic = _getPicAtIndex(_currentIndex!)
        
        if let _ = _pic?.objectForKey("_id") as? String{
            _btn_like.enabled = true
            _btn_comment.enabled = true
            _btn_toShare.enabled = true
            
            _btn_like.alpha = 1
            _btn_comment.alpha = 1
            _btn_toShare.alpha = 1
        }else{
            _btn_like.enabled = false
            _btn_comment.enabled = false
            _btn_toShare.enabled = false
            
            _btn_like.alpha = 0.2
            _btn_comment.alpha = 0.2
            _btn_toShare.alpha = 0.2
        }
        
        
        if _pic!.objectForKey("description") != nil{
            _setDescription(_pic!.objectForKey("description") as! String)
        }else{
            _setDescription("")
        }        
        
        if let _comments = _pic!.objectForKey("comments") as? Int{
            _setComNumAndLikeNum(_comments, __LikeNum: _pic!.objectForKey("likes") as! Int)
        }else{
            _setComNumAndLikeNum(0, __LikeNum: 0)
        }
        
        
        _setLiked(_likedArray?.objectAtIndex(_currentIndex!) as! Bool)
        
        
        
        
        
        
        
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
            
        }else{
            _picV._setPic(__pic,__block: { (__dict) -> Void in
                
            })
        }
        
        
        
        
        
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
        case  _btn_like:
            if _hasLikedAtIndex(_currentIndex!){
                _removeLikeAtIndex(_currentIndex!)
            }else{
                _addLikeAtIndex(_currentIndex!)
            }
            
            _setLiked(_likedArray?.objectAtIndex(_currentIndex!) as! Bool)

            break
        case _btn_comment: //----评论
            if let _id = _pic?.objectForKey("_id") as? String{
                let _controller:CommentList = CommentList()
                _controller._type = CommentList._Type_pic
                _controller._id = _id
                _controller._dealWidthDatas(NSArray())
                self.navigationController?.pushViewController(_controller, animated: true)
            }
            
            
        default:
            print(sender)
        }
        
    }
    
    
    //----判断是否已经有点过赞
    
    func _hasLikedAtIndex(__indexId:Int)->Bool{
        
        if __indexId>=self._likedArray?.count{
            return false
        }
        
        if (self._likedArray![__indexId] as? Bool) ==  true {
            return true
        }
        return false
    }
    //----添加点赞
    
    func _addLikeAtIndex(__index:Int){
        if _hasLikedAtIndex(__index){
            return
        }
        let _arr:NSMutableArray = NSMutableArray(array: self._likedArray!)
        _arr[__index] = true
        self._likedArray = _arr
        
        
        let _thePic:NSMutableDictionary = NSMutableDictionary(dictionary: _picsArray!.objectAtIndex(__index) as! NSDictionary)
        
        if var _likes = _thePic.objectForKey("likes") as? Int{
            _likes = _likes+1
            _thePic.setObject(_likes, forKey: "likes")
        }
        
        
        
        
        _setComNumAndLikeNum(_thePic.objectForKey("comments") as! Int, __LikeNum: _thePic.objectForKey("likes") as! Int)
        let _picArr:NSMutableArray = NSMutableArray(array: _picsArray!)
        _picArr[__index] = _thePic
        _picsArray = _picArr
    }
    //----取消点赞
    
    func _removeLikeAtIndex(__index:Int){
        if _hasLikedAtIndex(__index){
            
        }else{
            return
        }
        let _arr:NSMutableArray = NSMutableArray(array: self._likedArray!)
        _arr[__index] = false
        self._likedArray = _arr
        
        
        let _thePic:NSMutableDictionary = NSMutableDictionary(dictionary: _picsArray!.objectAtIndex(__index) as! NSDictionary)
        
        if var _likes = _thePic.objectForKey("likes") as? Int{
            _likes = _likes-1
            _thePic.setObject(_likes, forKey: "likes")
            
            
        }
        _setComNumAndLikeNum(_thePic.objectForKey("comments") as! Int, __LikeNum: _thePic.objectForKey("likes") as! Int)
        let _picArr:NSMutableArray = NSMutableArray(array: _picsArray!)
        _picArr[__index] = _thePic
        _picsArray = _picArr
    }
    //-----切换查看模式，瀑布流或滑动
    func _changeTo(__type:String){
        _showType = __type
        switch _showType{
        case "pic":
            _imagesCollection?.removeFromSuperview()
            self.view.insertSubview(_scrollView, atIndex: 0)
            _bottomBar?.hidden=false
            
            _titleT?.frame.origin.y = 10
            
            _moveToPicByIndex(_currentIndex!)
            _scrollView.setContentOffset(CGPoint(x: CGFloat(_currentIndex!)*self.view.frame.width, y: 0), animated: false)
            _btn_moreAction?.setImage(UIImage(named: "changeToCollect_icon.png"), forState: UIControlState.Normal)
            return
        case "collection":
            _scrollView.removeFromSuperview()
            _bottomBar?.hidden=true
            _titleT?.frame.origin.y = 20
            _titleT?.text = _titleBase
            self.view.insertSubview(_imagesCollection!, atIndex: 0)
            //_imagesCollection?.reloadData()
            _imagesCollection?.scrollToItemAtIndexPath(NSIndexPath(forItem: _currentIndex!, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            _btn_moreAction?.setImage(UIImage(named: "changeToPic_white"), forState: UIControlState.Normal)
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

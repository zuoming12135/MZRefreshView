//
//  MZRefreshHeader.swift
//  MZRefreshView
//
//  Created by Michael_Zuo on 2018/3/18.
//  Copyright © 2018年 Michael_Zuo. All rights reserved.
//

import UIKit

enum MZRefreshState {
    case drawing
    case loading
}
typealias refreshCallBack = () -> Void
class MZRefreshHeader: UIView {
    
    weak var scrollView: UIScrollView? {
        willSet {
            scrollView?.removeObserver(self, forKeyPath: "contentOffset")
            scrollView?.removeObserver(self, forKeyPath: "pan.state")
            scrollView?.removeObserver(self, forKeyPath: "frame")
        }
        didSet {
            scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            scrollView?.addObserver(self, forKeyPath: "pan.state", options: .new, context: nil)
            scrollView?.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            
        }
    }
    var drawingImages: [String] = [] //下拉过程中的动画图片
    var loadingImgs: [UIImage] = [] //下拉加载过程中的动画图片
    var _isTrigged: Bool = false
    var _state: MZRefreshState?
    var _refreshView: UIImageView?
    var _moveView: UIImageView?
    var callBack: refreshCallBack?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         _refreshView = UIImageView(frame: CGRect(x:( self.mz_width - kRefreshViewWidth) / 2, y: (self.mz_height - kRefreshViewHeight) / 2, width: kRefreshViewWidth, height: kRefreshViewHeight)) // 居中显示
        _refreshView?.contentMode = .scaleAspectFit
        _moveView = UIImageView(frame: CGRect(x:( self.mz_width - kMoveViewWidht) / 2, y: (self.mz_height - kMoveViewHeight) / 2, width: kMoveViewWidht, height: kMoveViewHeight)) // 居中显示
        _moveView?.contentMode = .scaleAspectFit
        self.addSubview(_refreshView!)
        _refreshView?.addSubview(_moveView!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 加载结束
    func endLoading() {
        if _state == MZRefreshState.loading {
            _isTrigged = false
        }
        setState(.drawing)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }, completion: nil)
    }
    
    /// 移除观察者
    func removeObservers()  {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        scrollView?.removeObserver(self, forKeyPath: "pan.state")
        scrollView?.removeObserver(self, forKeyPath: "frame")
    }
    //MARK:KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let scrollView = self.scrollView {
            if scrollView.contentOffset.y <=  0.0 { // 开始向下拽了
                // 判断是什么属性被监听了
                if keyPath == "pan.state" { // 拖拽手势
                    if scrollView.panGestureRecognizer.state == .ended && _isTrigged {
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction,.beginFromCurrentState], animations: {
                            scrollView.contentOffset = CGPoint(x: 0, y:  0 - MZRefreshHeaderHeight)
                            scrollView.contentInset = UIEdgeInsets(top: MZRefreshHeaderHeight, left: 0, bottom: 0, right: 0)
                        }, completion: { (finished) in
                             // 刷新完成的回调给开发者
                            if self.callBack != nil {
                                self.callBack!()
                            }
                        })
                
                    }
                } else if keyPath == "contentOffset" { // 偏移量发生了变化
                    scrollViewContentOffsetChanged()
                }  else if keyPath == "frame" {
                        self.frame = CGRect(x: self.mz_left, y: self.mz_top, width: scrollView.mz_width, height: scrollView.mz_height)
                }
            }
        }
        
        
    }
    
    //MARK: private
    // 在滑动过程中
    private func scrollViewContentOffsetChanged() {
        if _state != MZRefreshState.loading {
            if let scrollView  = self.scrollView {
                if scrollView.isDragging && scrollView.contentOffset.y < (0 - MZRefreshHeaderHeight) && !_isTrigged { //
                    _isTrigged = true
                    setState(.loading)
                } else {
                    if scrollView.isDragging && scrollView.contentOffset.y > (0 - MZRefreshHeaderHeight) {
                        _isTrigged = false
                        
                    }
                    setState(.drawing)
                }
            }
        }
    }
    
    // 设置状态
    private func setState(_ state: MZRefreshState) {
        if let scrollView = self.scrollView {
            var offset: CGFloat  = 0 - scrollView.contentOffset.y
            let ingoreOffSet: CGFloat = 10
            if offset < 0.0  {// 不是往下拽，而是没事干往上顶
                offset = 0.0
            }
            if offset > MZRefreshHeaderHeight  { // 小伙子太心急拉的太狠了，偏移量都比我们的刷新视图妹妹高了，这怎么行了
                offset = MZRefreshHeaderHeight
            }
            
            switch state {
            case .drawing: // 在拽的过程当中
                _refreshView?.stopAnimating()
                // 拽的过程中效果是两个view往中间靠
                _refreshView?.image = UIImage(named: self.drawingImages[0])
                _moveView?.image = UIImage(named: self.drawingImages[1])
                // 控制下这两个view的frame
                var refreshViewHeight: CGFloat = 0.0
                var moveViewHeight: CGFloat = 0.0
                if offset < MZRefreshHeaderHeight {
                    if offset > ingoreOffSet {
                        refreshViewHeight = (offset - ingoreOffSet)
                        moveViewHeight = kMoveViewHeight/(MZRefreshHeaderHeight - ingoreOffSet - 1)*refreshViewHeight
                    }
                }else {
                    refreshViewHeight = (MZRefreshHeaderHeight - ingoreOffSet - 1)
                    moveViewHeight = kMoveViewHeight
                }
                
                let refreshViewWidth = refreshViewHeight/(MZRefreshHeaderHeight - ingoreOffSet - 1)*64
                let moveViewWidth =  moveViewHeight/kMoveViewHeight*kMoveViewWidht
                _moveView?.isHidden = false
                _refreshView?.frame = CGRect(x: (self.mz_width - refreshViewWidth / (MZRefreshHeaderHeight - ingoreOffSet - 1) * 64) * 0.5 + 5, y: self.mz_height - offset + (offset-refreshViewHeight) * 0.5 + 1, width: refreshViewWidth, height: refreshViewHeight)

               let x1 = 50 * (kMoveViewHeight - moveViewWidth) / kMoveViewHeight
                let x = (_refreshView?.mz_width)! - moveViewWidth + 20 + x1
                let y = 3 * moveViewWidth / kMoveViewHeight + 2
                _moveView?.frame = CGRect(x: x, y: y, width: moveViewWidth, height: moveViewHeight)
       
            case .loading:
                _moveView?.isHidden = true
                _refreshView?.frame = CGRect(x: (self.mz_width - kRefreshViewWidth) * 0.5, y: self.mz_height - offset + (offset-kRefreshViewHeight) * 0.5, width: kRefreshViewWidth, height: kRefreshViewHeight)
                _refreshView?.animationImages = self.loadingImgs
                    _refreshView?.animationDuration = TimeInterval(self.loadingImgs.count / Int(20))
                _refreshView?.startAnimating() // 开始动起来了
            }
        }
        _state = state
    }
    deinit {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        scrollView?.removeObserver(self, forKeyPath: "pan.state")
        scrollView?.removeObserver(self, forKeyPath: "frame")
    }
}

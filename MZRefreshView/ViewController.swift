//
//  ViewController.swift
//  MZRefreshView
//
//  Created by Michael_Zuo on 2018/3/18.
//  Copyright © 2018年 Michael_Zuo. All rights reserved.
//
// 分析 下拉刷新控件
// 上拉加载
/* 下拉刷新
 1.下拉刷新控件有两个状态，下拉拽的过程和松手后加载的过程
 2.向下拉的过程中是两个view的重叠过程 refreshView和movevView都只是一张图片在控制fram
 3.加载过程就就是一个refreshView图片数组在不断的播放不同帧的图片
 
 */

/*
 上拉刷新
 */
import UIKit

class ViewController: UIViewController {
    
    
    var refreshHeaer: MZRefreshHeader?
    
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tb.addSubview(self.refreshHeader)
        self.refreshHeader.callBack = ({ // 下拉loading的回调
            
        })
        
    }
    
    //MARK: lazy init refreshHeader
    lazy var refreshHeader: MZRefreshHeader = {
        let header =  MZRefreshHeader(frame: CGRect(x: 0, y: 0 - MZRefreshHeaderHeight, width: self.view.bounds.size.width, height: MZRefreshHeaderHeight))
        header.scrollView = self.tb
        header.drawingImages = ["refresh_hill.png","refresh_plane.png"]
        var array: [UIImage] = []
        for index in 1..<8 {
            let imgStr = "refresh_gif\(index)"
            let img = UIImage(named: imgStr)!
            array.append(img)
        }
        header.loadingImgs = array
        return header
    }()
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.refreshHeader.endLoading()
    }
}




//
//  ViewController.swift
//  MZRefreshView
//
//  Created by Michael_Zuo on 2018/3/18.
//  Copyright © 2018年 Michael_Zuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var refreshHeaer: MZRefreshHeader?
    
    @IBOutlet weak var tb: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshHeaer = MZRefreshHeader(frame: CGRect(x: 0, y: 0 - MZRefreshHeaderHeight, width: self.view.bounds.size.width, height: MZRefreshHeaderHeight))
        self.refreshHeaer?.scrollView = self.tb
        
        self.refreshHeaer?.drawingImages = ["refresh_hill.png","refresh_plane.png"]
        var array: [String] = []
        for index in 0..<9 {
            array.append("refresh_gif\(index)")
        }
         self.refreshHeaer?.loadingImgs = array
        self.refreshHeaer?.backgroundColor = UIColor.blue
        self.tb.addSubview(self.refreshHeaer!)
        self.view.backgroundColor = UIColor.red
        self.tb.backgroundColor = UIColor.yellow
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
        
    }

    


}


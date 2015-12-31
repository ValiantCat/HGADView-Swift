//
//  HGADView.swift
//  HGADView
//
//  Created by nero on 15/12/30.
//  Copyright © 2015年 nero. All rights reserved.
//

import UIKit
private let kADViewHeight = 150

public class HGADView<ImageType>: UIView,UIScrollViewDelegate {
    public typealias ADDidClickClosure = (Int) -> Void
    public typealias ADViewLoadImageClosure = (UIImageView,ImageType) -> Void
    public var imageDidClick:ADDidClickClosure?
    public var loadImage:ADViewLoadImageClosure?
    public var images = [ImageType]() {
        didSet {
            pageControl.numberOfPages = images.count
            reloadData()
            timer?.invalidate()
            timer = nil
            if images.count > 1 { addTimer() }
        }
        
    }
    //   MARK: - 移除定时器
    public func removeTimer() {
        timer?.invalidate()
        timer = nil
        
    }
    //    MARK: - 添加定时器
    public func addTimer() {
        guard  images.count > 0 else  {return;}
        timer = NSTimer(timeInterval: 2.5, target: self, selector: Selector("timerScrollImage"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        NSRunLoop.currentRunLoop().runMode(UITrackingRunLoopMode, beforeDate: NSDate())
        
    }
    
    
    
    private var currentImageArray = [ImageType]()
    private var currentPage = 0
    
    private var timer:NSTimer?
    private lazy var scrollView:UIScrollView = {
        
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.contentSize = CGSize(width: self.frame.width * 3, height: self.frame.height)
        scrollView.contentOffset = CGPoint(x: self.frame.width, y: 0)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
        
    }()
    private lazy var pageControl:UIPageControl = {
        let pageWidth = self.frame.width * 0.25
        let pageHeight:CGFloat = 20.0
        let pageX = self.frame.width - pageWidth - 10.0
        let pageY = self.frame.height -  30.0
        let pageControl = UIPageControl(frame: CGRect(x: pageX, y: pageY, width: pageWidth, height: pageHeight))
        pageControl.userInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        return pageControl
    }()

    @objc private func timerScrollImage() {
        reloadData()
        scrollView.setContentOffset(CGPoint(x: frame.width * 2.0 , y: 0) , animated: true)
    }
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
        addSubview(pageControl)
        
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        scrollView.delegate = nil
        timer?.invalidate()
        timer = nil
    }
    
    private func reloadData() {
        
        //设置页数
        
        pageControl.currentPage = currentPage
        //        //根据当前页取出图片
        getDisplayImagesWithCurpage()
        //        //从scrollView上移除所有的subview
        scrollView.subviews.forEach({$0.removeFromSuperview()})
        
        for i in 0..<3 {
            let frame = CGRect(x: self.frame.width * CGFloat(i), y: 0, width: self.frame.width, height: self.frame.height)
            let imageView = UIImageView(frame: frame)
            imageView.userInteractionEnabled = true
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
            // 将加载图片的内容放给外部   专业无论你说直接加载 还是各种第三方库都能            
            loadImage?(imageView,currentImageArray[i])
            let tap = UITapGestureRecognizer(target: self, action: Selector("tapImage"))
            imageView.addGestureRecognizer(tap)
        }
        
        
        
        
    }
    private func  getDisplayImagesWithCurpage() {
        //取出开头和末尾图片在图片数组里的下标
        var front = currentPage - 1
        var last = currentPage + 1
        //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
        if currentPage == 0 {
            front = images.count - 1
        }
        //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
        if currentPage == images.count - 1 {
            last = 0
        }
        //如果当前图片数组不为空，则移除所有元素
        if currentImageArray.count > 0 {
            currentImageArray = [ImageType]()
        }
        //当前图片数组添加图片
        currentImageArray.append(images[front])
        currentImageArray.append(images[currentPage])
        currentImageArray.append(images[last])
        
        
        
    }
    @objc private func tapImage() {
        imageDidClick?(currentPage)
        
    }
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
        if scrollView.contentOffset.x >= frame.width * 2.0 {
            //当前图片位置+1
            currentPage += 1
            //如果当前图片位置超过数组边界，则设置为0
            if currentPage == images.count {
                currentPage = 0
            }
            reloadData()
            //设置scrollView偏移位置
            scrollView.contentOffset = CGPoint(x: frame.width, y: 0)
        }else if scrollView.contentOffset.x <= 0.0{
            currentPage -= 1
            if currentPage == -1 {
                currentPage = images.count - 1
            }
            reloadData()
            //设置scrollView偏移位置
            scrollView.contentOffset = CGPoint(x: frame.width, y: 0)
        }
        
    }
    // MARK: 停止滚动的时候回调
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: frame.width, y: 0), animated: true)
    }
    //    MARK: 开始拖拽的时候调用
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // 停止定时器(一旦定时器停止了,就不能再使用)
        removeTimer()
    }
    //    MARK: 停止拖拽的时候调用
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
}




//
//  WYKSwiper.swift
//  WYKSwiper
//
//  Created by 王亚坤 on 14/12/2016.
//  Copyright © 2016 yaomaitong. All rights reserved.
//

import UIKit

@objc
protocol WYKSwiperDelegate : NSObjectProtocol {
    @objc optional func onSwiperImageClicked(url: NSURL)
    @objc optional func onSwiperPageNumberChanged(pageNumber: Int)
}

class WYKSwiper: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
//MARK: - Preload Values
    let kPaginationDotColor = UIColor(red: 240 / 255.0, green: 240 / 255.0, blue: 240 / 255.0, alpha: 1)
    let kPaginationDotColorCurrent = UIColor(red: 50 / 255.0, green: 181 / 255.0, blue: 237 / 255.0, alpha: 1)
    let kBackgroundColor = UIColor(red: 250 / 255.0, green: 250 / 255.0, blue: 250 / 255.0, alpha: 1)
    let kPageControlUnitWidth: CGFloat = 16
    let kPageControlHeight: CGFloat = 30
    
//MARK: - Properties
    var swiperDelegate: WYKSwiperDelegate?
    var svMain = UIScrollView(frame: CGRect.zero)
    var ivList = [UIImageView]()
    var datasource = [Any]()
    var datasourceLinks = [NSURL?]()
    var pageControl = UIPageControl()
    var pageControlUnitWidth: CGFloat = 16
    var pageControlHeight: CGFloat = 30
    var pageControlAlignment = NSTextAlignment.center
    var currentPage = 0
    
//MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initProperties() {
        self.backgroundColor = kBackgroundColor
        
        svMain = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        svMain.showsVerticalScrollIndicator = false
        svMain.showsHorizontalScrollIndicator = false
        svMain.delegate = self
        svMain.isPagingEnabled = true
        self.addSubview(svMain)
        
        pageControlUnitWidth = kPageControlUnitWidth
        pageControlHeight = kPageControlHeight
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        var iv = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true;
        iv.isUserInteractionEnabled = true;
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(currentPageClicked))
        iv.addGestureRecognizer(tap1)
        svMain.addSubview(iv)
        ivList.append(iv)
        iv = UIImageView(frame: CGRect(x: 0, y: width, width: width, height: height))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true;
        iv.isUserInteractionEnabled = true;
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(currentPageClicked))
        iv.addGestureRecognizer(tap2)
        svMain.addSubview(iv)
        ivList.append(iv)
        iv = UIImageView(frame: CGRect(x: 0, y: width * 2, width: width, height: height))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true;
        iv.isUserInteractionEnabled = true;
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(currentPageClicked))
        iv.addGestureRecognizer(tap3)
        svMain.addSubview(iv)
        ivList.append(iv)
        
        pageControl.isHidden = true
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = kPaginationDotColor
        pageControl.currentPageIndicatorTintColor = kPaginationDotColorCurrent
        pageControl.currentPage = currentPage
        pageControl.addTarget(self, action: #selector(pageControlPageChanged), for: .valueChanged)
        self.addSubview(pageControl)
        self.bringSubview(toFront: pageControl)
    }
    
//MARK: - Private Methods
    func refreshCurrentUI() {
        //设置PageControl大小和位置
        if(datasource.count < 2) {
            self.pageControl.isHidden = true
        } else {
            self.pageControl.isHidden = false
            self.pageControl.numberOfPages = datasource.count
            var width = pageControlUnitWidth * CGFloat(datasource.count)
            if width > self.frame.size.width {
                width = self.frame.size.width
            }
            self.pageControl.frame = CGRect(x: (self.frame.size.width - width) / 2, y: self.frame.size.height - pageControlHeight, width: width, height: pageControlHeight)
        }
        //设置各个UIImageView的frame和image
        var ivIndex = -1;
        for i in 0..<ivList.count {
            if ivList[i].frame.origin.x == svMain.contentOffset.x {
                ivIndex = i
                break
            }
        }
        let vWidth = svMain.frame.size.width
        let vHeight = svMain.frame.size.height
        if ivIndex < 0 {
            ivIndex = 1
        }
        ivList[ivIndex].frame = CGRect(x: vWidth * CGFloat(self.pageControl.currentPage), y: 0, width: vWidth, height: vHeight)
        ivList[ivIndex].image = datasource[self.pageControl.currentPage] as? UIImage
        let preIndex = (ivIndex + 3 - 1) % 3
        if(self.pageControl.currentPage > 0){
            ivList[preIndex].frame = CGRect(x: vWidth * CGFloat(self.pageControl.currentPage - 1), y: 0, width: vWidth, height:vHeight)
            ivList[preIndex].image = datasource[self.pageControl.currentPage - 1] as? UIImage
            ivList[preIndex].isHidden = false
        } else {
            ivList[preIndex].isHidden = true
        }
        let postIndex = (ivIndex + 1) % 3
        if(self.pageControl.currentPage < datasource.count - 1) {
            ivList[postIndex].frame = CGRect(x: vWidth * CGFloat(self.pageControl.currentPage + 1), y: 0, width: vWidth, height:vHeight)
            ivList[postIndex].image = datasource[self.pageControl.currentPage + 1] as? UIImage
            ivList[postIndex].isHidden = false
        } else {
            ivList[postIndex].isHidden = true
        }
    }
    
//MARK: - Outside Methods
    func setDataSource(data:Array<Any>, links:Array<Any>) {
        datasource = [UIImage]()
        datasourceLinks = [NSURL?]()
        for i in 0..<data.count {
            var image: UIImage?
            var urllink: NSURL?
            let dataItem = data[i]
            if dataItem is String {
                if dataItem as! String != "" {
                let url = NSURL(string: dataItem as! String)!
                    let request = NSURLRequest(url: url as URL)
                    do {
                        let imgData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)
                        image = UIImage(data: imgData)!
                    } catch { }
                }
            } else if dataItem is NSURL {
                let request = NSURLRequest(url: dataItem as! URL)
                do {
                    let imgData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: nil)
                    image = UIImage(data: imgData)!
                } catch { }
            } else if dataItem is UIImage {
                image = dataItem as? UIImage
            }
            if image == nil {
                image = UIImage(named: "default_image")
            }
            if(links.count > i) {
                let linkItem = links[i]
                if linkItem is String {
                    if linkItem as! String != "" {
                        urllink = NSURL(string: linkItem as! String)
                    } else {
                        urllink = nil
                    }
                } else if linkItem is NSURL {
                    urllink = linkItem as? NSURL
                } else {
                    urllink = nil
                }
            }
            datasource.append(image!)
            datasourceLinks.append(urllink)
        }
        self.pageControl.currentPage = 0
        if datasource.count > 0 {
            svMain.contentSize = CGSize(width: self.frame.size.width * CGFloat(datasource.count), height: self.frame.size.height)
        } else {
            svMain.contentSize = self.frame.size
        }
        refreshCurrentUI()
    }
    
//MARK: - Response Methods
    func pageControlPageChanged() {
        if self.currentPage != self.pageControl.currentPage {
            self.currentPage = self.pageControl.currentPage
            let unitWidth = self.frame.size.width
            UIView.animate(withDuration: 0.3) {
                self.svMain.contentOffset = CGPoint(x: unitWidth * CGFloat(self.currentPage), y: 0)
                if (self.swiperDelegate?.responds(to: #selector(WYKSwiperDelegate.onSwiperPageNumberChanged)))! {
                    self.swiperDelegate?.onSwiperPageNumberChanged!(pageNumber: self.currentPage)
                }
            }
            refreshCurrentUI()
        }
    }
    
    func currentPageClicked() {
        if self.currentPage < 0 {
            return
        }
        if (self.swiperDelegate?.responds(to: #selector(WYKSwiperDelegate.onSwiperImageClicked(url:))))! {
            if datasourceLinks.count > self.currentPage && datasourceLinks[self.currentPage] != nil {
                self.swiperDelegate?.onSwiperImageClicked!(url: datasourceLinks[self.currentPage]!)
            }
        }
    }
    
//MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let unitWidth = self.frame.size.width
        let page = Int(scrollView.contentOffset.x / unitWidth)
        if(page == self.currentPage) {
            return
        }
        self.currentPage = page
        self.pageControl.currentPage = page
        if (self.swiperDelegate?.responds(to: #selector(WYKSwiperDelegate.onSwiperPageNumberChanged)))! {
            self.swiperDelegate?.onSwiperPageNumberChanged!(pageNumber: page)
        }
        refreshCurrentUI()
    }
//MARK: - Setters
    func setBackgroundColor(bgColor: UIColor) {
        self.backgroundColor = bgColor
    }
    
    func setFrame(frame: CGRect) {
        self.frame = frame
        refreshCurrentUI()
    }
    
    func setPageControlStyle(posistion: NSTextAlignment, height: CGFloat, unitWidth: CGFloat) {
        pageControlHeight = height
        pageControlUnitWidth = unitWidth
        pageControlAlignment = posistion
        refreshCurrentUI()
    }
}

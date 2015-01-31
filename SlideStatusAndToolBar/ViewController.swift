//
//  ViewController.swift
//  SlideStatusAndToolBar
//
//  Created by yamakadoh on 1/31/15.
//  Copyright (c) 2015 yamakadoh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {

    let webView = UIWebView()
    var isShowStatusBar = false // ステータスバーの表示状態
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.delegate = self
        webView.frame = self.view.bounds
        self.view.addSubview(webView)
        
        let url = NSURL(string: "http://www.apple.com")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        // ジェスチャー
        // タップ
        var gestureTap = UITapGestureRecognizer(target: self, action: "onTap:")
        gestureTap.delegate = self
        self.view.addGestureRecognizer(gestureTap)
        // ドラッグ
        var gesturePan = UIPanGestureRecognizer(target: self, action: "onPan:")
        gesturePan.delegate = self
        self.view.addGestureRecognizer(gesturePan)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        println("webViewDidStartLoad")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        println("webViewDidFinishLoad")
    }
    
    // ステータスバーの表示設定
    override func prefersStatusBarHidden() -> Bool {
        return !isShowStatusBar
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Slide
    }
    
    // タップイベントハンドラ
    func onTap(sender: UITapGestureRecognizer) -> Void {
        println("[onTap]called")
        
        // ステータスバーとツールバーの表示を切り替える
        isShowStatusBar = !isShowStatusBar
        UIView.animateWithDuration(0.3, animations: {[unowned self]() -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        })
        
    }
    
    // ドラッグイベントハンドラ
    func onPan(sender: UIPanGestureRecognizer) -> Void {
        println("[onPan]called")
        
        let point: CGPoint = sender.translationInView(self.view)
        println("Point = (\(point.x), \(point.y))")
        
        // 上方向にドラッグ(WebViewのボトムへの移動操作)：ステータスバーとツールバーを非表示にする
        // 下方向にドラッグ(WebViewのトップへの移動操作)：ステータスバーとツールバーを表示する
        if sender.state == UIGestureRecognizerState.Began {
            println(".Began")
        }
        if sender.state == UIGestureRecognizerState.Changed {
            println(".Changed")
        }
        if sender.state == UIGestureRecognizerState.Ended {
            println(".Ended")
            // WebViewのボトムへの移動操作か
            let isDragUp: Bool = point.y < 0    // TODO: しきい値を設定してちゃんと判定する
            if isDragUp {
                isShowStatusBar = false
                UIView.animateWithDuration(0.3, animations: {[unowned self]() -> Void in
                    self.setNeedsStatusBarAppearanceUpdate()
                })
            }

            // WebViewのトップへの移動操作か
            let isDragDown: Bool = point.y > 0    // TODO: しきい値を設定してちゃんと判定する
            if isDragDown {
                isShowStatusBar = true
                UIView.animateWithDuration(0.3, animations: {[unowned self]() -> Void in
                    self.setNeedsStatusBarAppearanceUpdate()
                })
            }
        }
    }
    
    // UIGestureRecognizerDelegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // 本メソッドを実装しない(trueを返さない)と、自作したジェスチャイベントハンドラが呼ばれない
        return true
    }
}


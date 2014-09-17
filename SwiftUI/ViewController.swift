//
//  ViewController.swift
//  SwiftUI
//
//  Created by 斉藤 祐輔 on 2014/09/11.
//  Copyright (c) 2014年 JIBUNSTYLE, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- アニメーションに関する設定値
    let duration = 0.7
    let delay = 0.0
    let damping = 0.7
    let velocity = 0.7
    
    // MARK:- Storyboardと紐付ける変数
    @IBOutlet weak var appleImageView: UIImageView!
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    
    // MARK:- UI Dynamicsで使う変数
    var animator : UIDynamicAnimator?
    var attachmentBehavior : UIAttachmentBehavior?
    var snapBehavior : UISnapBehavior?
    
    // MARK:- Viewのライフイベントを扱うメソッド
    // Viewがロードされた時（まだ表示はされていない）
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // このViewControllerが持つViewをダイナミックViewに設定
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    // Viewが表示された時
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 初めは小さくしておく
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let translate = CGAffineTransformMakeTranslation(0, -200)
        self.appleImageView.transform = CGAffineTransformConcat(scale, translate)
        
        // 大きくするアニメーション
        UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: nil, animations: {
                let scale = CGAffineTransformMakeScale(1, 1)
                let translate = CGAffineTransformMakeTranslation(0, 0)
                self.appleImageView.transform = CGAffineTransformConcat(scale, translate)
            },
            completion: { finished in
        })
    }
    
    // OSからメモリが足りない！と警告が来た時
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- アクションメソッド
    // Pan（抑えたままスライドする）ジェスチャーを検知した時に呼ばれる
    // ジェスチャー中は呼ばれ続けることに注意
    @IBAction func panHandler(sender: UIPanGestureRecognizer) {

        // このViewControllerが持つViewから見て、ジェスチャーを検出点（sender)がどこにあるのかを取得
        var fingerPosition = sender.locationInView(self.view);
        

        if sender.state == .Began {
        /* ジェスチャーが始まった時の処理 */
            
            animator?.removeBehavior(attachmentBehavior) // 前回のジェスチャーの最後に付けたsnapBehaviorを削除
            
            // ジャスチャー検出点とリンゴロゴの真ん中の差を計算（この値の分だけロゴが傾いていく）
            let centerOffset = UIOffsetMake(fingerPosition.x - appleImageView.center.x, fingerPosition.y - appleImageView.center.y)
            
            // リンゴに指の位置に対してバネで連結された様に寄っていく振る舞いを追加
            attachmentBehavior = UIAttachmentBehavior(item: appleImageView, offsetFromCenter: centerOffset, attachedToAnchor: fingerPosition)
            attachmentBehavior?.frequency = 0
            
            animator!.addBehavior(attachmentBehavior)

        } else if sender.state == .Changed {
        /* ジェスチャーが継続している間の処理 */
            
            // 寄っていく位置を更新
            attachmentBehavior!.anchorPoint = fingerPosition
            
        } else if sender.state == .Ended {
        /* ジェスチャーが終わった時の処理 */
        
            animator?.removeBehavior(attachmentBehavior)
        
            // リンゴにViewの中央にスナップを利かせて戻っていく振る舞いを追加
            snapBehavior = UISnapBehavior(item: appleImageView, snapToPoint: self.view.center)
            animator?.addBehavior(snapBehavior)
            
            /* 指が離れた場所が画中央から下に100pxより大きかったら、リンゴに重力を与える */
            // このViewControllerが持つViewと指の離れた点の相対位置を取得
            let translation = sender.translationInView(view)
            println("translation.y: \(translation.y)")
            
            if translation.y > 100 {
                animator?.removeAllBehaviors()
                
                // リンゴに重力で下に落ちる振る舞いを追加
                let gravity = UIGravityBehavior(items: [appleImageView])
                gravity.gravityDirection = CGVectorMake(0, 10)
                animator?.addBehavior(gravity)
                
                // 処理を指定時間後に実行する
                // ここでは0.3秒後に refreshViewメソッドを呼ぶようにしている
                dispatch_after(
                    dispatch_time(
                        DISPATCH_TIME_NOW,
                        Int64(0.3 * Double(NSEC_PER_SEC))
                    ),
                    dispatch_get_main_queue(), {
                        self.refreshView()
                    }
                )
            }
        }
    }
    
    func refreshView() {
        animator?.removeAllBehaviors()
        appleImageView.center = view.center
        viewDidAppear(true)
    }

}


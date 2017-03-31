//
//  ViewController.swift
//  ConcentricProgressRingView
//
//  Created by Dan Loewenherz on 06/30/2016.
//  Copyright (c) 2016 Dan Loewenherz. All rights reserved.
//

import UIKit
import ConcentricProgressRingView
//import LionheartExtensions

class ViewController: UIViewController {
    var progressRingView: ConcentricProgressRingView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let margin: CGFloat = 1
        let radius: CGFloat = self.view.frame.width/2 - 18

        let rings = [
            ProgressRing(color: UIColor.red, backgroundColor: UIColor.init(red: 5/255, green: 33/255, blue: 0, alpha: 0))
        ]
        progressRingView = try! ConcentricProgressRingView(center: view.center, radius: radius, margin: margin, rings: rings, defaultColor: UIColor.clear, defaultWidth: 18)

        for ring in progressRingView {
            ring.progress = 0.0
        }

        view.backgroundColor = UIColor.black
        //view.addSubview(progressRingView)
        
        let foo : ProgressRingLayer = ProgressRingLayer(center: self.view.center, radius: 200, width: 2, startAngle: 0, endAngle: 2*CGFloat.pi, color: UIColor.orange)
        foo.setProgress(0.5, duration: 2)
        //let x : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        //x.backgroundColor = UIColor.gray
        //x.layer.addSublayer(foo)
        //view.addSubview(x)
        view.layer.addSublayer(foo)
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        for (i, _) in progressRingView.enumerated() {
//            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(randomAnimation), userInfo: i, repeats: true)
//        }
    }
    var p : Float = 0.0

    func randomAnimation(_ timer: Timer?) {
//        guard let index = timer?.userInfo as? Int else {
//            return
//        }
//        
        let index = 0
        let f = Int64(0.2 * Double(index) * Double(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(f) / Double(NSEC_PER_SEC), execute: {
            self.p += 0.05
            print(self.p)
            self.progressRingView[index].setProgress(CGFloat(self.p), duration: max(0.4, CGFloat(drand48())))
        
        })
    }
}


//
//  ExampleViewController.swift
//  MaskProgressViewExample
//
//  Created by 洪鑫 on 16/3/4.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import MaskProgressView

class ExampleViewController: UIViewController {
    @IBOutlet weak var micphoneView: MaskProgressView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.micphoneView.setProgress(0.75, animated: true)
            self.slider.setValue(0.75, animated: true)
            self.updateProgressLabel()
        }
    }

    private func setupUI() {
        micphoneView.maskImage = UIImage(named: "micIcon")
        micphoneView.frontColor = UIColor(white: 195 / 255, alpha: 1)
        micphoneView.backColor = UIColor(white: 235 / 255, alpha: 1)
        micphoneView.setProgress(0.35, animated: false)
        slider.value = 0.35
    }

    private func updateProgressLabel() {
        progressLabel.text = "\(slider.value)"
    }
    
    @IBAction func sliderDidSlide(sender: UISlider) {
        updateProgressLabel()
        micphoneView.setProgress(CGFloat(sender.value), animated: false)
    }
}


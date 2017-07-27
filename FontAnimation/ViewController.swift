//
//  ViewController.swift
//  FontAnimation
//
//  Created by Sean Berry on 5/22/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var isSmall: Bool = true
    var crossFading: Bool {
        return crossFadeSwitch.isOn
    }
    
    @IBOutlet weak var crossFadeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        reset(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(_ sender: Any) {
        let font = label.font.withSize(20)
        var bounds = label.bounds
        label.font = font
        bounds.size = label.intrinsicContentSize
        label.bounds = bounds
        isSmall = true
    }

    @IBAction func animateFont(_ sender: Any) {
        if isSmall {
            enlarge()
        } else {
            shrink()
        }
        isSmall = !isSmall
    }
    
    func enlarge() {
        if crossFading {
            enlargeWithCrossFade()
            return
        }
        
        var bounds = label.bounds
        
        label.font = label.font.withSize(100)
        bounds.size = label.intrinsicContentSize
        
        let scaleX = label.frame.size.width / bounds.size.width
        let scaleY = label.frame.size.height / bounds.size.height
        
        label.bounds = bounds
        label.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        let duration = 1.0
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = .identity
        }, completion: { done in
        })
    }
    
    func enlargeWithCrossFade() {
        let labelCopy = label.copyLabel()
        view.addSubview(labelCopy)
        
        var bounds = label.bounds
        
        label.font = label.font.withSize(100)
        bounds.size = label.intrinsicContentSize
        
        let scaleX = label.frame.size.width / bounds.size.width
        let scaleY = label.frame.size.height / bounds.size.height
        
        label.bounds = bounds
        label.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        label.alpha = 0.0
        
        let duration = 1.0
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = .identity
            labelCopy.transform = CGAffineTransform(scaleX: 1 / scaleX, y: 1 / scaleY)
        }, completion: { done in
            labelCopy.removeFromSuperview()
        })
        
        UIView.animate(withDuration: duration / 2, animations: {
            self.label.alpha = 1.0
            labelCopy.alpha = 0.0
        }, completion: { done in
        })
    }
    
    func shrink() {
        if crossFading {
            shrinkWithCrossFade()
            return
        }
        
        let labelCopy = label.copyLabel()
        labelCopy.font = label.font.withSize(20)
        
        var bounds = labelCopy.bounds
        bounds.size = labelCopy.intrinsicContentSize
        let scaleX = bounds.size.width / label.frame.size.width
        let scaleY = bounds.size.height / label.frame.size.height
        
        let duration = 1.0
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }, completion: { done in
            self.label.font = labelCopy.font
            self.label.transform = .identity
            self.label.bounds = bounds
        })
    }
    
    func shrinkWithCrossFade() {
        let labelCopy = label.copyLabel()
        view.addSubview(labelCopy)
        
        label.font = label.font.withSize(20)
        
        var bounds = label.bounds
        bounds.size = label.intrinsicContentSize
        let scaleX = bounds.size.width / label.frame.size.width
        let scaleY = bounds.size.height / label.frame.size.height
        
        label.transform = CGAffineTransform(scaleX: 1 / scaleX, y: 1 / scaleY)
        label.alpha = 0.0
        
        let duration = 1.0
        UIView.animate(withDuration: duration, animations: {
            labelCopy.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            self.label.transform = .identity
        }, completion: { done in
            self.label.transform = .identity
            self.label.bounds = bounds
        })
        
        let multiple: Double = 5
        UIView.animate(withDuration: duration/multiple, delay: duration - (duration / multiple), options: .curveLinear, animations: {
            labelCopy.alpha = 0
            self.label.alpha = 1
        }, completion: { done in
            labelCopy.removeFromSuperview()
        })
    }
}

extension UILabel {
    func copyLabel() -> UILabel {
        let label = UILabel()
        label.font = self.font
        label.frame = self.frame
        label.text = self.text
        return label
    }
}


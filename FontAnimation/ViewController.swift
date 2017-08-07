//
//  ViewController.swift
//  FontAnimation
//
//  Created by Sean Berry on 5/22/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var crossFading: Bool {
        return crossFadeSwitch.isOn
    }
    let duration = 1.0
    let fontSizeSmall: CGFloat = 20
    let fontSizeBig: CGFloat = 100
    var isSmall: Bool = true
    
    @IBOutlet weak var label: UILabel!
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
        let font = label.font.withSize(fontSizeSmall)
        var bounds = label.bounds
        label.font = font
        bounds.size = label.intrinsicContentSize
        label.bounds = bounds
        isSmall = true
    }

    @IBAction func animateFont(_ sender: Any) {
        if isSmall {
            if crossFading {
                enlargeWithCrossFade()
            } else {
                enlarge()
            }
        } else {
            if crossFading {
                shrinkWithCrossFade()
            } else {
                shrink()
            }
        }
        isSmall = !isSmall
    }
    
    func enlarge() {
        var biggerBounds = label.bounds
        label.font = label.font.withSize(fontSizeBig)
        biggerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: biggerBounds.size, to: label.bounds.size)
        label.bounds = biggerBounds
        
        UIView.animate(withDuration: duration) {
            self.label.transform = .identity
        }
    }
    
    func enlargeWithCrossFade() {
        let labelCopy = label.copyLabel()
        view.addSubview(labelCopy)
        
        var biggerBounds = label.bounds
        label.font = label.font.withSize(fontSizeBig)
        biggerBounds.size = label.intrinsicContentSize
        
        label.transform = scaleTransform(from: biggerBounds.size, to: label.bounds.size)
        let enlargeTransform = scaleTransform(from: label.bounds.size, to: biggerBounds.size)
        label.bounds = biggerBounds
        label.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            self.label.transform = .identity
            labelCopy.transform = enlargeTransform
        }, completion: { done in
            labelCopy.removeFromSuperview()
        })
        
        UIView.animate(withDuration: duration / 2) {
            self.label.alpha = 1.0
            labelCopy.alpha = 0.0
        }
    }
    
    func shrink() {
        let labelCopy = label.copyLabel()
        labelCopy.font = label.font.withSize(fontSizeSmall)
        
        var bounds = labelCopy.bounds
        bounds.size = labelCopy.intrinsicContentSize
        let scaleX = bounds.size.width / label.frame.size.width
        let scaleY = bounds.size.height / label.frame.size.height
        
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
        
        label.font = label.font.withSize(fontSizeSmall)
        
        var bounds = label.bounds
        bounds.size = label.intrinsicContentSize
        let scaleX = bounds.size.width / label.frame.size.width
        let scaleY = bounds.size.height / label.frame.size.height
        
        label.transform = CGAffineTransform(scaleX: 1 / scaleX, y: 1 / scaleY)
        label.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            labelCopy.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            self.label.transform = .identity
        }, completion: { done in
            self.label.transform = .identity
            self.label.bounds = bounds
        })
        
        let percUntilFade = 0.8
        UIView.animate(withDuration: duration - (duration * percUntilFade), delay: duration * percUntilFade, options: .curveLinear, animations: {
            labelCopy.alpha = 0
            self.label.alpha = 1
        }, completion: { done in
            labelCopy.removeFromSuperview()
        })
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
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

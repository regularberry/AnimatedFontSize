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
    
    var fontSize: CGFloat {
        return isSmall ? 20 : 100
    }
    
    var finalBounds: CGRect {
        let font = label.font.withSize(fontSize)
        let tempLabel = UILabel()
        tempLabel.font = font
        
        var bounds = label.bounds
        bounds.size = tempLabel.intrinsicContentSize
        return bounds
    }
    
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
    }

    @IBAction func animateFont(_ sender: Any) {
        isSmall = !isSmall
        animate()
    }
    
    func enlarge() {
        
    }
    
    func animate() {
        
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


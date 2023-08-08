//
//  SnackBarView.swift
//  Performance
//
//  Created by Muhammad Ghifari on 09/09/21.
//

import Foundation
import UIKit
import PinLayout

struct SnackBar {
    static func show(message:String, duration: Double? = nil, keyboardHeight: CGFloat? = CGFloat(0)){
        SnackBarView().show(message: message, keyboardHeight: keyboardHeight)
    }
    
    class SnackBarView:UILabel{
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        let messageLabel:UILabel={
           let label = UILabel()
            label.textColor = .white
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = .systemFont(ofSize: 16)
            label.textColor = UIColor.secondaryLabel.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
            return label
        }()
        
        init() {
            super.init(frame: .zero)
            addSubview(messageLabel)
        }
        
        func show(message:String, duration: Double? = nil, keyboardHeight:CGFloat? = CGFloat(0)) {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            window.addSubview(self)
            
            messageLabel.text = message
            
            pin.left().right().marginHorizontal(30)
            messageLabel.pin.all().width(of: self).sizeToFit(.width).margin(16)
            pin.left().right().marginHorizontal(16)
            if #available(iOS 11.0, *) {
                pin.wrapContent(padding: 14).bottom().marginBottom(window.safeAreaInsets.bottom + keyboardHeight! + 24)
            }
            
            layer.cornerRadius = 8
            layer.masksToBounds = true
            backgroundColor = UIColor.tertiarySystemBackground.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
            
            self.transform = CGAffineTransform(translationX: 0, y: 100)
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(translationX: 0, y: -8)
            } completion: { Bool in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform(translationX: 0, y: 8)
                } completion: { Bool in
                    UIView.animate(withDuration: 0.1) {
                        self.transform = CGAffineTransform(translationX: 0, y: 0)
                    } completion: { Bool in
                        // Wait for 2 Seconds
                        Timer.scheduledTimer(withTimeInterval: duration ?? 0.8, repeats: false) { Timer in
                            // Hide Snackbar
                            UIView.animate(withDuration: 0.2) {
                                self.transform = CGAffineTransform(translationX: 0, y: 100)
                            } completion: { Bool in
                                // Remove SnackBar
                                self.removeFromSuperview()
                            }
                        }
                    }
                }
            }
            
        }
        
    }

    
}

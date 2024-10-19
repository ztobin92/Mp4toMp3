//
//  HighlightedButton.swift
//  UIComponents
//
//  Created by Bora Erdem on 14.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit

public class HighlightedButton: UIButton {

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        DispatchQueue.main.async {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = 0.5
            }, completion: nil)
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
                           completion: { _ in
                UIView.animate(withDuration: 0.3,
                               animations: {
                    self.transform = .identity
                    self.alpha = 1.0
                })
            }
            )
        }
    }

}

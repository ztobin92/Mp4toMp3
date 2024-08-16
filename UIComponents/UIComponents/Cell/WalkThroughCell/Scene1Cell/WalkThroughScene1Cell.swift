//
//  WalkThroughScene1Cell.swift
//  UIComponents
//
//  Created by Bora Erdem on 14.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI

public class WalkThroughScene1Cell: UICollectionViewCell, ReusableView {
    
    weak var viewModel: WalkThroughCellProtocol?
    
    let sv = UIScrollView()
    let sv2 = UIScrollView()
    let sv3 = UIScrollView()
    let mock = UIView()
    var timer: Timer?
    
    var yOffset: CGFloat = 0
    var yOffsetSV2: CGFloat = 5500
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureContents()
    }
    
    private func configureContents() {
        prepareBG()
        clipsToBounds = true
        
        let textContainer = stack(
            UIView(),
            Text(L10n.Modules.Onboard.Scene._1.title)
                .font(.system(size: 28, weight: .bold))
              .multilineTextAlignment(.center)
              .foregroundColor(Color(uiColor: .appBlack))
              .asUIKit(),
            Text(L10n.Modules.Onboard.Scene._1.desc)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(uiColor: .appBlack))
                .padding(.horizontal, 30)
                .asUIKit(),
            spacing: 24
        )
        
        addSubview(textContainer)
        textContainer.centerXToSuperview()
        textContainer.bottomToSuperview()
        
        // Start BG Animation
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            sv2.contentOffset.x = 5500
            timerAction()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func timerAction() {
        yOffset += 20
        yOffsetSV2 -= 20
        yOffset > sv.contentSize.width ? yOffset = 0 : nil
        yOffsetSV2 > sv2.contentSize.width ? yOffsetSV2 = 0 : nil
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear]) {
                self.sv.contentOffset.x = self.yOffset
                self.sv2.contentOffset.x = self.yOffsetSV2
                self.sv3.contentOffset.x = self.yOffset
            }
        }
    }
    
    private func prepareBG() {
        
        let scrollContainer = UIView()

        scrollContainer.stack(
            prepareSV1(),
            prepareSV2(),
            prepareSV3()
        )
        
        scrollContainer.withWidth(170 * 3)
        scrollContainer.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.3))
        addSubview(scrollContainer)
        scrollContainer.anchor(
            .leading(leadingAnchor, constant: -ScreenSize.width),
            .trailing(trailingAnchor, constant: -ScreenSize.width),
            .top(topAnchor, constant:  -ScreenSize.height * 0.05)
        )
        
        func prepareSV1() -> UIView {
            sv.withHeight(170)
            let stack = UIView().hstack(spacing: 0)
            
            (0..<10).forEach { _ in
                let images: [UIImage] = [.imgOnbT1, .imgOnbT2, .imgOnbT3, .imgOnbT4]
                images.forEach { image in
                    let iv = UIImageViewBuilder()
                        .image(image)
                        .clipsToBounds(true)
                        .masksToBounds(true)
                        .contentMode(.scaleAspectFit)
                        .build()
                    iv.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / -2))
                    iv.withSize(.init(width: 170, height: 170))
                    stack.addArrangedSubview(iv)
                }
            }
            sv.addSubview(stack)
            stack.fillSuperview()
            return sv
        }
        
        func prepareSV2() -> UIView {
            sv2.withHeight(170)
            let stack = UIView().hstack(spacing: 0)
            print("init \(sv2.contentOffset.x)")
            
            (0..<10).forEach { _ in
                let images: [UIImage] = [.imgOnbT5, .imgOnbT6, .imgOnbT7, .imgOnbT8]
                images.forEach { image in
                    let iv = UIImageViewBuilder()
                        .image(image)
                        .clipsToBounds(true)
                        .masksToBounds(true)
                        .contentMode(.scaleAspectFit)
                        .build()
                    iv.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / -2))
                    iv.withSize(.init(width: 170, height: 170))
                    stack.addArrangedSubview(iv)
                }
            }
            sv2.addSubview(stack)
            stack.fillSuperview()
            return sv2

        }
        
        func prepareSV3() -> UIView {
            sv3.withHeight(170)
            let stack = UIView().hstack(spacing: 0)
            
            (0..<10).forEach { _ in
                let images: [UIImage] = [.imgOnbT9, .imgOnbT10, .imgOnbT2, .imgOnbT6]
                images.forEach { image in
                    let iv = UIImageViewBuilder()
                        .image(image)
                        .clipsToBounds(true)
                        .masksToBounds(true)
                        .contentMode(.scaleAspectFit)
                        .build()
                    iv.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / -2))
                    iv.withSize(.init(width: 170, height: 170))
                    stack.addArrangedSubview(iv)
                }
            }
            sv3.addSubview(stack)
            stack.fillSuperview()
            return sv3

        }

        let gradient = Rectangle()
            .foregroundColor(.clear)
            .frame(width: ScreenSize.width, height: 600)
            .background(
              LinearGradient(
                stops: [
                  Gradient.Stop(color: Color(red: 0.96, green: 0.97, blue: 0.99).opacity(0), location: 0.00),
                  Gradient.Stop(color: Color(uiColor: .appWhite), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0.02),
                endPoint: UnitPoint(x: 0.5, y: 0.73)
              )
            )
            .asUIKit()
        
        addSubview(gradient)
        gradient.centerXToSuperview()
        gradient.bottom(to: self)
    }
    
    public func set(viewModel: WalkThroughCellProtocol) {
        self.viewModel = viewModel
        
    }
    
}

//
//  WalkThroughScene2Cell.swift
//  UIComponents
//
//  Created by Bora Erdem on 14.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI

public class WalkThroughScene2Cell: UICollectionViewCell, ReusableView {
    
    weak var viewModel: WalkThroughCellProtocol?
    
    var textContainers: [UIView] = []
    var nameContainer = UIView()
    
    public var didAppear: Bool? {
        willSet {
            let height = UIScreen.main.bounds.height
            let width = UIScreen.main.bounds.width
            
            textContainers.forEach({$0.transform = .init(translationX: 0, y: height)})
            nameContainer.transform = .init(translationX: width, y: 0)
            
            // Text containers
            self.textContainers.enumerated().forEach { index, view in
                UIView.animate(withDuration: 1, delay: TimeInterval(Double(index) * 0.2), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2) {
                    view.transform = .identity
                }
            }
            
            // Name container
            UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2) {
                self.nameContainer.transform = .identity
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureContents()
    }
    
    private func configureContents() {
        setupCircleBlurBackground()
        
        stack(
            Text(L10n.Modules.Onboard.Scene._2.title)
                .font(.system(size: 28, weight: .bold))
              .multilineTextAlignment(.center)
              .foregroundColor(Color(uiColor: .appBlack))
              .asUIKit(),
            middleContainer(height: ScreenSize.height * 0.5),
            UIView(),
            Text(L10n.Modules.Onboard.Scene._2.desc)
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(uiColor: .appBlack))
                .padding(.horizontal, 30)
                .minimumScaleFactor(0.001)
                .asUIKit(),
            spacing: 32
        ).padTop(30)
    }
    
    private func setupCircleBlurBackground() {
        let circle1 = Circle()
            .frame(width: 80, height: 80)
            .background(Color(UIColor.appOrange).opacity(0.41))
            .blur(radius: 107)
            .asUIKit()
        
        let circle2 = Circle()
            .frame(width: 80, height: 80)
            .background(Color(UIColor.appBlue).opacity(0.4))
            .blur(radius: 107)
            .asUIKit()
        
        addSubview(circle1)
        circle1.topToSuperview(offset: 40, usingSafeArea: true)
        circle1.trailingToSuperview()
        
        addSubview(circle2)
        circle2.bottomToSuperview(offset: 300, usingSafeArea: true)
        circle2.leadingToSuperview()
        
    }
    
    private func middleContainer(height: CGFloat) -> UIView {
        
        let container = UIView()
//        let width = ScreenSize.width * 0.7
//        let imageHtight = width * 367/263
        //            .frame(width: 263, height: 367)
        
        let imageHtight = height * 0.85
        let width = imageHtight * 263 / 367
        
        let image = Rectangle()
            .foregroundColor(.clear)
            .frame(width: width, height: imageHtight)
            .background(
                Image(uiImage: .imgOnboard2Banner)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: imageHtight)
                .clipped()
            )
            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
            .cornerRadius(20)
            .asUIKit()
        
        container.stack(image)
        
        let imageBlur = Rectangle()
            .foregroundColor(.clear)
            .frame(width: width * 0.9, height: imageHtight * 0.9)
            .background(
                Image(uiImage: .imgOnboard2Banner)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width * 0.9, height: imageHtight * 0.9)
                .clipped()
            )
            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
            .cornerRadius(20)
            .blur(radius: 25)
            .opacity(0.5)
            .asUIKit()
        
        nameContainer = Rectangle()
            .foregroundColor(.clear)
            .frame(width: 128, height: 43)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.15), radius: 20, x: -10, y: 10)
            .overlay {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Casey Litel")
                        .font(.system(size: 13))
                        .foregroundStyle(.black)
                    HStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color(UIColor.appOrange))
                        Text("4.9")
                            .font(.system(size: 9))
                            .foregroundStyle(.black)
                    }
                }
                .padding(.horizontal, 20)
            }
            .asUIKit()
        
        image.addSubview(nameContainer)
        nameContainer.topToSuperview(offset: 100)
        nameContainer.trailingToSuperview(offset: 40)
        
        
        let recContainer = UIView().hstack(
            generateRectangle(image: .icEqualizer.withRenderingMode(.alwaysTemplate), text: L10n.Modules.Onboard.Scene._2.Advantages._1),
            generateRectangle(image: .init(systemName: "waveform", withConfiguration: UIImage.SymbolConfiguration(hierarchicalColor: .white))!.withRenderingMode(.alwaysTemplate), text: L10n.Modules.Onboard.Scene._2.Advantages._2),
            generateRectangle(image: .icBackup.withRenderingMode(.alwaysTemplate), text: L10n.Modules.Onboard.Scene._2.Advantages._3),
            spacing: 16
        )
        recContainer.arrangedSubviews.forEach { view in
            textContainers.append(view)
        }
        
        container.addSubview(recContainer)
        recContainer.centerXToSuperview()
        recContainer.bottomToSuperview(offset: 40)
        
        container.addSubview(imageBlur)
        imageBlur.centerXToSuperview()
        imageBlur.centerYToSuperview(offset: imageHtight * 0.2)
        container.sendSubviewToBack(imageBlur)

        func generateRectangle(image: UIImage, text: String) -> UIView {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 100, height: 101.94175)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
                .cornerRadius(10)
                .overlay(content: {
                    VStack (alignment: .leading, spacing: 8) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .tint(.white)
                            .foregroundStyle(.white)
                        Text(text)
                            .font(.system(size: 13, weight: .medium))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                    }
                    .padding(10)
                })
                .asUIKit()
        }
        
        return container
    }
    
    public func set(viewModel: WalkThroughCellProtocol) {
        self.viewModel = viewModel
        
    }
    
}

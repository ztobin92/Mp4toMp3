//
//  NavBar.swift
//  UIComponents
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import LBTATools

public final class NavBar: UIView {
    
    public weak var delegate: NavBarDelegate?
    public var titleString: String? {
        willSet {
            title.text = newValue
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var settings = generateCircleButton(type: .settings)
    lazy var close = generateCircleButton(type: .close)
    lazy var back = generateCircleButton(type: .back)
    lazy var export = generateExportButton()
    lazy var edit = generateEditButton()
    lazy var loading = LoadingView().asUIKit()
    
    lazy var reorder = HStack {
        Text(L10n.Modules.History.date)
            .font(.system(size: 17, weight: .medium))
        Image(systemName: "arrow.up.arrow.down")
            .font(.system(size: 15, weight: .semibold))
    }
        .foregroundStyle(Color(uiColor: .appHeather.withAlphaComponent(0.5)))
        .asUIKit()
    
    var expand = Image(systemName: "chevron.up")
        .font(.system(size: 15, weight: .semibold))
        .foregroundStyle(Color(uiColor: .appHeather.withAlphaComponent(0.5)))
        .asUIKit()
    
    private let title = UILabelBuilder()
        .font(.systemFont(ofSize: 22, weight: .medium))
        .textColor(.appBlack)
        .build()
    
    public func setSettingHidden(_ bool: Bool) {
        settings.isHidden = bool
    }
    
    public func setCloseHidden(_ bool: Bool) {
        close.isHidden = bool
    }
    
    public func setBackHidden(_ bool: Bool) {
        back.isHidden = bool
    }
    
    public func setExportHidden(_ bool: Bool) {
        export.isHidden = bool
    }
    
    public func setLoadingHidden(_ bool: Bool) {
        loading.isHidden = bool
    }
    
    public func setEditHidden(_ bool: Bool) {
        edit.isHidden = bool
    }
    
    public func setExpandHidden(_ bool: Bool) {
        expand.isHidden = bool
    }
    
    public func setReorderHidden(_ bool: Bool) {
        reorder.isHidden = bool
    }
    
    private func setupUI() {
        export.isHidden = true
        back.isHidden = true
        close.isHidden = true
        settings.isHidden = true
        loading.isHidden = true
        edit.isHidden = true
        expand.isHidden = true
        reorder.isHidden = true
        
        hstack(
            back,
            title,
            UIView(),
            settings,
            export,
            edit,
            loading,
            expand,
            reorder,
            close,
            spacing: 16
        )
        
        withHeight(40)
    }
    
    private func configureContents() {
        settings.onTap { [weak self] in
            guard let self else { return }
            delegate?.didTapSettings?()
        }
        
        back.onTap { [weak self] in
            guard let self else { return }
            delegate?.didTapClose?()
        }
        
        close.onTap { [weak self] in
            guard let self else { return }
            delegate?.didTapClose?()
        }
        
        export.onTap { [weak self] in
            guard let self else { return }
            delegate?.didTapExport?()
        }
        
        edit.onTap { [weak self] in
            guard let self else { return }
            delegate?.didTapEdit?()
        }
        
        reorder.onTap { [weak self] in
            guard let self else { return }
            delegate?.didTapReorder?()
        }
    }
    
    @frozen enum CircleButtonType {
        case close, settings, back
    }
    
    private func generateCircleButton(type: CircleButtonType) -> UIView {
        
        var image = UIImage()
        
        switch type {
        case .close:
            image = .init(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold))!
        case .settings:
            image = .icSetting
        case .back:
            image = .init(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold))!
        }
        
        return Button(action: {
            
        }, label: {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 40, height: 40)
                .makeGradientBackground(singleColor: false, cornerRadius: 20)
                .overlay {
                    Image(uiImage: image.withRenderingMode(.alwaysTemplate))
                        .foregroundStyle(Color(uiColor: .appBlack))
                }
        })
            .asUIKit()
    }
    
    private func generateExportButton() -> UIView {
        let container = Button {
            
        } label: {
            
            HStack {
                Image(uiImage: .icExportFile.withRenderingMode(.alwaysTemplate))
                Text(L10n.Modules.Export.title)
                    .font(.system(size: 17 ,weight: .semibold))
            }
            .foregroundStyle(Color(uiColor: .appClearWhite))
            .frame(height: 40)
            .padding(.horizontal, 24)
            .background {
                LinearGradient(colors: [Color(uiColor: .appBlue).opacity(1), Color(uiColor: .appBlue).opacity(0.7)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .inset(by: 0.5)
                        .stroke(Color(uiColor: .appClearWhite), lineWidth: 1)
                )
            }
        }

        
        return container.asUIKit()
    }
    
    private func generateEditButton() -> UIView {
        let container = Button {
            
        } label: {
            
            HStack {
                Image(uiImage: .icEqualizer.withRenderingMode(.alwaysTemplate))
                    .foregroundStyle(Color(UIColor.appBlue))
                Text(L10n.Modules.Edit.edit)
                    .font(.system(size: 17 ,weight: .semibold))
                    .foregroundStyle(Color(UIColor.appBlue))
            }
            .frame(height: 40)
            .padding(.horizontal, 24)
            .makeGradientBackground(singleColor: false, cornerRadius: 20)
        }

        
        return container.asUIKit()
    }
}

@objc public protocol NavBarDelegate {
    @objc optional func didTapSettings()
    @objc optional func didTapClose()
    @objc optional func didTapExport()
    @objc optional func didTapEdit()
    @objc optional func didTapReorder()
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 3)
            .foregroundStyle(Color(uiColor: .appClearWhite))
            .opacity(0.3)
            .makeGradientBackground(singleColor: false, cornerRadius: 20)
            .overlay(
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .foregroundColor(Color(uiColor: .appBlue))
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            )
            .frame(width: 40, height: 40)
            .onAppear {
                isAnimating = true
            }
    }
}

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
    lazy var export = generateExportButton()  // Now it's a UIButton
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
    
    private func generateExportButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Export", for: .normal)
        button.setTitleColor(.white, for: .normal)

        // Disable autoresizing mask
        button.translatesAutoresizingMaskIntoConstraints = false

        // Set background color to solid blue
        button.backgroundColor = UIColor.systemBlue

        // Adjust for rounded rectangle shape
        button.layer.cornerRadius = 15 // Rounded rectangle with smaller corner radius
        button.clipsToBounds = true

        // Add border if needed
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor

        button.addTarget(self, action: #selector(exportButtonTapped), for: .touchUpInside)

        // Set explicit width and height constraints
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 150), // Set your desired width
            button.heightAnchor.constraint(equalToConstant: 60)  // Set your desired height
        ])

        return button
    }



    // Move exportButtonTapped outside of generateExportButton
    @objc func exportButtonTapped() {
        print("Export button tapped directly")
        delegate?.didTapExport?()
    }

    private func configureContents() {
        settings.onTap { [weak self] in
            guard let self = self else { return }
            print("Settings button tapped in NavBar") // Add this for further debugging
            self.delegate?.didTapSettings?()
        }
        
        back.onTap { [weak self] in
            guard let self = self else { return }
            self.delegate?.didTapClose?()
        }
        
        close.onTap { [weak self] in
            guard let self = self else { return }
            self.delegate?.didTapClose?()
        }
        
        edit.onTap { [weak self] in
            guard let self = self else { return }
            self.delegate?.didTapEdit?()
        }
        
        reorder.onTap { [weak self] in
            guard let self = self else { return }
            self.delegate?.didTapReorder?()
        }
    }
    
    @frozen enum CircleButtonType {
        case close, settings, back
    }
    
    private func generateCircleButton(type: CircleButtonType) -> UIButton {
        let button = UIButton(type: .system)
        var image = UIImage()
        
        switch type {
        case .close:
            image = .init(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold))!
        case .settings:
            image = .icSetting  // Assuming this is correctly defined elsewhere
        case .back:
            image = .init(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold))!
        }
        
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .appBlack  // Assuming you have a UIColor extension for appBlack
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        return button
    }

    @objc private func settingsButtonTapped() {
        print("Settings button tapped in NavBar")
        delegate?.didTapSettings?()
    }

    private func generateEditButton() -> UIView {
        let container = Button {
            // Button action logic
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

// MARK: - NavBarDelegate
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

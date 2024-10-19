//
//  BaseViewController.swift
//  SampleProject
//
//  Created by Mehmet Salih Aslan on 4.11.2020.
//  Copyright © 2020 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI

typealias BaseLoadingProtocols = LoadingProtocol & ActivityIndicatorProtocol

class BaseViewController<V: BaseViewModelProtocol>: UIViewController, BaseLoadingProtocols {
    
    var viewModel: V
    
    var safeAreaContainer = UIView()
    
    init(viewModel: V) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // swiftlint:disable fatal_error unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // swiftlint:enable fatal_error unavailable_function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
//        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        subscribeLoading()
        subscribeActivityIndicator()
        subscribeToast()
    }
    
    private func subscribeActivityIndicator() {
        viewModel.showActivityIndicatorView = { [weak self] in
            self?.showActivityIndicator()
        }
        viewModel.hideActivityIndicatorView = { [weak self] in
            self?.hideActivityIndicator()
        }
    }
    
    private func subscribeLoading() {
        viewModel.showLoading = { [weak self] in
            self?.presentLoading()
        }
        viewModel.hideLoading = { [weak self] in
            self?.dismissLoading()
        }
    }
    
    private func subscribeToast() {
        viewModel.showWarningToast = { text in
            ToastPresenter.showWarningToast(text: text)
        }
    }
    
    func showWarningToast(message: String) {
        ToastPresenter.showWarningToast(text: message)
    }
    
    public func setupSingleBlueBackground() {
        let width = ScreenSize.width / 2
        
        let circle = Circle()
            .foregroundStyle(Color(UIColor.appBlue))
            .frame(width: width, height: width)
            .background(Color(red: 0.13, green: 0.64, blue: 0.94))
            .blur(radius: 75)
            .opacity(0.3)
            .asUIKit()
        
        view.addSubview(circle)
        circle.trailingToSuperview(offset: -width / 2.3)
        circle.topToSuperview(offset: width/3, usingSafeArea: true)
    }
    
    public func setupSafeAreaContainer() {
        view.addSubview(safeAreaContainer)
        safeAreaContainer.anchor(
            .leading(view.leadingAnchor),
            .trailing(view.trailingAnchor),
            .bottom(view.bottomAnchor),
            .top(view.safeAreaLayoutGuide.topAnchor)
        )
    }

    
    #if DEBUG
    deinit {
        debugPrint("deinit \(self)")
    }
    #endif
    
}

// MARK: - NavigationBar Logo
extension BaseViewController {
    func addNavigationBarLogo() {
        let image = UIImage.imgLogoFodamy
        let imageView = UIImageView()
        imageView.size(CGSize(width: 110, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationItem.titleView = imageView
    }
}

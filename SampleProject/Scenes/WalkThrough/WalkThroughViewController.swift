//
//  WalkThroughViewController.swift
//  SampleProject
//
//  Created by Murat Celebi on 1.04.2021.
//  Copyright © 2021 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI

final class WalkThroughViewController: BaseViewController<WalkThroughViewModel> {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        collectionView.register(WalkThroughCell.self)
        collectionView.register(WalkThroughScene2Cell.self)
        collectionView.register(WalkThroughScene1Cell.self)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .appWhite
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let pageControl = UIPageControlBuilder<PageControl>()
        .numberOfPages(4)
        .build()
    
    private let nextButton = ButtonFactory.createPrimaryButton(style: .large)
    
    private let dismissButton = UIButtonBuilder()
        .image(UIImage.icClose.withRenderingMode(.alwaysTemplate))
        .tintColor(.appCinder)
        .build()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        configureContents()
        setLocalize()
    }
}

// MARK: - UILayout
extension WalkThroughViewController {
    
    private func addSubViews() {

        nextButton.onTap { [weak self] in
            guard let self else { return }
            nextButtonTapped()
        }
        
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .touchUpInside)

        let c = UIView()
        view.addSubview(c)
        c.anchor(
            .leading(view.leadingAnchor),
            .trailing(view.trailingAnchor),
            .bottom(view.safeAreaLayoutGuide.bottomAnchor),
            .top(view.topAnchor)
        )
        
        c.stack(
            collectionView,
            c.stack(nextButton).withMargins(.allSides(30))
        )
        
    }
    
    func presentPaywallController() {
        let router = PaywallRouter()
        let viewModel = PaywallViewModel(router: router, viewSource: .onboard)
        let viewController = PaywallViewController(viewModel: viewModel)
        
        
        let newViewController = viewController
        newViewController.view.frame = self.view.frame.offsetBy(dx: self.view.frame.width, dy: 0)

        addChild(newViewController)
        view.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
        
        let tmp = self.view.frame
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
//        }
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2) {
            newViewController.view.frame = tmp
        }

    }
    
}

// MARK: - Configure and Localize
extension WalkThroughViewController {
    
    private func configureContents() {
        view.backgroundColor = .appWhite
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setLocalize() {
        nextButton.setTitle(L10n.Modules.Onboard.start, for: .normal)
    }
}

// MARK: - Actions
extension WalkThroughViewController {
    
    @objc
    private func nextButtonTapped() {
       
        
        switch pageControl.currentPage {
        case viewModel.numberOfItemsAt(section: 0) - 1:
//            viewModel.didFinishWalkThroughScene()
            presentPaywallController()
        default:
            break
        }
        
        let nextIndex = min(pageControl.currentPage + 1, viewModel.numberOfItemsAt(section: 0) - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc
    private func pageControlValueChanged(_ sender: UIPageControl) {
        let current = sender.currentPage
        collectionView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(current), y: 0), animated: true)
    }
    
    @objc
    private func dismissButtonTapped() {
        viewModel.didFinishWalkThroughScene()
    }
}

// MARK: - UIScrollViewDelegate
extension WalkThroughViewController {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let xPoint = targetContentOffset.pointee.x
        let pageIndex = Int(xPoint / view.frame.width)
        pageControl.currentPage = pageIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        switch pageControl.currentPage {
        case 1:
            nextButton.setTitle(L10n.General.continue, for: .normal)
        case viewModel.numberOfItemsAt(section: 0) - 1:
            nextButton.setTitle(L10n.General.continue, for: .normal)
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WalkThroughViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsAt(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellItem = viewModel.cellItemAt(indexPath: indexPath)
        
        switch cellItem.scene {
        case .scene1:
            let cell: WalkThroughScene1Cell = collectionView.dequeueReusableCell(for: indexPath)
            cell.set(viewModel: cellItem)
            return cell
        case .scene2:
            let cell: WalkThroughScene2Cell = collectionView.dequeueReusableCell(for: indexPath)
            cell.set(viewModel: cellItem)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? WalkThroughScene2Cell {
            cell.didAppear = true
        }
    }
    
}

// swiftlint:disable line_length
// MARK: - UICollectionViewDelegateFlowLayout
extension WalkThroughViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
}
// swiftlint:enable line_length

//
//  PaywallViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import Defaults
import Localize_Swift

protocol PaywallViewDataSource {}

protocol PaywallViewEventSource {}

protocol PaywallViewProtocol: PaywallViewDataSource, PaywallViewEventSource {}

final class PaywallViewModel: BaseViewModel<PaywallRouter>, PaywallViewProtocol {
    
    @Published var yearlySelected = true
    
    @frozen enum PaywallViewSource {
        case onboard, other
    }
    
    var viewSource: PaywallViewSource!
    
    var paywallBannerImage: UIImage {
        return switch Localize.currentLanguage() {
        case "es":
            UIImage.imgPwBannerEs
        case "fr":
            UIImage.imgPwBannerFr
        case "en":
            UIImage.imgPaywallBanner
        case "de":
            UIImage.imgPwBannerDe
        case "ko":
            UIImage.imgPwBannerKo
        case "vi":
            UIImage.imgPwBannerVi
        case "pt-BR":
            UIImage.imgPwBannerPt
        default:
            UIImage.imgPaywallBanner
        }
    }
    
    init(router: PaywallRouter, viewSource: PaywallViewSource) {
        super.init(router: router)
        self.viewSource = viewSource
    }
    
    func didTapClose() {
        switch viewSource {
        case .onboard:
            didFinishWalkThroughScene()
        case .other:
            router.close()
        case .none:
            break
        }
    }
    
    func didFinishWalkThroughScene() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            Defaults[.firstRun] = false
        }
        router.presentHome()
    }
    
    
    func purchase() {
        let yearlyProduct: RevenueHelper.Offering = .yearly
        let weeklyProduct: RevenueHelper.Offering  = .weekly
        
        showLoading?()
        RevenueHelper.shared.purchasePackage(for: yearlySelected ? yearlyProduct : weeklyProduct) { [weak self] result in
            guard let self else { return }
            
            hideLoading?()
            switch result {
            case .premiumCompleted:
                if viewSource == .onboard {
                    didFinishWalkThroughScene()
                } else {
                    router.close()
                }
            case .normalFinished:
                break
            case .failure:
                break
            }
        }
    }

}

extension PaywallViewModel: ObservableObject {
}

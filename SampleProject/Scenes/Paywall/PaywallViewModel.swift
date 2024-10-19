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
import RevenueCat

protocol PaywallViewDataSource {}

protocol PaywallViewEventSource {}

protocol PaywallViewProtocol: PaywallViewDataSource, PaywallViewEventSource {}

final class PaywallViewModel: BaseViewModel<PaywallRouter>, PaywallViewProtocol {
    
    @Published var yearlySelected = true
    
    @frozen enum PaywallViewSource {
        case onboard, other
    }
    
    var viewSource: PaywallViewSource!
    
    // Instance of the RCPurchaseController
    private let purchaseController = RCPurchaseController()
    
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
    
    /*
    // Updated purchase method using RCPurchaseController
    func purchase() {
        let productIdentifier = yearlySelected ? "your_yearly_product_identifier" : "your_weekly_product_identifier"
        
        showLoading?()
        
        Task {
            do {
                // Fetch the SKProduct for the given product identifier
                let products = try await Purchases.shared.products([productIdentifier])
                
                guard let product = products.first else {
                    print("Product not found")
                    hideLoading?()
                    return
                }
                
                // Now pass the SKProduct to the purchase method
                let purchaseResult = try await purchaseController.purchase(product: product)
                hideLoading?()
                
                // Handle purchase result
                switch purchaseResult {
                case .purchased:
                    handlePurchaseCompleted()
                case .restored:
                    handlePurchaseRestored()
                case .cancelled:
                    // Handle cancellation
                    break
                case .failed(let error):
                    print("Purchase failed: \(error.localizedDescription)")
                default:
                    break
                }
            } catch {
                hideLoading?()
                print("Error fetching product: \(error.localizedDescription)")
            }
        }
    }
*/
    
    private func handlePurchaseCompleted() {
        // Your logic for completing a purchase
        if viewSource == .onboard {
            didFinishWalkThroughScene()
        } else {
            router.close()
        }
    }
    
    private func handlePurchaseRestored() {
        // Your logic for restoring purchases
        ToastPresenter.showWarningToast(text: "Restored", position: .bottomNote, color: .appBlue)
    }
}

extension PaywallViewModel: ObservableObject {
}

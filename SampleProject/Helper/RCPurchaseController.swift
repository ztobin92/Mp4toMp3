import SuperwallKit
import RevenueCat
import StoreKit
import Defaults

enum PurchasingError: Error {
    case productNotFound
}

final class RCPurchaseController: PurchaseController {
    // Sync Subscription Status
    func syncSubscriptionStatus() {
        assert(Purchases.isConfigured, "You must configure RevenueCat before calling this method.")
        Task {
            for await customerInfo in Purchases.shared.customerInfoStream {
                // Sync subscription status with Superwall
                let hasActiveSubscription = !customerInfo.entitlements.active.isEmpty
                if hasActiveSubscription {
                    Superwall.shared.subscriptionStatus = .active
                    Defaults[.premium] = true  // Update Defaults to indicate premium status
                } else {
                    Superwall.shared.subscriptionStatus = .inactive
                    Defaults[.premium] = false  // Update Defaults to indicate non-premium status
                }

                // Optionally post a notification to update the UI if needed
                NotificationCenter.default.post(name: NSNotification.Name("PremiumStatusChanged"), object: nil)
            }
        }
    }

    // Handle Purchases
    func purchase(product: SKProduct) async -> PurchaseResult {
        do {
            guard let storeProduct = await Purchases.shared.products([product.productIdentifier]).first else {
                throw PurchasingError.productNotFound
            }
            let purchaseDate = Date()
            let revenueCatResult = try await Purchases.shared.purchase(product: storeProduct)
            if revenueCatResult.userCancelled {
                return .cancelled
            } else {
                if let transaction = revenueCatResult.transaction, purchaseDate > transaction.purchaseDate {
                    return .restored
                } else {
                    return .purchased
                }
            }
        } catch let error as ErrorCode {
            if error == .paymentPendingError {
                return .pending
            } else {
                return .failed(error)
            }
        } catch {
            return .failed(error)
        }
    }

    // Handle Restores
    func restorePurchases() async -> RestorationResult {
        do {
            _ = try await Purchases.shared.restorePurchases()
            return .restored
        } catch let error {
            return .failed(error)
        }
    }
}

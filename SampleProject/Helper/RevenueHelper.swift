import Foundation
import SuperwallKit
import Defaults
import RevenueCat

public enum RevenueResult {
    case premiumCompleted, normalFinished, failure
}

public final class RevenueHelper: NSObject {
    
    public static let shared = RevenueHelper()
    
    override init() {
        super.init()
        // No need to set an entitlements update listener with RevenueCat
    }
    
    private var products: [Offering: Package] = [:]
    var isPackagesFetched = false
    var updateUI: VoidClosure?
    
    enum Offering {
        case weekly, yearly
    }
    
    // Fetches the products from RevenueCat
    func fetchProducts() {
        Purchases.shared.getOfferings { [weak self] (offerings, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching offerings: \(error.localizedDescription)")
                return
            }
            
            guard let availableOfferings = offerings, let mainOffering = availableOfferings.current else {
                return
            }
            
            self.products[.yearly] = mainOffering.annual
            self.products[.weekly] = mainOffering.weekly
            self.isPackagesFetched = true
            self.checkEntitlements() // Check user entitlements after fetching packages
            self.updateUI?() // Call the UI update closure if set
        }
    }
    
    // Returns the package for the requested offering type
    func getPackage(for type: Offering) -> Package? {
        guard isPackagesFetched else { return nil }
        return products[type]
    }
    
    // Checks if the user is entitled to the premium features
    func checkEntitlements() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            if let error = error {
                print("Error fetching customer info: \(error.localizedDescription)")
                return
            }
            
            if let customerInfo = customerInfo, customerInfo.entitlements["pro"]?.isActive == true {
                Defaults[.premium] = true
            } else {
                Defaults[.premium] = false
            }
        }
    }
    
    // Restores the user's purchases
    func restorePurchases(completion: @escaping (RevenueResult) -> ()) {
        Purchases.shared.restorePurchases { (customerInfo, error) in
            if let error = error {
                print("Error restoring purchases: \(error.localizedDescription)")
                completion(.failure)
                return
            }
            
            if let customerInfo = customerInfo, customerInfo.entitlements["pro"]?.isActive == true {
                Defaults[.premium] = true
                completion(.premiumCompleted)
            } else {
                Defaults[.premium] = false
                completion(.normalFinished)
            }
        }
    }
    
    // Initiates a purchase for the requested package type
    func purchasePackage(for type: Offering, completion: @escaping (RevenueResult) -> ()) {
        guard let package = products[type] else {
            completion(.failure) // Fix: use `.failure` instead of `.failed`
            return
        }
        
        Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
            if let error = error {
                print("Purchase failed: \(error.localizedDescription)")
                completion(.failure)
                return
            }
            
            if customerInfo?.entitlements["pro"]?.isActive == true {
                Defaults[.premium] = true
                Superwall.shared.subscriptionStatus = .active // Sync with Superwall
                completion(.premiumCompleted)
                
                // Post notification for UI update
                NotificationCenter.default.post(name: NSNotification.Name("PremiumStatusChanged"), object: nil)
            } else {
                completion(.normalFinished)
            }
        }
    }
}

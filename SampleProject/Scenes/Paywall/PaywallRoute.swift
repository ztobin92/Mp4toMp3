import SuperwallKit

protocol PaywallRoute {
    func presentPaywall(event: String, completion: (() -> Void)?)
}

extension PaywallRoute where Self: RouterProtocol {
    
    func presentPaywall(event: String = "campaign_trigger", completion: (() -> Void)? = nil) {
            // Register the event with Superwall
            Superwall.shared.register(event: event) {
                // Completion handler after paywall is handled
                completion?()
            }
        }
}

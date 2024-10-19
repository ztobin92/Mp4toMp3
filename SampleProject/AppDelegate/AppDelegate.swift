import UIKit
import IQKeyboardManagerSwift
import Defaults
import RevenueCat
import SuperwallKit
import AVFAudio
import Firebase
import Localize_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        self.window?.makeKeyAndVisible()
        
        setupLanguage()
        configureIQKeyboardManager()
        setupFirebase()
        setupColorMode()
        setupRevenueCat()
        setupSuperwall()
        setupSpeakerOutput()
        AppRouter.shared.startApp()
        
        // Check subscription status on app launch
        checkSubscriptionStatus()
        
        return true
    }
    
    private func setupLanguage() {
        LocalizableManager.observe()
        if Localize.availableLanguages().contains(Localize.currentLanguage()) {
            Localize.setCurrentLanguage(Localize.currentLanguage())
            LocalizableManager.globalLocalize.send(Localize.currentLanguage())
        }
        
        if let usersLang = Defaults[.prefferedLanguage] {
            Localize.setCurrentLanguage(usersLang)
            LocalizableManager.globalLocalize.send(usersLang)
        }
        
        print(Localize.currentLanguage())
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
    }
    
    private func setupSpeakerOutput() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("Ses oturumu yapılandırılamadı: \(error.localizedDescription)")
        }

        do {
            try audioSession.overrideOutputAudioPort(.speaker)
        } catch {
            print("Ses çıkışı yapılandırılamadı: \(error.localizedDescription)")
        }
    }
    
    private func setupColorMode() {
        switch AppColorMode(rawValue: Defaults[.usersColorMode]) ?? .System {
        case .Dark:
            window?.overrideUserInterfaceStyle = .dark
        case .Light:
            window?.overrideUserInterfaceStyle = .light
        case .System:
            window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    private func setupRevenueCat() {
        Purchases.configure(withAPIKey: "appl_jkvSGgvMIzWFjUdDxVofXnDKHlf")
    }
    
    private func setupSuperwall() {
        let purchaseController = RCPurchaseController()

        Superwall.configure(
          apiKey: "pk_4cdf3a2a836d979ac9d560a635465be8573755a85aeda993",
          purchaseController: purchaseController
        )

        // Sync the subscription status
        purchaseController.syncSubscriptionStatus()
    }
    
    // Function to check subscription status
    private func checkSubscriptionStatus() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let error = error {
                print("Failed to check subscription status: \(error.localizedDescription)")
                return
            }
            
            // Check if the user has the "pro" entitlement
            if customerInfo?.entitlements["pro"]?.isActive == true {
                Defaults[.premium] = true
                Superwall.shared.subscriptionStatus = .active // Sync with Superwall
                print("User is subscribed to pro.")
            } else {
                Defaults[.premium] = false
                Superwall.shared.subscriptionStatus = .inactive // Sync with Superwall
                print("User is not subscribed to pro.")
            }
            
            // Notify any UI components about the premium status change if needed
            NotificationCenter.default.post(name: NSNotification.Name("PremiumStatusChanged"), object: nil)
        }
    }
}

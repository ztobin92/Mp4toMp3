//
//  AppDelegate.swift
//  SampleProject
//
//  Created by Mehmet Salih Aslan on 3.11.2020.
//  Copyright © 2020 Mobillium. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Defaults
import Qonversion
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
        setupConverison()
        setupSpeakerOutput()
        AppRouter.shared.startApp()
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
    
    private func setupConverison() {
        let config = Qonversion.Configuration(projectKey: "dgGwY15UoYQyw1-X38OM8b21iCkrXpd9", launchMode: .subscriptionManagement)
        Qonversion.initWithConfig(config)
        RevenueHelper.shared.fetchProdutcs()
        Qonversion.shared().syncHistoricalData()
        Qonversion.shared().collectAppleSearchAdsAttribution()
    }
}

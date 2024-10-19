//
//  SettingsViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import MessageUI
import Defaults

protocol SettingsViewDataSource {
    func numberOfItemsAt(section: Int) -> Int
    func cellItemAt(indexPath: IndexPath) -> SettingsCellProtocol
}

protocol SettingsViewEventSource {}

protocol SettingsViewProtocol: SettingsViewDataSource, SettingsViewEventSource {}


final class SettingsViewModel: BaseViewModel<SettingsRouter>, SettingsViewProtocol, ObservableObject {
    
    // Instance of the RCPurchaseController
    private let purchaseController = RCPurchaseController()
    
    @Published var triggerLocalizeForPremiumContainer = false
    var reloadData: VoidClosure?
    
    var sectionTitles: [String] = []
    
    func numberOfItemsAt(section: Int) -> Int {
        return cellItems[section].count
    }
    
    func cellItemAt(indexPath: IndexPath) -> SettingsCellProtocol {
        return cellItems[indexPath.section][indexPath.row]
    }
    
    private lazy var cellItems: [[SettingsCellProtocol]] = []
    
    func configureCellItems() {
        var general = [
            SettingsCellModel(image: .icBackup, title: L10n.Modules.Settings.Section.General.restore, action: didTapRestore),
            SettingsCellModel(image: .init(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold))!, title: L10n.Modules.Settings.Section.General.clear, action: didTapClearHistory)
        ]
        
        if Defaults[.premium] || Defaults[.remainingCount] > 0 {
            general.insert(SettingsCellModel(image: .icLike, title: L10n.Modules.Settings.Section.General.rate, action: didTapRateUs), at: 0)
        }
        
        var help = [
            SettingsCellModel(image: .icAddress, title: L10n.Modules.Settings.Section.Help.contact, action: didTapContactUs)
        ]
        
        var settings = [
            SettingsCellModel(image: .icTranslateLanguage, title: L10n.Modules.Settings.Section.Settings.language, action: didTapLanguage),
            SettingsCellModel(image: .icAdjust, title: L10n.Modules.Settings.Section.Settings.theme, action: {})
        ]
        
        var other = [
            SettingsCellModel(image: .icLink, title: L10n.Modules.Settings.Section.Other.privacy, action: didTapPrivacy),
            SettingsCellModel(image: .icLink, title: L10n.Modules.Settings.Section.Other.terms, action: didTapTerms)
        ]
        
        cellItems = [
            general,
            help,
            settings,
            other
        ]
        
        sectionTitles = [
            L10n.Modules.Settings.Section.General.title,
            L10n.Modules.Settings.Section.Help.title,
            L10n.Modules.Settings.Section.Settings.title,
            L10n.Modules.Settings.Section.Other.title
        ]
        
        reloadData?()
    }
    
    func didTapRestore() {
        showLoading?()
        Task {
            let result = await purchaseController.restorePurchases()
            hideLoading?()
            
            switch result {
            case .restored:
                ToastPresenter.showWarningToast(text: L10n.Alert.restore, position: .bottomNote, color: .appBlue)
            case .failed(let error):
                print("Restore failed: \(error?.localizedDescription)")
            }
        }
    }
}


extension SettingsViewModel {
    private func didTapPrivacy() {
        router.presentInSafari(with: .init(string: "https://docs.google.com/document/d/1LTvVWq-m_HXm2djFJhGMmRU9sQjsZ60pZUp-gH5EfMo/mobilebasic")!)
    }
    
    private func didTapTerms() {
        router.presentInSafari(with: .init(string: "https://docs.google.com/document/d/1jlTAKxcNdR6vGPGhRQyEwbdLOEzaNn9OtN8-jqE1ops/mobilebasic")!)
    }
    
    private func didTapContactUs() {
        if MFMailComposeViewController.canSendMail() {
            let transition = ModalTransition(isAnimated: true, modalTransitionStyle: .coverVertical, modalPresentationStyle: .formSheet)
            router.open(MailHelper.shared.prepareComposer(), transition: transition)
            return
        }
        
        if let emailUrl = MailHelper.shared.createEmailUrl(to: "zach@productgrowth.com", subject: "", body: "") {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func didTapRateUs() {
        RatingHelper.shared.nativeRating()
    }
    
    private func didTapClearHistory() {
        
        AlertHelper.showAlert(
            title: L10n.Alert.Clear.title,
            message: L10n.Alert.Clear.desc,
            action1Title: L10n.Alert.cancel,
            action1Style: .default,
            action1Handler: { _ in
                
            },
            action2Title: L10n.Alert.clear,
            action2Style: .destructive,
            action2Handler: { _ in
                executeClear()
            },
            hasOneAction: false
            )
        
        func executeClear() {
            CacheHelper.clearCache(forKey: CacheHelper.Key.historyIDS.rawValue)
            
            let cacheURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let fileManager = FileManager.default
            do {
                // Get the directory contents urls (including subfolders urls)
                let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
                for file in directoryContents {
                    do {
                        try fileManager.removeItem(at: file)
                    }
                    catch let error as NSError {
                        debugPrint("Ooops! Something went wrong: \(error)")
                    }
                    
                }
                ToastPresenter.showWarningToast(text: L10n.Alert.Clear.success, position: .bottomNote, color: .appBlue)
            } catch let error as NSError {
                print(error.localizedDescription)
            }

        }
    }
    
   
    
    private func didTapLanguage() {
        router.pushChangeLanguage()
    }

}

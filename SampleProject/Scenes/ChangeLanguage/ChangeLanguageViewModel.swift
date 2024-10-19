//
//  ChangeLanguageViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 25.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import Localize_Swift
import Defaults

protocol ChangeLanguageViewDataSource {}

protocol ChangeLanguageViewEventSource {}

protocol ChangeLanguageViewProtocol: ChangeLanguageViewDataSource, ChangeLanguageViewEventSource {}

final class ChangeLanguageViewModel: BaseViewModel<ChangeLanguageRouter>, ChangeLanguageViewProtocol {
    @Published var languages = Localize.availableLanguages()
    var updateNavTitle: VoidClosure?
    
    @Published var selectedLanguage: String = Localize.currentLanguage() {
        willSet {
            Defaults[.prefferedLanguage] = newValue
            Localize.setCurrentLanguage(newValue)
            LocalizableManager.globalLocalize.send(newValue)
            updateNavTitle?()
        }
    }
}

extension ChangeLanguageViewModel: ObservableObject {
    
}

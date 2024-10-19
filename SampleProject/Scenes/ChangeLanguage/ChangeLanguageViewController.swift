//
//  ChangeLanguageViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 25.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI
import Localize_Swift

final class ChangeLanguageViewController: BaseViewController<ChangeLanguageViewModel> {
    
    let navBar = NavBar()
    @State var  selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupUI()
    }
    
    private func configureNavBar() {
        navBar.delegate = self
        navBar.setBackHidden(false)
        navBar.titleString = L10n.Modules.Language.title
        navBar.delegate = self
        
        viewModel.updateNavTitle = { [weak self] in
            guard let self else { return }
            navBar.titleString = L10n.Modules.Language.title
        }
    }
    
}

extension ChangeLanguageViewController: NavBarDelegate {
    func didTapClose() {
        viewModel.router.close()
    }
}

extension ChangeLanguageViewController {
    private func setupUI() {
        view.stack(
            navBar,
            ListView(vm: viewModel).asUIKit(),
            spacing: 32
        )
        .withMargins(.allSides(30))
    }

    struct ListView: View {
        @ObservedObject var vm: ChangeLanguageViewModel
        var body: some View {
            ScrollView (showsIndicators: false) {
                LazyVStack(content: {
                    ForEach(vm.languages.filter({$0 != "Base"}), id: \.self) { lang in
                        HStack {
                            Text(Localize.displayNameForLanguage(lang).capitalized)
                            Spacer()
                            Image(systemName: vm.selectedLanguage == lang ? "circle.circle.fill" : "circle")
                                .foregroundStyle(Color(uiColor: vm.selectedLanguage == lang ? .appBlue : .appHeather.withAlphaComponent(0.5)))
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 55)
                        .makeGradientBackground(singleColor: false,borderColor: vm.selectedLanguage == lang ? .appBlue : .appClearWhite)
                        .onTapGesture {
                            withAnimation {
                                vm.selectedLanguage = lang
                            }
                        }

                    }
                })
                .animation(.bouncy, value: vm.selectedLanguage)
            }
        }
    }

}

//
//  SettingsViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import SwiftUI
import Defaults

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    
    let navBar = NavBar()
    private lazy var premiumContainer = PremiumContainer(vm: viewModel).asUIKit()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingsCell.self)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .top(-30)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContents()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        premiumContainer.isHidden = Defaults[.premium]
        viewModel.configureCellItems()
        navBar.titleString = L10n.Modules.Settings.title
    }
    
    private func configureNavBar() {
        navBar.delegate = self
        navBar.setBackHidden(false)
        navBar.titleString = L10n.Modules.Settings.title
    }
    
    private func configureContents() {
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.reloadData = {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                tableView.reloadData()
            }
        }
    }
}

// MARK: - UILayout
extension SettingsViewController {
    private func setupUI() {
        setupSingleBlueBackground()
        
        view.stack(
            navBar,
            premiumContainer,
            tableView,
            spacing: 24
        ).withMargins(.init(top: 30, left: 30, bottom: 0, right: 30))
    }
    
    
    struct PremiumContainer: View {
        @ObservedObject var vm: SettingsViewModel
        @Default(.premium) var isPremium
        var body: some View {
            VStack {
                HStack  {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(L10n.Componenets.Premium.Container.unlock) **\(L10n.General.premium)**")
                            .font(.system(size: 22))
                            .lineLimit(2)
                            .foregroundColor(.white)
                        Text(L10n.Componenets.Premium.Container.desc)
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 0.96, green: 0.97, blue: 0.99))
                        Text(L10n.Componenets.Premium.Container.action)
                            .font(.system(size: 17 ,weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal,24)
                            .padding(.vertical, 8)
                            .makeGradientBackground(singleColor: false)
                            .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.2).opacity(0.2), radius: 7.5, x: 10, y: 10)
                    }
                    
                    Spacer()
                    Image(uiImage: .imgSettingContainerBanner)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: ScreenSize.width * 0.25)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                
            }
                .background {
                Rectangle()
                  .foregroundColor(.clear)
                  .background(Color(red: 0.13, green: 0.64, blue: 0.94))
                  .cornerRadius(20)
                  .overlay(
                    RoundedRectangle(cornerRadius: 20)
                      .inset(by: 0.5)
                      .stroke(Color(uiColor: .appClearWhite), lineWidth: 1)
                  )

                }
                .padding(.vertical, 16)
                .onTapGesture(perform: didTapPresnet)
                .onAppear(perform: {
                    vm.triggerLocalizeForPremiumContainer.toggle()
                })
        }
        
        func didTapPresnet() {
            UIImpactFeedbackGenerator().impactOccurred()
            vm.router.presentPaywall()
        }
    }
    
}

// MARK: - NavBarDelegate
extension SettingsViewController: NavBarDelegate {
    func didTapClose() {
        viewModel.router.close()
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsAt(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.cellItemAt(indexPath: indexPath).action()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(for: indexPath)
        let cellItem = viewModel.cellItemAt(indexPath: indexPath)
        cell.set(viewModel: cellItem)
        cell.textLabel?.text = cellItem.title
        cell.textLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        cell.imageView?.image = cellItem.image.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .appBlack
        let acc = UIImageView(image: .init(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 13))!)
        acc.tintColor = .appBlack
        cell.accessoryView = acc
        cell.backgroundColor = .clear
        cell.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        cell.selectionStyle = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
   
}

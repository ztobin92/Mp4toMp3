//
//  HomeViewController.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit
import LBTATools
import SwiftUI
import PhotosUI
import Defaults

final class HomeViewController: BaseViewController<HomeViewModel> {
    
    let navBar = NavBar()
    @Default(.premium) var isPremium
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupUI()
        viewModel.showRating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar.titleString = L10n.Modules.Home.title
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissHistoryView.send(())
    }
    
    
    private func presentHistory() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            viewModel.router.presentHistory()
        }
    }
    
    private func configureNavBar() {
        navBar.delegate = self
        navBar.setSettingHidden(false)
    }
    
    
}

// MARK: - UILayout
extension HomeViewController {
    private func setupUI() {
        setupSingleBlueBackground()
        setupSafeAreaContainer()
        
        safeAreaContainer.stack(
            navBar,
            ConntentContainer(viewModel: viewModel).asUIKit(),
            spacing: 48
        ).withMargins(.allSides(30))
        
    }
    
    struct ConntentContainer: View {
        @ObservedObject var viewModel: HomeViewModel
        var body: some View {
            VStack (spacing: 24) {
                ImportTitle()
                ImportContainer(viewModel: viewModel)
                Spacer()
            }
        }
    }
    
    struct ImportContainer: View {
        @ObservedObject var viewModel: HomeViewModel
        var body: some View {
            ZStack {
                VStack(spacing: 16) {
                    HStack (spacing: 24) {
                        Image(uiImage: .icGallery)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Text("\(L10n.Modules.Home.from) **\(L10n.Modules.Home.gallery)**")
                            .font(.system(size: 17))
                            .foregroundColor(Color(uiColor: .appBlack))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(UIColor.appHeather.withAlphaComponent(0.5)))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        didTapImport(source: .gallery)
                    }
                    Divider()
                        .frame(height: 1)
                        .foregroundColor(Color(UIColor.appHeather))
                    HStack (spacing: 24) {
                        Image(uiImage: .icFile)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        Text("\(L10n.Modules.Home.from) **\(L10n.Modules.Home.files)**")
                            .font(.system(size: 17))
                            .foregroundColor(Color(uiColor: .appBlack))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(UIColor.appHeather.withAlphaComponent(0.5)))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        didTapImport(source: .files)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
                .makeGradientBackground(singleColor: false, cornerRadius: 20)
            }
            .onAppear(perform: {
                viewModel.localizableTrigger.toggle()
            })
        }
        
        func didTapImport(source: HomeViewModel.VideoSourceType) {
            viewModel.selectVideosTapped(source: source)
        }
        
    }
}

// MARK: - UIDocumentPickerDelegate
extension HomeViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        let dispatch = DispatchGroup()

        var urlsToConvert: [URL] = []
        urls.forEach({_ in dispatch.enter()})
        urls.forEach { url in
            let tmpURL = url
            let name = tmpURL.deletingPathExtension().lastPathComponent
            
            let vidURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(name).mp4")
            do {
                if url.startAccessingSecurityScopedResource() {
                    if FileManager.default.fileExists(atPath: vidURL.path) {
                        try FileManager.default.removeItem(at: vidURL)
                    }
                    try FileManager.default.copyItem(at: url, to: vidURL)
                    urlsToConvert.append(vidURL)
                    dispatch.leave()
                } else {
                    dispatch.leave()
                }
            } catch (let error) {
                print(error.localizedDescription)
                dispatch.leave()
            }

        }
        
        dispatch.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                guard let self, !urlsToConvert.isEmpty else { return }
                viewModel.router.pushEdit(urls: urlsToConvert)
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Kullanıcı picker'ı iptal ettiğinde burası çağrılır
        print("Document picker was cancelled")
    }
}

// MARK: - PHPickerViewControllerDelegate
extension HomeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Seçilen videoları işleyin
        let dispatch = DispatchGroup()
        var videoURLs: [URL] = []
        let itemProviers = results.map {$0.itemProvider}
        itemProviers.forEach { item in
            dispatch.enter()
            DispatchQueue.main.async {
                if item.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    item.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, err in
                        if let url = url {
                            //video generation from temp url
                            var tmpURL = url
                            let name = tmpURL.deletingPathExtension().lastPathComponent
                            
                            let vidURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(name).mp4")
                            do {
                                if FileManager.default.fileExists(atPath: vidURL.path) {
                                    try FileManager.default.removeItem(at: vidURL)
                                }
                                try FileManager.default.copyItem(at: url, to: vidURL)
                                videoURLs.append(vidURL)
                                dispatch.leave()
                            } catch {
                                dispatch.leave()
                            }
                            //temp url has removed
                            
                        }
                    }
                }
            }
        }
        
        dispatch.notify(queue: .main) { [weak self] in
            guard let self = self else {return}
            picker.dismiss(animated: true)
            if videoURLs.isEmpty {return}
            viewModel.router.pushEdit(urls: videoURLs)
        }

    }
}

struct ImportTitle: View {
    @Default(.premium) var isPremium
    var body: some View {
        HStack {
            Text(L10n.Modules.Home.import)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(Color(UIColor.appBlack))
            Spacer()
            if !isPremium {
                HStack(content: {
                    Image(systemName: "crown")
                        .foregroundStyle(Color(UIColor.appBlue))
                    Text("\(L10n.Modules.Home.go) **\(L10n.General.premium)**")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(uiColor: .appBlack))
                })
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .makeGradientBackground(singleColor: false, cornerRadius: 8)
                .onTapGesture {
                    didTapPremium()
                  }
            }
        }
    }
    
    func didTapPremium() {
        if
            let vc = AppRouter.shared.topViewController() as? HistoryViewController
        {
            UIImpactFeedbackGenerator().impactOccurred()
            vc.viewModel.router.presentPaywall()
        }
    }
    
}

// MARK: - NavBar Delegate
extension HomeViewController: NavBarDelegate {
    func didTapSettings() {
        UIImpactFeedbackGenerator().impactOccurred()
        viewModel.router.pushSettings()
    }
}

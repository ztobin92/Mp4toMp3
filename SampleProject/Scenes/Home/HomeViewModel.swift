//
//  HomeViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 12.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import Photos
import PhotosUI
import MobileCoreServices
import Defaults

protocol HomeViewDataSource {}

protocol HomeViewEventSource {}

protocol HomeViewProtocol: HomeViewDataSource, HomeViewEventSource {}

final class HomeViewModel: BaseViewModel<HomeRouter>, HomeViewProtocol {
    
    @Published var localizableTrigger = false
    
    @frozen enum VideoSourceType {
        case gallery, files
    }
    
    
    func didAuthorized(authorized : @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .denied:
                DispatchQueue.main.async {
                    AlertHelper.showAlert(
                        title: L10n.Alert.Gallery.title,
                        message: L10n.Alert.Gallery.desc,
                        action1Title: L10n.Alert.cancel,
                        action2Title: L10n.Alert.settings,
                        action2Handler: {_ in
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    )
                }
            case .authorized:
                authorized()

            default:
                break;
            }
        }
    }
    
    func selectVideosTapped(source: VideoSourceType) {
        
        if Defaults[.remainingCount] < 1, !Defaults[.premium] {
            showPaywall()
            return
        }
        
        Defaults[.remainingCount] = max(-1, Defaults[.remainingCount] - 1)
        didAuthorized {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch source {
                case .gallery:
                    var configuration = PHPickerConfiguration()
                    configuration.filter = .videos // Sadece videoları seçmek için
                    configuration.selectionLimit = 0 // Sınırsız seçim için, belirli bir sayı da olabilir
                    configuration.preferredAssetRepresentationMode = .current
                    let pickerViewController = PHPickerViewController(configuration: configuration)
                    pickerViewController.delegate = router.viewController! as? PHPickerViewControllerDelegate
                    AppRouter.shared.topViewController()?.present(pickerViewController, animated: true)
                case .files:
                    let types: [UTType] = [UTType.video, UTType.movie]
                    let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
                    documentPickerController.delegate = router.viewController as? UIDocumentPickerDelegate
                    documentPickerController.allowsMultipleSelection = true // Birden çok seçime izin ver
                    AppRouter.shared.topViewController()?.present(documentPickerController, animated: true)
                }
            }
        }
    }
    
    func didTapSettings() {
            router.pushSettings()  // Ensure the router properly pushes the settings view controller
        }
    
    func showPaywall() {
        if
            let vc = AppRouter.shared.topViewController() as? HistoryViewController
        {
            UIImpactFeedbackGenerator().impactOccurred()
            vc.viewModel.router.presentPaywall()
        }
    }
    
    func showRating() {
        
        // First Run
        if Defaults[.firstRun] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                guard let self else { return }
                RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .general)
            }
            return
        }
        
        // Else
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            RatingHelper.shared.increaseLikeCountAndShowRatePopup(for: .welcome)
        }
        
    }
    
}

extension HomeViewModel: ObservableObject {
    
}

import SwiftUI

protocol EditBottomSheetRoute {
    func presentEditBottomSheet(editVM: EditViewModel)
}

extension EditBottomSheetRoute where Self: RouterProtocol {
    
    func presentEditBottomSheet(editVM: EditViewModel) {
        // Ensure the router has a valid viewController to present from
        guard let presentingViewController = self.viewController else {
            print("No presenting view controller found.")
            return
        }

        // Check if EditBottomSheetViewController is already being presented
        if let presentedVC = presentingViewController.presentedViewController as? EditBottomSheetViewController {
            print("EditBottomSheetViewController is already being presented.")
            return
        }
        
        let router = EditBottomSheetRouter()
        let bottomSheetViewModel = EditBottomSheetViewModel(editVM: editVM, router: router)
        let bottomSheetViewController = EditBottomSheetViewController(viewModel: bottomSheetViewModel)
        
        // Set modalPresentationStyle BEFORE accessing sheetPresentationController
        bottomSheetViewController.modalPresentationStyle = .automatic
        
        let transition = ModalTransition()
        router.viewController = bottomSheetViewController
        router.openTransition = transition
        
        // Configure the sheet if available
        if let sheet = bottomSheetViewController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { _ in ScreenSize.height * 0.3}, .large(), .custom { _ in 70}]
                sheet.largestUndimmedDetentIdentifier = sheet.detents[0].identifier
                sheet.selectedDetentIdentifier = sheet.detents[0].identifier
            } else {
                sheet.detents = [.large()]
                sheet.largestUndimmedDetentIdentifier = .large
            }

            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 40
        }
        
        // Present the bottom sheet from the current view controller
        presentingViewController.present(bottomSheetViewController, animated: true, completion: nil)
    }
}

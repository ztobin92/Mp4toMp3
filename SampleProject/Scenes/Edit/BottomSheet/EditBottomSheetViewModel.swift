//
//  EditBottomSheetViewModel.swift
//  SampleProject
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol EditBottomSheetViewDataSource {
    func numberOfItemsAt(section: Int) -> Int
    func cellItemAt(indexPath: IndexPath) -> EditBottomSheetCellProtocol
}

protocol EditBottomSheetViewEventSource {}

protocol EditBottomSheetViewProtocol: EditBottomSheetViewDataSource, EditBottomSheetViewEventSource {}

final class EditBottomSheetViewModel: BaseViewModel<EditBottomSheetRouter>, EditBottomSheetViewProtocol {
    
    private var cancellable = Set<AnyCancellable>()
    @ObservedObject var editVM: EditViewModel
    
    public enum Channel: String, CaseIterable, Identifiable {
        case single = "Single"
        case double = "Double"
        
        var id: String { self.rawValue }
        
        var value: CGFloat {
            switch self {
            case .single:
                return 1
            case .double:
                return 2
            }
        }
    }
    
    init(editVM: EditViewModel, router: EditBottomSheetRouter) {
        self.editVM = editVM
        super.init(router: router)
        dismissHistoryView.sink { _ in
            router.close()
        }.store(in: &cancellable)
    }
    
    func numberOfItemsAt(section: Int) -> Int {
        return cellItems.count
    }
    
    func cellItemAt(indexPath: IndexPath) -> EditBottomSheetCellProtocol {
        return cellItems[indexPath.row]
    }
    
    private let cellItems: [EditBottomSheetCellProtocol] = []
    
}

extension EditBottomSheetViewModel: ObservableObject {
    
}

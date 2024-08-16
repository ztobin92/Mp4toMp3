//
//  EditBottomSheetCell.swift
//  UIComponents
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import UIKit

public class EditBottomSheetCell: UICollectionViewCell, ReusableView {
    
    weak var viewModel: EditBottomSheetCellProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureContents()
    }
    
    private func configureContents() {
        
    }
    
    public func set(viewModel: EditBottomSheetCellProtocol) {
        self.viewModel = viewModel
        
    }
    
}

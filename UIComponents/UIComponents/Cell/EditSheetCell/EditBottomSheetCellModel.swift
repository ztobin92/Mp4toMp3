//
//  EditBottomSheetCellModel.swift
//  UIComponents
//
//  Created by Bora Erdem on 13.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation

public protocol EditBottomSheetCellDataSource: AnyObject {
    
}

public protocol EditBottomSheetCellEventSource: AnyObject {
    
}

public protocol EditBottomSheetCellProtocol: EditBottomSheetCellDataSource, EditBottomSheetCellEventSource {
    
}

public final class EditBottomSheetCellModel: EditBottomSheetCellProtocol {
    
}

//
//  ActionRestrictableTextField.swift
//  testrevolut
//
//  Created by Nikita Timonin on 14/10/2018.
//  Copyright © 2018 Nikita Timonin. All rights reserved.
//

import UIKit


final class ActionRestrictableTextField: UITextField {
    
    // MARK: - Public properties
    
    var canPerformPaste = false
    var canPerformCopy = false
    
    
    // MARK: - Public methods
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return canPerformPaste
        }
        
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return canPerformCopy
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
}

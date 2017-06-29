//
//  NewClass.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/21/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

class UIKitWrapper {
    
    typealias Validation = () -> ValidationPriority
    typealias ValidationHandler = (ValidationPriority) -> ()
    
    var element: EventProvider
    let validation: Validation
    let validationHandler: ValidationHandler
    
    init(element: EventProvider,
         validation: @escaping Validation,
         validationHandler: @escaping ValidationHandler) {
        self.element = element
        self.validation = validation
        self.validationHandler = validationHandler
    }
    
    func validateOnChange(enabled: Bool) {
        element.onEditingChanged(enabled: enabled, for: self, action: #selector(validate))
    }
}

extension UIKitWrapper {
    @objc func validate() {
        validationHandler(validation())
    }
}

protocol EventProvider {
    func onEditingChanged(enabled: Bool, for target: Any, action: Selector)
}

extension EventProvider where Self: UIControl {
    func onEditingChanged(enabled: Bool, for target: Any, action: Selector) {
        if enabled {
            self.addTarget(target, action: action, for: .editingChanged)
        } else {
            self.removeTarget(target, action: action, for: .editingChanged)
        }
    }
}

extension UITextField: EventProvider {}
extension UISlider: EventProvider {}
extension UISwitch: EventProvider {}

extension EventProvider where Self: UITextView {
    func onEditingChanged(enabled: Bool, for target: Any, action: Selector) {
        if enabled {
            NotificationCenter.default.addObserver(target, selector: action, name: .UITextViewTextDidChange, object: self)
        } else {
            NotificationCenter.default.removeObserver(self, name: .UITextViewTextDidChange, object: self)
        }
    }
}

extension UITextView: EventProvider {}



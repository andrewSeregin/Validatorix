//
//  NewClass.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/21/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

extension Validatorix {
    
    class Element {
        
        typealias ValidationHandler = (PriorityResult) -> Void
        
        var element: EventProvider
        let validation: Validatable
        let handler: ValidationHandler
        
        init(element: EventProvider,
             validation: Validatable,
             validationHandler: @escaping ValidationHandler) {
            self.element = element
            self.validation = validation
            self.handler = validationHandler
        }
        
        func setNeedsValidateOnChange(_ isEnable: Bool) {
            element.enableProvideEventOnEditingChanged(isEnable, for: self, action: #selector(validate))
        }
        
        deinit {
            self.setNeedsValidateOnChange(false)
        }
        
    }
    
}

@objc extension Validatorix.Element {
    
    func validate() {
        handler(validation.validationResult)
    }
    
}

protocol EventProvider {
    
    func enableProvideEventOnEditingChanged(_ isEnable: Bool, for target: Any, action: Selector)
}

extension EventProvider where Self: UIControl {
    
    func enableProvideEventOnEditingChanged(_ isEnable: Bool, for target: Any, action: Selector) {
        guard isEnable else {
            return self.removeTarget(target, action: action, for: .editingChanged)
        }
        self.addTarget(target, action: action, for: .editingChanged)
    }
    
}

extension UITextField: EventProvider {}
extension UISlider: EventProvider {}
extension UISwitch: EventProvider {}
extension UISegmentedControl: EventProvider {}

extension EventProvider where Self: UITextView {
    
    func enableProvideEventOnEditingChanged(_ isEnable: Bool, for target: Any, action: Selector) {
        guard isEnable else {
            return NotificationCenter.default.removeObserver(target, name: .UITextViewTextDidChange, object: self)
        }
        NotificationCenter.default.addObserver(target, selector: action, name: .UITextViewTextDidChange, object: self)
    }
}

extension UITextView: EventProvider {}



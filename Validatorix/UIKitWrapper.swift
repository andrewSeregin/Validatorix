//
//  UIKitElementWrapper.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/20/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

class UIKitWrapper {
    
    typealias Validation = () -> ValidationPriority
    typealias ValidationHandler = (ValidationPriority) -> ()
    
    var element: UITextField
    let validation: Validation
    let validationHandler: ValidationHandler
    
    init(element: UITextField,
         validation: @escaping Validation,
         validationHandler: @escaping ValidationHandler) {
        self.element = element
        self.validation = validation
        self.validationHandler = validationHandler
    }
    
    func validateOnChange(enabled: Bool) {
        if enabled {
            element.addTarget(self, action: #selector(validate(sender:)), for: .editingChanged)
        } else {
            element.removeTarget(self, action: #selector(validate(sender:)), for: .editingChanged)
        }
    }
}

extension UIKitWrapper {
    @objc func validate(sender: UITextField) {
        validationHandler(validation())
    }
}

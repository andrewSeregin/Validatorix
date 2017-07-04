//
//  ValidationElement.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/30/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

struct ValidationElement {
    
    let validation: Validated
    let validationHandler: UIKitWrapper.ValidationHandler
    
    let validationAction: () -> Void
}

extension ValidationElement {
    init(wrappedElement: UIKitWrapper) {
        self.init(validation: wrappedElement.validation,
                  validationHandler: wrappedElement.validationHandler,
                  validationAction: wrappedElement.validate)
    }
}

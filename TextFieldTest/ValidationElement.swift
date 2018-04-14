//
//  ValidationElement.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/30/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

struct ValidationElement {
    
    let validation: Validatable
    let handler: WrappedElement.ValidationHandler
    
    let validationAction: () -> Void
    
    func performValidation() {
        handler(validationResult)
    }
    
    var validationResult: PriorityResult {
        return validation.validationResult
    }
}

extension ValidationElement {
    
    init(wrappedElement: WrappedElement) {
        self.init(validation: wrappedElement.validation,
                  handler: wrappedElement.handler,
                  validationAction: wrappedElement.validate)
    }
    
}

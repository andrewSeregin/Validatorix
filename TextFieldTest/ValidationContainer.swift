//
//  ValidationContainer.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/30/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import Foundation

class ValidationContainer {
    
    private var container: [ObjectIdentifier: ValidationElement] = [:]
    let onValid: () -> Void
    let onInvalid: (ValidationResult.ErrorDescription) -> Void
    
    init(container: [ObjectIdentifier: ValidationElement] = [:],
         onValid: @escaping () -> Void,
         onInvalid: @escaping (ValidationResult.ErrorDescription) -> Void) {
        self.container = container
        self.onValid = onValid
        self.onInvalid = onInvalid
    }
    
    convenience init(container:  [ObjectIdentifier: ValidationElement] = [:],
                     delegate: ValidationDelegate) {
        self.init(container: container,
                  onValid: delegate.onValid,
                  onInvalid: delegate.onInvalid(using:))
    }
    
    func append(wrappedElement: UIKitWrapper?) {
        if let wrapped = wrappedElement {
            let element = ValidationElement(wrappedElement: wrapped)
            let identifier = ObjectIdentifier(wrapped)
            container[identifier] = element
        }
    }
    
    func remove(wrappedElement: UIKitWrapper) {
        let key = ObjectIdentifier(wrappedElement)
        container.removeValue(forKey: key)
    }
    
    func removeAll() {
        container.removeAll()
    }
    
    var isEmpty: Bool {
        return container.isEmpty
    }
    
    func validateAll() {
        var validationsErrors: [ValidationPriority] = []
        container.values.forEach {
            let result = $0.validation.validate()
            $0.validationHandler(result)
            if !result.isValid {
                validationsErrors.append(result)
            }
        }
        guard !validationsErrors.isEmpty else {
            return onValid()
        }
        let averagedError = validationsErrors
                                .reduce(ValidationPriority()) { $0 && $1 }
        onInvalid(averagedError.description)
    }
    
}

protocol ValidationDelegate {
    func onValid()
    func onInvalid(using description: ValidationResult.ErrorDescription)
}

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

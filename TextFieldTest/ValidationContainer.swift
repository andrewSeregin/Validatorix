//
//  ValidationContainer.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/30/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

protocol ValidationDelegate {
    func onValid()
    func onInvalid(using description: ValidationResult.ErrorDescription)
}

class ValidationContainer {
    
    private var container: [ObjectIdentifier: ValidationElement] = [:]
    let onValid: () -> Void
    let onInvalid: (ValidationResult.ErrorDescription) -> Void
    
    var isEmpty: Bool {
        return container.isEmpty
    }
    
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
    
    func validateAll() {
        var validationsErrors: [ValidationPriority] = []
        container.values.forEach {
            perform(on: $0) { validationsErrors.append($0) }
        }
        guard validationsErrors.isEmpty else {
            let averagedError = validationsErrors
                                    .reduce(ValidationPriority()) { $0 && $1 }
            return onInvalid(averagedError.description)
        }
        return onValid()
        
    }
    
    private func perform(on item: ValidationElement,
                         using handler: (ValidationPriority) -> Void) {
        let validationPriority = item.validation.validate()
        item.validationHandler(validationPriority)
        if !validationPriority.isValid {
            handler(validationPriority)
        }
    }
}

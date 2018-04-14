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
    
    typealias ErrorDescription = ValidationResult.ErrorDescription
    
    typealias ValidHandler = () -> Void
    typealias InvalidHandler = (ErrorDescription) -> Void
    
    private var container: [ObjectIdentifier: ValidationElement] = [:]
    
    private var onValid: ValidHandler?
    private var onInvalid: InvalidHandler?
    
    var isEmpty: Bool {
        return container.isEmpty
    }
    
    init(container: [ObjectIdentifier: ValidationElement] = [:],
         onValid: ValidHandler?,
         onInvalid: InvalidHandler?) {
        self.container = container
        self.onValid = onValid
        self.onInvalid = onInvalid
    }
    
    convenience init<Delegate: ValidationDelegate & AnyObject>(container:  [ObjectIdentifier: ValidationElement] = [:],
                                                               delegate: Delegate)  {
        
        self.init(container: container,
                  onValid: { [weak delegate] in delegate?.onValid() },
                  onInvalid: { [weak delegate] error in delegate?.onInvalid(using: error) })
    }
    
    convenience init<Delegate: ValidationDelegate>(container: [ObjectIdentifier: ValidationElement] = [:],
                                       delegate: Delegate) {
        self.init(container: container,
                  onValid: delegate.onValid,
                  onInvalid: delegate.onInvalid(using:))
    }
    
    func change<Delegate: ValidationDelegate & AnyObject>(delegate: Delegate) {
        self.onValid = { [weak delegate] in delegate?.onValid() }
        self.onInvalid = { [weak delegate] error in delegate?.onInvalid(using: error) }
    }
    
    func change<Delegate: ValidationDelegate>(delegate: Delegate) {
        self.onValid = delegate.onValid
        self.onInvalid = delegate.onInvalid(using:)
    }
    
    func removeDelegate() {
        self.onValid = nil
        self.onInvalid = nil
    }
    
    func append(_ wrappedElement: WrappedElement?) {
        guard let element = wrappedElement else { return }
        let identifier = ObjectIdentifier(element)
        container[identifier] = ValidationElement(wrappedElement: element)
    }
    
    
    func remove(_ wrappedElement: WrappedElement) {
        let identifier = ObjectIdentifier(wrappedElement)
        container.removeValue(forKey: identifier)
    }
    
    func removeAll() {
        container.removeAll()
    }
    
    func validate() {
        
        let errors = container.map { record -> PriorityResult in
            record.value.performValidation()
            return record.value.validationResult
        }.filter {
            $0.isValid.not
        }
        
        guard errors.isEmpty else {
            onInvalid?(errors.averagedError.description)
            return
        }
        
        onValid?()
        
    }
    
}

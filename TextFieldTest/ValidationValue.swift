//
//  ValidationValue.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

protocol ValidationValue {
    associatedtype Value
    var validationValue: Value { get }
    var isNotNil: Bool { get }
    
    func validate<R: Rule>(using rule: R) -> ValidationPriority  where R.Value == Self.Value
    func validate(using scopeOfRule: ScopeOfRules<Self.Value>) -> ValidationPriority
}

extension ValidationValue {
    var validationValue: Self { return self }
    var isNotNil: Bool { return true }
    
    func validate<R: Rule>(using rule: R) -> ValidationPriority  where R.Value == Self.Value {
        let scope = ScopeOfRules(rules: [rule])
        return validate(using: scope)
    }
    
    func validate(using scopeOfRule: ScopeOfRules<Self.Value>) -> ValidationPriority {
        if isNotNil {
            return scopeOfRule
                    .validate(value: self.validationValue)
                    .reduce(ValidationPriority()) { $0 && $1 }
        }
        let validationError = Constants.ValidationResult.ErrorDescription.empty
        return ValidationPriority(validationResult: .invalid(validationError))
    }
}

extension Int: ValidationValue {}
extension Float: ValidationValue {}
extension Double: ValidationValue {}
extension String: ValidationValue {}
extension Date: ValidationValue {}

extension Optional: ValidationValue {
    var validationValue: Wrapped {
        return unsafelyUnwrapped
    }
    
    var isNotNil: Bool {
        switch self {
        case .none: return false
        case .some(_): return true
        }
    }
}

extension UITextView: ValidationValue {
    var validationValue: String { return text }
}

extension UITextField: ValidationValue {
    var validationValue: String { return text ?? "" }
}

extension UISlider: ValidationValue {
    var validationValue: Float { return value }
}

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
    
    func validate<R: Rule>(using rule: R) -> ValidationPriority  where R.Value == Self.Value
    func validate(using scopeOfRule: ScopeOfRules<Self.Value>) -> ValidationPriority
}


extension ValidationValue {
    var validationValue: Self { return self }

    func validate<R: Rule>(using rule: R) -> ValidationPriority  where R.Value == Self.Value {
        let scope = ScopeOfRules(rules: [rule])
        return validate(using: scope)
    }
    
    func validate(using scopeOfRule: ScopeOfRules<Self.Value>) -> ValidationPriority {
        return scopeOfRule
            .validate(value: self.validationValue)
            .reduce(ValidationPriority()) { $0 && $1 }
    }
}

extension Int: ValidationValue {}
extension Float: ValidationValue {}
extension Double: ValidationValue {}
extension String: ValidationValue {}
extension Date: ValidationValue {}

extension UITextView: ValidationValue {
    var validationValue: String { return text }
}

extension UITextField: ValidationValue {
    var validationValue: String { return text ?? "" }
}

extension UISlider: ValidationValue {
    var validationValue: Float { return value }
}

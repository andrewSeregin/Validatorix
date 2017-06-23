//
//  Rule.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import Foundation

protocol Rule {
    associatedtype Value
    var prioruty: Bool { get }
    var errorDescription: ValidationResult.ErrorDescription { get }
    var condition: (Value) -> Bool { get }
    
    func validation(for value: Value) -> ValidationPriority
}

struct AnyRule<Value>: Rule {
    let prioruty: Bool
    let errorDescription: ValidationResult.ErrorDescription
    let condition: (Value) -> Bool
    
    init(prioruty: Bool = true,
         errorDescription: ValidationResult.ErrorDescription = Constants.ValidationResult.ErrorDescription.base,
         condition: @escaping (Value) -> Bool) {
        self.prioruty = prioruty
        self.errorDescription = errorDescription
        self.condition = condition
    }
    
    init<R: Rule>(converted rule: R) where R.Value == Value {
        self.init(prioruty: rule.prioruty, errorDescription: rule.errorDescription, condition: rule.condition)
    }
    
    func validation(for value: Value) -> ValidationPriority {
        let validationResult: ValidationResult = condition(value) ? .valid : .invalid(errorDescription)
        return ValidationPriority(isPrioruty: prioruty, validationResult: validationResult)
    }
}

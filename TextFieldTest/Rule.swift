//
//  Rule.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import Foundation

struct RuleDescription<Value> {
    var priority: Bool
    var errorDescription: ValidationResult.ErrorDescription
    var condition: (Value) -> Bool
}

protocol Rule {
    associatedtype Value
    var description: RuleDescription<Value> { get }
    
    func validation(for value: Value) -> ValidationPriority
}

extension Rule {
    func validation(for value: Value) -> ValidationPriority {
        let validationResult: ValidationResult = description.condition(value) ? .valid : .invalid(description.errorDescription)
        return ValidationPriority(isPrioruty: description.priority,
                                  validationResult: validationResult)
    }
}

struct AnyRule<Value>: Rule {
    let description: RuleDescription<Value>
}

extension AnyRule {
    init(priority: Bool = true,
         errorDescription: ValidationResult.ErrorDescription = Constants.ValidationResult.ErrorDescription.base,
         condition: @escaping (Value) -> Bool) {
        let description = RuleDescription(priority: priority,
                                          errorDescription: errorDescription,
                                          condition: condition)
        self.init(description: description)
    }
    
    init<R: Rule>(converted rule: R) where R.Value == Value {
        self.init(description: rule.description)
    }
}

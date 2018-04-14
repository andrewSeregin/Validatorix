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
    var template: RuleTemplate<Value> { get }
    
    func validation(for value: Value) -> PriorityResult
    
}

extension Rule {
    
    func validation(for value: Value) -> PriorityResult {
        let validationResult: ValidationResult = template.condition(value) ? .valid : .invalid(template.error)
        return PriorityResult(isPrioruty: template.isPriority,
                              result: validationResult)
    }
    
}

struct RuleTemplate<Value> {
    
    var isPriority: Bool
    var error: ValidationResult.ErrorDescription
    var condition: (Value) -> Bool
    
}

struct AnyRule<Value>: Rule {
    let template: RuleTemplate<Value>
}

extension AnyRule {
    
    init(isPriority: Bool = true,
         errorDescription: ValidationResult.ErrorDescription = Constants.ValidationResult.Error.base,
         condition: @escaping (Value) -> Bool) {
        let template = RuleTemplate(isPriority: isPriority,
                                    error: errorDescription,
                                    condition: condition)
        self.init(template: template)
    }
    
    init<Principle: Rule>(converted rule: Principle) where Principle.Value == Value {
        self.init(template: rule.template)
    }
}

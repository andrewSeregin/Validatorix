//
//  Validator.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

protocol Validatable {
    
    var validationResult: PriorityResult { get }
    
}

enum Validation {
    
    struct Validatorix<Value: ValidationValue>: Validatable {
        
        let value: Value
        let rules: Rules<Value.Value>
        
        var validationResult: PriorityResult {
            return Validatorix.validate(input: value, using: rules)
        }
        
        static func validate<Value: ValidationValue, Principle: Rule>(input value: Value,
                                                                      using rule: Principle) -> PriorityResult where Principle.Value == Value.Value {
            return value.validate(by: rule)
        }
        
        static func validate<Value: ValidationValue>(input value: Value,
                                                     using rules: Rules<Value.Value>) -> PriorityResult {
            return value.validate(by: rules)
        }
    }
    
}


extension Validation.Validatorix {
    
    init<Principle: Rule>(value: Value, rule: Principle) where Principle.Value == Value.Value {
        let rules = Rules(rules: [rule])
        self.init(value: value, rules: rules)
    }
    
}

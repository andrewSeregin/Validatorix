//
//  Validator.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

protocol Validated {
    func validate() -> ValidationPriority
}

struct Validatorix<Value: ValidationValue>: Validated {
    
    let value: Value
    let scopeOfRule: ScopeOfRules<Value.Value>
    
    func validate() -> ValidationPriority {
        return Validatorix.validate(input: value, using: scopeOfRule)
    }
    
    static func validate<Value: ValidationValue, R: Rule>(input value: Value,
                                                          using rule: R) -> ValidationPriority where R.Value == Value.Value {
        return value.validate(using: rule)
    }
    
    static func validate<Value: ValidationValue>(input value: Value,
                                                 using scopeOfRule: ScopeOfRules<Value.Value>) -> ValidationPriority {
        return value.validate(using: scopeOfRule)
    }
}

extension Validatorix {
    init<R: Rule>(value: Value, rule: R) where R.Value == Value.Value {
        let scopeOfRule = ScopeOfRules(rules: [rule])
        self.init(value: value, scopeOfRule: scopeOfRule)
    }
}

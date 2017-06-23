//
//  Validator.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

struct Validatorix {
    
    static func validate<Value: ValidationValue, R: Rule>(input value: Value, using rule: R) -> ValidationPriority where R.Value == Value.Value {
        return value.validate(using: rule)
    }
    
    static func validate<Value: ValidationValue>(input value: Value, using scopeOfRule: ScopeOfRules<Value.Value>) -> ValidationPriority {
        return value.validate(using: scopeOfRule)
    }
    
    
}

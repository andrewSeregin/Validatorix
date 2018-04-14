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
    var template: Validatorix.RuleTemplate<Value> { get }
    
    func validation(for value: Value) -> Validatorix.PriorityResult
    
}

extension Rule {
    
    func validation(for value: Value) -> Validatorix.PriorityResult {
        let validationResult: Validatorix.Result = template.condition(value) ? .valid : .invalid(template.error)
        return Validatorix.PriorityResult(isPrioruty: template.isPriority,
                                          result: validationResult)
    }
    
}

extension Validatorix {
    
    struct AnyRule<Value>: Rule {
        let template: RuleTemplate<Value>
    }
    
    struct RuleTemplate<Value> {
        
        var isPriority: Bool
        var error: Validatorix.Result.ErrorDescription
        var condition: (Value) -> Bool
        
    }
    
}


extension Validatorix.AnyRule {
    
    init(isPriority: Bool = true,
         errorDescription: Validatorix.Result.ErrorDescription = Validatorix.Constants.Result.Error.base,
         condition: @escaping (Value) -> Bool) {
        let template = Validatorix.RuleTemplate(isPriority: isPriority,
                                               error: errorDescription,
                                               condition: condition)
        self.init(template: template)
    }
    
    init<Principle: Rule>(converted rule: Principle) where Principle.Value == Value {
        self.init(template: rule.template)
    }
}

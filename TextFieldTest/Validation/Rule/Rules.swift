//
//  Rules.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/21/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

extension Validatorix {
    
    struct Rules<Value> {
        
        fileprivate var _rules: [AnyRule<Value>] = []
        
        var isEmpty: Bool {
            return _rules.isEmpty
        }
        
        mutating func append(condition: @escaping (Value) -> Bool) {
            let rule = AnyRule(condition: condition)
            append(rule: rule)
        }
        
        mutating func append(rule: AnyRule<Value>) {
            _rules.append(rule)
        }
        
        func validate(value: Value) -> [PriorityResult] {
            return _rules.validate(value: value)
        }
    }
    
}

extension Validatorix.Rules {
    
    init<Principle: Rule>(rules: [Principle]) where Principle.Value == Value {
        self._rules = rules.compactMap(Validatorix.AnyRule.init)
    }
    
}

extension Sequence where Iterator.Element: Rule {
    
    func validate(value: Self.Element.Value) -> [PriorityResult] {
        return self.compactMap { $0.validation(for: value) }
    }
    
}

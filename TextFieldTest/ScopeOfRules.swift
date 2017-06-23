//
//  ScopeOfRules.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/21/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

struct ScopeOfRules<Value> {
    private var _rules: [AnyRule<Value>] = []
    
    init() {}
    
    init<R: Rule>(rules: [R]) where R.Value == Value {
        self._rules = rules.flatMap(AnyRule.init)
    }
    
    mutating func appendRule(using condition: @escaping (Value) -> Bool) {
        let rule = AnyRule(condition: condition)
        appendRule(using: rule)
    }
    
    mutating func appendRule(using rule: AnyRule<Value>) {
        _rules.append(rule)
    }
    
    func validate(value: Value) -> [ValidationPriority] {
        return _rules.flatMap { $0.validation(for: value) }
    }
}

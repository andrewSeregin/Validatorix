//
//  ScopeOfRules.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/21/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

extension Sequence where Iterator.Element : Rule {
    func validate(value: Self.Element.Value) -> [ValidationPriority] {
        return self.flatMap { $0.validation(for: value) }
    }
}

struct ScopeOfRules<Value> {
    fileprivate var _rules: [AnyRule<Value>] = []
    
    var isEmpty: Bool {
        return _rules.isEmpty
    }
    
    mutating func appendRule(using condition: @escaping (Value) -> Bool) {
        let rule = AnyRule(condition: condition)
        appendRule(using: rule)
    }
    
    mutating func appendRule(using rule: AnyRule<Value>) {
        _rules.append(rule)
    }
    
    func validate(value: Value) -> [ValidationPriority] {
        return _rules.validate(value: value)
    }
}

extension ScopeOfRules {
    init<R: Rule>(rules: [R]) where R.Value == Value {
        self._rules = rules.flatMap(AnyRule.init)
    }
}


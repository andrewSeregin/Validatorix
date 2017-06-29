//
//  RulePopulator.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import Foundation

enum RulePopulator {
    
    enum Comparisons {
        static func makeGreaterThenRule<Value: Comparable>(value: Value) -> AnyRule<Value> {
            return AnyRule { $0 > value }
        }
        
        static func makeGreaterOrEqualThanRule<Value: Comparable>(value: Value) -> AnyRule<Value> {
            return AnyRule { $0 >= value }
        }
        
        static func makeSmallerThenRule<Value: Comparable>(value: Value) -> AnyRule<Value> {
            return AnyRule { $0 < value }
        }
        
        static func makeSmallerOrEqualThanRule<Value: Comparable>(value: Value) -> AnyRule<Value> {
            return AnyRule { $0 <= value }
        }
        
        static func makeGreaterAndSmallerThenRule<Value: Comparable>(minimum start: Value, maximum finish: Value) -> AnyRule<Value> {
            let greaterThenRule = RulePopulator.Comparisons.makeGreaterThenRule(value: start)
            let smallerThenRule = RulePopulator.Comparisons.makeSmallerThenRule(value: finish)
            return AnyRule { greaterThenRule.description.condition($0) && smallerThenRule.description.condition($0) }
        }
        
        static func makeGreaterOrEqualAndSmallerOrEqualThenRule<Value: Comparable>(minimum start: Value, maximum finish: Value) -> AnyRule<Value> {
            let greaterOrEqualThenRule = RulePopulator.Comparisons.makeGreaterOrEqualThanRule(value: start)
            let smallerOrEqualThenRule = RulePopulator.Comparisons.makeSmallerOrEqualThanRule(value: finish)
            return AnyRule { greaterOrEqualThenRule.description.condition($0) && smallerOrEqualThenRule.description.condition($0) }
        }
    }

    
    enum RegExp {
        static func makeCustomRule<Pattern: CustomStringConvertible>(using pattern: Pattern) -> AnyRule<String> {
            let predicate = NSPredicate(format: Constants.RegExp.predicateFormat, pattern.description)
            return AnyRule { predicate.evaluate(with: $0) }
        }
        
    }
}




//
//  RulePopulator.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import Foundation

extension Validation {
    
    enum Populator {
        
        enum Equality {
            
            static func equal<Value: Equatable>(to value: Value) -> AnyRule<Value> {
                return AnyRule { $0 == value }
            }
            
            static func noteEqual<Value: Equatable>(to value: Value) -> AnyRule<Value> {
                return AnyRule.init { $0 != value }
                
            }
        }
        
        enum Comparisons {
            
            static func greater<Value: Comparable>(than value: Value) -> AnyRule<Value> {
                return AnyRule { $0 > value }
            }
            
            static func greaterOrEqual<Value: Comparable>(than value: Value) -> AnyRule<Value> {
                return AnyRule { $0 >= value }
            }
            
            static func smaller<Value: Comparable>(than value: Value) -> AnyRule<Value> {
                return AnyRule { $0 < value }
            }
            
            static func smallerOrEqual<Value: Comparable>(than value: Value) -> AnyRule<Value> {
                return AnyRule { $0 <= value }
            }
            
            static func greater<Value: Comparable>(than minimum: Value, smaller maximum: Value) -> AnyRule<Value> {
                let greaterRule = Comparisons.greater(than: minimum)
                let smallerRule = Comparisons.smaller(than: maximum)
                return AnyRule{ greaterRule.template.condition($0) && smallerRule.template.condition($0) }
            }
            
            static func greaterOrEqual<Value: Comparable>(than minimum: Value, smallerOrEqual maximum: Value) -> AnyRule<Value> {
                let greaterOrEqualRule = Comparisons.greaterOrEqual(than: minimum)
                let smallerOrEqualRule = Comparisons.smaller(than: maximum)
                return AnyRule { greaterOrEqualRule.template.condition($0) && smallerOrEqualRule.template.condition($0) }
            }
        }
        
        enum RegExp {
            
            static func custom<Pattern: CustomStringConvertible>(by pattern: Pattern) -> AnyRule<String> {
                let predicate = NSPredicate(format: Constants.RegExp.predicateFormat, pattern.description)
                return AnyRule { predicate.evaluate(with: $0) }
            }
            
        }
        
    }
    
}






//
//  ValidationValue.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

protocol ValidationValue {
    typealias Priority = PriorityResult
    
    associatedtype Value
    
    var value: Value { get }
    var isEmpty: Bool { get }
    
    func validate<R: Rule>(by rule: R) -> Priority
    func validate(by rules: Rules<Value>) -> Priority
}

extension ValidationValue {
    
    var value: Self { return self }
    var isEmpty: Bool { return false }
    
    func validate<R: Rule>(by rule: R) -> Priority  {
        guard let rules = Rules(rules: [rule]) as? Rules<Value> else {
            let errorDescription = Constants.ValidationResult.Error.Reasons.mismatchedType
            return Priority(result: .invalid(errorDescription))
        }
        return validate(by: rules)
    }
    
    func validate(by rules: Rules<Value>) -> Priority {
        
        guard isEmpty else {
            return rules.validate(value: value).reduce(Priority()) { $0 && $1 }
        }
        
        let errorDescription = Constants.ValidationResult.Error.Reasons.emptyValue
        return PriorityResult(result: .invalid(errorDescription))
        
    }
}

extension Int: ValidationValue {}
extension Float: ValidationValue {}
extension Double: ValidationValue {}
extension String: ValidationValue {}
extension Date: ValidationValue {}

extension Optional: ValidationValue {
    
    var value: Wrapped {
        return unsafelyUnwrapped
    }
    
    var isEmpty: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }
}

extension UITextField: ValidationValue {
    var value: String { return text ?? ""}
}

extension UITextView: ValidationValue {
    var value: String { return text }
}

extension UISlider: ValidationValue {}

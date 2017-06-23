//
//  ValidationResult.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/20/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

enum ValidationResult {
    
    typealias ErrorDescription = String
    
    case valid
    case invalid(ErrorDescription)
    
    var isValid: Bool {
        return self == .valid
    }
    
    static func &&(lhs: ValidationResult,
                   rhs: @autoclosure () throws -> ValidationResult) rethrows -> ValidationResult {
        switch lhs {
        case .valid:
            return try rhs()
        case .invalid(let error):
            if case let ValidationResult.invalid(anotherError) = try rhs() {
                let resultError = error + anotherError
                return .invalid(resultError)
            }
            return lhs
        }
    }
    
    func merge(validation results: [ValidationResult]) -> ValidationResult {
        return results.reduce(self) { $0 && $1 }
    }
}

extension ValidationResult: Equatable {
    public static func ==(lhs: ValidationResult,
                          rhs: ValidationResult) -> Bool {
        switch (lhs, rhs) {
        case (.valid, valid): return true
        case (.invalid(let one), .invalid(let two)):
            return one == two
        default:
            return false
        }
    }
}

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .valid:
            return Constants.ValidationResult.valid
        case .invalid(let errorDescription):
            return errorDescription
        }
    }
}

//
//  ValidationResult.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/20/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

extension Validatorix {
    
    enum Result {
        
        typealias ErrorDescription = String
        
        case valid
        case invalid(ErrorDescription)
        
        var isValid: Bool {
            return self == .valid
        }
        
        static func &&(lhs: Validatorix.Result,
                       rhs: @autoclosure () throws -> Validatorix.Result) rethrows -> Validatorix.Result {
            switch lhs {
            case .valid:
                return try rhs()
            case .invalid(let error):
                if case let Validatorix.Result.invalid(anotherError) = try rhs() {
                    let resultError = error + anotherError
                    return .invalid(resultError)
                }
                return lhs
            }
        }
        
        func merge(validation results: [Validatorix.Result]) -> Validatorix.Result {
            return results.reduce(self) { $0 && $1 }
        }
    }
    
}

extension Validatorix.Result: Equatable {
    public static func == (lhs: Validatorix.Result,
                           rhs: Validatorix.Result) -> Bool {
        switch (lhs, rhs) {
        case (.valid, valid): return true
        case (.invalid(let one), .invalid(let two)):
            return one == two
        default:
            return false
        }
    }
}

extension Validatorix.Result: CustomStringConvertible {
    var description: String {
        switch self {
        case .valid:
            return Validatorix.Constants.Result.valid
        case .invalid(let errorDescription):
            return errorDescription
        }
    }
}

//
//  ValidationPriority .swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/20/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

extension Bool {
    var not: Bool { return !self }
}

struct PriorityResult {
    let isPrioruty: Bool
    let result: ValidationResult

    init(isPrioruty: Bool = true,
         result: ValidationResult = .valid) {
        self.isPrioruty = isPrioruty
        self.result = result
    }
    
    static func && (lhs: PriorityResult,
                    rhs: @autoclosure () -> PriorityResult)  -> PriorityResult {
        
        let validationResult = lhs.result && rhs().result
        let isPrioruty = lhs.isPrioruty || rhs().isPrioruty
        return PriorityResult(isPrioruty: isPrioruty, result: validationResult)
        
    }
    
    var isValid: Bool {
        return self.result.isValid
    }
}

extension PriorityResult: CustomStringConvertible {
    var description: String {
        return result.description
    }
}

extension Sequence where Iterator.Element == PriorityResult {
    
    var averagedError: PriorityResult {
        return self.reduce(PriorityResult()) { $0 && $1 }
    }
    
}

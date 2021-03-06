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

extension Validatorix {
    
    struct PriorityResult {
        let isPrioruty: Bool
        let result: Validatorix.Result
        
        init(isPrioruty: Bool = true,
             result: Validatorix.Result = .valid) {
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
    
}



extension Validatorix.PriorityResult: CustomStringConvertible {
    var description: String {
        return result.description
    }
}

extension Sequence where Iterator.Element == Validatorix.PriorityResult {
    
    var average: Validatorix.PriorityResult {
        return self.reduce(Validatorix.PriorityResult()) { $0 && $1 }
    }
    
}

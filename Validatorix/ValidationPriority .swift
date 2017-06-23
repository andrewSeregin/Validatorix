//
//  ValidationPriority .swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/20/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

struct ValidationPriority {
    let isPrioruty: Bool
    let validationResult: ValidationResult
    
    init(isPrioruty: Bool = true,
         validationResult: ValidationResult = .valid) {
        self.isPrioruty = isPrioruty
        self.validationResult = validationResult
    }
    
    static func &&(lhs: ValidationPriority,
                   rhs: @autoclosure () -> ValidationPriority)  -> ValidationPriority {
            let validationResult = lhs.validationResult && rhs().validationResult
            return ValidationPriority(validationResult: validationResult)
    }
}

extension ValidationPriority: CustomStringConvertible {
    var description: String {
        return validationResult.description
    }
}

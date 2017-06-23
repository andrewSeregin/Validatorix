//
//  Constanrs.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/20/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import Foundation

enum Constants {

    enum ValidationResult {
        static let valid = "Valid"
        
        enum ErrorDescription {
            static let base = "Does not satisfy the rule."
        }
        
    }
    
    enum RegExp {
        static let predicateFormat = "SELF MATCHES %@"
    }
}

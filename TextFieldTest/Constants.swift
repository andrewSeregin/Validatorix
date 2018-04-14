//
//  Constanrs.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/20/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import Foundation

extension Validatorix {
    
    enum Constants {
        
        enum Result {
            static let valid = "Valid"
            
            enum Error {
                static let base = "Does not satisfy the rules"
                
                enum Reasons {
                    static let emptyValue = "Value can't be empty"
                    static let mismatchedType = "Mismatched type"
                }
                
            }
        }
        
        enum RegExp {
            static let predicateFormat = "SELF MATCHES %@"
        }
    }
    
}




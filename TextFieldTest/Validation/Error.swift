//
//  Error.swift
//  TextFieldTest
//
//  Created by apple on 4/14/18.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

import Foundation

extension Validatorix {
    
    enum Error: Swift.Error {
        
        typealias ErrorDescription = Constants.Result.Error
        
        case emptyValue
        case mismatchedType
    }
    
}

extension Validatorix.Error: CustomStringConvertible {
    
    var description: String {
        return ErrorDescription.base + ": " + reason
    }
    
    var reason: String {
        switch self {
        case .emptyValue:
            return ErrorDescription.Reasons.emptyValue
        case .mismatchedType:
            return ErrorDescription.Reasons.mismatchedType
        }
    }
    
}

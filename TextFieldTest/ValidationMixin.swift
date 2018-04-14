//
//  ValidationMixin.swift
//  TextFieldTest
//
//  Created by apple on 4/14/18.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

import Foundation

protocol ContainerAppendableMixin {}

extension ContainerAppendableMixin where Self: EventProvider & ValidationValue & WrappableMixin {
    
    func register(to container: Validatorix.Container,
                  basedOn rule: Validatorix.AnyRule<Self.Value>,
                  for handler: @escaping Validatorix.Element.ValidationHandler = { _ in }) {
        
        let wrapped = self.wrapp(by: rule, for: handler)
        container.append(wrapped)
        
    }
    
}

protocol WrappableMixin {}

extension WrappableMixin where Self: EventProvider & ValidationValue {
    
    func wrapp(by rules: Validatorix.AnyRule<Self.Value>,
               for handler: @escaping Validatorix.Element.ValidationHandler) -> Validatorix.Element {
        let validationCore = Validatorix.Validation(value: value, rule: rules)
        return Validatorix.Element(element: self,
                                  validation: validationCore,
                                  validationHandler: handler)
    }
}

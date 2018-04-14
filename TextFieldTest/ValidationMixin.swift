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
    
    func register(to container: Validation.Container,
                  basedOn rule: AnyRule<Self.Value>,
                  for handler: @escaping Validation.Element.ValidationHandler = { _ in }) {
        
        let wrapped = self.wrapp(by: rule, for: handler)
        container.append(wrapped)
        
    }
    
}

protocol WrappableMixin {}

extension WrappableMixin where Self: EventProvider & ValidationValue {
    
    func wrapp(by rules: AnyRule<Self.Value>,
               for handler: @escaping Validation.Element.ValidationHandler) -> Validation.Element {
        let validationCore = Validation.Validatorix(value: value, rule: rules)
        return Validation.Element(element: self,
                                  validation: validationCore,
                                  validationHandler: handler)
    }
}

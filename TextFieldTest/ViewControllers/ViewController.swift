//
//  ViewController.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/21/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private(set) weak var castomSlider: UISlider!
    @IBOutlet private(set) weak var textField: UITextField!
    @IBOutlet private(set) weak var blockTextField: UITextField!
    @IBOutlet private(set) weak var resultLabel: UILabel!
    
    var field: UIKitWrapper?
    var newField: UIKitWrapper?
    var sliderWraper: UIKitWrapper?
    
    var container: ValidationContainer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let r = AnyRule { $0 == "Andrew" }
        print(textField.validate(using: r))
        
        field = UIKitWrapper(element: textField,
                             validation: { self.textField.validate(using: r) },
                             validationHandler: { _ in print("Hi!") })
        field?.validateOnChange(enabled: true)
        
        
        let rule = AnyRule { (value: String) in
            if let number = Int(value), number == 5 {
                return true
            }
            return false
        }
        newField = UIKitWrapper(element: blockTextField,
                                validation: { self.blockTextField.validate(using: rule) },
                                validationHandler: {
                                    self.field?.validateOnChange(enabled: !$0.isValid)
                                })
        newField?.validateOnChange(enabled: true)*/
        
        //let value: String? = nil
        
        /*let nsString: NSString? = nil
        print(nsString.isNotNil)
        let nsStringRule: AnyRule<NSString> = AnyRule { $0 == "Andrew" }
        
        let result = nsString.validate(using: nsStringRule)
        print(result)
        
        /*print(value.validate(using: r).description)*/
        
        let new: New? = New(one: "Andrew")
        let rule: AnyRule<New> = AnyRule{ $0.one == "Andrew" }
        
        let res = new.validate(using: rule)
        print(res)*/
        
        let value: String??? = "Hi"
        /*let res: String = value.cast(proprty: value)
        print(res)*/
        
        container = ValidationContainer(delegate: self)
        container?.append(wrappedElement: field)
        container?.append(wrappedElement: newField)
        container?.append(wrappedElement: sliderWraper)
    }
}

extension ViewController: ValidationDelegate {
    func onValid() {
        print("Valid")
    }
    
    func onInvalid(using description: ValidationResult.ErrorDescription) {
        print(description)
    }
}

struct New {
    let one: String
}

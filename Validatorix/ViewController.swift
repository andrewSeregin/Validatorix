//
//  ViewController.swift
//  Validatorix
//
//  Created by Andrew Seregin on 6/19/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private(set) weak var testTextField: UITextField!
    @IBOutlet private(set) weak var resultLabel: UILabel!
    
    private var wraper: UIKitWrapper?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var scope = ScopeOfRules<TestStruct>()
        scope.appendRule { $0.valueOne == "Andrew" }
        scope.appendRule { $0.valueTwo == 2 }
        
        let user = TestStruct(valueOne: "Andrew", valueTwo: 2)
        let validationResult = Validatorix.validate(input: user, using: scope)
        print(validationResult)
        

        let newRule = RulePopulator.Comparisons.makeGreaterAndSmallerThenRule(minimum: -5, maximum: 5)
        print(4.validate(using: newRule))
        
        let rule = RulePopulator.RegExp.makeCustomRule(using: "^.+@.+\\..+$")
        print("aff@a.a".validate(using: rule))
        
        let textField = UITextField()
        textField.text = "aff@aa"
        
        //TODO: Impliment
        /*let nt = AnyRule<UITextField> {
            $0.validationValue
                .valudate(using: RulePopulator.RegExp.makeCustomRule(using: "^.+@.+\\..+$"))
                .validationResult
                .isValid
        }
        print(textField.valudate(using: nt))*/
        
        let r = AnyRule { $0 == "Andrew" }
        print(textField.validate(using: r))
        
        var newScope = ScopeOfRules<String>()
        newScope.appendRule { value in
            value != "Andrew"
        }
        print(textField.validate(using: newScope))
        
        print(Validatorix.validate(input: textField, using: newScope))
        
        wraper = UIKitWrapper(element: textField,
                              validation: { self.testTextField.validate(using: r) },
                              validationHandler: { self.resultLabel.text = $0.description})
        wraper?.validateOnChange(enabled: true)
        
    }
    
    @IBAction func conection(_ sender: Any) {
        
    }
    
}

struct TestStruct {
    var valueOne: String
    var valueTwo: Int
}

extension TestStruct: ValidationValue {}

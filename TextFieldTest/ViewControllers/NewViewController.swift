//
//  NewViewController.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/21/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

protocol ValidationContainerAppendableMixin {}

extension ValidationContainerAppendableMixin where Self: EventProvider & ValidationValue & ValidationWrappableMixin {
    
    func append(to container: ValidationContainer,
                basedOn rule: AnyRule<Self.Value>,
                for handler: @escaping WrappedElement.ValidationHandler = { _ in }) {
        
        let wrapped = self.wrapp(by: rule, for: handler)
        container.append(wrapped)
    }
    
}

protocol ValidationWrappableMixin {}

extension ValidationWrappableMixin where Self: EventProvider & ValidationValue {
    
    func wrapp(by rules: AnyRule<Self.Value>,
               for handler: @escaping WrappedElement.ValidationHandler) -> WrappedElement {
        let validationCore = Validation.Validatorix(value: value, rule: rules)
        return WrappedElement(element: self,
                              validation: validationCore,
                              validationHandler: handler)
    }
}

extension UITextField: ValidationContainerAppendableMixin {}
extension UITextField: ValidationWrappableMixin {}

class NewViewController: UIViewController {

    let value = UISlider(frame: .zero)
    
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var wraper: WrappedElement?
    
    @IBOutlet weak var secondTextView: UITextView!
    var secondWraper: WrappedElement?
    
    
    let textField = UITextField(frame: .zero)

    var container: ValidationContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = ValidationContainer(delegate: self)
        let ruleTwo = Validation.Populator.Equality.equal(to: "Andrew")
        textField.append(to: container, basedOn: ruleTwo)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        container?.validate()
    }
}


extension NewViewController: ValidationDelegate {
    func onValid() {
        validationLabel.text = "Valid"
    }
    
    func onInvalid(using description: ValidationResult.ErrorDescription) {
        let alert = UIAlertController(title: "Validation Error", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
        validationLabel.text = description
    }
}

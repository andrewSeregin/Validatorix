//
//  NewViewController.swift
//  TextFieldTest
//
//  Created by Andrew Seregin on 6/21/17.
//  Copyright © 2017 Andrew Seregin. All rights reserved.
//

import UIKit

extension UITextField: ContainerAppendableMixin {}
extension UITextField: WrappableMixin {}

class NewViewController: UIViewController {

    let value = UISlider(frame: .zero)
    
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var wraper: Validation.Element?
    
    @IBOutlet weak var secondTextView: UITextView!
    var secondWraper: Validation.Element?
    
    
    let textField = UITextField(frame: .zero)
    
    var container: Validation.Container?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = Validation.Container(delegate: self)
        let ruleTwo = Validation.Populator.Equality.equal(to: "Andrew")
        textField.register(to: container, basedOn: ruleTwo)
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

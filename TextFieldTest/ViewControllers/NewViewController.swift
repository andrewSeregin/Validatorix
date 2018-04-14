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
    var wraper: Validatorix.Element?
    
    @IBOutlet weak var secondTextView: UITextView!
    var secondWraper: Validatorix.Element?
    
    
    let textField = UITextField(frame: .zero)
    
    var container: Validatorix.Container?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let container = Validatorix.Container(delegate: self)
        let ruleTwo = Validatorix.Populator.Equality.equal(to: "Andrew")
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
    
    func onInvalid(using description: Validatorix.Result.ErrorDescription) {
        let alert = UIAlertController(title: "Validation Error", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
        validationLabel.text = description
    }
}

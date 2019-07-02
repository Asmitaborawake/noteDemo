//
//  EditViewController.swift
//  Note
//
//  Created by Mac on 22/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

protocol editDataDelegate {
    func editdata(title:String , desc:String)
}
class EditViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLbl: UITextField!
    
    @IBOutlet weak var descLbl: UITextView!
    
    
    
    var selectedNote = [Note]()
    var delegate : editDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        topView.layer.cornerRadius = 10
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.orange.cgColor
        self.title = "Edit Note"
        for data in selectedNote {
            titleLbl.text = data.title
            descLbl.text = data.descriptionLbl
        }

    }

   
    @IBAction func doneClick(_ sender: Any) {
        let title = titleLbl.text!
        let desc =  descLbl.text!
        delegate?.editdata(title: title, desc: desc)
    
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
}

//
//  ChildrenViewCell.swift
//  alefTestProject
//
//  Created by Alibek Ismagulov on 31.07.2023.
//

import UIKit

class ChildrenViewCell: UITableViewCell {
    
    weak var delegate: ChildrenViewCellDelegate?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var kidName: UITextField!
    @IBOutlet weak var kidAge: UITextField!
    lazy var bar: UIToolbar = {
        let bar = UIToolbar()
        let doneButton = UIBarButtonItem(title:"Done", style: .plain, target: self, action: #selector(donePressed))
        bar.items = [doneButton]
        bar.sizeToFit()
        
        return bar
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        kidName.delegate = self
        kidAge.delegate = self
        kidAge.inputAccessoryView = bar
    }
    
    override func prepareForReuse() {
        kidName.text = ""
        kidAge.text = ""
    }
    
    @objc func donePressed() {
        delegate?.finishEditCell(cell: self, kidName: kidName.text, kidAge: kidAge.text)
        kidAge.resignFirstResponder()
    }
    
    @IBAction func deleteKidPressed(_ sender: UIButton) {
        if let deleteDelegate =  delegate {
            deleteDelegate.deletePressed(cell: self)
        }
    }
}

extension ChildrenViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.finishEditCell(cell: self, kidName: kidName.text, kidAge: kidAge.text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.finishEditCell(cell: self, kidName: kidName.text, kidAge: kidAge.text)
        self.endEditing(true)
        return true
    }
}

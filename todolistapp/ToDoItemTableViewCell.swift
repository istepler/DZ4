//
//  ToDoItemTableViewCell.swift
//  ToDoListApp
//
//  Created by Kirill Kirikov on 5/14/17.
//  Copyright © 2017 GoIT. All rights reserved.
//

import UIKit

protocol ToDoItemTableViewCellDelegate {
    func cellWasChanged(cell: ToDoItemTableViewCell)
}

class ToDoItemTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var delegate:ToDoItemTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        priorityView.layer.cornerRadius = 5
        titleTextField.delegate = self
        titleTextField.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleTextField.becomeFirstResponder()
        titleTextField.isEnabled = true
    }

    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleTextField.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        titleTextField.isEnabled = false
        delegate?.cellWasChanged(cell: self)
    }
}

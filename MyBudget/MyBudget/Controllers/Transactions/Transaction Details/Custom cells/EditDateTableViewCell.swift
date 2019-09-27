//
//  EditDateTableViewCell.swift
//  
//
//  Created by Johannes on 26.09.19.
//

import UIKit

class EditDateTableViewCell: UITableViewCell {

    @IBOutlet weak var textfield: UITextField!
    
    
    private lazy var datepicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.date = Date()
        datepicker.locale = NSLocale.current
        datepicker.datePickerMode = .date
        datepicker.addTarget(self, action: #selector(self.datePickerDidChange), for: .valueChanged)

        return datepicker
    }()
    
    var date: Date = Date() {
        didSet {
            datepicker.date = date
            updateDateLabel()
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return textfield.becomeFirstResponder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        textfield.inputView = datepicker
    }

    @objc private func datePickerDidChange() {
        updateDateLabel()
    }
    
    private func updateDateLabel() {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        let dateString = formatter.string(from: datepicker.date)
        textfield.text = dateString

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selectedDate() -> Date {
        return datepicker.date
    }
}

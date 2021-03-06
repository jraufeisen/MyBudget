//
//  EditDateTableViewCell.swift
//  
//
//  Created by Johannes on 26.09.19.
//

import UIKit

class EditDateTableViewCell: UITableViewCell {

    static let Identifier = "EditDateTableViewCell"

    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var symbolBackgroundView: RoundedCornerView!
    
    var colorStyle: EditTransactionDetailsCellStyles = .gray {
        didSet {
            symbolImageView.tintColor = colorStyle.primaryColor()
            symbolBackgroundView.backgroundColor = colorStyle.secondaryColor()
        }
    }
    
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
        
        if #available(iOS 13.0, *) {
            symbolImageView.image = UIImage.init(systemName: "calendar.circle") // SF symbols only available since iOS 13
        } else {
            symbolImageView.image = nil
        }
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

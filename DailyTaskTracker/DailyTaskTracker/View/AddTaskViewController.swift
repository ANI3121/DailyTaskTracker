//
//  AddTaskViewController.swift
//  DailyTaskTracker
//
//  Created by Anirudha Kumar on 10/03/21.
//

import UIKit

protocol AddTaskDelegateProtocol {
    func addTaskData(data: TaskData)
}

class AddTaskViewController: UIViewController {

    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var titleLabel: UITextField!
    var taskDelegate: AddTaskDelegateProtocol?
    let timePicker = UIDatePicker()
    var dateTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        titleLabel.delegate = self
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
        confirmButton.isEnabled = false
    }
    
    func configureView() {
        self.view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        containerView.layer.cornerRadius = 10.0
        confirmButton.layer.borderWidth = 0.5
        confirmButton.layer.cornerRadius = 10.0
    }
    
    func showDatePicker() {
        timePicker.addTarget(self, action: #selector(donedatePicker), for: .valueChanged)
        timePicker.datePickerMode = .dateAndTime
        timePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = timePicker
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:MM"
        dateTextField.text = formatter.string(from: timePicker.date)
        confirmButton.isEnabled = titleLabel.text?.count ?? 0 > 0 && startTimeTextField.text?.count ?? 0 > 0 && endTimeTextField.text?.count ?? 0 > 0
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true) { [weak self] in
            let randomInt = Int.random(in: 1...1000)
            if let taskTitle = self?.titleLabel.text, let startTime = self?.startTimeTextField.text, let endTime = self?.endTimeTextField.text {
                self?.taskDelegate?.addTaskData(data: TaskData(id: randomInt, title: taskTitle, status: Constants.todoString, startTime: startTime, endTime: endTime))
            }
        }
    }
    
}

extension AddTaskViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        confirmButton.isEnabled = titleLabel.text?.count ?? 0 > 0 && startTimeTextField.text?.count ?? 0 > 0 && endTimeTextField.text?.count ?? 0 > 0
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityIdentifier?.lowercased() == Constants.startTextField {
            dateTextField = startTimeTextField
        }
        if textField.accessibilityIdentifier?.lowercased() == Constants.endTextField {
            dateTextField = endTimeTextField
        }
        showDatePicker()
    }
}

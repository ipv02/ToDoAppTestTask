
import UIKit

final class NewTaskViewController: UIViewController {
    
    //MARK: - Properties
    weak var delegate: NewTaskDelegateProtocol?
    
    private var nameTaskTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter task name"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }()
    
    private var dateTaskTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter date task"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }()
    
    private var descriptionTaskTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter description task"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        return textField
    }()
    
    //MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavBar()
        setupTextfields()
    }
    
    //MARK: - Setup UI
    private func setupNavBar() {
        navigationItem.title = "Add Task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonTapped))
    }
    //MARK: - Textfields
    private func setupTextfields() {
        
        view.addSubview(nameTaskTextField)
        
        NSLayoutConstraint.activate([
            nameTaskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            nameTaskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            nameTaskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        view.addSubview(dateTaskTextField)
        
        NSLayoutConstraint.activate([
            dateTaskTextField.topAnchor.constraint(equalTo: nameTaskTextField.bottomAnchor, constant: 35),
            dateTaskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            dateTaskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        view.addSubview(descriptionTaskTextField)
        
        NSLayoutConstraint.activate([
            descriptionTaskTextField.topAnchor.constraint(equalTo: dateTaskTextField.bottomAnchor, constant: 35),
            descriptionTaskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            descriptionTaskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }

    //MARK: - SaveTask
    private func saveTaskEndExit() {
        guard let nameTask = nameTaskTextField.text else { return }
        guard let timeTask = dateTaskTextField.text else { return }
        guard let descriptionTask = descriptionTaskTextField.text else { return }
        
        let result = Task(id: nil, dateStart: timeTask,
                          dateFinish: nil,
                          name: nameTask,
                          description: descriptionTask)
        
        delegate?.saveTask(result)
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Objc methods
    @objc private func doneButtonTapped() {
        saveTaskEndExit()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

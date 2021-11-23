//
//  ViewController.swift
//  MyTableView
//
//  Created by Gabriel Juren on 20/11/21.
//

import UIKit

class ToDoList {
    let Todo: String
    var isChecked = false
    
    init(todo: String) {
        self.Todo = todo
    }
}
    
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate{

        
    var items: [ToDoList] = [].compactMap({
        ToDoList(todo: $0)
    })
    
    var itemsDone: [ToDoList] = [].compactMap({
        ToDoList(todo: $0)
    })
    
    let stack = UIStackView()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate =    self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.delegate = self
        textField.font = UIFont(name: "Avenir", size: 17)
        
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.widthAnchor.constraint(equalToConstant: 45).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Adicionar", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.addSubview(stack)
        view.addSubview(tableView)
        SetLayout()
    }
    
    func SetLayout() {
        stack.addArrangedSubview(textField)
        stack.addArrangedSubview(button)
        stack.spacing = 2
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return items.count
        }
        else if section == 1 {
            return itemsDone.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UITableViewCell")
        
        if indexPath.section == 0 {
            if !items.isEmpty {
                cell.textLabel?.text = items[indexPath.row].Todo
            }
        }
        else if indexPath.section == 1 {
            cell.accessoryType = itemsDone[indexPath.row].isChecked ? .checkmark : .none
            cell.textLabel?.text = itemsDone[indexPath.row].Todo
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = indexPath.section == 0 ? items[indexPath.row] : itemsDone[indexPath.row]
        
        if indexPath.section == 0 {
            item.isChecked = !item.isChecked
            addDoneItems(doneItem: item)
            removeToDoItems(toDoItemToRemove: indexPath.row)
        }
        else {
            item.isChecked = !item.isChecked
            addToDoItem(toDoItemToAdd: item)
            removeDoneItems(doneItemToRemove: indexPath.row)
        }
        
        tableView.reloadData()
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "A fazer"
        }
        
        return "Feito"
    }
        
    // TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == nil || textField.text == "" {
            return true
        }
        
        updateList()
        return true
    }
    
    @objc func didTapButton() {
        if textField.text == nil || textField.text == "" {
            return
        }
        
        updateList()
    }
    
    func updateList() {
        guard let newTodoListText = textField.text else {
            return
        }
        
        let newTodoListItem: ToDoList = ToDoList(todo: newTodoListText)
        items.append(newTodoListItem)
        tableView.reloadData()
    }
    
    func addToDoItem(toDoItemToAdd: ToDoList) {
        items.append(toDoItemToAdd)
    }
    
    func removeToDoItems(toDoItemToRemove: Int) {
        if !items.isEmpty {
            items.remove(at: toDoItemToRemove)
        }
    }
    
    func removeDoneItems(doneItemToRemove: Int) {
        if !itemsDone.isEmpty {
            itemsDone.remove(at: doneItemToRemove)
        }
    }
    
    func addDoneItems(doneItem: ToDoList) {
        itemsDone.append(doneItem)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

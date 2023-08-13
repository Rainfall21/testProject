//
//  PersonViewController.swift
//  alefTestProject
//
//  Created by Alibek Ismagulov on 27.07.2023.
//

import UIKit
import CoreData

class PersonViewController: UITableViewController {
    
    var persons = [Person]()
    
    var childrens: [Children] = []
    
    @IBOutlet weak var addKidButton: UIButton!
    @IBOutlet weak var parentName: UITextField!
    @IBOutlet weak var parentAge: UITextField!
    
    var enableEdit: Bool = true

    var selectedPerson : NSManagedObjectID?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnNumpad(textField: parentAge)
        
        overrideUserInterfaceStyle = .light
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        if selectedPerson != nil {
            let object = loadPerson() as! Person
            var kids = object.kids?.allObjects as! [Kids]
            for kid in kids {
                let child = Children(name: kid.kidName, age: Int(kid.kidAge))
                childrens.append(child)
            }
            parentName.text = object.name
            parentAge.text = String(object.age)
        }
        parentName.delegate = self
        self.tableView.register(UINib(nibName: "ChildrenViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        keypadToolbar.items=[
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        textField.inputAccessoryView = keypadToolbar
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! ChildrenViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.kidName.text = childrens[indexPath.row].name
        if let age = childrens[indexPath.row].age {
            cell.kidAge.text = String(age)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func loadPerson() -> NSManagedObject? {
        if let id = selectedPerson {
            let object = try context.object(with: id)
            return object
        }
        return nil
    }
    
    @IBAction func wipeButtonPressed(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Очистить данные?", message: "При нажатии 'Сбросить' все данные удалятся", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Сбросить данные", style: .destructive, handler: { _ in
            var cells = self.tableView.visibleCells
            for cell in cells {
                if cell.reuseIdentifier == "customCell" {
                    self.deletePressed(cell: cell)
                }
            }
            let object = self.loadPerson()
            if let person = object {
                self.context.delete(person)
                self.save()
            }
            self.parentAge.text = ""
            self.parentName.text = ""
            self.tableView.reloadData()
        }))
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func checkAge() -> Bool {
        var result : Bool = true
        if let age = parentAge.text, let intAge = Int32(age) {
            if intAge < 18 || intAge > 100 {
                let alert = UIAlertController(title: "Ошибка возраста", message: "Возраст родителя не может быть меньше 18 и больше 100", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                result = false
            }
        }
        for children in childrens {
            if let age = parentAge.text, let intAge = Int32(age), let childrenAge = children.age {
                let ageDifference = intAge - Int32(childrenAge)
                if ageDifference <= 18 {
                    let alert = UIAlertController(title: "Ошибка возраста", message: "Разница в возрасте родителя и ребенка не может быть меньше или ровно 18", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    result = false
                } else if Int32(childrenAge) < 0 {
                    let alert = UIAlertController(title: "Ошибка возраста", message: "Возраст не может быть меньше 0", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    result = false
                }
            }
        }
        return result
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if parentName.text == "" || parentAge.text == "" {
            let alert = UIAlertController(title: "Пустые значения", message: "Заполните 'Имя' и/или 'Возраст'", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        } else if checkAge() {
            if selectedPerson != nil {
                let object = loadPerson() as! Person
                if let age = parentAge.text, let intAge = Int32(age) {
                    object.age = intAge
                }
                object.name = parentName.text

                if let kids = object.kids {
                    object.removeFromKids(kids)
                }

                for children in childrens {
                    let kid = Kids(context: context)
                    kid.kidName = children.name
                    if let childrenAge = children.age {
                        kid.kidAge = Int32(childrenAge)
                    }
                    object.addToKids(kid)
                }
                save()
            } else {
               let person = Person(context: context)
               if let age = parentAge.text, let intAge = Int32(age) {
                   person.age = intAge
               }
               person.name = parentName.text
               for children in childrens {
                   let kid = Kids(context: context)
                   kid.kidName = children.name
                   if let childrenAge = children.age {
                       kid.kidAge = Int32(childrenAge)
                   }
                   person.addToKids(kid)
               }
               save()
           }
            tableView.reloadData()
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                let alert = UIAlertController(title: "Успешно!", message: "Сохранено успешно!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } catch {
                let alert = UIAlertController(title: "Ошибка!", message: "Ошибка при сохранении!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addKid(_ sender: UIButton) {
        if childrens.count < 5 {
            let children = Children(name: nil, age: nil)
            childrens.append(children)
            tableView.reloadData()
        } else {
            addKidButton.isHidden = true
        }
    }
}

//MARK: - ChildrenViewCellDelegate
extension PersonViewController : ChildrenViewCellDelegate {
    
    func finishEditCell(cell: UITableViewCell, kidName: String?, kidAge: String?) {
    
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let kidName {
            childrens[indexPath.row].name = kidName
        }
        if let kidAge {
            childrens[indexPath.row].age = Int(kidAge)
        }
    }
    
    func deletePressed(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        childrens.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if childrens.count < 5 {
            addKidButton.isHidden = false
        }
    }
}

//MARK: - UITextFieldDelegate
extension PersonViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacter = CharacterSet.letters
        let allowedSpaces = CharacterSet.whitespaces
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacter.isSuperset(of: characterSet) || allowedSpaces.isSuperset(of: characterSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

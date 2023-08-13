//
//  ViewController.swift
//  alefTestProject
//
//  Created by Alibek Ismagulov on 27.07.2023.
//

import UIKit
import CoreData

class PersonsListViewController: UITableViewController {
    
    var personsArray = [Person]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        loadPersonsList()
    }
    override func viewDidAppear(_ animated: Bool) {
        loadPersonsList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        cell.textLabel?.text = personsArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPerson", sender: self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToPerson", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? PersonViewController else { return }
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPerson = personsArray[indexPath.row].objectID
        }
    }
    
    func loadPersonsList() {
        
        let request : NSFetchRequest<Person> = Person.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        do {
            personsArray = try context.fetch(request)
        } catch {
            let alert = UIAlertController(title: "Ошибка", message: "Ошибка загрузки", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
}


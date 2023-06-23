//
//  ToDosVC.swift
//  First Project (ToDoList)
//
//  Created by faisal almalki on 20/06/2023.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    
    var todosArray: [Todo] = []
    
    @IBOutlet weak var todosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.todosArray = getTodos()
        
        // New Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        
        // Edit Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
        
        // Delete Todo Notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoDeleted), name: NSNotification.Name(rawValue: "TodoDeleted"), object: nil)
        
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
    }
    @objc func newTodoAdded(notifiction: Notification){ //Add new Todo item
       
        if let myTodo = notifiction.userInfo?["addedTodo"] as? Todo{
            todosArray.append(myTodo)
            todosTableView.reloadData()
            storeTodo(todo: myTodo)
        }
    }
    
    @objc func currentTodoEdited(notification: Notification){   //Edit an exist Todo item
        if let todo = notification.userInfo?["editedTodo"] as? Todo{
            if let index = notification.userInfo?["editedTodoIndex"] as? Int{
                todosArray[index] = todo
                todosTableView.reloadData()
                updateTodo(todo: todo, index: index)
            }
        }
    }
    
    @objc func todoDeleted(notification: Notification){
            
        if let index = notification.userInfo?["deletedTodoIndex"] as? Int{
            todosArray.remove(at: index)
            todosTableView.reloadData()
            deleteTodo(index: index)
        }
    }
    func storeTodo(todo: Todo){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContext = appDelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "TodoEntity", in: manageContext) else { return }
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: manageContext)
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")
        
        if let image = todo.image{
            let imageData = image.pngData()
            todoObject.setValue(imageData, forKey: "image")
        }
        
        do{
            try manageContext.save()
            print("====== Success =====")
        }catch{
            print("====== Error ======")
        }
        
    }
    
    func updateTodo(todo: Todo, index: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            if let image = todo.image {
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")
            }
            
            try context.save()
        }catch{
            print("===== Error =====")
        }
    }
    func deleteTodo(index: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoToDelete = result[index]
            context.delete(todoToDelete)
            try context.save()
        }catch{
            print("===== Error =====")
        }
    }
    
    func getTodos() -> [Todo]{
        var todos: [Todo] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return [] }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedTodo in result{
                let title = managedTodo.value(forKey: "title") as? String
                let details = managedTodo.value(forKey: "details") as? String
                var todoImage: UIImage? = nil
                if let imageFromContext = managedTodo.value(forKey: "image") as? Data{
                    todoImage = UIImage(data: imageFromContext)
                }
                let todo = Todo(title: title ?? "",image: todoImage, details: details ?? "")
                todos.append(todo)
            }
        }catch{
            print("===== Error =====")
        }
        return todos
    }

}

extension TodosVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        cell.todoTitleLabel.text = todosArray[indexPath.row].title
        
        if todosArray[indexPath.row].image != nil{
            cell.todoImageView.image = todosArray[indexPath.row].image
        }else{
            cell.todoImageView.image = UIImage(named: "Image 4")
        }
        cell.todoImageView.layer.cornerRadius = cell.todoImageView.frame.width/2
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let todo = todosArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(identifier: "TodoDetails") as? TodoDetailsVC
        if let viewController = vc{
            viewController.todo = todo
            viewController.index = indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}

//
//  TodoDetailsVCViewController.swift
//  First Project (ToDoList)
//
//  Created by faisal almalki on 20/06/2023.
//

import UIKit

// VC to add or edit Todo item
class TodoDetailsVC: UIViewController {

    var todo: Todo!
    var index: Int!
    
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if todo.image != nil {
            todoImageView.image = todo.image

        }else{
            todoImageView.image = UIImage(named: "Image 1")

        }
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil)
    }
    @objc func currentTodoEdited(notification: Notification){
        if let todo = notification.userInfo?["editedTodo"] as? Todo{
            if let index = notification.userInfo?["editedTodoIndex"] as? Int{
                self.todo = todo
                setupUI()
            }
        }
    }
    func setupUI(){
        todoTitleLabel.text = todo.title
        detailsLabel.text = todo.details
        todoImageView.image = todo.image
    }
    
    @IBAction func editTodoButtonClicked(_ sender: Any) { // Edit Todo item and go back home page when edited button is clikced
        let vc = storyboard?.instantiateViewController(identifier: "NewTodoVC") as? NewTodoVC
        if let viewController = vc {
            viewController.isCraetionScreen = false
            viewController.editedTodo = todo
            viewController.editedTodoIndex = index
            navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
    @IBAction func deleteButtonClicked(_ sender: Any) { //Delete button
        let confirmAlert = UIAlertController(title: "Caution", message: "are you sure you want to delete the task?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm to Delete", style: .destructive,handler: {
            alert in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TodoDeleted"), object: nil, userInfo: ["deletedTodoIndex": self.index])
                
                let alert = UIAlertController(title: "Task Deleted", message: "Your task has been deleted", preferredStyle: .alert)
                let closeAction = UIAlertAction(title: "Dismiss", style: .default, handler: { action in self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(closeAction)
                self.present(alert, animated: true)
            })
        confirmAlert.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        confirmAlert.addAction(cancelAction)
        present(confirmAlert, animated: true)
        
        
    }
    
}

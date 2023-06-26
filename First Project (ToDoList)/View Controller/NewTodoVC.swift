//
//  NewTodoVC.swift
//  First Project (ToDoList)
//
//  Created by faisal almalki on 20/06/2023.
//

import UIKit

class NewTodoVC: UIViewController {

    var isCraetionScreen = true
    var editedTodo: Todo?
    var editedTodoIndex: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide the keyboard
        self.hideKeyboardWhenTappedAround()
        if !isCraetionScreen{
            mainButton.setTitle("Edit Task", for: .normal)
            navigationItem.title = "Edit the Task"
            if let todo = editedTodo{
                titleTextField.text = todo.title
                detailsTextView.text = todo.details
                mainButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
                todoImageView.image = todo.image
                
            }
            
        }

    }
    @IBAction func changeButtonClicked(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        
        if isCraetionScreen{
            let todo = Todo(title: titleTextField.text!,image: todoImageView.image,details: detailsTextView.text)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil,userInfo: ["addedTodo" : todo])
            
            let alert = UIAlertController(title: "Task Added", message: "Your task has been added", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                self.tabBarController?.selectedIndex = 0
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            })
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
           
        }else{ // if the view controller is opend for edit (not for create)
            let todo = Todo(title: titleTextField.text!, image: todoImageView.image, details: detailsTextView.text)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentTodoEdited"), object: nil, userInfo: ["editedTodo": todo, "editedTodoIndex": editedTodoIndex])
            
            let alert = UIAlertController(title: "Task Edited", message: "Your task has been edited", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                self.navigationController?.popViewController(animated: true)
                self.titleTextField.text = ""
                self.detailsTextView.text = ""
            })
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
        }
    
    }

}

extension NewTodoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true)
        todoImageView.image = image
        
    }
}

// Hide keyboard when tapped any where
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

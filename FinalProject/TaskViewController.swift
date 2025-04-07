//
//  TaskViewController.swift
//  FinalProject
//  Diego Tsukayama 101472085
//  Illia Konik 101460488
//

import UIKit
import CoreData

class TaskViewController: UIViewController, UITextFieldDelegate {
    
//    @IBOutlet var label: UILabel!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var subtaskTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
//    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskSubtitleLabel: UILabel!
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete '\(task?.name ?? "---")' and all its subtasks?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteTask()
        }))

        present(alert, animated: true, completion: nil)
    }
    var task: Task?
    var subtasks: [Subtask] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        subtaskTextField.delegate = self
        taskTitle.delegate = self
        taskTitle.returnKeyType = .done

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        fetchTaskAndSubtasks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if let taskListVC = viewController as? ViewController {
                    taskListVC.fetchTasks()
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func fetchTaskAndSubtasks() {
        guard let taskName = task?.name else { return }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", taskName)

        do {
            let tasks = try context.fetch(request)
            if let updatedTask = tasks.first {
                self.task = updatedTask
                updateUI()
            }
        } catch {
            print("Failed to fetch updated task: \(error)")
        }
    }

    func updateUI() {
        guard let task = task else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = task.timestamp != nil ? formatter.string(from: task.timestamp!) : "No Date"
        
//        label.text = "\(task.name ?? "No Task")\nCreated: \(dateString)"
//        taskTitleLabel.text = task.name ?? "No Task"
        taskTitle.text = task.name
        taskSubtitleLabel.text = "Created: \(dateString)"

        if let subtasksSet = task.subtasks as? Set<Subtask> {
            subtasks = Array(subtasksSet)
        }

        tableView.reloadData()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Add subtask" {
            textField.text = ""
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            textField.text = "Add subtask"
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == subtaskTextField {
                    addSubtaskFromTextField()
        } else if textField == taskTitle {
            saveTaskTitle()
        }
        textField.resignFirstResponder()
        return true
    }
    
    func saveTaskTitle() {
        guard let newTitle = taskTitle.text,
              let task = task,
              let context = task.managedObjectContext,
              !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        task.name = newTitle
        do {
            try context.save()
            print("Task title updated")
        } catch {
            print("Failed to update task title: \(error)")
        }
    }

    func addSubtaskFromTextField() {
        guard let text = subtaskTextField.text, !text.isEmpty,
              let task = self.task,
              let context = task.managedObjectContext else {
            print("Error: Task has no valid context or empty text")
            return
        }

        let newSubtask = Subtask(context: context)
        newSubtask.name = text
        newSubtask.isCompleted = false
        task.addToSubtasks(newSubtask)

        do {
            try context.save()
            subtaskTextField.text = ""
            updateUI()
        } catch {
            print("Failed to save subtask: \(error)")
        }
    }

    @objc func deleteTask() {
        guard let taskToDelete = task,
              let context = taskToDelete.managedObjectContext else { return }

        context.delete(taskToDelete)

        do {
            try context.save()

            if let viewControllers = navigationController?.viewControllers {
                for viewController in viewControllers {
                    if let taskListVC = viewController as? ViewController {
                        taskListVC.fetchTasks()
                    }
                }
            }

            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to delete task: \(error)")
        }
    }

}

// MARK: - TableView for Subtasks
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtaskCell", for: indexPath)
        let subtask = subtasks[indexPath.row]

        cell.textLabel?.text = subtask.name
        cell.detailTextLabel?.text = subtask.isCompleted ? "Completed" : "Pending"
        cell.accessoryType = subtask.isCompleted ? .checkmark : .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let context = task?.managedObjectContext else { return }
        let subtask = subtasks[indexPath.row]
        subtask.isCompleted.toggle()

        do {
            try context.save()
            updateUI()
        } catch {
            print("Failed to update subtask: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let context = task?.managedObjectContext else { return }
            let subtaskToDelete = subtasks[indexPath.row]

            context.delete(subtaskToDelete)
            subtasks.remove(at: indexPath.row)

            do {
                try context.save()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Failed to delete subtask: \(error)")
            }
        }
    }
}

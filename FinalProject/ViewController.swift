//
//  ViewController.swift
//  FinalProject
//  Diego Tsukayama 101472085
//  Illia Konik 101460488
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To Do List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSortOptions))
        tableView.delegate = self
        tableView.dataSource = self
        fetchTasks()
    }

    func fetchTasks() {
        let request = NSFetchRequest<Task>(entityName: "Task")
        do {
            tasks = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }

    @IBAction func didTapAdd() {
        let viewController = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        viewController.title = "New Task"
        viewController.update = {
            self.fetchTasks()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func showSortOptions() {
        let alert = UIAlertController(title: "Sort Tasks", message: "Choose how you want to sort the tasks", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Alphabetically (A-Z)", style: .default, handler: { _ in
            self.tasks.sort {
                ($0.name ?? "").lowercased() < ($1.name ?? "").lowercased()
            }

            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Alphabetically (Z-A)", style: .default, handler: { _ in
            self.tasks.sort {
                ($0.name ?? "").lowercased() > ($1.name ?? "").lowercased()
            }
            
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "By Date Created", style: .default, handler: { _ in
            self.tasks.sort { ($0.timestamp ?? Date()) < ($1.timestamp ?? Date()) }
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.fetchTasks()
        }))

        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = self.navigationItem.rightBarButtonItem
        }

        present(alert, animated: true)
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        viewController.task = tasks[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        let task = tasks[indexPath.row]
//        task.isCompleted.toggle()
//
//        do {
//            try context.save()
//            fetchTasks()
//        } catch {
//            print("Failed to toggle task completion: \(error)")
//        }
//    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "initialCell", for: indexPath)
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.name
//        cell.accessoryType = task.isCompleted ? .checkmark : .none
        
        if let date = task.timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            cell.detailTextLabel?.text = formatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = "No date"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let taskToDelete = tasks[indexPath.row]
//            context.delete(taskToDelete)
//            tasks.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            
//            do {
//                try context.save()
//            } catch {
//                print("Failed to delete task: \(error)")
//            }
//        }
        if editingStyle == .delete {
                let taskToDelete = tasks[indexPath.row]

                let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    self.context.delete(taskToDelete)
                    self.tasks.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)

                    do {
                        try self.context.save()
                    } catch {
                        print("Failed to delete task: \(error)")
                    }
                }))

                self.present(alert, animated: true, completion: nil)
            }
    }
}

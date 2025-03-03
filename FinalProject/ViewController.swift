//
//  ViewController.swift
//  FinalProject
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List of Tasks"
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
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        viewController.task = tasks[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "initialCell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        if let date = task.timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            cell.detailTextLabel?.text = formatter.string(from: date)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            context.delete(taskToDelete)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            do {
                try context.save()
            } catch {
                print("Failed to delete task: \(error)")
            }
        }
    }
}

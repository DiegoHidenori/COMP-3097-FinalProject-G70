//
//  ViewController.swift
//  FinalProject
//
//  Created by Ivanna Bandalak on 2025-02-14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List of Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
            
        }
        
        updateTasks()
        
    }
    
    func updateTasks() {
        
        tasks.removeAll()
        let count = UserDefaults().integer(forKey: "count")
        
        for x in 1...count {
            if let taskData = UserDefaults().dictionary(forKey: "task\(x)"),
               let text = taskData["text"] as? String,
               let timestamp = taskData["timestamp"] as? TimeInterval {
                
                let date = Date(timeIntervalSince1970: timestamp)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = formatter.string(from: date)
                tasks.append("\(text) (\(dateString))")
            }
        }
        
        print("Tasks loaded: \(tasks)")
        
//        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func didTapAdd() {
        let viewController = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        viewController.title = "New Task"
        viewController.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        viewController.title = "Task"
        viewController.task = tasks[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            
            guard let self = self else { return }
            
            let taskKey = "task\(indexPath.row + 1)"
            UserDefaults().removeObject(forKey: taskKey)
            
            var count = UserDefaults().integer(forKey: "count")
            count -= 1
            UserDefaults().set(count, forKey: "count")
            
            self.updateTasks()
            
            print("Task deleted: \(taskKey)")
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = UIColor.red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "initialCell", for: indexPath)
        
        let taskString = tasks[indexPath.row]
        let parts = taskString.components(separatedBy: " (")
        
        let taskName = parts[0]
        let date = parts.count > 1 ? parts[1].dropLast() : ""
        
        cell.textLabel?.text = taskName
        cell.detailTextLabel?.text = String(date)
        cell.detailTextLabel?.textColor = UIColor.gray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return cell
    }
}

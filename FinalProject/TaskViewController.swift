//
//  TaskViewController.swift
//  FinalProject
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let taskObject = task {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = taskObject.timestamp != nil ? formatter.string(from: taskObject.timestamp!) : "No Date"

            label.text = "\(taskObject.name ?? "No Task")\nCreated: \(dateString)"
        } else {
            label.text = "No Task"
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTask))
    }


    
    @objc func deleteTask() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

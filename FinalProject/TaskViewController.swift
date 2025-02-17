//
//  TaskViewController.swift
//  FinalProject
//
//  Created by Ivanna Bandalak on 2025-02-14.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var task: String?
    var timestamp: TimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let taskText = task, let taskTimestamp = timestamp {
            let date = Date(timeIntervalSince1970: taskTimestamp)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            
            label.text = "\(taskText)\nCreated: \(dateString)"
        } else {
            label.text = task
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

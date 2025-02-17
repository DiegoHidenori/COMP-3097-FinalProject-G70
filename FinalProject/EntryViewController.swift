//
//  EntryViewController.swift
//  FinalProject
//
//  Created by Ivanna Bandalak on 2025-02-14.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTask))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        
        return true
    }
    
    @objc func saveTask() {
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        var count = UserDefaults().integer(forKey: "count")
        let newCount = count + 1
        
        let taskData: [String: Any] = [
            "text": text,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        UserDefaults().set(taskData, forKey: "task\(newCount)")
        UserDefaults().set(newCount, forKey: "count")
        
        print("Task saved: \(text) at task\(newCount)")
        
        update?()
        
        navigationController?.popViewController(animated: true)
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

//
//  ViewController.swift
//  Iron Log
//
//  Created by Christian Cruz on 2/15/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func manageWorkoutsPressed(_ sender: UIButton) {
        let url = getDocumentsDirectory().appendingPathComponent("savedWorkouts.txt")
        do {
         // Get the saved data
         let savedData = try Data(contentsOf: url)
         // Convert the data back into a string
         if let savedString = String(data: savedData, encoding: .utf8) {
            print(savedString)
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}


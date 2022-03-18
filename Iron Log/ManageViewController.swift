//
//  ManageViewController.swift
//  Iron Log
//
//  Created by Christian Cruz on 3/16/22.
//

import UIKit

class ManageViewController: UIViewController {

    var arrayOfWorkouts: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = getDocumentsDirectory().appendingPathComponent("ListOfWorkouts.txt")
        //save workouts to an array of strings
        do {
         let savedData = try Data(contentsOf: url)
         if let savedString = String(data: savedData, encoding: .utf8) {
             if (savedString != "") {
                 arrayOfWorkouts = savedString.components(separatedBy: "\n")
                 print(arrayOfWorkouts)
             }
             else {
                 print("No Workouts Saved")
             }
         }
        } catch {
         // Catch any errors
         print("Unable to read the file")
        }
    }
    
    @IBAction func deleteWorkoutsPressed(_ sender: UIButton) {
        let text = ""
        let url = getDocumentsDirectory().appendingPathComponent("ListOfWorkouts.txt")
        do {
            try text.write(to: url, atomically: true, encoding: .utf8)
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func listWorkoutsPressed(_ sender: UIButton) {
        let url = getDocumentsDirectory().appendingPathComponent("ListOfWorkouts.txt")
        do {
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//
//  SelectWorkoutViewController.swift
//  Iron Log
//
//  Created by Christian Cruz on 3/17/22.
//

import UIKit

var selectedWorkout: String = ""

class SelectWorkoutViewController: UIViewController {

    var workoutArray: Array<String> = []
    var yVal = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveToWorkoutArray()
        if (!workoutArray.isEmpty) {
            for workout in workoutArray {
                createButton(title: workout)
                yVal += 40
            }
        }
        else {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: yVal, width: 400, height: 20)
            label.text = "No Workouts Available"
            label.textAlignment = .center
            self.view.addSubview(label)
        }
    }
    
    //workout pressed
    @objc func buttonAction(_ sender:UIButton!){
            selectedWorkout = sender.currentTitle ?? ""
            performSegue(withIdentifier: "showWorkout", sender: sender)
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //create an array of the workout names
    func saveToWorkoutArray() {
        let url = getDocumentsDirectory().appendingPathComponent("ListOfWorkouts.txt")
        //save workouts to an array of strings
        do {
         let savedData = try Data(contentsOf: url)
         if let savedString = String(data: savedData, encoding: .utf8) {
             if (savedString != "") {
                 workoutArray = savedString.components(separatedBy: "\n")
                 print(workoutArray)
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
    
    //create button for workout
    func createButton(title name: String) {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: yVal, width: 400, height: 50)
        button.setTitle(name, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        view.addSubview(button)
        self.view = view
    }
}

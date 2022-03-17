//
//  CreateViewController.swift
//  Iron Log
//
//  Created by Christian Cruz on 3/9/22.
//

import UIKit

class CreateViewController: UIViewController, AddExerciseToListDelegate {
    
    @IBOutlet weak var workoutTitle: UITextField!
    
    var xVal = 0
    var yVal = 150
    var fullWorkout: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testLabel()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as? createPopupViewController
        secondVC?.delegate = self
    }
    
    func addExerciseToList(_ exercise: Exercise) {
        fullWorkout += [exercise.muscleGroup, exercise.workoutName, exercise.numberOfSets, exercise.numberOfReps]
        let label = UILabel()
        label.frame = CGRect(x: xVal, y: yVal, width: 400, height: 20)
        label.text = "\(exercise.muscleGroup) \(exercise.workoutName) \(exercise.numberOfSets) X \(exercise.numberOfReps)"
        label.textAlignment = .center
        self.view.addSubview(label)
        print("addExerciseToList called")
        yVal += 40
        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        if let saveTitle = workoutTitle.text {
            if (saveTitle.count == 0) {
                let errorTitle = "Empty title."
                let errorMsg = "Please enter a title."
                let errorAlertController = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
                let errorOkayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                errorAlertController.addAction(errorOkayAction)
                present(errorAlertController, animated: true, completion: nil)
            }
            else {
                fullWorkout.insert(saveTitle, at: 0)
                fullWorkout.append("end")
                let str = fullWorkout.joined(separator: "\n")
                let url = getDocumentsDirectory().appendingPathComponent("savedWorkouts.txt")
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        //createWorkout()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

//
//  createPopupViewController.swift
//  Iron Log
//
//  Created by Christian Cruz on 3/9/22.
//

import UIKit

struct Exercise {
    var muscleGroup: String
    var workoutName: String
    var numberOfSets: String
    var numberOfReps: String
    
    init() {
        muscleGroup = " "
        workoutName = " "
        numberOfSets = " "
        numberOfReps = " "
    }
}

protocol AddExerciseToListDelegate {
    //func createExerciseLabel(labelX x:Int, labelY y:Int)
    func addExerciseToList(_ exercise: Exercise)
}

class createPopupViewController: UIViewController {

    @IBOutlet weak var muscleSegment: UISegmentedControl!
    @IBOutlet weak var workoutText: UITextField!
    @IBOutlet weak var setsText: UITextField!
    @IBOutlet weak var repsText: UITextField!
    var delegate: AddExerciseToListDelegate?
    var exercise = Exercise()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backgroundPressed(_ sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    //let muscleGroup = muscleSegment.titleForSegment(at: muscleSegment.selectedSegmentIndex)
    @IBAction func addExercise(_ sender: UIButton) {
        exercise.muscleGroup = muscleSegment.titleForSegment(at: muscleSegment.selectedSegmentIndex) ?? ""
        if let workout = workoutText.text, let sets = setsText.text, let reps = repsText.text{
            exercise.workoutName = workout
            exercise.numberOfSets = sets
            exercise.numberOfReps = reps
            delegate?.addExerciseToList(exercise)
            dismiss(animated: true, completion: nil)
        } else {
            let errorTitle = "Empty fields."
            let errorMsg = "Please fill out all fields."
            let errorAlertController = UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: .alert)
            let errorOkayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            errorAlertController.addAction(errorOkayAction)
            present(errorAlertController, animated: true, completion: nil)
        }
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

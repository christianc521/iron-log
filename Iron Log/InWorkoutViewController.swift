//
//  InWorkoutViewController.swift
//  Iron Log
//
//  Created by Christian Cruz on 3/17/22.
//

import UIKit

struct CurrentExercise {
    var name = ""
    var muscleGroup = ""
    var numberOfSets = ""
    var targetReps = ""
}

class InWorkoutViewController: UIViewController {
    
    @IBOutlet weak var decreaseRepsButton: UIButton!
    @IBOutlet weak var nextSetButton: UIButton!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var muscleLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var repsHit: UILabel!
    @IBOutlet weak var targetSetsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
   
    var workoutArray: Array<String> = []
    var exerciseArray: Array<Array<String>> = []
    var singleExercise: Array<String> = []
    var currentExercise = CurrentExercise()
    var exerciseIndex = 0
    var currentSet = 1
    var currentRep = 0
    var timerCounting:Bool = true
    var startTime:Date?
    var stopTime:Date?
    var scheduledTimer: Timer!
    
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutLabel.text = selectedWorkout
        setLabel.text = String(currentSet)
        saveToWorkoutArray()
        saveToExerciseArray()
        setCurrentExercise(exerciseArray[0][0], exerciseArray[0][1], exerciseArray[0][2], exerciseArray[0][3])
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        startStopAction()
        if (timerCounting) {
            startTimer()
        }
        else {
            stopTimer()
            if let start = startTime
            {
                if let stop = stopTime
                {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }
        
        
    }
    
    @IBAction func nextSetPressed(_ sender: UIButton) {
        currentRep = 1
        repsHit.text = String(currentRep)
        if (String(currentSet) == currentExercise.numberOfSets) {
            currentSet = 1
            changeExercise()
        }
        else {
            currentSet += 1
            setLabel.text = String(currentSet)
        }
    }
    
    @IBAction func increaseRepsPressed(_ sender: UIButton) {
        currentRep += 1
        repsHit.text = String(currentRep)
        if (decreaseRepsButton.isEnabled == false) {
            decreaseRepsButton.isEnabled = true
        }
    }
    
    @IBAction func decreaseRepsPressed(_ sender: UIButton) {
        if (currentRep > 1) {
            currentRep -= 1
            repsHit.text = String(currentRep)
        }
        else {
            sender.isEnabled = false
        }
    }
    
    @IBAction func targetRepsPressed(_ sender: UIButton) {
        currentRep = Int(currentExercise.targetReps) ?? 1
        repsHit.text = String(currentRep)
        if (decreaseRepsButton.isEnabled == false) {
            decreaseRepsButton.isEnabled = true
        }
    }
    
    func changeExercise() {
        if (exerciseIndex != exerciseArray.count - 1) {
            setLabel.text = String(currentSet)
            exerciseIndex += 1
            setCurrentExercise(exerciseArray[exerciseIndex][0],
                               exerciseArray[exerciseIndex][1],
                               exerciseArray[exerciseIndex][2],
                               exerciseArray[exerciseIndex][3])
        }
        else {
            nextSetButton.isEnabled = false
            createButton()
            stopTimer()
            print("reached end")
        }
    }
    
    @objc func buttonAction(_ sender:UIButton!){
        selectedWorkout = sender.currentTitle ?? ""
        performSegue(withIdentifier: "showCompleted", sender: sender)
    }
    
    func createButton() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 600, width: 400, height: 50)
        button.setTitle("Finish Workout", for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        view.addSubview(button)
        self.view = view
    }
    
    func setCurrentExercise(_ muscleGroup:String, _ name:String, _ numberOfSets:String, _ targetReps: String) {
        currentExercise.name = name
        currentExercise.muscleGroup = muscleGroup
        currentExercise.numberOfSets = numberOfSets
        currentExercise.targetReps = targetReps
        muscleLabel.text = muscleGroup
        exerciseLabel.text = name
        repLabel.text = targetReps
        targetSetsLabel.text = numberOfSets
    }
    
    func saveToExerciseArray() {
        var index = 0
        for i in workoutArray {
            switch index {
            case 0,1,2:
                singleExercise.append(i)
                index += 1
            case 3:
                singleExercise.append(i)
                exerciseArray.append(singleExercise)
                singleExercise.removeAll()
                index = 0
            default:
                print("error")
            }
        }
        print(exerciseArray)
    }
    
    func saveToWorkoutArray() {
        let url = getDocumentsDirectory().appendingPathComponent("\(selectedWorkout).txt")
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
    
    func startStopAction() {
        if timerCounting {
            setStopTime(date: Date())
            stopTimer()
        } else {
            if let stop = stopTime {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else {
                setStartTime(date: Date())
            }
            startTimer()
        }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    func startTimer() {
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
    }
    
    @objc func refreshValue() {
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
        }
        else {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setTimeLabel(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timeLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms / 3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    func stopTimer() {
        if scheduledTimer != nil {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
    }
    
    func setStartTime(date: Date?) {
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?) {
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool) {
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

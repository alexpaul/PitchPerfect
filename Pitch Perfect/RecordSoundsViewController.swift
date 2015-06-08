//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex Paul on 6/2/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var microphoneLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.stopButton.hidden = true
        self.pauseButton.hidden = true
        self.microphoneButton.enabled = true
        self.microphoneLabel.hidden = false
        self.recordingInProgress.text = "recording" // set to default in case pause was last value
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func recordAudioButtonPressed(sender: UIButton) {
        // Hide the microphone label when user taps on microphone
        microphoneLabel.hidden = true
        
        // Get the App's Directory Path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        // Create the recording file name 
        let recordingName = "my_audio.wav"
        
        // Path Array
        let pathArray = [dirPath, recordingName]
        
        // Construct the File Path
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // Print the File Path
        println(filePath)
        
        // Get Session shared Instance (sets the Audio context for the app)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil) // fixes low volume on iPhone
        
        // Set the Audio Recorder instance 
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        // Show the recording Label
        self.recordingInProgress.hidden = false
        
        // Show the stop button 
        self.stopButton.hidden = false
        
        // Show the pause button 
        self.pauseButton.hidden = false
        
        // Disable the microphone 
        self.microphoneButton.enabled = false
    }
    
    @IBAction func stopRecordingAudioButtonPressed(sender: UIButton) {
        // Stop recording the user's voice
        audioRecorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        // Hide the recording Label
        self.recordingInProgress.hidden = true
        
        // Enable the microphone button 
        self.microphoneButton.enabled = true
    }
    
    @IBAction func pauseRecordingButtonPressed(sender: UIButton) {
        if audioRecorder.recording == true {
            // Pause Recording 
            audioRecorder.pause()
            self.recordingInProgress.text = "paused"
        }else {
            // Resume Recording 
            audioRecorder.record()
            self.recordingInProgress.text = "recording..."
        }
    }
    
    
    // MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
            println("Recording was unsuccessful")
            microphoneButton.enabled = true
            stopButton.hidden = true
        }
    }

}


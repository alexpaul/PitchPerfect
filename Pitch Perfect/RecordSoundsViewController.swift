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
    @IBOutlet weak var microphoneButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.stopButton.hidden = true
        self.microphoneButton.enabled = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func recordAudioButtonPressed(sender: UIButton) {
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
    
    // MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent // gets the title
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
            println("Recording was unsuccessful")
            microphoneButton.enabled = true
            stopButton.hidden = true
        }
    }

}


//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Alex Paul on 6/4/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer! // for echo effect
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title for this view controller
        self.title = "Choose an Effect"
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true // enableRate MUST be set to true in order to adjust the playback rate
        audioEngine = AVAudioEngine() // initialize new Engine
    }
    
    // MARK: Actions
    @IBAction func slowPlayButtonPressed(sender: UIButton) {
        stopAllAudioActions()
        playAudioWithRate(rate: 0.5)
    }
    
    @IBAction func fastPlayButtonPressed(sender: UIButton) {
        stopAllAudioActions()
        playAudioWithRate(rate: 2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        stopAllAudioActions()
        playAudioWithVariablePitch(pitch: 1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        stopAllAudioActions()
        playAudioWithVariablePitch(pitch: -1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        stopAllAudioActions()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        audioPlayer.numberOfLoops = 3 // number of times to "echo" audio after initial play
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        stopAllAudioActions()
        
        let audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let reverb = AVAudioUnitReverb() // initialize an instance of AVAudioUnitReverb
        reverb.wetDryMix = 50 // blend of the wet and dry signals, 0% all dry, 100% all wet
        
        audioEngine.attachNode(reverb) // take ownership of unitReverb
        
        audioEngine.connect(audioPlayerNode, to: reverb, format: audioFile.processingFormat)
        audioEngine.connect(reverb, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)

        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudioButtonPressed(sender: UIButton) {
        stopAllAudioActions()
    }
    
    // MARK: Helper Methods
    
    // For Slow and Fast Speed
    func playAudioWithRate(#rate: Float) {
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate // range 0.5 for half the normal speed to 2.0 double the normal speed, 1.0 is normal speed
        audioPlayer.prepareToPlay() // pre loads the buffer
        audioPlayer.play() // plays sound asynchronously
    }
    
    // For High and Low Pitch Sounds
    func playAudioWithVariablePitch(#pitch: Float) {
        let audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch // default is 1.0, range is -2400 to 2400
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        print(audioFile)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func stopAllAudioActions() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}

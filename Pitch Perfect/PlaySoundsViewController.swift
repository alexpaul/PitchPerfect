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
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true // enableRate MUST be set to true in order to adjust the playback rate
        
        audioEngine = AVAudioEngine() // initialize new Engine
        //let audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func slowPlayButtonPressed(sender: UIButton) {
        playAudioWithRate(rate: 0.5)
    }
    
    @IBAction func fastPlayButtonPressed(sender: UIButton) {
        playAudioWithRate(rate: 2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(pitch: 1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(pitch: -1000)
    }
    
    @IBAction func stopAudioButtonPressed(sender: UIButton) {
        audioPlayer.stop()
    }
    
    // MARK: Helper Methods
    func playAudioWithRate(#rate: Float) {
        audioPlayer.rate = rate // range 0.5 for half the normal speed to 2.0 double the normal speed, 1.0 is normal speed
        audioPlayer.prepareToPlay() // pre loads the buffer
        audioPlayer.stop()
        audioPlayer.play() // plays sound asynchronously
    }
    
    func playAudioWithVariablePitch(#pitch: Float) {
        let audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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
    

}

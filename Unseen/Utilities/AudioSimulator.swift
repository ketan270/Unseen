//
//  AudioSimulator.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import Foundation
import AVFoundation
import Combine

class AudioSimulator: NSObject, ObservableObject {
    @Published var isPlaying = false
    @Published var currentSound: String?
    
    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var audioFile: AVAudioFile?
    private var lowPassFilter: AVAudioUnitEQ?
    
    private var hearingLossLevel: Double = 0.0
    
    override init() {
        super.init()
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        lowPassFilter = AVAudioUnitEQ(numberOfBands: 1)
        
        guard let engine = audioEngine,
              let player = playerNode,
              let filter = lowPassFilter else { return }
        
        engine.attach(player)
        engine.attach(filter)
        
        // Configure filter
        let band = filter.bands[0]
        band.filterType = .lowPass
        band.frequency = 20000 // Start with full frequency range
        band.bypass = false
        
        // Connect nodes
        engine.connect(player, to: filter, format: nil)
        engine.connect(filter, to: engine.mainMixerNode, format: nil)
        
        do {
            try engine.start()
        } catch {
            print("Audio engine failed to start: \\(error)")
        }
    }
    
    func setHearingLoss(level: Double) {
        hearingLossLevel = level
        
        guard let filter = lowPassFilter else { return }
        
        // Adjust frequency cutoff based on hearing loss level
        // Normal: 20kHz, Severe: 1kHz
        let frequency = 20000 - (19000 * level)
        filter.bands[0].frequency = Float(frequency)
        
        // Also reduce volume
        let volume = 1.0 - (0.7 * level)
        audioEngine?.mainMixerNode.outputVolume = Float(volume)
    }
    
    func playSound(_ soundName: String) {
        // Stop current sound if playing
        if isPlaying {
            stopSound()
            return
        }
        
        // Generate a simple tone since we don't have audio files
        playTone(for: soundName)
    }
    
    private func playTone(for soundName: String) {
        guard let player = playerNode else { return }
        
        // Generate different tones for different sounds
        let frequency: Float
        let duration: TimeInterval
        
        switch soundName {
        case "notification":
            frequency = 800
            duration = 0.3
        case "alarm":
            frequency = 1000
            duration = 1.0
        case "voice":
            frequency = 300
            duration = 1.5
        default:
            frequency = 440
            duration = 0.5
        }
        
        if let buffer = generateTone(frequency: frequency, duration: duration) {
            currentSound = soundName
            isPlaying = true
            
            player.scheduleBuffer(buffer, at: nil) { [weak self] in
                DispatchQueue.main.async {
                    self?.isPlaying = false
                    self?.currentSound = nil
                }
            }
            
            player.play()
        }
    }
    
    private func generateTone(frequency: Float, duration: TimeInterval) -> AVAudioPCMBuffer? {
        guard let engine = audioEngine else { return nil }
        
        let sampleRate = engine.mainMixerNode.outputFormat(forBus: 0).sampleRate
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: engine.mainMixerNode.outputFormat(forBus: 0),
            frameCapacity: frameCount
        ) else { return nil }
        
        buffer.frameLength = frameCount
        
        let channels = Int(buffer.format.channelCount)
        let amplitude: Float = 0.3
        
        for channel in 0..<channels {
            guard let channelData = buffer.floatChannelData?[channel] else { continue }
            
            for frame in 0..<Int(frameCount) {
                let time = Float(frame) / Float(sampleRate)
                channelData[frame] = sin(2.0 * .pi * frequency * time) * amplitude
            }
        }
        
        return buffer
    }
    
    func stopSound() {
        playerNode?.stop()
        isPlaying = false
        currentSound = nil
    }
}

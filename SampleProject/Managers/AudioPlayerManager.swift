//
//  AudioPlayerManager.swift
//  SampleProject
//
//  Created by Bora Erdem on 24.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import AVFAudio

class AudioPlayerManager: NSObject, AVAudioPlayerDelegate, ObservableObject {
    var player: AVAudioPlayer?
    var didFinishPlaying: (() -> Void)?
    var url: URL!
    var timer: Timer?
    
    @Published var audioSamples: [CGFloat] = (1...35).map { _ in CGFloat.random(in: 0.25...1.0) }
    @Published var playbackPosition: CGFloat = 0
    @Published var isPlaying = false
    
    @Published var currentTime: String = ""
    @Published var endTime: String = ""
    
    deinit {
        timer?.invalidate()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        didFinishPlaying?()
    }
        
    func setupPlayer() {
        guard let url else {return}
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            self.player = player
            player.delegate = self
            player.prepareToPlay()
            
            endTime = stringFromTimeInterval(long: false)
            currentTime = stringFromTimeInterval(interval: player.currentTime, long: false)
            
            didFinishPlaying = { [weak self] in
                player.currentTime = 0
                self?.isPlaying = false
                self?.updatePlaybackPosition()
            }
        } catch {
            print("Audio player setup failed: \(error)")
        }
    }
    
    func playPause() {
        guard let player = player else { return }
        if player.isPlaying == true {
            player.pause()
            stopTimer()
        } else {
            player.play()
            startTimer()
        }
        isPlaying.toggle()
    }
    
    
    func updatePlaybackPosition(newPosition: CGFloat? = nil) {
        guard let player = player else { return }
        playbackPosition = CGFloat(player.currentTime / player.duration)
        
        if let newPosition {
            if  player.duration > 0 {
                let newTime = TimeInterval(newPosition) * player.duration
                player.currentTime = newTime
                playbackPosition = newPosition
            }
        }
    }
    
    func updateCurrentTimeString() {
        guard let player = player else { return }
        let time = player.currentTime
        currentTime = stringFromTimeInterval(interval: time, long: false) // Veya 'long: true' eğer uzun format isteniyorsa
    }
    
    private func startTimer() {
        timer?.invalidate() // Mevcut timer varsa iptal et
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.updatePlaybackPosition()
            self?.updateCurrentTimeString()
        }
    }
    
    // Timer'ı durdur
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    func stringFromTimeInterval(interval: Double? = nil, long: Bool) -> String {
        guard let player = player else {return ""}
        var time = NSInteger(player.duration)
        
        if let interval {
            time = Int(interval)
        }
        
        if long {
            
            let hours = time / 3600
            let minutes = (time % 3600) / 60
            let seconds = time % 60
            
            var timeString = ""
            
            if hours > 0 {
                timeString = "\(hours) Hours "
            }
            
            if minutes > 0 {
                timeString += "\(minutes) Min "
            }
            
            if seconds > 0 || timeString.isEmpty {
                timeString += "\(seconds) Sec"
            }
            
            return timeString.trimmingCharacters(in: .whitespaces)
        }
        
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        
        // Saat bileşeni 0 ise, sadece dakika ve saniyeyi göster
        if hours > 0 {
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        } else {
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }
    }
    
    func goBackward10() {
        guard let currentPlayer = player else { return }
        let currentTime = currentPlayer.currentTime
        currentPlayer.currentTime = max(currentTime - 10, 0)
    }
    
    func goForward10() {
        guard let currentPlayer = player else { return }
        let currentTime = currentPlayer.currentTime
        let duration = currentPlayer.duration
        currentPlayer.currentTime = min(currentTime + 10, duration)
    }


}

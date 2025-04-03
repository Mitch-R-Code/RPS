import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private init() {
        preloadSounds()
    }
    
    private func preloadSounds() {
        // Load countdown sound
        if let countdownPath = Bundle.main.path(forResource: "countdown", ofType: "mp3") {
            do {
                let countdownPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: countdownPath))
                countdownPlayer.prepareToPlay()
                audioPlayers["countdown"] = countdownPlayer
            } catch {
                print("Error loading countdown sound: \(error)")
            }
        }
        
        // Load reveal sound
        if let revealPath = Bundle.main.path(forResource: "reveal", ofType: "mp3") {
            do {
                let revealPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: revealPath))
                revealPlayer.prepareToPlay()
                audioPlayers["reveal"] = revealPlayer
            } catch {
                print("Error loading reveal sound: \(error)")
            }
        }
    }
    
    func playCountdown() {
        audioPlayers["countdown"]?.play()
    }
    
    func playReveal() {
        audioPlayers["reveal"]?.play()
    }
} 
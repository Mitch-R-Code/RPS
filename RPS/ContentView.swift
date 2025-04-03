//
//  ContentView.swift
//  RPS
//
//  Created by Admin on 4/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var gameState: GameState = .start
    @State private var countdown = 3
    @State private var selectedOption: GameOption?
    @State private var timer: Timer?
    @State private var showGo = false
    @State private var countdownScale: CGFloat = 1.0
    @State private var resultScale: CGFloat = 0.1
    @State private var resultRotation: Double = 0
    
    enum GameState {
        case start
        case countdown
        case result
    }
    
    enum GameOption: String, CaseIterable {
        case rock = "Rock"
        case paper = "Paper"
        case scissors = "Scissors"
    }
    
    private var countdownText: String {
        switch countdown {
        case 3: return "Rock"
        case 2: return "Paper"
        case 1: return "Scissors"
        default: return ""
        }
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                if gameState == .start {
                    Button(action: startGame) {
                        Text("Start")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 200)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                    .scaleEffect(countdownScale)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: countdownScale)
                    .sensoryFeedback(.impact(weight: .medium), trigger: gameState)
                } else if gameState == .countdown {
                    if showGo {
                        Text("Go!")
                            .font(.system(size: 100, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(countdownScale)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: countdownScale)
                            .sensoryFeedback(.success, trigger: showGo)
                    } else {
                        Text(countdownText)
                            .font(.system(size: 100, weight: .bold))
                            .foregroundColor(.white)
                            .scaleEffect(countdownScale)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: countdownScale)
                            .sensoryFeedback(.impact(weight: .medium), trigger: countdown)
                    }
                } else if gameState == .result {
                    if let option = selectedOption {
                        Image(option.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .scaleEffect(resultScale)
                            .rotationEffect(.degrees(resultRotation))
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: resultScale)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: resultRotation)
                            .sensoryFeedback(.success, trigger: resultScale)
                    }
                }
                
                Spacer()
                
                if gameState == .result {
                    Button(action: resetGame) {
                        Text("Again!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                    .sensoryFeedback(.impact(weight: .medium), trigger: gameState)
                }
            }
        }
    }
    
    private func startGame() {
        gameState = .countdown
        countdown = 3
        showGo = false
        selectedOption = nil
        
        // Animate the countdown text
        withAnimation {
            countdownScale = 1.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                countdownScale = 1.0
            }
        }
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
                
                // Play countdown sound
                SoundManager.shared.playCountdown()
                
                // Animate the countdown text
                withAnimation {
                    countdownScale = 1.5
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        countdownScale = 1.0
                    }
                }
            } else {
                showGo = true
                
                // Play countdown sound for "Go!"
                SoundManager.shared.playCountdown()
                
                // Animate "Go!" text
                withAnimation {
                    countdownScale = 1.5
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        countdownScale = 1.0
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    timer.invalidate()
                    self.timer = nil
                    showResult()
                }
            }
        }
    }
    
    private func showResult() {
        if selectedOption == nil {
            selectedOption = GameOption.allCases.randomElement()
        }
        
        // Play reveal sound
        SoundManager.shared.playReveal()
        
        // Animate the result reveal
        withAnimation {
            resultScale = 1.0
            resultRotation = 360
        }
        
        gameState = .result
    }
    
    private func resetGame() {
        gameState = .start
        selectedOption = nil
        timer?.invalidate()
        timer = nil
        
        // Reset animation values
        resultScale = 0.1
        resultRotation = 0
    }
}

#Preview {
    ContentView()
}

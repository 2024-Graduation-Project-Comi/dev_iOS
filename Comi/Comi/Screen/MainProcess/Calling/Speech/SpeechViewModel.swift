//
//  SpeechViewModel.swift
//  Comi
//
//  Created by 문영균 on 5/9/24.
//

import Foundation
import AVFoundation
import Alamofire

class SpeechViewModel: ObservableObject {

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingTimer: Timer?
    private var audioCheckInterval: TimeInterval = 0.1  // 타이머 간격
    private var maxConsecutiveNoInputTime: TimeInterval = 3  // 사용자 입력 감지 간격
    private var consecutiveNoInputCount: TimeInterval = 0  // 사용자 입력 카운터

    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var audioURL: URL?

    func startRecording() {
        guard !isRecording else {return}
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission { [weak self] granted in
                guard granted else {
                    print("Error: User denied recording permission.")
                    return
                }
                
                guard let self = self else { return }
                
                let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let audioFilename = documentPath.appendingPathComponent("recording.wav")
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                do {
                    self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                    try FileManager.default.createDirectory(at: documentPath, withIntermediateDirectories: true, attributes: nil)
                    self.audioRecorder?.record()
                    self.audioRecorder?.isMeteringEnabled = true
                    
                    DispatchQueue.main.async {
                        self.isRecording = true
                        self.startRecordingTimer()
                    }
                } catch {
                    print("Error: Failed to start recording process.")
                }
            }
        } catch {
            print("Error: Failed to set up recording session.")
        }
    }

    func stopRecording() {
        guard isRecording else { return }

        audioRecorder?.stop()
        audioURL = audioRecorder?.url
        audioRecorder = nil
        isRecording = false
        stopRecordingTimer()
    }

    func playRecording() {
        guard let audioURL = audioURL else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.setVolume(1, fadeDuration: .infinity)
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Error: Failed to play recording.")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }

    private func startRecordingTimer() {
        recordingTimer = Timer.scheduledTimer(withTimeInterval: audioCheckInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            self.audioRecorder?.updateMeters()
            let db = self.audioRecorder?.averagePower(forChannel: 0) ?? 0
            print("Current audio level: \(db) dB")

            if db < -25 {  // 소리가 감지되지 않을 때
                self.consecutiveNoInputCount += self.audioCheckInterval
                print("No input detected. Consecutive no input time: \(self.consecutiveNoInputCount) seconds")
                if self.consecutiveNoInputCount >= self.maxConsecutiveNoInputTime {
                    print("No user input detected, stopping recording.")
                    stopRecording()
                } else {  // 소리 감지시
                    self.consecutiveNoInputCount = 0
                }
            }
        })
    }

    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        consecutiveNoInputCount = 0
    }
}

class SpeechPlayingClient {
    var audioPlayer: AVAudioPlayer?
    func startPlaying(url: URL, parameters: [String: String]) {
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: ["Content-Type":"application/json"]).responseData { response in
            switch response.result {
            case .success(let data):
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsDirectory.appendingPathComponent("audio.wav")

                do {
                    try data.write(to: fileURL)

                    // AVAudioPlayer로 음성 파일 재생
                    self.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                    self.audioPlayer?.play()
                } catch {
                    print("Error: Failed to save or play audio data")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

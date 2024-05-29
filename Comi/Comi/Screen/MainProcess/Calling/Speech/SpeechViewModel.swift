//
//  SpeechViewModel.swift
//  Comi
//
//  Created by 문영균 on 5/9/24.
//

import Foundation
import AVFoundation
import Alamofire
import Speech
import MicrosoftCognitiveServicesSpeech

class SpeechViewModel: ObservableObject {

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingTimer: Timer?
    private var audioCheckInterval: TimeInterval = 0.1  // 타이머 간격
    private var maxConsecutiveNoInputTime: TimeInterval = 2  // 사용자 입력 감지 간격
    private var consecutiveNoInputCount: TimeInterval = 0  // 사용자 입력 카운터

    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var audioURL: URL?
    @Published var speechedText: String?

    // 녹음이 종료될 때 호출할 클로저
    var onRecordingStopped: (() -> Void)?

    func startRecording(onStopped: @escaping () -> Void) {
        guard !isRecording else { return }

        self.onRecordingStopped = onStopped

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
//        onRecordingStopped?()
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
        consecutiveNoInputCount = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: audioCheckInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.global(qos: .background).async {
                self.audioRecorder?.updateMeters()
                let db = self.audioRecorder?.averagePower(forChannel: 0) ?? 0
                print("Current audio level: \(db) dB")

                if db < -30 {  // 소리가 감지되지 않을 때
                    DispatchQueue.main.async {
                        self.consecutiveNoInputCount += self.audioCheckInterval
                        print("No input detected. Consecutive no input time: \(self.consecutiveNoInputCount) seconds")
                        if self.consecutiveNoInputCount >= self.maxConsecutiveNoInputTime {
                            print("No user input detected, stopping recording.")
                            self.stopRecording()
                            self.onRecordingStopped?()  // 타이머에 의한 종료 시 클로저 호출
                        }
                    }
                } else { // 소리 감지 시
                    DispatchQueue.main.async {
                        print("Input detected, resetting counter.")
                        self.consecutiveNoInputCount = 0
                    }
                }
            }
        })
    }

    func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        consecutiveNoInputCount = 0
    }
}

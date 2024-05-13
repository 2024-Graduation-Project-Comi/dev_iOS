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

    func startRecrding() {
        guard !isRecording else { return }

        if #available(iOS 17.0, *) {
            let recordingApplication = AVAudioApplication.shared
            let recordingSession = AVAudioSession.sharedInstance()
            do {

            } catch {

            }
        } else {
            let recordingSession = AVAudioSession.sharedInstance()

            do {
                try recordingSession.setCategory(.playAndRecord)
                try recordingSession.setActive(true)

                recordingSession.requestRecordPermission{ [weak self] granted in
                    guard granted else {
                        print("Error: User denied recording permission.")
                        return
                    }

                    guard let self = self else { return }

                    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let audioFileName = documentPath.appendingPathComponent("recording.wav")
                    let settings = [
                        AVFormatIDKey: Int(kAudioFormatLinearPCM),
                        AVSampleRateKey: 44100,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                    ]

                    do {
                        self.audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
                        try FileManager.default.createDirectory(at: documentPath, withIntermediateDirectories: true, attributes: nil)
                        self.audioRecorder?.record()
                        self.audioRecorder?.isMeteringEnabled = true

                        DispatchQueue.main.async {
                            self.isRecording = true
//                            self.startRecrdingTimer()
                        }
                    } catch {
                        print("Error: Failed to start recording process.")
                    }
                }
            } catch {
                print("Error: Failed to set up recording session.")
            }
        }

    }
}

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

    func startRecording() {
        guard !isRecording else { return }

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
        consecutiveNoInputCount = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: audioCheckInterval, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.global(qos: .background).async {
                self.audioRecorder?.updateMeters()
                let db = self.audioRecorder?.averagePower(forChannel: 0) ?? 0
                print("Current audio level: \(db) dB")

                if db < -25 {  // 소리가 감지되지 않을 때
                    DispatchQueue.main.async {
                        self.consecutiveNoInputCount += self.audioCheckInterval
                        print("No input detected. Consecutive no input time: \(self.consecutiveNoInputCount) seconds")
                        if self.consecutiveNoInputCount >= self.maxConsecutiveNoInputTime {
                            print("No user input detected, stopping recording.")
                            self.stopRecording()
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

    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        consecutiveNoInputCount = 0
    }

    // MARK: Azure API를 사용해서 발음 평가 및 STT
    func pronEval() {
        guard let path = audioURL else { return }
        guard let sub = Bundle.main.azureApiKey else {
            print("Azure Key 로드 실패")
            return
        }
        guard let region = Bundle.main.azureRegion else {
            print("Azure Region 로드 실패")
            return
        }
        // Replace with your own subscription key and service region (e.g., "westus").
        // Creates an instance of a speech config with specified subscription key and service region.
        let speechConfig = try! SPXSpeechConfiguration(subscription: sub, region: region)
        // Read audio data from file. In real scenario this can be from memory or network
        let audioDataWithHeader = try! Data(contentsOf: path)
        let audioData = Array(audioDataWithHeader[46..<audioDataWithHeader.count])

        let startTime = Date()

        let audioFormat = SPXAudioStreamFormat(usingPCMWithSampleRate: 44100, bitsPerSample: 16, channels: 1)!
        guard let audioInputStream = SPXPushAudioInputStream(audioFormat: audioFormat) else {
            print("Error: Failed to create audio input stream.")
            return
        }

        guard let audioConfig = SPXAudioConfiguration(streamInput: audioInputStream) else {
            print("Error: audioConfig is Nil")
            return
        }

        let speechRecognizer = try! SPXSpeechRecognizer(speechConfiguration: speechConfig, language: "en-US", audioConfiguration: audioConfig)

        let referenceText = ""
        let pronAssessmentConfig = try! SPXPronunciationAssessmentConfiguration(referenceText, gradingSystem: SPXPronunciationAssessmentGradingSystem.hundredMark, granularity: SPXPronunciationAssessmentGranularity.word, enableMiscue: true)

        pronAssessmentConfig.enableProsodyAssessment()

        try! pronAssessmentConfig.apply(to: speechRecognizer)

        audioInputStream.write(Data(audioData))
        audioInputStream.write(Data())

        // Handle the recognition result
        try! speechRecognizer.recognizeOnceAsync { result in
            guard let pronunciationResult = SPXPronunciationAssessmentResult(result) else {
                print("Error: pronunciationResult is Nil")
                return
            }

            var finalResult = ""
            let resultText = "Accuracy score: \(pronunciationResult.accuracyScore), Prosody score: \(pronunciationResult.prosodyScore), Pronunciation score: \(pronunciationResult.pronunciationScore), Completeness Score: \(pronunciationResult.completenessScore), Fluency score: \(pronunciationResult.fluencyScore)"
            print(resultText)
            finalResult.append("\(resultText)\n")
            finalResult.append("\nword    accuracyScore   errorType\n")

            if let words = pronunciationResult.words {
                var totalWords = ""
                for word in words {
                    let wordString = word.word ?? ""
                    let errorType = word.errorType ?? ""
                    finalResult.append("\(wordString)    \(word.accuracyScore)   \(errorType)\n")
                    totalWords.append("\(wordString) ")
                }
                print(totalWords)
            }

            let endTime = Date()
            let timeCost = endTime.timeIntervalSince(startTime) * 1000
            print("Time cost: \(timeCost)ms")
        }
    }

    // MARK: 애플 기본 제공 Speech 라이브러리를 사용한 STT 기능
    func pronEvalBuiltIn(completion: @escaping (String?) -> Void) {
        guard let path = audioURL else {
            completion(nil)
            return
        }
        // TODO: en-US 를 사용자 언어에 맞춰서 할 수 있도록 해야함
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        // 음성 권한 요청
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .notDetermined, .denied, .restricted:
                print("\(status.rawValue)")
                completion(nil)
            case .authorized:
                print("\(status.rawValue)")
            @unknown default:
                print("Unknown case")
                completion(nil)
            }
        }

        if speechRecognizer!.isAvailable {
            let request = SFSpeechURLRecognitionRequest(url: path)
            speechRecognizer?.supportsOnDeviceRecognition = true
            speechRecognizer?.recognitionTask(
                with: request,
                resultHandler: { (result, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        completion(nil)
                    }

                    guard let result = result else {
                        print("Error: speechRecognizer result not exist.")
                        completion(nil)
                        return
                    }
                    print(result.bestTranscription.formattedString)
                    if result.isFinal {
                        self.speechedText = result.bestTranscription.formattedString
                        completion(self.speechedText)
                    }
                })
        }
    }
}

class SpeechPlayingClient {
    var audioPlayer: AVAudioPlayer?
    func startPlaying(url: URL, parameters: [String: String]) {
        guard let newURL = createURL(baseURL: url, params: parameters) else { return }
        print(newURL)
        AF.request(newURL, method: .get, parameters: nil, encoding: JSONEncoding(options: []), headers: ["Content-Type":"application/json"]).responseData { response in
            switch response.result {
            case .success(let data):
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsDirectory.appendingPathComponent("audio.wav")

                do {
                    try data.write(to: fileURL)

                    // AVAudioPlayer로 음성 파일 재생
//                    self.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.volume = 1.0
                    self.audioPlayer?.play()
                } catch {
                    print("Error: Failed to save or play audio data")
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func createURL(baseURL: URL, params: [String: Any]) -> URL? {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem]()

        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }

        urlComponents?.queryItems = queryItems

        return urlComponents?.url
    }
}

//
//  PronEvaluationViewModel.swift
//  Comi
//
//  Created by MoonGoon on 5/24/24.
//

import Foundation
import Speech
import MicrosoftCognitiveServicesSpeech

class STTViewModel: ObservableObject {
    @Published var audioURL: URL?
    @Published var speechedText: String?
    @Published var azureResponses: [ChatAzureResponseData] = []
    private var settingViewModel = SettingViewModel()

//    var chatAzureResponseData: ChatAzureResponseData?

    // MARK: Azure API를 사용해서 발음 평가 및 STT
    func pronEval(globalCode: String) {
        let locale = settingViewModel.getLocale(globalCode: globalCode)

        guard let path = audioURL else { return }
        guard let sub = Bundle.main.azureApiKey else {
            print("Azure Key 로드 실패")
            return
        }
        guard let region = Bundle.main.azureRegion else {
            print("Azure Region 로드 실패")
            return
        }
        let speechConfig = try! SPXSpeechConfiguration(subscription: sub, region: region)
        let audioDataWithHeader = try! Data(contentsOf: path)
        let audioData = Array(audioDataWithHeader[46..<audioDataWithHeader.count])
        let audioFormat = SPXAudioStreamFormat(usingPCMWithSampleRate: 44100, bitsPerSample: 16, channels: 1)!
        guard let audioInputStream = SPXPushAudioInputStream(audioFormat: audioFormat) else {
            print("Error: Failed to create audio input stream.")
            return
        }
        guard let audioConfig = SPXAudioConfiguration(streamInput: audioInputStream) else {
            print("Error: audioConfig is Nil")
            return
        }
        let speechRecognizer = try! SPXSpeechRecognizer(speechConfiguration: speechConfig, language: locale, audioConfiguration: audioConfig)
        let referenceText = ""
        let pronAssessmentConfig = try! SPXPronunciationAssessmentConfiguration(referenceText, gradingSystem: SPXPronunciationAssessmentGradingSystem.hundredMark, granularity: SPXPronunciationAssessmentGranularity.word, enableMiscue: true)

        pronAssessmentConfig.enableProsodyAssessment()

        try! pronAssessmentConfig.apply(to: speechRecognizer)

        audioInputStream.write(Data(audioData))
        audioInputStream.write(Data())

        var azureResponseData: ChatAzureResponseData? = ChatAzureResponseData(text: "", accuracyScore: 0, pronunciationScore: 0, completenessScore: 0, fluencyScore: 0, prosodyScore: 0)

        try! speechRecognizer.recognizeOnceAsync { result in
            guard let pronunciationResult = SPXPronunciationAssessmentResult(result) else {
                print("Error: pronunciationResult is Nil")
                return
            }

            var finalResult = ""
            let resultText = "Accuracy score: \(pronunciationResult.accuracyScore), Prosody score: \(pronunciationResult.prosodyScore), Pronunciation score: \(pronunciationResult.pronunciationScore), Completeness Score: \(pronunciationResult.completenessScore), Fluency score: \(pronunciationResult.fluencyScore)"
            print(resultText)
            azureResponseData?.accuracyScore = pronunciationResult.accuracyScore
            azureResponseData?.completenessScore = pronunciationResult.completenessScore
            azureResponseData?.fluencyScore = pronunciationResult.fluencyScore
            azureResponseData?.pronunciationScore = pronunciationResult.pronunciationScore
            azureResponseData?.prosodyScore = pronunciationResult.prosodyScore

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
                azureResponseData?.text = totalWords
            }
            self.azureResponses.append(azureResponseData!)
        }
    }

    // MARK: 애플 기본 제공 Speech 라이브러리를 사용한 STT 기능
    func pronEvalBuiltIn(globalCode: String, completion: @escaping (String?) -> Void) {
        let locale = settingViewModel.getLocale(globalCode: globalCode)
        guard let path = audioURL else {
            completion(nil)
            return
        }
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: locale))
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

                    if result.isFinal {
                        self.speechedText = result.bestTranscription.formattedString
                        print(result.bestTranscription.formattedString)
                        completion(self.speechedText)
                    }
                })
        }
    }
}

//
//  AudioCaptureViewModel.swift
//  Comi
//
//  Created by MoonGoon on 5/24/24.
//

import Foundation
import Alamofire
import AVFAudio
import AVFoundation

class AudioCaptureViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var session: Session!
    private var audioPlayer: AVAudioPlayer?
    private var audioData = Data()
    private var completion: ((Bool) -> Void)?
    @Published var isPlayable = true

    func playAiAudio(url: URL, params: [String: Any], completion: @escaping (Bool) -> Void) {
        self.completion = completion
        let newURL = createURL(baseURL: url, params: params)!
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        self.session = Session()
        audioData = Data()
        completion(true)
//        self.session.streamRequest(newURL, method: .get, parameters: Optional<Empty>.none, headers: headers)
//            .responseStream { (stream) in
//                switch stream.event {
//                case let .stream(result):
//                    switch result {
//                    case let .success(data):
//                        print("data received: \(data.count) bytes.")
//                        self.processDataChunk(data) // 데이터 청크 저장
//                    case let .failure(error):
//                        print("Error occurred during stream: \(error.localizedDescription)")
//                    }
//                case .complete(_):
//                    print("Stream complete")
//                    let result = self.saveToWAVFile(filename: "output.wav")
//                    if result {
//
//                    } else {
//                        completion(false)
//                    }
//                }
//            }
    }

    private func processDataChunk(_ chunk: Data) {
        // 수신된 데이터를 audioData에 추가
        audioData.append(chunk)
        print("audioData: \(audioData)")
    }

    private func saveToWAVFile(filename: String) -> Bool {

        // WAV 파일 헤더 생성
        let wavHeader = createWAVHeader(dataSize: audioData.count)
        var wavFileData = Data()
        wavFileData.append(wavHeader)
        wavFileData.append(audioData)

        // 파일 저장
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentPath.appendingPathComponent(filename)
        do {
            try wavFileData.write(to: fileURL)
            print("WAV 파일이 저장되었습니다: \(fileURL)")
            if isPlayable {
                playWAVFile(at: fileURL)
            }
            return true
        } catch {
            print("파일 저장 실패: \(error)")
            return false
        }

//        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileURL = documentDirectory.appendingPathComponent(filename)
//            do {
//                try wavFileData.write(to: fileURL)
//                print("WAV 파일이 저장되었습니다: \(fileURL)")
//                if isPlayable {
//                    playWAVFile(at: fileURL)
//                }
//                return true
//            } catch {
//                print("파일 저장 실패: \(error)")
//                return false
//            }
//        }
//        return false
    }

    private func createWAVHeader(dataSize: Int) -> Data {
        let sampleRate: UInt32 = 24000
        let numChannels: UInt16 = 1
        let bitsPerSample: UInt16 = 16
        let byteRate = sampleRate * UInt32(numChannels * bitsPerSample / 8)
        let blockAlign = numChannels * bitsPerSample / 8

        var header = Data()

        // RIFF Header
        header.append("RIFF".data(using: .utf8)!)
        header.append(UInt32(36 + dataSize).littleEndianData)
        header.append("WAVE".data(using: .utf8)!)

        // fmt subchunk
        header.append("fmt ".data(using: .utf8)!)
        header.append(UInt32(16).littleEndianData) // Subchunk1Size for PCM
        header.append(UInt16(1).littleEndianData)  // AudioFormat for PCM
        header.append(numChannels.littleEndianData)
        header.append(sampleRate.littleEndianData)
        header.append(byteRate.littleEndianData)
        header.append(blockAlign.littleEndianData)
        header.append(bitsPerSample.littleEndianData)

        // data subchunk
        header.append("data".data(using: .utf8)!)
        header.append(UInt32(dataSize).littleEndianData)

        return header
    }

    private func playWAVFile(at url: URL) {
        do {

//            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)  // 상단 스피커 대신 메인 스피커를 사용하도록 변경하여 크기가 작아짐을 방지함
            try AVAudioSession.sharedInstance().setActive(true)
            // 기존 플레이어 중지 및 초기화
//            audioPlayer?.stop()
//            audioPlayer = nil
            // 새로운 플레이어 생성 및 설정
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Playing WAV file")
        } catch {
            print("Failed to play WAV file: \(error.localizedDescription)")
            completion?(false)
        }
    }
    // AVAudioPlayerDelegate 메서드 구현
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio finished playing")
        player.stop()
        audioPlayer = nil
        completion?(flag)
    }
}

extension AudioCaptureViewModel {
    private func createURL(baseURL: URL, params: [String: Any]) -> URL? {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem]()

        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        urlComponents?.queryItems = queryItems

        return urlComponents?.url
    }
}

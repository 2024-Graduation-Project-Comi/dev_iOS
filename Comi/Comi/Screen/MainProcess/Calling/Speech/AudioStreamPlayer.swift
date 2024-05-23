import AVFoundation
import Alamofire

class AudioStreamPlayer {
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var audioFormat: AVAudioFormat?
    private var headerData = Data()
    private var isHeaderParsed = false

    init() {
        setupAudioEngine()
    }

    private func setupAudioEngine() {
        audioEngine.attach(playerNode)
        let mainMixer = audioEngine.mainMixerNode
        audioEngine.connect(playerNode, to: mainMixer, format: mainMixer.outputFormat(forBus: 0))

        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine start error: \(error.localizedDescription)")
        }
    }

    func processStreamData(_ data: Data) {
        if !isHeaderParsed {
            headerData.append(data)
            if headerData.count >= 44 {
                audioFormat = parseWAVHeader(headerData)
                isHeaderParsed = true

                if headerData.count > 44 {
                    let remainingData = headerData.advanced(by: 44)
                    playAudioData(remainingData)
                }
            }
            return
        }
        playAudioData(data)
    }

    func playAudioData(_ data: Data) {
        let utf8Text = String(data: data, encoding: .utf8)
        print("* RESPONSE DATA: \(utf8Text)") // encode data to UTF8
        if audioFormat == nil {
            audioFormat = parseWAVHeader(data)
            guard let audioFormat = audioFormat else {
                print("Audio format is not set or invalid WAV header")
                return
            }
            let audioData = data.advanced(by: 44) // WAV 헤더를 건너뛰고 오디오 데이터 재생
            playAudioData(audioData)
            return
        }
        guard let audioFormat = audioFormat else {
            print("Audio format is not set")
            return
        }
        let frameCapacity = UInt32(data.count) / audioFormat.streamDescription.pointee.mBytesPerFrame
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: frameCapacity) else {
            print("Failed to create AVAudioPCMBuffer")
            return
        }

        buffer.frameLength = frameCapacity

        data.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) in
            if let audioBuffer = buffer.audioBufferList.pointee.mBuffers.mData {
                memcpy(audioBuffer, bufferPointer.baseAddress, Int(buffer.frameLength * audioFormat.streamDescription.pointee.mBytesPerFrame))
            }
        }

        playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
        playerNode.play()
    }

    private func parseWAVHeader(_ data: Data) -> AVAudioFormat? {
//        guard data.count >= 44 else {
//            print("Invalid WAV header")
//            return nil
//        }

        let sampleRate = data.withUnsafeBytes { $0.load(fromByteOffset: 24, as: UInt32.self).littleEndian }
        let channels = data.withUnsafeBytes { $0.load(fromByteOffset: 22, as: UInt16.self).littleEndian }
        let bitsPerSample = data.withUnsafeBytes { $0.load(fromByteOffset: 34, as: UInt16.self).littleEndian }

        let formatFlags: AudioFormatFlags = bitsPerSample == 16 ? kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked : kAudioFormatFlagIsFloat
        var streamDescription = AudioStreamBasicDescription(mSampleRate: Float64(sampleRate),
                                                            mFormatID: kAudioFormatLinearPCM,
                                                            mFormatFlags: formatFlags,
                                                            mBytesPerPacket: UInt32(channels) * UInt32(bitsPerSample / 8),
                                                            mFramesPerPacket: 1,
                                                            mBytesPerFrame: UInt32(channels) * UInt32(bitsPerSample / 8),
                                                            mChannelsPerFrame: UInt32(channels),
                                                            mBitsPerChannel: UInt32(bitsPerSample),
                                                            mReserved: 0)

        return AVAudioFormat(streamDescription: &streamDescription)
    }
}

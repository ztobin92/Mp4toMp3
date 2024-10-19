//
//  ConvertHelper.swift
//  SampleProject
//
//  Created by Bora Erdem on 18.01.2024.
//  Copyright © 2024 Mobillium. All rights reserved.
//

import Foundation
import AVFoundation


public final class ConvertHelper {
    static let shared = ConvertHelper()
    
    @frozen enum SampleRate: Int, CaseIterable {
        case
        v48000 = 48000,
        v44100 = 44100,
        v32000 = 32000,
        v24000 = 24000,
        v22050 = 22050,
        v16000 = 16000,
        v11025 = 11025,
        v8000 = 8000
        
        func str() -> String {
            "\(self.rawValue) Hz"
        }
    }
    
    @frozen enum OutputFormat: String , CaseIterable{
        case
        MP3,
        M4A,
        WAV,
        AIFF,
        CAF,
        AVI,
        MKV,
        WEBM,
        FLAC,
        AAC,
        VOC
    }
    
    @frozen enum BitRate: Int, CaseIterable {
        case
        v256 = 256000,
        v224 = 224000,
        v192 = 192000,
        v160 = 160000,
        v144 = 144000,
        v128 = 128000,
        v112 = 112000,
        v96 = 96000,
        v80 = 80000,
        v64 = 64000,
        v56 = 56000,
        v48 = 48000,
        v40 = 40000,
        v32 = 32000
        
        func str() -> String {
            "\(self.rawValue.toString.dropLast().dropLast().dropLast()) kbit/s"
        }
    }
    
    struct OutputParameters {
        var name: String
        var startSecond: CGFloat
        var finishSecond: CGFloat
        var format: OutputFormat
        var bitrate: BitRate
        var sampleRate: SampleRate
        var volume: CGFloat
        var channels: Int
        var speed: CGFloat
        var image: UIImage
        
    }
    
    
    func convertVideo(for url: URL, parameters: OutputParameters, completion: @escaping (URL?)->()) {
        
        // Simüle edilen dönüştürme işlemi
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            let audioOutputURL = createOutputURL(for: url, name: parameters.name)
            let composition = AVMutableComposition()
            let asset = AVURLAsset(url: url)
            let track = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
            
            if asset.tracks(withMediaType: .audio).isEmpty {
                DispatchQueue.main.async {
                    ToastPresenter.showWarningToast(text: L10n.Error.Convert.Sound.channel,position: .bottomNote, color: .appRed)
                }
                completion(nil)
                return
            }
            
            do {
                try track?.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: asset.tracks(withMediaType: .audio)[0], at: .zero)
            } catch {
                completion(nil)
                print("Failed to insert audio track: \(error)")
                return
            }

            guard let assetReader = try? AVAssetReader(asset: composition) else { 
                completion(nil)
                return
            }
            
            guard let sourceTrack = asset.tracks(withMediaType: .audio).first else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let startCMTime = CMTime(seconds: parameters.startSecond, preferredTimescale: sourceTrack.naturalTimeScale)
            let durationCMTime = CMTime(seconds: parameters.finishSecond - parameters.startSecond, preferredTimescale: sourceTrack.naturalTimeScale)
            let timeRange = CMTimeRange(start: startCMTime, duration: durationCMTime)
            
            assetReader.timeRange = timeRange
            
            let audioMix = AVMutableAudioMix()
            let inputParameters = AVMutableAudioMixInputParameters(track: sourceTrack)
            inputParameters.trackID = sourceTrack.trackID
            inputParameters.setVolume(Float(parameters.volume), at: CMTime.zero) // Hacmi ayarlayın
            audioMix.inputParameters = [inputParameters]
            
            let assetReaderAudioMixOutput = AVAssetReaderAudioMixOutput(audioTracks: composition.tracks(withMediaType: .audio), audioSettings: nil)
            assetReaderAudioMixOutput.audioMix = audioMix // Audio mix'i kullanarak ses hacmini ayarla
            assetReader.add(assetReaderAudioMixOutput)
            guard assetReader.startReading() else {
                completion(nil)
                return
            }

            let outputSettings: [String : Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: parameters.sampleRate.rawValue,
                AVNumberOfChannelsKey: parameters.channels,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVEncoderBitRatePerChannelKey: parameters.bitrate.rawValue,
            ]
            
            guard let assetWriter = try? AVAssetWriter(outputURL: audioOutputURL, fileType: .m4a ) else { return }
            let writerInput = AVAssetWriterInput(mediaType: .audio, outputSettings: outputSettings)
            assetWriter.add(writerInput)
            guard assetWriter.startWriting() else { return }
            assetWriter.startSession(atSourceTime: CMTime.zero)

            let queue = DispatchQueue(label: "my.queue.id")
            writerInput.requestMediaDataWhenReady(on: queue) {

                // capture assetReader in my block to prevent it being released
                let readerOutput = assetReader.outputs.first!

                while writerInput.isReadyForMoreMediaData {
                    if let nextSampleBuffer = readerOutput.copyNextSampleBuffer() {
                        writerInput.append(nextSampleBuffer)
                    } else {
                        writerInput.markAsFinished()
                        assetWriter.endSession(atSourceTime: composition.duration)
                        assetWriter.finishWriting() {
                            DispatchQueue.main.async { [weak self] in
                                guard let self else { return }
                                adjustVolumeOfAudioFile(at: audioOutputURL, to: Float(parameters.volume)) { result in
                                    switch result {
                                    case .success(let url):
                                        DispatchQueue.main.async {
                                            completion(url)
                                        }
                                    case .failure(_):
                                        DispatchQueue.main.async {
                                            completion(nil)
                                        }
                                    }
                                }
                            }
                        }
                        break;
                    }
                }
            }
        }
    }
    
    func createOutputURL(for videoURL: URL, with extra: String = "", name: String) -> URL {
        let directoryURL = FileManager.default.temporaryDirectory
//        let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileName = name
        
        let outputURL = directoryURL.appendingPathComponent(fileName + ".m4a")
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try? FileManager.default.removeItem(at: outputURL)
        }
        return outputURL
    }
    
    func adjustVolumeOfAudioFile(at url: URL, to newVolume: Float, completion: @escaping (Result<URL, Error>) -> Void) {
        let fileManager = FileManager.default
//        let tempDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let tempDirectory = fileManager.temporaryDirectory
        let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(url.pathExtension)
        
        do {
            // Ses dosyasını oku
            let file = try AVAudioFile(forReading: url)
            let format = file.processingFormat
            let frameCount = UInt32(file.length)
            let audioBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
            
            try file.read(into: audioBuffer)
            
            // Ses dosyasının hacmini ayarla
            let audioBufferFloatChannelData = audioBuffer.floatChannelData!
            for frame in 0..<Int(frameCount) {
                for channel in 0..<Int(format.channelCount) {
                    audioBufferFloatChannelData[channel][frame] *= newVolume
                }
            }
            
            // Değiştirilmiş ses dosyasını yaz
            let outputFile = try AVAudioFile(forWriting: tempFileURL, settings: file.fileFormat.settings)
            try outputFile.write(from: audioBuffer)
            
            // Orijinal dosyayı geçici dosya ile değiştir
            if fileManager.fileExists(atPath: url.path) {
                try? fileManager.removeItem(at: url)
            }
            try fileManager.moveItem(at: tempFileURL, to: url)
            
            // İşlem tamamlandığında completion handler'ı çağır
            completion(.success(url))
        } catch {
            completion(.failure(error))
        }
    }
    
    @frozen enum DownloadDestination {
        case temp, cache, documents
    }
    
    func downloadAudioFromURL(audioURL: URL, parameters: ConvertHelper.OutputParameters, destination: DownloadDestination = .documents, completion: @escaping (Result<URL, Error>)->()) {
        
        var outputType = parameters.format.rawValue.lowercased()
        
        let documentsURL: URL!
        
        switch destination {
        case .temp:
            documentsURL =  FileManager.default.temporaryDirectory
        case .cache:
            documentsURL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            outputType = ".m4a"
        case .documents:
            documentsURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        
        let destinationURL = documentsURL.appendingPathComponent("audio_\(parameters.name)_\(Date().string(format: "MM-dd_HH-mm-ss")).\(outputType)")
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let downloadTask = session.downloadTask(with: audioURL) { (location, response, error) in
            if let location = location {
                do {
                    try FileManager.default.copyItem(at: location, to: destinationURL)
                    print("Dosya indirildi ve kaydedildi: \(destinationURL.absoluteString)")
                    completion(.success(destinationURL))
                } catch {
                    print("Dosya kaydedilemedi: \(error)")
                    completion(.failure(error))
                }
            } else if let error = error {
                print("Dosya indirilemedi: \(error)")
                completion(.failure(error))
            }
        }
        downloadTask.resume()
    }
    
    func loadFileAsync(url: URL, parameters: OutputParameters, completion: @escaping (String?, Error?) -> Void)
        {
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            let outputType = parameters.format.rawValue.lowercased()
            let destinationUrl = documentsUrl.appendingPathComponent("audio_\(parameters.name)\(Date().string(format: "MM-dd_HH-mm-ss")).\(outputType)")

            if FileManager().fileExists(atPath: destinationUrl.path)
            {
                print("File already exists [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let task = session.dataTask(with: request, completionHandler:
                {
                    data, response, error in
                    if error == nil
                    {
                        if let response = response as? HTTPURLResponse
                        {
                            if response.statusCode == 200
                            {
                                if let data = data
                                {
                                    if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                    {
                                        completion(destinationUrl.path, error)
                                    }
                                    else
                                    {
                                        completion(destinationUrl.path, error)
                                    }
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                        }
                    }
                    else
                    {
                        completion(destinationUrl.path, error)
                    }
                })
                task.resume()
            }
        }
    
    // Not good
    func changeSpeedOfAudioFile(inputURL: URL, speed: Float, completionHandler: @escaping (Result<URL, Error>) -> Void) {
        let audioFile: AVAudioFile
        let engine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        
        let temp: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(UUID().uuidString).m4a")
        try? FileManager.default.copyItem(at: inputURL, to: temp)

        do {
            audioFile = try AVAudioFile(forReading: temp)
        } catch {
            completionHandler(.failure(error))
            return
        }

        timePitch.rate = speed

        engine.attach(playerNode)
        engine.attach(timePitch)

        engine.connect(playerNode, to: timePitch, format: audioFile.processingFormat)
        engine.connect(timePitch, to: engine.mainMixerNode, format: nil)

        do {
            try engine.start()
        } catch {
            completionHandler(.failure(error))
            return
        }

        let format = engine.mainMixerNode.outputFormat(forBus: 0)

        let name = inputURL.deletingPathExtension().lastPathComponent
        if FileManager.default.fileExists(atPath: inputURL.path) {
            try? FileManager.default.removeItem(at: inputURL)
        }

        let outputAudioFile: AVAudioFile
        do {
            outputAudioFile = try AVAudioFile(forWriting: inputURL, settings: format.settings, commonFormat: format.commonFormat, interleaved: format.isInterleaved)
        } catch {
            completionHandler(.failure(error))
            return
        }

        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 4096, format: format) { buffer, when in
            do {
                try outputAudioFile.write(from: buffer)
            } catch {
                completionHandler(.failure(error))
                engine.stop()
                return
            }
        }

        playerNode.scheduleFile(audioFile, at: nil) {
            engine.mainMixerNode.removeTap(onBus: 0)
            engine.stop()
            completionHandler(.success(inputURL))
        }

        playerNode.play()
    }
}

//
//  Speaker.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/05.
//

import Foundation
import AVFoundation
//音声再生エージェント

final class Speaker: NSObject, ObservableObject, AVSpeechSynthesizerDelegate{
    
    @Published var state: State = .inactive
    private let syntesizer: AVSpeechSynthesizer = .init()
    var utterance = AVSpeechUtterance(string: "")
    //播放状态的枚举
    enum State: String {
        case inactive, speaking, paused
    }
    
    override init() {
        super.init()
        syntesizer.delegate = self
        
    }
    //说
    func speak(words: String) {
        utterance = AVSpeechUtterance(string: words)
        //用日语说
        utterance.voice = AVSpeechSynthesisVoice(language: "ja_JP")
        syntesizer.speak(utterance)
    }
    //暂停
    func pause() {
        syntesizer.pauseSpeaking(at: .immediate)
    }
    //停止
    func stop() {
        syntesizer.stopSpeaking(at: .immediate)
    }
    //继续说
    func continueSpeaking() {
        syntesizer.continueSpeaking()
    }
    
    //开始说
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.state = .speaking
    }
    //暂停说
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        self.state = .paused
    }
    //说结束
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.state = .inactive
    }
    
    
}

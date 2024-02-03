//
//  TextRecognitionView.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/05.
//

import SwiftUI
import Vision
import VisionKit
import AVFoundation

//文本识别页面
struct TextRecognitionView: View {
    @Environment(\.presentationMode) var presentationMode
    private var selImage:UIImage
    @Binding private var  name: String
    // 文字转语音
    @ObservedObject var speaker = Speaker()
    @State var recognitionText = ""
    
    init(selImage: UIImage, name: Binding<String>) {
        self.selImage = selImage
        _name = name
    }
    
    
    @State var speakerImageName = "speaker.wave.2.circle.fill"
    var body: some View {
        VStack(spacing: 10) {
            // 文本输入
            TextEditor(text: $recognitionText).fontWeight(.bold).font(Font.system(size: 30)).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            HStack {
                //Spacer().frame(width: 20)
                //语音播放按钮
                Button {
                    self.didTapSpeaker()
                } label: {
                    Image(systemName: speakerImageName).resizable()
                }.frame(width: 40, height: 40).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                //保存按钮
                Button {
                    self.didTapSaveData()
                } label: {
                    Text("保存").foregroundColor(.black).fontWeight(.bold).font(Font.system(size: 25))
                }.frame(minWidth: 50, maxWidth: .infinity, minHeight: 60)
                    .padding(0)
                    .background(Color.RGBA(52, 199, 90))
                    .cornerRadius(25)
                Spacer().frame(width: 20)
                
            }
        }
        
        .onAppear(perform: {
            self.configRequest()
        })
        .onDisappear(perform: {
            //页面消失,取消语音
            self.speaker.stop()
        })
        .onReceive(speaker.$state, perform: { state in
            // 获取语音播放状态
            switch state {
                //再生ボタンの画像変更
            case .inactive:
                self.speakerImageName = "speaker.wave.2.circle.fill"
            case .speaking:
                self.speakerImageName = "pause.circle.fill"
            case .paused:
                self.speakerImageName = "play.circle.fill"
            }
           
        })
        .navigationTitle("Recognition Text").navigationBarTitleDisplayMode(.inline)
    }
    
    //画像を識別する文字
    private   func configRequest() {
        let textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { request, error in
            if let requestResults = request.results as? [VNRecognizedTextObservation] {
                DispatchQueue.main.async {
                    let maximumCandidates = 1
                    var recognitionText = ""
                    for observation in requestResults {
                        guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                        print(candidate.string)
                        recognitionText += candidate.string
                    }
                    self.recognitionText = recognitionText
                }
            }
        })
        //识别水平 精确的
        textRecognitionRequest.recognitionLevel = .accurate
        //不使用手机当前语言
        textRecognitionRequest.usesLanguageCorrection = false
        //日语识别
        textRecognitionRequest.recognitionLanguages = ["ja_JP"] //["zh-Hans"]
        
        do {
            if let cgImage = self.selImage.cgImage {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                try handler.perform([textRecognitionRequest])
            }
            
        } catch {
            print(error)
        }
    }
    
    // 文字を話す
    func didTapSpeaker() {
        switch speaker.state {
        case .inactive:
            speaker.speak(words: self.recognitionText)
        case .speaking:
            speaker.pause()
        case .paused:
            speaker.continueSpeaking()
        }
        
    }
    
    //保存
    func didTapSaveData() {
        self.name = self.recognitionText
        self.presentationMode.wrappedValue.dismiss()
    }
 
}


struct TextRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TextRecognitionView(selImage: UIImage(), name: .constant(""))
        }
        
    }
}

//
//  ImagePickerView.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/06.
//

import SwiftUI
//swiftui 使用 uiKit的内容
struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    let sourceType: UIImagePickerController.SourceType
    @Binding var selImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        //设置代理
        picker.delegate = context.coordinator
        picker.allowsEditing = false
       // picker.modalPresentationStyle = .formSheet
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIImagePickerController
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, presentationMode: presentationMode)
    }
    
    //apple官方demo对于delegate的示例写法
    final class Coordinator: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
        private let parent: ImagePickerView
        @Binding private var presentationMode: PresentationMode
        //初始化
        init(_ parent: ImagePickerView, presentationMode: Binding<PresentationMode>) {
            self.parent = parent
            _presentationMode = presentationMode
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //图片选择完时调用
            let uiimage = info[.originalImage] as! UIImage
            let newImage = normalizedimage(image: uiimage)
            self.parent.selImage = newImage
            presentationMode.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //点击取消
            presentationMode.dismiss()
        }

    }


}

//struct ImagePickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePickerView()
//    }
//}

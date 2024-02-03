//
//  AddView.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/03.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    let placeList = ["名前(写真で自動認識します)","種類","数量","賞味期限","買った日にち"]
    var isAdd: Bool
    var item: GoodsItem?
    
    
    @State var name = "" //名字
    @State var kind = ""//种类
    @State var count = ""//数量
    @State var deadline = Date()// 失效期
    @State var produceTime = Date()//生产日期
    @State var remark = "" // 备注
    
    @State var showSheet = false
    @State var showImagePicker = false
    @State var showTextRecognition = false
    
    @State var showAlert = false
    @State var errorMsg = ""
    //图片选择源,相机或者相册
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    // 选中的图片
    @State var selImage: UIImage?
    var body: some View {
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 12) {
                    //名字
                    TextField(placeList[0], text: $name)
                        .font(Font.system(size: 16)) //字体
                        .foregroundColor(.black) // 文字颜色
                        .padding(EdgeInsets(top: 18, leading: 10, bottom: 18, trailing: 10))//边距
                        .background(Color.RGBA(208,208,208))// 背景颜色
                        .cornerRadius(4) //圆角
                    //种类
                    TextField(placeList[1], text: $kind).font(Font.system(size: 16)).foregroundColor(.black).padding(EdgeInsets(top: 18, leading: 10, bottom: 18, trailing: 10)).background(Color.RGBA(208,208,208)).cornerRadius(4)
                    //数量
                    TextField(placeList[2], text: $count).font(Font.system(size: 16)).foregroundColor(.black).padding(EdgeInsets(top: 18, leading: 10, bottom: 18, trailing: 10)).background(Color.RGBA(208,208,208)).cornerRadius(4)
                    //过期时间选择器
                    DatePicker(selection: $deadline, displayedComponents: DatePickerComponents.date) {
                        HStack {
                            //左边的文本
                            Text(placeList[3]).font(Font.system(size: 15)).foregroundColor(.black).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 5))
                                .background(Color.RGBA(208,208,208)).cornerRadius(4)
                            Spacer()
                        }
                        
                        
                    }
                    //生产时间选择器
                    DatePicker(selection: $produceTime, displayedComponents: DatePickerComponents.date) {
                        HStack {
                            Text(placeList[4]).font(Font.system(size: 15)).foregroundColor(.black).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 5)).background(Color.RGBA(208,208,208)).cornerRadius(4)
                            Spacer()
                        }
                        
                    }.datePickerStyle(.automatic)
                    
                    
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))//边距
                .cornerRadius(8)//圆角半径
                .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color.RGBA(96, 81,81), lineWidth: 2)//边框
                )
                Spacer().frame(height: 15)
                HStack(spacing: 10) {
                    //选择的图片存在,
                    if selImage != nil {
                        Image(uiImage: selImage!).resizable()
                            .frame(width: 90, height: 110).padding(0)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous)//圆角
                                .stroke(Color.RGBA(96,81,81,0.5), lineWidth: 2))
                            .allowsHitTesting(true)// 允许交互
                            .onTapGesture {
                                showSheet.toggle()// 点击图片 showSheet取反
                            }
                    } else {
                        // 选择的图片不存在, 用个占位图片
                        Image("placeholder").resizable()
                            .frame(width: 30, height: 30).padding(EdgeInsets(top: 40, leading: 30, bottom: 40, trailing: 30))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color.RGBA(96,81,81,0.5), lineWidth: 2))
                            .allowsHitTesting(true)// 允许交互
                            .onTapGesture {
                                showSheet.toggle()//点击图片 showSheet取反
                            }
                    }
                    
                    //"メモー"
                    ZStack {
                        // 备注文本输入框
                        TextEditor(text: $remark)
                            .font(Font.system(size: 16)).frame(height: 100)
                            .foregroundColor(.black)
                            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .cornerRadius(4)
                            .overlay(RoundedRectangle(cornerRadius: 4, style: .continuous).stroke(Color.RGBA(96,81,81,0.5), lineWidth: 2))
                            .onChange(of: remark) { value in
                                print(value)
                            }
                        //
                        if remark.isEmpty {
                            // 这个当做占位文字 placeholder
                            Text("メモー")
                                .font(Font.system(size: 16))
                                .foregroundColor(Color(UIColor.placeholderText))
                                .position(x: 38, y: 23)
                            
                            
                        }
                    }
                    
                    
                }
                Spacer()
                
            }.frame(width: kscreenW - 90).frame(maxHeight: .infinity)
            HStack {
                //编辑的情况下, 展示关闭按钮
                if !isAdd {
                    Button {
                        // 点击关闭,取消页面
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        //
                        Image("lastClose").resizable().frame(width: 50, height: 50)
                    }.padding(.leading, 40)
                        .cornerRadius(25)
                }
                
                Spacer()
                Button {
                    //点击按钮,执行保存动作
                    self.didTapAddAction()
                } label: {
                    //追加":"編集完了 按钮
                    Text(isAdd ? "追加":"編集完了").foregroundColor(.black).fontWeight(.bold).font(Font.system(size: 20))
                }.frame(height: 50)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                    .background(Color.RGBA(208,208,208))
                    .cornerRadius(6)
                Spacer().frame(width: 30)
            }
            
            Spacer().frame(height: 20)
        }//.frame(height: kscreenH)
        //选择相册或者相机弹出框
        .actionSheet(isPresented: $showSheet, content: {
            ActionSheet(title: Text("写真を選択してください"), buttons:
                            [ActionSheet.Button.default(Text("写真"), action: {
                self.sourceType = .photoLibrary
                self.showImagePicker = true
            }),ActionSheet.Button.default(Text("カメラ"), action: {
                self.sourceType = .camera
                self.showImagePicker = true
            }),ActionSheet.Button.destructive(Text("キャンセル"))])
        })
        // 显示图库或者相机页面
        .sheet(isPresented: $showImagePicker, onDismiss: {
            self.showTextRecognition = (selImage != nil)
        }, content: {
            ImagePickerView(sourceType: self.sourceType, selImage: $selImage)
        })
        // 导航显示图片识别页面
        .navigationDestination(isPresented: $showTextRecognition, destination: {
            TextRecognitionView(selImage: self.selImage ?? UIImage() , name: $name)
        })
        //显示错误弹窗
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text(errorMsg))
        })
        
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: Button(action: {
            //返回按钮
            presentationMode.wrappedValue.dismiss() //返回上级页面
        }, label: {
            Image("return").resizable().frame(width: 25, height: 20)
        }))
        
        .onAppear {
            // 编辑情况下,给页面赋值
            if let item = item ,
               self.name.isEmpty{
                self.name = item.name ?? ""
                self.kind = item.kind ?? ""
                self.count = String(item.count)
                self.deadline = item.deadline ?? Date()
                self.produceTime = item.produceTime ?? Date()
                self.remark = item.remark ?? ""
                
                let imgName = item.imgName ?? ""
                let fullPath = "\(imageFilePath)/\(imgName)"
                
                let data = NSData(contentsOfFile: fullPath) as? Data
                if let data = data {
                    self.selImage = UIImage(data: data) ?? UIImage(named: "placeholder")!
                }
                
            }
        }
    }
    //点击保存
    func didTapAddAction() {
        //判断输入框有数据
        if name.isEmpty || kind.isEmpty || count.isEmpty {
            errorMsg = "データを入力してください！！"
            showAlert.toggle()
            return
        }
        guard let num = Int(count), num > 0  else {
            errorMsg = "データを入力してください！！"
            showAlert.toggle()
            return
        }
        guard let selImage = selImage else {
            errorMsg = "データを入力してください！！"
            showAlert.toggle()
            return
        }
        //图片压缩
        let imageData = selImage.jpegData(compressionQuality: 0.4)! as NSData
        //生成一个随机图片名字
        let imgName = UUID().uuidString + ".png"
        //图片保存的全路径
        let fullPath = "\(imageFilePath)/\(imgName)"
        //将图片按照全路径,写入沙盒
        imageData.write(toFile: fullPath, atomically: true)
        //从详情进来,编辑
        if !isAdd,
           let item = self.item {
            item.name = name
            item.kind = kind
            item.count = Int64(num)
            item.deadline = deadline
            item.produceTime = produceTime
            item.remark = remark
            item.imgName = imgName
            do {
                try viewContext.save()
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                errorMsg = error.localizedDescription
                showAlert.toggle()
            }
            return
        }
        print(fullPath)
        //从列表进来新增
        withAnimation {
            let newItem = GoodsItem(context: viewContext)
            newItem.name = name
            newItem.kind = kind
            newItem.count = Int64(num)
            newItem.deadline = deadline
            newItem.produceTime = produceTime
            newItem.remark = remark
            newItem.imgName = imgName
            do {
                try viewContext.save()
                //取消页面
                self.presentationMode.wrappedValue.dismiss()
            } catch {
                //显示错误
                errorMsg = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView(isAdd: true, item: nil)
        }
        
        
    }
}

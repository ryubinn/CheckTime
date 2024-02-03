//
//  DetailsView.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/10.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext)  var viewContext
    var item: GoodsItem
    @State var image = UIImage()
    var body: some View {
        GeometryReader { proxy in
            
                HStack(spacing: 0){
                    // 左边部分内容
                    VStack(alignment: .center, spacing: 10) {
                        Spacer().frame(height: proxy.safeAreaInsets.top)
                        Button {
                            
                        } label: {
                            Image("Home_Top").resizable().frame(width: 25, height: 25, alignment: .center)
                        }.padding(.top, -20)
                        //分割线
                        Text("|\n|\n|\n|\n|\n|\n|\n|")
                            .font(Font.system(size: 17))
                            .fontWeight(.medium)
                            .foregroundColor(Color.RGBA(140,130,130))
                            .padding(.top, 30)
                        // 生产日期
                        Text("\(item.produceTime ?? Date(), formatter: itemFormatter)")
                            .font(Font.system(size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .padding(.top, 40)
                            .padding(.bottom, 40)
                        //分割线
                        Text("|\n|\n|\n|\n|\n|\n|\n|")
                            .font(Font.system(size: 17))
                            .fontWeight(.medium)
                            .foregroundColor(Color.RGBA(140,130,130))
                        
                        Spacer()
                    }.frame(width: 90, height: kscreenH)
                        .background(Color.RGBA(96,81,81))
                    //右半部分
                    VStack(alignment: .center, spacing: 0) {
                        Spacer().frame(height: 130)
                        VStack(alignment: .leading) {
                            HStack {
                                //名字
                                Text(item.name ?? "")
                                    .padding(.leading, 10)
                                    .font(Font.system(size: 18, weight: .medium))
                                Spacer()
                                //退出按钮
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image("close").resizable().frame(width: 40, height: 40)
                                }.padding(.trailing, 10)

                            }.frame( height: 60)
                            HStack {
                                Spacer().frame(height: 2).background(Color.RGBA(96,81,81))
                            }
                            //图片
                            Image(uiImage: image).resizable().frame(width: 120, height: 120).padding(.leading, 20)
                            //过期日期
                            Text("\(item.deadline ?? Date(), formatter: itemFormatter)")
                                .font(Font.system(size: 18, weight: .medium))
                                .padding(EdgeInsets(top: 7, leading: 30, bottom: 0, trailing: 10))
                                //备注
                            Text(item.remark ?? "")
                                .font(Font.system(size: 18, weight: .medium))
                                .padding(EdgeInsets(top: 27, leading: 30, bottom: 20, trailing: 10))
                            Spacer()
                            
                        }.frame(height: 450).cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous)//圆角
                                .stroke(Color.RGBA(96,81,81), lineWidth: 2))
                            .padding(EdgeInsets(top: 7, leading: 10, bottom: 7, trailing: 10))
                        HStack {
                            //["確定","編集","削除"]
                            
                            DetailsButtonView(imageName: "確定")
                                .padding(.leading, 50)
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            Spacer()
                            NavigationLink(destination: AddView(isAdd: false, item: item)) {
                                DetailsButtonView(imageName: "編集")
                            }
                            
                            Spacer()
                            DetailsButtonView(imageName: "削除")
                                .padding(.trailing, 50)
                                .onTapGesture {
                                    deleteItem()
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }.padding(.top, 10)
                        
                        Spacer()
                    }.frame(width:kscreenW - 90, height: kscreenH)
                        .background(Color.white)
                    
                    
                }.edgesIgnoringSafeArea(.top)
                .navigationBarHidden(true)
                .onAppear {
                    // 设置图片
                    let imgName = item.imgName ?? ""
                    let fullPath = "\(imageFilePath)/\(imgName)"
                    
                    let data = NSData(contentsOfFile: fullPath) as? Data
                    if let data = data {
                        self.image = UIImage(data: data) ?? UIImage(named: "placeholder")!
                    }
                    
                    print(fullPath)
                }
        }
    }
    
    //删除
    private func deleteItem() {
        withAnimation {
            //删除内存中数据
            viewContext.delete(item)
            //同步到沙盒
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailsView(item: GoodsItem( context: PersistenceController.shared.container.viewContext))
        }
    }
}

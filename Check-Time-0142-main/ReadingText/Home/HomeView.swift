//
//  HomeView.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/01.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GoodsItem.creatTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<GoodsItem>
    var body: some View {
        GeometryReader { proxy in
            
            NavigationStack {
                ZStack {
                    // 页面左边和右边背景
                    HStack(spacing: 0){
                        Spacer().frame(width: 90, height: kscreenH, alignment: .leading).background(Color.RGBA(96,81,81))
                        
                        Spacer().frame(width: kscreenW - 90, height: kscreenH, alignment: .leading).background(Color.white)
                    }
                    
                    VStack(alignment: .center, spacing: 0) {
                        Spacer().frame(height: proxy.safeAreaInsets.top)
                        HStack {
                            // 顶部菜单和全部图片
                            Button {
                                print("menu")
                                
                            } label: {
                                Image("Home_Top").resizable().frame(width: 25, height: 25, alignment: .center)
                            }.padding(EdgeInsets(top: 0, leading: 32.5, bottom: 0, trailing: 32.5))
                            
                            Button {
                            } label: {
                                Image("All").resizable().frame(width: 25, height: 25, alignment: .center)
                            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                            Text("全部").font(Font.system(size: 20)).padding(0)
                            Spacer()
                        }
                        .frame(height: 44)
                        .background(Color.clear)
                        // 有数据创建List显示,没数据不展示List
                        if items.count > 0 {
                            List {
                                ForEach(0..<items.count,id: \.self) { index in
                                    ZStack {
                                        HomeRowView(item:items[index]).frame(width: kscreenW)
                                        NavigationLink {
                                            DetailsView(item: items[index])
                                        } label: {
                                            EmptyView()
                                        }
                                    }
                                    
                                    // 设置每一行row背景 透明
                                }.listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets())//设置内容不自动偏移
                                    .listRowSeparator(.hidden)// 隐藏分割线
                                
                            }.listStyle(.plain)
                                .scrollContentBackground(.hidden)// list背景透明
                                .background(Color.clear)// list背景透明
                        } else {
                            Spacer().background(Color.red)
                        }
                        
                    }
                    //底部添加按钮
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer().background(Color.clear)
                        NavigationLink {
                            //点击按钮的目标页面
                            AddView(isAdd: true,item: nil)
                        } label: {
                            HStack {
                                Spacer().frame(width: 120)
                                Image("add").resizable().allowsHitTesting(true).frame(width: 60, height: 60, alignment: .center)
                            }
                        }
                        //底部空出一段距离
                        Spacer().frame(height: proxy.safeAreaInsets.bottom+30)
                    }.frame(width: kscreenW, alignment: .leading).background(Color.clear)
                    
                    
                    
                }.frame(width: kscreenW, height: kscreenH)
                
                
                
            }
            .onAppear {
                //页面展示时创建通知 每周三早上九点定时通知
                NotificationManager.share.setUsernotification()
                let array =  Locale.availableIdentifiers
                for i in 0..<array.count {
                    print(array[i])
                }
            }
            
        }
    }
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



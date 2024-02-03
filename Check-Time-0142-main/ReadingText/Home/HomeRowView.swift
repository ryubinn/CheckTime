//
//  HomeRowView.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/02.
//

import SwiftUI

struct HomeRowView: View {
    var item: GoodsItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            //时间
            Text("\(item.produceTime!, formatter: itemFormatter)").foregroundColor(.white).frame(width: 90)
            
            HStack(){
                VStack(alignment: .leading, spacing: 5) {
                    //名字
                    Text(item.name ?? "").foregroundColor(.black)
                    // 备注
                    Text(item.remark ?? "").foregroundColor(.black).padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)).background((item.remark ?? "").isEmpty ? Color.clear : Color.RGBA(208,208,208))
                    
                }.padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
                Spacer()
            }.cornerRadius(5)
            // 设置黑色圆角边框
                .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color.black, lineWidth: 1))
                .padding(EdgeInsets(top: 7, leading: 10, bottom: 7, trailing: 10))
            
            
        }
    }
}

struct HomeRowView_Previews: PreviewProvider {
    static var previews: some View {
        HomeRowView(item: GoodsItem( context: PersistenceController.shared.container.viewContext)).background(Color.RGBA(96,81,81))
    }
}

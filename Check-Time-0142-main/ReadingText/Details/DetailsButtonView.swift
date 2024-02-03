//
//  DetailsButtonView.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/12.
//

import SwiftUI

struct DetailsButtonView: View {
    //["確定","編集","削除"]
    var imageName = "確定"
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30, alignment: .center)
            Text(imageName)
                .foregroundColor(Color.RGBA(96,81,81))
                .font(Font.system(size: 16))
        }
    }
}

struct DetailsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsButtonView()
    }
}

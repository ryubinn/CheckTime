//
//  Constant.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/03.
//

import Foundation
import SwiftUI

let kscreenW = UIScreen.main.bounds.width
let kscreenH = UIScreen.main.bounds.height
//图片储存文件夹
let imageFilePath : String =  NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).last!


extension Color {
    static func RGBA(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat = 1.0) -> Color{
        return Color(red: r/255.0, green: g/255.0, blue: b/255.0, opacity: a)
    }
    
    static func RGBWithHex(_ rgba: UInt32,_ a:CGFloat = 1.0) -> Color{
        return Color(red: CGFloat(Int(rgba >> 16) & 0xFF)/255.0,
                     green: CGFloat(Int(rgba >> 8) & 0xFF)/255.0,
                     blue: CGFloat(rgba & 0xFF)/255.0,
                     opacity: a)
    }
}

//日期格式 11-22 2022
public let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    //formatter.dateStyle = .medium
    formatter.dateFormat = "MM-dd\nyyyy"
    //formatter.formatter.timeStyle = .none
    return formatter
}()

//改变图片方向
func normalizedimage(image:UIImage) -> UIImage {
    if image.imageOrientation == UIImage.Orientation.up {
        return image
    }else{
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: image.size))
        let normalizedimage = UIGraphicsGetImageFromCurrentImageContext()
        return normalizedimage!
    }
}

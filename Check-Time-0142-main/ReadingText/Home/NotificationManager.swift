//
//  NotificationManager.swift
//  ReadingText
//
//  Created by 柳冰 on 2023/2/25.
//

import SwiftUI

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate{
    static let share = NotificationManager()
    override init() {
        super.init()
        // 请求通知权限
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { status, error in
            if  !status {
                print("通知同意されていない")
            } else {
                print("通知同意されている")
            }
        }
        UNUserNotificationCenter.current().delegate  = self
    }
    //每周三早上九点定时通知
    func setUsernotification()  {
        //通知内容
        let content = UNMutableNotificationContent()
        content.title = "Check Time"
        content.body = "賞味期限商品チェックしよう！！"
        content.badge = 1
        //通知策略
        let dateComponent = DateComponents(hour: 9, weekday: 3)//时间设定
        let triger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        //UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        //通知请求
        let request = UNNotificationRequest(identifier: "myid000020321312", content: content, trigger: triger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("追加不成功", error.localizedDescription)
            } else {
                print("追加成功")
            }
        }
    }
    
    //通知代理, 允许通知弹窗 (必须实现该代理,否则通知收不到)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.list,.banner,.sound,.badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
}

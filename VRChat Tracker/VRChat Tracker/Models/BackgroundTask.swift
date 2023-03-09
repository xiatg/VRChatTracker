//
//  BackgroundTask.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/24/23.
//

import Foundation
import UserNotifications
import BackgroundTasks

/**
 Request registrater access
 */
func registerNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in }
}

/**
 Schedule friends status background fetch
 */
func scheduleFetchFriendStatus() {
    let request = BGAppRefreshTaskRequest(identifier: "fetchFriendStatus")
    try? BGTaskScheduler.shared.submit(request)
}

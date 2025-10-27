//
//  NotificationError.swift
//  Hello
//
//  Created by Afnan hassan on 04/05/1447 AH.
//

import Combine
import UserNotifications
import SwiftUI

enum NotificationError: Error { case denied }

final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    private init() {}

    @discardableResult
    func requestAuthorization() async throws -> Bool {
        let granted = try await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
        if !granted { throw NotificationError.denied }
        return granted
    }

    // Schedules a daily repeating reminder for the given plant.
    // You can later adapt this to your chosen cadence model.
    func scheduleWaterReminder(for plant: Plant) async {
        await removeNotification(id: plant.id.uuidString)

        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body  = "Hey! let's water \(plant.name)"
        content.sound = .default

        // Repeat every 24 hours (must be >= 60 seconds to repeat)
        let seconds: TimeInterval = 86_400
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: true)

        let req = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: content,
            trigger: trigger
        )

        do {
            try await UNUserNotificationCenter.current().add(req)
        } catch {
#if DEBUG
            print("Notif error:", error)
#endif
        }
    }

    func removeNotification(id: String) async {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current()
            .removeDeliveredNotifications(withIdentifiers: [id])
    }
}

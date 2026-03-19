import CoreLocation
import Foundation
import KlawtyKit
import UIKit

typealias KlawtyCameraSnapResult = (format: String, base64: String, width: Int, height: Int)
typealias KlawtyCameraClipResult = (format: String, base64: String, durationMs: Int, hasAudio: Bool)

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: KlawtyCameraSnapParams) async throws -> KlawtyCameraSnapResult
    func clip(params: KlawtyCameraClipParams) async throws -> KlawtyCameraClipResult
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: KlawtyLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: KlawtyLocationGetParams,
        desiredAccuracy: KlawtyLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: KlawtyLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

@MainActor
protocol DeviceStatusServicing: Sendable {
    func status() async throws -> KlawtyDeviceStatusPayload
    func info() -> KlawtyDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: KlawtyPhotosLatestParams) async throws -> KlawtyPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: KlawtyContactsSearchParams) async throws -> KlawtyContactsSearchPayload
    func add(params: KlawtyContactsAddParams) async throws -> KlawtyContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: KlawtyCalendarEventsParams) async throws -> KlawtyCalendarEventsPayload
    func add(params: KlawtyCalendarAddParams) async throws -> KlawtyCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: KlawtyRemindersListParams) async throws -> KlawtyRemindersListPayload
    func add(params: KlawtyRemindersAddParams) async throws -> KlawtyRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: KlawtyMotionActivityParams) async throws -> KlawtyMotionActivityPayload
    func pedometer(params: KlawtyPedometerParams) async throws -> KlawtyPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: KlawtyWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}

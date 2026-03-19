import Foundation

public enum KlawtyDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum KlawtyBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum KlawtyThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum KlawtyNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum KlawtyNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct KlawtyBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: KlawtyBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: KlawtyBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct KlawtyThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: KlawtyThermalState

    public init(state: KlawtyThermalState) {
        self.state = state
    }
}

public struct KlawtyStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct KlawtyNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: KlawtyNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [KlawtyNetworkInterfaceType]

    public init(
        status: KlawtyNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [KlawtyNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct KlawtyDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: KlawtyBatteryStatusPayload
    public var thermal: KlawtyThermalStatusPayload
    public var storage: KlawtyStorageStatusPayload
    public var network: KlawtyNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: KlawtyBatteryStatusPayload,
        thermal: KlawtyThermalStatusPayload,
        storage: KlawtyStorageStatusPayload,
        network: KlawtyNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct KlawtyDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}

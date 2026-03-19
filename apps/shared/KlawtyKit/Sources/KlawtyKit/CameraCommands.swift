import Foundation

public enum KlawtyCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum KlawtyCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum KlawtyCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum KlawtyCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct KlawtyCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: KlawtyCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: KlawtyCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: KlawtyCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: KlawtyCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct KlawtyCameraClipParams: Codable, Sendable, Equatable {
    public var facing: KlawtyCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: KlawtyCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: KlawtyCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: KlawtyCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}

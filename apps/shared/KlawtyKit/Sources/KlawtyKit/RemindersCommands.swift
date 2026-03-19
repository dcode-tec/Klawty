import Foundation

public enum KlawtyRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum KlawtyReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct KlawtyRemindersListParams: Codable, Sendable, Equatable {
    public var status: KlawtyReminderStatusFilter?
    public var limit: Int?

    public init(status: KlawtyReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct KlawtyRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct KlawtyReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct KlawtyRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [KlawtyReminderPayload]

    public init(reminders: [KlawtyReminderPayload]) {
        self.reminders = reminders
    }
}

public struct KlawtyRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: KlawtyReminderPayload

    public init(reminder: KlawtyReminderPayload) {
        self.reminder = reminder
    }
}

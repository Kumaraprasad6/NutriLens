import Foundation

protocol CloudSyncService {
    func sync() async throws
    func isSyncEnabled() -> Bool
    func setSyncEnabled(_ enabled: Bool)
    var syncStatus: SyncStatus { get }
}

enum SyncStatus: Equatable {
    case idle
    case syncing
    case synced(Date)
    case error(String)
    case offline
}

final class CloudSyncServiceImpl: CloudSyncService {
    private(set) var syncStatus: SyncStatus = .idle
    private var isEnabled: Bool = false

    func sync() async throws {
        guard isEnabled else { return }
        guard syncStatus != .offline else {
            throw CloudSyncError.offline
        }

        syncStatus = .syncing

        try await Task.sleep(nanoseconds: 2_000_000_000)

        syncStatus = .synced(Date())
    }

    func isSyncEnabled() -> Bool {
        isEnabled
    }

    func setSyncEnabled(_ enabled: Bool) {
        isEnabled = enabled
    }
}

enum CloudSyncError: Error, LocalizedError {
    case offline
    case authenticationRequired
    case quotaExceeded
    case networkError

    var errorDescription: String? {
        switch self {
        case .offline:
            return "No network connection available"
        case .authenticationRequired:
            return "Please sign in to iCloud"
        case .quotaExceeded:
            return "iCloud storage quota exceeded"
        case .networkError:
            return "Network error during sync"
        }
    }
}
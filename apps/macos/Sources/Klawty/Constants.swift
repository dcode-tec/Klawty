import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-klawty writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.klawty.mac"
let gatewayLaunchdLabel = "ai.klawty.gateway"
let onboardingVersionKey = "klawty.onboardingVersion"
let onboardingSeenKey = "klawty.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "klawty.pauseEnabled"
let iconAnimationsEnabledKey = "klawty.iconAnimationsEnabled"
let swabbleEnabledKey = "klawty.swabbleEnabled"
let swabbleTriggersKey = "klawty.swabbleTriggers"
let voiceWakeTriggerChimeKey = "klawty.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "klawty.voiceWakeSendChime"
let showDockIconKey = "klawty.showDockIcon"
let defaultVoiceWakeTriggers = ["klawty"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "klawty.voiceWakeMicID"
let voiceWakeMicNameKey = "klawty.voiceWakeMicName"
let voiceWakeLocaleKey = "klawty.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "klawty.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "klawty.voicePushToTalkEnabled"
let talkEnabledKey = "klawty.talkEnabled"
let iconOverrideKey = "klawty.iconOverride"
let connectionModeKey = "klawty.connectionMode"
let remoteTargetKey = "klawty.remoteTarget"
let remoteIdentityKey = "klawty.remoteIdentity"
let remoteProjectRootKey = "klawty.remoteProjectRoot"
let remoteCliPathKey = "klawty.remoteCliPath"
let canvasEnabledKey = "klawty.canvasEnabled"
let cameraEnabledKey = "klawty.cameraEnabled"
let systemRunPolicyKey = "klawty.systemRunPolicy"
let systemRunAllowlistKey = "klawty.systemRunAllowlist"
let systemRunEnabledKey = "klawty.systemRunEnabled"
let locationModeKey = "klawty.locationMode"
let locationPreciseKey = "klawty.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "klawty.peekabooBridgeEnabled"
let deepLinkKeyKey = "klawty.deepLinkKey"
let modelCatalogPathKey = "klawty.modelCatalogPath"
let modelCatalogReloadKey = "klawty.modelCatalogReload"
let cliInstallPromptedVersionKey = "klawty.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "klawty.heartbeatsEnabled"
let debugPaneEnabledKey = "klawty.debugPaneEnabled"
let debugFileLogEnabledKey = "klawty.debug.fileLogEnabled"
let appLogLevelKey = "klawty.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26

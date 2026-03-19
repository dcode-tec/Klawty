package ai.klawty.app.node

import ai.klawty.app.protocol.KlawtyCalendarCommand
import ai.klawty.app.protocol.KlawtyCanvasA2UICommand
import ai.klawty.app.protocol.KlawtyCanvasCommand
import ai.klawty.app.protocol.KlawtyCameraCommand
import ai.klawty.app.protocol.KlawtyCapability
import ai.klawty.app.protocol.KlawtyCallLogCommand
import ai.klawty.app.protocol.KlawtyContactsCommand
import ai.klawty.app.protocol.KlawtyDeviceCommand
import ai.klawty.app.protocol.KlawtyLocationCommand
import ai.klawty.app.protocol.KlawtyMotionCommand
import ai.klawty.app.protocol.KlawtyNotificationsCommand
import ai.klawty.app.protocol.KlawtyPhotosCommand
import ai.klawty.app.protocol.KlawtySmsCommand
import ai.klawty.app.protocol.KlawtySystemCommand

data class NodeRuntimeFlags(
  val cameraEnabled: Boolean,
  val locationEnabled: Boolean,
  val sendSmsAvailable: Boolean,
  val readSmsAvailable: Boolean,
  val voiceWakeEnabled: Boolean,
  val motionActivityAvailable: Boolean,
  val motionPedometerAvailable: Boolean,
  val debugBuild: Boolean,
)

enum class InvokeCommandAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SendSmsAvailable,
  ReadSmsAvailable,
  MotionActivityAvailable,
  MotionPedometerAvailable,
  DebugBuild,
}

enum class NodeCapabilityAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  VoiceWakeEnabled,
  MotionAvailable,
}

data class NodeCapabilitySpec(
  val name: String,
  val availability: NodeCapabilityAvailability = NodeCapabilityAvailability.Always,
)

data class InvokeCommandSpec(
  val name: String,
  val requiresForeground: Boolean = false,
  val availability: InvokeCommandAvailability = InvokeCommandAvailability.Always,
)

object InvokeCommandRegistry {
  val capabilityManifest: List<NodeCapabilitySpec> =
    listOf(
      NodeCapabilitySpec(name = KlawtyCapability.Canvas.rawValue),
      NodeCapabilitySpec(name = KlawtyCapability.Device.rawValue),
      NodeCapabilitySpec(name = KlawtyCapability.Notifications.rawValue),
      NodeCapabilitySpec(name = KlawtyCapability.System.rawValue),
      NodeCapabilitySpec(
        name = KlawtyCapability.Camera.rawValue,
        availability = NodeCapabilityAvailability.CameraEnabled,
      ),
      NodeCapabilitySpec(
        name = KlawtyCapability.Sms.rawValue,
        availability = NodeCapabilityAvailability.SmsAvailable,
      ),
      NodeCapabilitySpec(
        name = KlawtyCapability.VoiceWake.rawValue,
        availability = NodeCapabilityAvailability.VoiceWakeEnabled,
      ),
      NodeCapabilitySpec(
        name = KlawtyCapability.Location.rawValue,
        availability = NodeCapabilityAvailability.LocationEnabled,
      ),
      NodeCapabilitySpec(name = KlawtyCapability.Photos.rawValue),
      NodeCapabilitySpec(name = KlawtyCapability.Contacts.rawValue),
      NodeCapabilitySpec(name = KlawtyCapability.Calendar.rawValue),
      NodeCapabilitySpec(
        name = KlawtyCapability.Motion.rawValue,
        availability = NodeCapabilityAvailability.MotionAvailable,
      ),
      NodeCapabilitySpec(name = KlawtyCapability.CallLog.rawValue),
    )

  val all: List<InvokeCommandSpec> =
    listOf(
      InvokeCommandSpec(
        name = KlawtyCanvasCommand.Present.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = KlawtyCanvasCommand.Hide.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = KlawtyCanvasCommand.Navigate.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = KlawtyCanvasCommand.Eval.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = KlawtyCanvasCommand.Snapshot.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = KlawtyCanvasA2UICommand.Push.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = KlawtyCanvasA2UICommand.PushJSONL.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = KlawtyCanvasA2UICommand.Reset.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = KlawtySystemCommand.Notify.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyCameraCommand.List.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = KlawtyCameraCommand.Snap.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = KlawtyCameraCommand.Clip.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = KlawtyLocationCommand.Get.rawValue,
        availability = InvokeCommandAvailability.LocationEnabled,
      ),
      InvokeCommandSpec(
        name = KlawtyDeviceCommand.Status.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyDeviceCommand.Info.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyDeviceCommand.Permissions.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyDeviceCommand.Health.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyNotificationsCommand.List.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyNotificationsCommand.Actions.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyPhotosCommand.Latest.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyContactsCommand.Search.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyContactsCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyCalendarCommand.Events.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyCalendarCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = KlawtyMotionCommand.Activity.rawValue,
        availability = InvokeCommandAvailability.MotionActivityAvailable,
      ),
      InvokeCommandSpec(
        name = KlawtyMotionCommand.Pedometer.rawValue,
        availability = InvokeCommandAvailability.MotionPedometerAvailable,
      ),
      InvokeCommandSpec(
        name = KlawtySmsCommand.Send.rawValue,
        availability = InvokeCommandAvailability.SendSmsAvailable,
      ),
      InvokeCommandSpec(
        name = KlawtySmsCommand.Search.rawValue,
        availability = InvokeCommandAvailability.ReadSmsAvailable,
      ),
      InvokeCommandSpec(
        name = KlawtyCallLogCommand.Search.rawValue,
      ),
      InvokeCommandSpec(
        name = "debug.logs",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(
        name = "debug.ed25519",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
    )

  private val byNameInternal: Map<String, InvokeCommandSpec> = all.associateBy { it.name }

  fun find(command: String): InvokeCommandSpec? = byNameInternal[command]

  fun advertisedCapabilities(flags: NodeRuntimeFlags): List<String> {
    return capabilityManifest
      .filter { spec ->
        when (spec.availability) {
          NodeCapabilityAvailability.Always -> true
          NodeCapabilityAvailability.CameraEnabled -> flags.cameraEnabled
          NodeCapabilityAvailability.LocationEnabled -> flags.locationEnabled
          NodeCapabilityAvailability.SmsAvailable -> flags.sendSmsAvailable || flags.readSmsAvailable
          NodeCapabilityAvailability.VoiceWakeEnabled -> flags.voiceWakeEnabled
          NodeCapabilityAvailability.MotionAvailable -> flags.motionActivityAvailable || flags.motionPedometerAvailable
        }
      }
      .map { it.name }
  }

  fun advertisedCommands(flags: NodeRuntimeFlags): List<String> {
    return all
      .filter { spec ->
        when (spec.availability) {
          InvokeCommandAvailability.Always -> true
          InvokeCommandAvailability.CameraEnabled -> flags.cameraEnabled
          InvokeCommandAvailability.LocationEnabled -> flags.locationEnabled
          InvokeCommandAvailability.SendSmsAvailable -> flags.sendSmsAvailable
          InvokeCommandAvailability.ReadSmsAvailable -> flags.readSmsAvailable
          InvokeCommandAvailability.MotionActivityAvailable -> flags.motionActivityAvailable
          InvokeCommandAvailability.MotionPedometerAvailable -> flags.motionPedometerAvailable
          InvokeCommandAvailability.DebugBuild -> flags.debugBuild
        }
      }
      .map { it.name }
  }
}

package ai.klawty.app.node

import ai.klawty.app.protocol.KlawtyCalendarCommand
import ai.klawty.app.protocol.KlawtyCameraCommand
import ai.klawty.app.protocol.KlawtyCallLogCommand
import ai.klawty.app.protocol.KlawtyCapability
import ai.klawty.app.protocol.KlawtyContactsCommand
import ai.klawty.app.protocol.KlawtyDeviceCommand
import ai.klawty.app.protocol.KlawtyLocationCommand
import ai.klawty.app.protocol.KlawtyMotionCommand
import ai.klawty.app.protocol.KlawtyNotificationsCommand
import ai.klawty.app.protocol.KlawtyPhotosCommand
import ai.klawty.app.protocol.KlawtySmsCommand
import ai.klawty.app.protocol.KlawtySystemCommand
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class InvokeCommandRegistryTest {
  private val coreCapabilities =
    setOf(
      KlawtyCapability.Canvas.rawValue,
      KlawtyCapability.Device.rawValue,
      KlawtyCapability.Notifications.rawValue,
      KlawtyCapability.System.rawValue,
      KlawtyCapability.Photos.rawValue,
      KlawtyCapability.Contacts.rawValue,
      KlawtyCapability.Calendar.rawValue,
      KlawtyCapability.CallLog.rawValue,
    )

  private val optionalCapabilities =
    setOf(
      KlawtyCapability.Camera.rawValue,
      KlawtyCapability.Location.rawValue,
      KlawtyCapability.Sms.rawValue,
      KlawtyCapability.VoiceWake.rawValue,
      KlawtyCapability.Motion.rawValue,
    )

  private val coreCommands =
    setOf(
      KlawtyDeviceCommand.Status.rawValue,
      KlawtyDeviceCommand.Info.rawValue,
      KlawtyDeviceCommand.Permissions.rawValue,
      KlawtyDeviceCommand.Health.rawValue,
      KlawtyNotificationsCommand.List.rawValue,
      KlawtyNotificationsCommand.Actions.rawValue,
      KlawtySystemCommand.Notify.rawValue,
      KlawtyPhotosCommand.Latest.rawValue,
      KlawtyContactsCommand.Search.rawValue,
      KlawtyContactsCommand.Add.rawValue,
      KlawtyCalendarCommand.Events.rawValue,
      KlawtyCalendarCommand.Add.rawValue,
      KlawtyCallLogCommand.Search.rawValue,
    )

  private val optionalCommands =
    setOf(
      KlawtyCameraCommand.Snap.rawValue,
      KlawtyCameraCommand.Clip.rawValue,
      KlawtyCameraCommand.List.rawValue,
      KlawtyLocationCommand.Get.rawValue,
      KlawtyMotionCommand.Activity.rawValue,
      KlawtyMotionCommand.Pedometer.rawValue,
      KlawtySmsCommand.Send.rawValue,
      KlawtySmsCommand.Search.rawValue,
    )

  private val debugCommands = setOf("debug.logs", "debug.ed25519")

  @Test
  fun advertisedCapabilities_respectsFeatureAvailability() {
    val capabilities = InvokeCommandRegistry.advertisedCapabilities(defaultFlags())

    assertContainsAll(capabilities, coreCapabilities)
    assertMissingAll(capabilities, optionalCapabilities)
  }

  @Test
  fun advertisedCapabilities_includesFeatureCapabilitiesWhenEnabled() {
    val capabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        defaultFlags(
          cameraEnabled = true,
          locationEnabled = true,
          sendSmsAvailable = true,
          readSmsAvailable = true,
          voiceWakeEnabled = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
        ),
      )

    assertContainsAll(capabilities, coreCapabilities + optionalCapabilities)
  }

  @Test
  fun advertisedCommands_respectsFeatureAvailability() {
    val commands = InvokeCommandRegistry.advertisedCommands(defaultFlags())

    assertContainsAll(commands, coreCommands)
    assertMissingAll(commands, optionalCommands + debugCommands)
  }

  @Test
  fun advertisedCommands_includesFeatureCommandsWhenEnabled() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        defaultFlags(
          cameraEnabled = true,
          locationEnabled = true,
          sendSmsAvailable = true,
          readSmsAvailable = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
          debugBuild = true,
        ),
      )

    assertContainsAll(commands, coreCommands + optionalCommands + debugCommands)
  }

  @Test
  fun advertisedCommands_onlyIncludesSupportedMotionCommands() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          sendSmsAvailable = false,
          readSmsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = true,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertTrue(commands.contains(KlawtyMotionCommand.Activity.rawValue))
    assertFalse(commands.contains(KlawtyMotionCommand.Pedometer.rawValue))
  }

  @Test
  fun advertisedCommands_splitsSmsSendAndSearchAvailability() {
    val readOnlyCommands =
      InvokeCommandRegistry.advertisedCommands(
        defaultFlags(readSmsAvailable = true),
      )
    val sendOnlyCommands =
      InvokeCommandRegistry.advertisedCommands(
        defaultFlags(sendSmsAvailable = true),
      )

    assertTrue(readOnlyCommands.contains(KlawtySmsCommand.Search.rawValue))
    assertFalse(readOnlyCommands.contains(KlawtySmsCommand.Send.rawValue))
    assertTrue(sendOnlyCommands.contains(KlawtySmsCommand.Send.rawValue))
    assertFalse(sendOnlyCommands.contains(KlawtySmsCommand.Search.rawValue))
  }

  @Test
  fun advertisedCapabilities_includeSmsWhenEitherSmsPathIsAvailable() {
    val readOnlyCapabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        defaultFlags(readSmsAvailable = true),
      )
    val sendOnlyCapabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        defaultFlags(sendSmsAvailable = true),
      )

    assertTrue(readOnlyCapabilities.contains(KlawtyCapability.Sms.rawValue))
    assertTrue(sendOnlyCapabilities.contains(KlawtyCapability.Sms.rawValue))
  }

  private fun defaultFlags(
    cameraEnabled: Boolean = false,
    locationEnabled: Boolean = false,
    sendSmsAvailable: Boolean = false,
    readSmsAvailable: Boolean = false,
    voiceWakeEnabled: Boolean = false,
    motionActivityAvailable: Boolean = false,
    motionPedometerAvailable: Boolean = false,
    debugBuild: Boolean = false,
  ): NodeRuntimeFlags =
    NodeRuntimeFlags(
      cameraEnabled = cameraEnabled,
      locationEnabled = locationEnabled,
      sendSmsAvailable = sendSmsAvailable,
      readSmsAvailable = readSmsAvailable,
      voiceWakeEnabled = voiceWakeEnabled,
      motionActivityAvailable = motionActivityAvailable,
      motionPedometerAvailable = motionPedometerAvailable,
      debugBuild = debugBuild,
    )

  private fun assertContainsAll(actual: List<String>, expected: Set<String>) {
    expected.forEach { value -> assertTrue(actual.contains(value)) }
  }

  private fun assertMissingAll(actual: List<String>, forbidden: Set<String>) {
    forbidden.forEach { value -> assertFalse(actual.contains(value)) }
  }
}

package ai.klawty.app.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class KlawtyProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", KlawtyCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", KlawtyCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", KlawtyCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", KlawtyCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", KlawtyCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", KlawtyCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", KlawtyCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", KlawtyCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", KlawtyCapability.Canvas.rawValue)
    assertEquals("camera", KlawtyCapability.Camera.rawValue)
    assertEquals("voiceWake", KlawtyCapability.VoiceWake.rawValue)
    assertEquals("location", KlawtyCapability.Location.rawValue)
    assertEquals("sms", KlawtyCapability.Sms.rawValue)
    assertEquals("device", KlawtyCapability.Device.rawValue)
    assertEquals("notifications", KlawtyCapability.Notifications.rawValue)
    assertEquals("system", KlawtyCapability.System.rawValue)
    assertEquals("photos", KlawtyCapability.Photos.rawValue)
    assertEquals("contacts", KlawtyCapability.Contacts.rawValue)
    assertEquals("calendar", KlawtyCapability.Calendar.rawValue)
    assertEquals("motion", KlawtyCapability.Motion.rawValue)
    assertEquals("callLog", KlawtyCapability.CallLog.rawValue)
  }

  @Test
  fun cameraCommandsUseStableStrings() {
    assertEquals("camera.list", KlawtyCameraCommand.List.rawValue)
    assertEquals("camera.snap", KlawtyCameraCommand.Snap.rawValue)
    assertEquals("camera.clip", KlawtyCameraCommand.Clip.rawValue)
  }

  @Test
  fun notificationsCommandsUseStableStrings() {
    assertEquals("notifications.list", KlawtyNotificationsCommand.List.rawValue)
    assertEquals("notifications.actions", KlawtyNotificationsCommand.Actions.rawValue)
  }

  @Test
  fun deviceCommandsUseStableStrings() {
    assertEquals("device.status", KlawtyDeviceCommand.Status.rawValue)
    assertEquals("device.info", KlawtyDeviceCommand.Info.rawValue)
    assertEquals("device.permissions", KlawtyDeviceCommand.Permissions.rawValue)
    assertEquals("device.health", KlawtyDeviceCommand.Health.rawValue)
  }

  @Test
  fun systemCommandsUseStableStrings() {
    assertEquals("system.notify", KlawtySystemCommand.Notify.rawValue)
  }

  @Test
  fun photosCommandsUseStableStrings() {
    assertEquals("photos.latest", KlawtyPhotosCommand.Latest.rawValue)
  }

  @Test
  fun contactsCommandsUseStableStrings() {
    assertEquals("contacts.search", KlawtyContactsCommand.Search.rawValue)
    assertEquals("contacts.add", KlawtyContactsCommand.Add.rawValue)
  }

  @Test
  fun calendarCommandsUseStableStrings() {
    assertEquals("calendar.events", KlawtyCalendarCommand.Events.rawValue)
    assertEquals("calendar.add", KlawtyCalendarCommand.Add.rawValue)
  }

  @Test
  fun motionCommandsUseStableStrings() {
    assertEquals("motion.activity", KlawtyMotionCommand.Activity.rawValue)
    assertEquals("motion.pedometer", KlawtyMotionCommand.Pedometer.rawValue)
  }

  @Test
  fun callLogCommandsUseStableStrings() {
    assertEquals("callLog.search", KlawtyCallLogCommand.Search.rawValue)
  }

  @Test
  fun smsCommandsUseStableStrings() {
    assertEquals("sms.search", KlawtySmsCommand.Search.rawValue)
  }
}

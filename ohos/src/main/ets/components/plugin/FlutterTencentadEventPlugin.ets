import { EventChannel, FlutterPlugin, FlutterPluginBinding } from '@ohos/flutter_ohos';
import { EventSink, StreamHandler } from '@ohos/flutter_ohos/src/main/ets/plugin/common/EventChannel';
import FlutterTencentadConfig from './FlutterTencentadConfig';

export default class FlutterTencentadEventPlugin implements FlutterPlugin, StreamHandler {
  private static eventChannel: EventChannel | null = null;
  private static eventSink: EventSink | null = null;
  private static context: Context | null = null;

  onListen(args: Object, events: EventSink): void {
    FlutterTencentadEventPlugin.eventSink = events;
  }

  onCancel(args: Object): void {
    FlutterTencentadEventPlugin.eventSink = null;
  }

  getUniqueClassName(): string {
    return FlutterTencentadConfig.adevent;
  }

  static sendContent(content: Record<string, string | number>) {
    FlutterTencentadEventPlugin.eventSink?.success(content);
  }

  static sendError(errorCode: string, errorMessage: string, content: Map<string, string | number>) {
    FlutterTencentadEventPlugin.eventSink?.error(errorCode, errorMessage, content);
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    FlutterTencentadEventPlugin.eventChannel =
      new EventChannel(binding.getBinaryMessenger(), FlutterTencentadConfig.adevent);
    FlutterTencentadEventPlugin.eventChannel.setStreamHandler(this);
    FlutterTencentadEventPlugin.context = binding.getApplicationContext();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (FlutterTencentadEventPlugin.eventChannel) {
      FlutterTencentadEventPlugin.eventChannel.setStreamHandler(null);
    }
    FlutterTencentadEventPlugin.eventChannel = null;
  }
}

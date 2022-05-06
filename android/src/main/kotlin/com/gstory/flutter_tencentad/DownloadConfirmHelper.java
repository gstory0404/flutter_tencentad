package com.gstory.flutter_tencentad;

import android.app.Activity;
import android.text.TextUtils;
import android.util.Log;

import com.qq.e.comm.compliance.ApkDownloadComplianceInterface;
import com.qq.e.comm.compliance.DownloadConfirmCallBack;
import com.qq.e.comm.compliance.DownloadConfirmListener;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/*
 * created by timfeng 2021/2/2
 */
public class DownloadConfirmHelper {
  public static final String TAG = "DownloadConfirmHelper";
  public static boolean USE_CUSTOM_DIALOG = false;

  private static final String JSON_INFO_PARAMETER = "&resType=api";

  private static final String JSON_RESULT_KEY = "ret";
  private static final String JSON_DATA_KEY = "data";

  private static final String ICON_URL_KEY = "iconUrl";//App Icon
  private static final String APP_NAME_KEY = "appName";//App 名称
  private static final String VERSION_NAME_KEY = "versionName";//版本号
  private static final String AUTHOR_NAME_KEY = "authorName";//开发者
  private static final String PERMISSIONS_KEY = "permissions";//权限列表（具体权限信息，非URL）
  private static final String PRIVACY_AGREEMENT_KEY = "privacyAgreement";//隐私政策（URL）这个url需要使用外部浏览器或者webview展示
  private static final String UPDATE_TIME_KEY = "apkPublishTime";//版本更新时间
  private static final String APK_FILE_SIZE_KEY = "fileSize";//apk文件大小，bytes

  private static boolean USE_RAW_PERMISSIONS = false;
  private static JSONObject PERMISSIONS_MAP_JSON;

  public static class ApkInfo {
    public String iconUrl;
    public String appName;
    public String versionName;
    public String authorName;
    public List<String> permissions;
    public String privacyAgreementUrl;
    public long apkPublishTime;
    public long fileSize;
  }

  public static final DownloadConfirmListener DOWNLOAD_CONFIRM_LISTENER =
      new DownloadConfirmListener() {

        @Override
        public void onDownloadConfirm(Activity context, int scenes, String infoUrl,
                                      DownloadConfirmCallBack callBack) {
          Log.d(TAG, "scenes:" + scenes + " info url:" + infoUrl);

          //获取对应的json数据并自定义显示
//          DownloadApkConfirmDialog dialog = new DownloadApkConfirmDialog(context, getApkJsonInfoUrl(infoUrl), callBack);
          DownloadApkConfirmDialog dialog = new DownloadApkConfirmDialog(context, infoUrl, callBack);//使用webview显示
          if((scenes & ApkDownloadComplianceInterface.INSTALL_BITS) != 0){
            dialog.setInstallTip();
            scenes &= ~ApkDownloadComplianceInterface.INSTALL_BITS;
            Log.d(TAG, "real scenes:" + scenes );
          }
          dialog.show();
        }
      };

  public static String getApkJsonInfoUrl(String infoUrl) {
    return infoUrl + JSON_INFO_PARAMETER;
  }

  public static ApkInfo getAppInfoFromJson(String jsonStr) {
    ApkInfo result = null;

    if (TextUtils.isEmpty(jsonStr)) {
      Log.d(TAG, "请求应用信息返回值为空");
      return null;
    }
    try {
      JSONObject json = new JSONObject(jsonStr);
      int retCode = json.optInt(JSON_RESULT_KEY, -1);
      if (retCode != 0) {
        Log.d(TAG, "请求应用信息返回值错误");
        return null;
      }
      JSONObject dataJson = json.optJSONObject(JSON_DATA_KEY);
      if (dataJson == null) {
        Log.d(TAG, "请求应用信息返回值错误" + JSON_DATA_KEY);
        return null;
      }

      if (dataJson != null) {
        result = new ApkInfo();
        result.iconUrl = dataJson.optString(ICON_URL_KEY);
        result.appName = dataJson.optString(APP_NAME_KEY);
        result.versionName = dataJson.optString(VERSION_NAME_KEY);
        result.authorName = dataJson.optString(AUTHOR_NAME_KEY);
        //这里获得是原始的权限数组，android.permission.ACCESS_NETWORK_STATE这种
        JSONArray jsonPermissions = dataJson.optJSONArray(PERMISSIONS_KEY);
        if (jsonPermissions != null) {
          result.permissions = new ArrayList<>();
          for (int i = 0; i < jsonPermissions.length(); i++) {
            String rawPermission = jsonPermissions.getString(i);
            if (USE_RAW_PERMISSIONS) {
              result.permissions.add(jsonPermissions.getString(i));
              continue;
            }
            //字面权限，不会显示所有，只会显示一部分常用权限
            JSONObject permissionContent = PERMISSIONS_MAP_JSON.optJSONObject(rawPermission);
            if (permissionContent != null) {
              String permissionTitle = permissionContent.optString("title");
              if (!TextUtils.isEmpty(permissionTitle)) {
                result.permissions.add(permissionTitle);
              }
            }
          }
        }
        result.privacyAgreementUrl = dataJson.optString(PRIVACY_AGREEMENT_KEY);
        //后台返回的时间可能是秒也可能是毫秒，这里需要统一下为毫秒
        //2000年1月1日1时0分0秒对应的 秒是946688401 毫秒是 946688401000
        long publicTime = dataJson.optLong(UPDATE_TIME_KEY);
        result.apkPublishTime = publicTime > 946688401000L ? publicTime : publicTime * 1000;
        result.fileSize = dataJson.optLong(APK_FILE_SIZE_KEY);//单位是字节
      }
    } catch (JSONException e) {
      e.printStackTrace();
    }
    return result;
  }

  /**
   * 1. 权限对照表作为开发者参考使用
   * 2. level = 1，代表敏感权限，0，代表普通权限，开发者可以按需使用
   * 3. 权限未穷举部分，需要开发者自行翻译
   */

  public static final String PERMISSIONS_MAP_JSON_STR = "{\n" +
      "\"android.permission.ACCESS_CHECKIN_PROPERTIES\": {\n" +
      "\"desc\": \"允许应用对登记服务上传的属性拥有读/写权限。普通应用不应使用此权限。\",\n" +
      "\"title\": \"访问检入属性\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.ACCESS_COARSE_LOCATION\": {\n" +
      "\"desc\": \"允许该应用获取您的大致位置信息，这类位源信息来自于使用网络位置信息源(例如基站和WLAN)" +
      "的位置信息服务。您必须在设备上开启这些位置信息服务，应用才能获得位置信息。应用会使用此类服务确定您的大概位置。\",\n" +
      "\"title\": \"大致位置(基于网络)\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.ACCESS_LOCATION_EXTRA_COMMANDS\": {\n" +
      "\"desc\": \"允许应用程序访问其他的位置信息提供程序命令。此权限使该应用可以干扰GPS或其他位置信息源的运作。\",\n" +
      "\"title\": \"获取额外的位置信息提供程序命令。\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.ACCESS_NETWORK_STATE\": {\n" +
      "\"desc\": \"允许该应用查看网络连接的相关信息，例如存在和连接的网络。\",\n" +
      "\"title\": \"查看网络连接。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.ACCESS_NOTIFICATION_POLICY\": {\n" +
      "\"desc\": \"允许访问通知策略的应用程序的标记权限。\",\n" +
      "\"title\": \"访问通知策略\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.ACCESS_WIFI_STATE\": {\n" +
      "\"desc\": \"允许该应用查看WLAN网络的相关信息。例如是否启用了WLAN以及连接的WLAN设备的名称。\",\n" +
      "\"title\": \"查看WLAN连接\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.ACCOUNT_MANAGER\": {\n" +
      "\"desc\": \"允许应用使用AccountManager的帐户身份验证程序功能，包括创建帐户以及获取和设置复密码。\",\n" +
      "\"title\": \"创建帐户并设置密码\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.ACTIVITY_RECOGNITION\": {\n" +
      "\"desc\": \"允许应用程序识别身体活动。\",\n" +
      "\"title\": \"识别身体活动\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.ANSWER_PHONE_CALLS\": {\n" +
      "\"desc\": \"允许该应用接听来电。\",\n" +
      "\"title\": \"接听来电\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.BATTERY_STATS\": {\n" +
      "\"desc\": \"允许应用读取当前电量使用情况的基础数据。此权限可让应用了解关于您使用了哪些应用的详细信息。\",\n" +
      "\"title\": \"读取电池使用统计信息。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BIND_CARRIER_SERVICES\": {\n" +
      "\"desc\": \"允许应用告知系统哪些小部件可提供哪个应用使用。拥有此权限的应用可向其他应用授予对个人数据的访问权限。普通应用不应使用此权限。\",\n" +
      "\"title\": \"选择小部件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BIND_CONTROLS\": {\n" +
      "\"desc\": \"允许SystemUI请求第三方控件。\",\n" +
      "\"title\": \"请求第三方控件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BIND_QUICK_SETTINGS_TILE\": {\n" +
      "\"desc\": \"允许应用程序绑定到第三方快速设置磁贴。\",\n" +
      "\"title\": \"绑定快速设置磁贴\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BLUETOOTH\": {\n" +
      "\"desc\": \"允许该应用查看手机上的蓝牙配置，以及建立和接受与配对设备的连接。\",\n" +
      "\"title\": \"与蓝牙设备配对。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BLUETOOTH_ADMIN\": {\n" +
      "\"desc\": \"允许应用配置本地蓝牙手机，以及发现远程设备并进行配对。\",\n" +
      "\"title\": \"访问蓝牙设置。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BLUETOOTH_PRIVILEGED\": {\n" +
      "\"desc\": \"允许应用程序与蓝牙设备配对，而无需用户交互。\",\n" +
      "\"title\": \"运行应用进行蓝牙配对。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BODY_SENSORS\": {\n" +
      "\"desc\": \"允许应用访问您用于测量身体状况（如心跳速率）的传感器中的数据。\",\n" +
      "\"title\": \"人体传感器\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BROADCAST_PACKAGE_REMOVED\": {\n" +
      "\"desc\": \"允许应用程序广播已删除应用程序的通知。\",\n" +
      "\"title\": \"发送软件包被移除的广播通知。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BROADCAST_SMS\": {\n" +
      "\"desc\": \"允许应用广播一条有关已收到短信的通知。恶意应用可能借此伪造接到的短信。\",\n" +
      "\"title\": \"发送短信收到的广播\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.BROADCAST_STICKY\": {\n" +
      "\"desc\": \"允许应用程序广播粘性意图。\",\n" +
      "\"title\": \"发送持久广播。\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.BROADCAST_WAP_PUSH\": {\n" +
      "\"desc\": \"允许应用程序广播WAP PUSH接收通知。\",\n" +
      "\"title\": \"发送WAP-PUSH 收到的广播。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CALL_COMPANION_APP\": {\n" +
      "\"desc\": \"允许应用作为呼叫伴随应用启用。\",\n" +
      "\"title\": \"伴随呼叫启动\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CALL_PHONE\": {\n" +
      "\"desc\": \"允许应用程序在不通过拨号界面的情况下发起电话呼叫。\",\n" +
      "\"title\": \"直接拨打电话号码\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.CALL_PRIVILEGED\": {\n" +
      "\"desc\": \"允许应用程序拨打任何电话号码，包括紧急号码，而无需通过拨号界面来让用户确认正在拨打的电话。\",\n" +
      "\"title\": \"直接呼叫任何电话号码\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.CAMERA\": {\n" +
      "\"desc\": \"允许该应用使用相机拍摄照片和视频。此权限可让该应用随时使用相机，而无需您的确认。\",\n" +
      "\"title\": \"拍摄照片和视频\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CAPTURE_AUDIO_OUTPUT\": {\n" +
      "\"desc\": \"允许该应用捕获和重定向音频输出。\",\n" +
      "\"title\": \"捕获音频输出。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CHANGE_COMPONENT_ENABLED_STATE\": {\n" +
      "\"desc\": \"允许应用启用或停用其他应用的组件。\",\n" +
      "\"title\": \"启用或停用应用组件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CHANGE_CONFIGURATION\": {\n" +
      "\"desc\": \"允许应用程序修改当前设备配置。\",\n" +
      "\"title\": \"更改系统显示设置。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CHANGE_NETWORK_STATE\": {\n" +
      "\"desc\": \"允许应用程序更改网络连接状态。\",\n" +
      "\"title\": \"更改网络连接状态。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CHANGE_WIFI_MULTICAST_STATE\": {\n" +
      "\"desc\": \"允许该应用使用多播地址接收发送到WLAN网络上所有设备的数据包。该操作的耗电量比非多播模式更大。\",\n" +
      "\"title\": \"允许接收WLAN多播。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CHANGE_WIFI_STATE\": {\n" +
      "\"desc\": \"允许该应用与 WLAN 接入点建立和断开连接，以及更改WLAN网络的设备配置。\",\n" +
      "\"title\": \"连接WLAN网络和断开连接。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CLEAR_APP_CACHE\": {\n" +
      "\"desc\": \"允许应用程序清除设备上所有已安装应用程序的缓存。\",\n" +
      "\"title\": \"删除所有应用缓存数据\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.CONTROL_LOCATION_UPDATES\": {\n" +
      "\"desc\": \"允许应用启用/停止来自无线装置的位置更新通知。普通应用应该使用此权限。\",\n" +
      "\"title\": \"控制位置更新通知。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.DELETE_CACHE_FILES\": {\n" +
      "\"desc\": \"允许删除应用程序的缓存文件。\",\n" +
      "\"title\": \"删除其他应用程序的缓存文件。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.DELETE_PACKAGES\": {\n" +
      "\"desc\": \"允许应用程序删除其他应用。\",\n" +
      "\"title\": \"删除应用\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.DIAGNOSTIC\": {\n" +
      "\"desc\": \"允许应用读取/写入诊断拥有的所有资源（例如/dev中的文件）。这可能会影响系统的稳定性和安全性。\",\n" +
      "\"title\": \"允许应用程序读写诊断资源。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.DISABLE_KEYGUARD\": {\n" +
      "\"desc\": \"允许该应用停用键锁以及任何关联的密码安全措施。例如，让手机在接听来电时停用键锁，在通话结束后重新启用键。\",\n" +
      "\"title\": \"停用屏幕锁定\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.DUMP\": {\n" +
      "\"desc\": \"允许应用程序从系统服务中检索状态转储信息。\",\n" +
      "\"title\": \"检索系统内部状态\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.EXPAND_STATUS_BAR\": {\n" +
      "\"desc\": \"允许应用程序展开或折叠状态栏。\",\n" +
      "\"title\": \"展开/收拢状态栏\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.FACTORY_TEST\": {\n" +
      "\"desc\": \"允许应用以制造商测试应用程序的身份运行，以root用户身份运行。\",\n" +
      "\"title\": \"在出厂测试模式下运行\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.FOREGROUND_SERVICE\": {\n" +
      "\"desc\": \"允许应用程序使用前台服务。\",\n" +
      "\"title\": \"使用前台服务\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.GET_ACCOUNTS\": {\n" +
      "\"desc\": \"允许访问帐户服务中的帐户列表。\",\n" +
      "\"title\": \"查找设备上的账户\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.GET_ACCOUNTS_PRIVILEGED\": {\n" +
      "\"desc\": \"允许访问帐户服务中的帐户列表。\",\n" +
      "\"title\": \"访问账户列表\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.GET_PACKAGE_SIZE\": {\n" +
      "\"desc\": \"允许应用程序查看其他应用使用的空间大小。\",\n" +
      "\"title\": \"计算应用存储空间\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.GET_TASKS\": {\n" +
      "\"desc\": \"允许应用程序获取当前的信息或最近运行的任务。\",\n" +
      "\"title\": \"检索正在运行的应用。\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.INSTALL_LOCATION_PROVIDER\": {\n" +
      "\"desc\": \"创建用于测试的模拟位置源或安装新的位置提供程序。\",\n" +
      "\"title\": \"允许安装位置信息提供程序\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.INSTALL_PACKAGES\": {\n" +
      "\"desc\": \"允许应用程序安装其他应用。\",\n" +
      "\"title\": \"直接安装应用\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.INSTANT_APP_FOREGROUND_SERVICE\": {\n" +
      "\"desc\": \"允许即时应用创建前台服务。\",\n" +
      "\"title\": \"创建前台服务\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.INTERNET\": {\n" +
      "\"desc\": \"允许该应用创建网络套接字和使用自定义网络协议。浏览器和其他某些应用提供了向互联网发送数据的途径，因此应用无需该权限即可向互联网发送数据。\",\n" +
      "\"title\": \"完全的网络访问权限\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.KILL_BACKGROUND_PROCESSES\": {\n" +
      "\"desc\": \"允许应用清理后台应用进程。\",\n" +
      "\"title\": \"关闭其他应用\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.LOADER_USAGE_STATS\": {\n" +
      "\"desc\": \"允许数据加载器读取程序包的访问日志。\",\n" +
      "\"title\": \"允许读取程序包日志\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.MANAGE_DOCUMENTS\": {\n" +
      "\"desc\": \"允许应用程序管理档存储空间。\",\n" +
      "\"title\": \"管理文档存储空间\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.MANAGE_EXTERNAL_STORAGE\": {\n" +
      "\"desc\": \"允许应用程序访问作用域存储中的外部存储。\",\n" +
      "\"title\": \"允许程序访问APP通知方式\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.MEDIA_CONTENT_CONTROL\": {\n" +
      "\"desc\": \"允许应用控制媒体播放及使用媒体信息(标题、作者..)。\",\n" +
      "\"title\": \"控制媒体播放和使用元数据。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.MODIFY_AUDIO_SETTINGS\": {\n" +
      "\"desc\": \"允许该应用修改全局音频设置，例如音量和用于输出的扬声器。\",\n" +
      "\"title\": \"更改您的音频设置\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.MODIFY_PHONE_STATE\": {\n" +
      "\"desc\": \"允许应用控制设备的电话功能。拥有此权限的应用可在不通知您的情况下执行切换网络、开关手机无线装置等此类操。\",\n" +
      "\"title\": \"修改手机状态\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.MOUNT_FORMAT_FILESYSTEMS\": {\n" +
      "\"desc\": \"允许格式化可移动存储设备。\",\n" +
      "\"title\": \"清除USB存储设备内容\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.MOUNT_UNMOUNT_FILESYSTEMS\": {\n" +
      "\"desc\": \"允许挂载和卸载可移动存储的文件系统。\",\n" +
      "\"title\": \"访问USB存储设备的文件系统\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.NFC\": {\n" +
      "\"desc\": \"允许应用与近距离无线通信(NFC)标签、卡和读取器通信。\",\n" +
      "\"title\": \"控制近距离通信\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.PACKAGE_USAGE_STATS\": {\n" +
      "\"desc\": \"允许应用收集组件使用情况统计信息。\",\n" +
      "\"title\": \"更新组件使用情况统计\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.PERSISTENT_ACTIVITY\": {\n" +
      "\"desc\": \"允许应用程序在内存中持续保留其自身的某些组件。\",\n" +
      "\"title\": \"让应用始终运行\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.PROCESS_OUTGOING_CALLS\": {\n" +
      "\"desc\": \"允许应用在拨出电话时查看拨打的电话号码，并选择改为拨打其他号码或完全中止通话。\",\n" +
      "\"title\": \"重新设置外拨电话的路径\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.QUERY_ALL_PACKAGES\": {\n" +
      "\"desc\": \"允许查询设备上的任何应用程序。\",\n" +
      "\"title\": \"查看设备上所有应用\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.READ_CALENDAR\": {\n" +
      "\"desc\": \"允许应用读取用户的日历数据。\",\n" +
      "\"title\": \"读取日历活动信息\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.READ_CALL_LOG\": {\n" +
      "\"desc\": \"允许应用程序读取用户的通话记录。\",\n" +
      "\"title\": \"读取通话记录\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.READ_CONTACTS\": {\n" +
      "\"desc\": \"允许该应用读取您手机上存储的联系人的相关数据，包括您通过打电话、发送电子邮件或以其他方式与特定个人通信的频率。\",\n" +
      "\"title\": \"读取您的通讯录\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.READ_EXTERNAL_STORAGE\": {\n" +
      "\"desc\": \"允许应用程序从外部存储读取数据。\",\n" +
      "\"title\": \"读取您的USB存储设备中的内容\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.READ_LOGS\": {\n" +
      "\"desc\": \"允许应用程序读取系统日志文件。\",\n" +
      "\"title\": \"查阅敏感日志数据\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.READ_PHONE_NUMBERS\": {\n" +
      "\"desc\": \"允许读取访问设备的电话号码。\",\n" +
      "\"title\": \"读取手机电话号码\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.READ_PHONE_STATE\": {\n" +
      "\"desc\": \"允许该应用访问设备的电话功能，此权限可以让应用确定本机号码和设备ID、是否正处于通话状态以及拨打的号码。\",\n" +
      "\"title\": \"读取手机状态和身份\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.READ_PRECISE_PHONE_STATE\": {\n" +
      "\"desc\": \"允许访问精确的电话状态。\",\n" +
      "\"title\": \"读取确切的手机状态\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.READ_SMS\": {\n" +
      "\"desc\": \"允许该应用读取您手机或SIM卡上存储的短信。\",\n" +
      "\"title\": \"读取您的讯息(短信或彩信)\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.READ_SYNC_SETTINGS\": {\n" +
      "\"desc\": \"许该应用读取某个账户的同步设置。\",\n" +
      "\"title\": \"读取同步设置。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.READ_SYNC_STATS\": {\n" +
      "\"desc\": \"允许该应用读取某个账户的同步统计信息，包括同步活动历史记录和同步数据量。\",\n" +
      "\"title\": \"读取同步统计信息。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.REBOOT\": {\n" +
      "\"desc\": \"允许应用强行重新启动设备。\",\n" +
      "\"title\": \"强行重新启动手机。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.RECEIVE_BOOT_COMPLETED\": {\n" +
      "\"desc\": \"允许应用在系统完成引导后立即自动启动。\",\n" +
      "\"title\": \"开机启动\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.RECEIVE_MMS\": {\n" +
      "\"desc\": \"允许应用程序监听彩信消息。\",\n" +
      "\"title\": \"接收讯息（彩信）\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.RECEIVE_SMS\": {\n" +
      "\"desc\": \"允许应用程序接收短信消息。\",\n" +
      "\"title\": \"接收讯息(短信)\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.RECEIVE_WAP_PUSH\": {\n" +
      "\"desc\": \"允许应用程序接收WAP推送消息。\",\n" +
      "\"title\": \"接收讯息(WAP)\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.RECORD_AUDIO\": {\n" +
      "\"desc\": \"允许应用程序录制音频。\",\n" +
      "\"title\": \"录音\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.REORDER_TASKS\": {\n" +
      "\"desc\": \"允允许该应用将任务移动到前台和后台。\",\n" +
      "\"title\": \"对正在运行的应用重新排序\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.REQUEST_COMPANION_RUN_IN_BACKGROUND\": {\n" +
      "\"desc\": \"允许合作应用在后台运行。\",\n" +
      "\"title\": \"合作应用后台运行\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.REQUEST_COMPANION_USE_DATA_IN_BACKGROUND\": {\n" +
      "\"desc\": \"允许合作应用在后台使用数据。\",\n" +
      "\"title\": \"合作应用后台使用数据\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.REQUEST_DELETE_PACKAGES\": {\n" +
      "\"desc\": \"允许应用程序请求卸载其他应用。\",\n" +
      "\"title\": \"卸载其他应用\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS\": {\n" +
      "\"desc\": \"允许用户请求应用忽略电池优化。\",\n" +
      "\"title\": \"忽略电池优化\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.REQUEST_INSTALL_PACKAGES\": {\n" +
      "\"desc\": \"允许应用程序请求安装软件包。\",\n" +
      "\"title\": \"安装软件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.REQUEST_PASSWORD_COMPLEXITY\": {\n" +
      "\"desc\": \"允许应用程序请求屏幕锁定复杂性，并提示用户将屏幕锁定更新到特定的复杂性级别。\",\n" +
      "\"title\": \"获取屏幕锁定复杂性\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.RESTART_PACKAGES\": {\n" +
      "\"desc\": \"允许应用程序结束其他应用的后台进程。\",\n" +
      "\"title\": \"关闭其他应用\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SEND_RESPOND_VIA_MESSAGE\": {\n" +
      "\"desc\": \"允许应用程序将请求发送到其他应用程序，以便处理来电的“通过信息回复”事件。\",\n" +
      "\"title\": \"发送“通过信息回复”事件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SEND_SMS\": {\n" +
      "\"desc\": \"允许应用程序发送短信消息。\",\n" +
      "\"title\": \"发送短信\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.SET_ANIMATION_SCALE\": {\n" +
      "\"desc\": \"允许修改全局动画缩放比例。\",\n" +
      "\"title\": \"修改全局动画\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SET_DEBUG_APP\": {\n" +
      "\"desc\": \"允许该应用对其他应用程序进行调试。\",\n" +
      "\"title\": \"启动应用调试\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SET_PREFERRED_APPLICATIONS\": {\n" +
      "\"desc\": \"允许程序修改您的首选应用。\",\n" +
      "\"title\": \"设置首选应用。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SET_PROCESS_LIMIT\": {\n" +
      "\"desc\": \"允许应用程序设置可以运行的应用程序进程的最大数量。\",\n" +
      "\"title\": \"限制运行的进程数量。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SET_TIME\": {\n" +
      "\"desc\": \"允许应用程序直接设置系统时间。\",\n" +
      "\"title\": \"设置时间。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SET_TIME_ZONE\": {\n" +
      "\"desc\": \"允许应用程序直接设置系统时区。\",\n" +
      "\"title\": \"设置时区\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SET_WALLPAPER\": {\n" +
      "\"desc\": \"允许应用程序设置墙纸。\",\n" +
      "\"title\": \"设置壁纸\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SET_WALLPAPER_HINTS\": {\n" +
      "\"desc\": \" 允许应用程序设置墙纸大小的提示。\",\n" +
      "\"title\": \"调整您的壁纸大小\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SIGNAL_PERSISTENT_PROCESSES\": {\n" +
      "\"desc\": \"允许应用程序请求将信号发送到所有持久性进程。\",\n" +
      "\"title\": \"向应用发送 Linux 信号\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SMS_FINANCIAL_TRANSACTIONS\": {\n" +
      "\"desc\": \"允许金融应用读取过滤的短信。\",\n" +
      "\"title\": \"读取过滤短信\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.START_VIEW_PERMISSION_USAGE\": {\n" +
      "\"desc\": \"允许启动应用程序的权限使用屏幕。\",\n" +
      "\"title\": \"使用手机屏幕\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.STATUS_BAR\": {\n" +
      "\"desc\": \"允许应用程序打开，关闭或禁用状态栏及其图标。\",\n" +
      "\"title\": \"停用或修改状态栏\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.SYSTEM_ALERT_WINDOW\": {\n" +
      "\"desc\": \"允许应用显示在所有其他应用的顶部。\",\n" +
      "\"title\": \"在其他应用之上显示内容\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.TRANSMIT_IR\": {\n" +
      "\"desc\": \"允许使用设备的红外发射器。\",\n" +
      "\"title\": \"使用红外线发射器\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.UPDATE_DEVICE_STATS\": {\n" +
      "\"desc\": \"允许应用程序更新设备统计信息。\",\n" +
      "\"title\": \"修改使用统计信息。\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.USE_BIOMETRIC\": {\n" +
      "\"desc\": \"允许应用使用设备支持的生物特征识别方式。\",\n" +
      "\"title\": \"允许使用指纹等识别方式\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.USE_FINGERPRINT\": {\n" +
      "\"desc\": \"允许应用使用指纹硬件。\",\n" +
      "\"title\": \"允许应用使用指纹硬件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.USE_FULL_SCREEN_INTENT\": {\n" +
      "\"desc\": \"允许应用显示全屏通知。\",\n" +
      "\"title\": \"允许应用显示全屏通知\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.USE_SIP\": {\n" +
      "\"desc\": \"允许应用程序使用SIP服务。\",\n" +
      "\"title\": \"拨打/接听SIP电话\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.VIBRATE\": {\n" +
      "\"desc\": \"允许使用振动器。\",\n" +
      "\"title\": \"控制振动\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.WAKE_LOCK\": {\n" +
      "\"desc\": \"允许应用阻止手机进入休眠状态。\",\n" +
      "\"title\": \"防止手机休眠\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.WRITE_APN_SETTINGS\": {\n" +
      "\"desc\": \"允许应用更改网络设置，并拦截和检查所有网络流量。\",\n" +
      "\"title\": \"更改/拦截网络设置和流量\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.WRITE_CALENDAR\": {\n" +
      "\"desc\": \"允许应用程序写入、删除、更改用户的日历数据。\",\n" +
      "\"title\": \"添加或修改日历活动，并在所有者不知情的情况下向邀请对象发送电子邮件\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.WRITE_CALL_LOG\": {\n" +
      "\"desc\": \"允许应用程序添加/修改用户的通话记录。\",\n" +
      "\"title\": \"写入通话记录\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.WRITE_CONTACTS\": {\n" +
      "\"desc\": \"允许应用程序写入用户的联系人数据。\",\n" +
      "\"title\": \"修改您的通讯录\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.WRITE_EXTERNAL_STORAGE\": {\n" +
      "\"desc\": \"允许应用程序读取/写入外部存储。\",\n" +
      "\"title\": \"修改或删除您的USB存储设备中的内容\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.WRITE_SECURE_SETTINGS\": {\n" +
      "\"desc\": \"允许应用读取或写入安全系统设置。\",\n" +
      "\"title\": \"修改安全系统设置\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.WRITE_SETTINGS\": {\n" +
      "\"desc\": \"允许应用读取或写入系统设置。\",\n" +
      "\"title\": \"修改系统设置\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.WRITE_SYNC_SETTINGS\": {\n" +
      "\"desc\": \"允许应用程序修改某个账户的同步设置。\",\n" +
      "\"title\": \"启用和停用同步\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.WRITE_VOICEMAIL\": {\n" +
      "\"desc\": \"允许应用程序修改和删除系统中现有的语音邮件。\",\n" +
      "\"title\": \"读取修改语音邮件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.DOWNLOAD_WITHOUT_NOTIFICATION\": {\n" +
      "\"desc\": \"允许该应用通过下载管理器下载文件，而不会向用户显示任何通知。\",\n" +
      "\"title\": \"直接下载文件而不显示通知\",\n" +
      "\"level\": 1\n" +
      "},\n" +
      "\"android.permission.ACCESS_ALL_EXTERNAL_STORAGE\": {\n" +
      "\"desc\": \"允许该应用访问所有用户的外部存储。\",\n" +
      "\"title\": \"访问所有用户的外部存储设备\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.ASEC_ACCESS\": {\n" +
      "\"desc\": \"允许该应用获取有关内部存储的信息。\",\n" +
      "\"title\": \"获取有关内部存储设备的信息\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.ACCESS_MOCK_LOCATION\": {\n" +
      "\"desc\": \"允许模拟位置源进行测试。\",\n" +
      "\"title\": \"停用模拟地点来源进行测试\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"android.permission.AUTHENTICATE_ACCOUNTS\": {\n" +
      "\"desc\": \"允许创建帐户并设置密码。\",\n" +
      "\"title\": \"创建账户并设置密码\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"com.android.alarm.permission.SET_ALARM\": {\n" +
      "\"desc\": \"允许应用程序为用户设置闹钟。\",\n" +
      "\"title\": \"设置闹钟\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"com.android.voicemail.permission.READ_VOICEMAIL\": {\n" +
      "\"desc\": \"允许应用程序读取系统中的语音邮件。\",\n" +
      "\"title\": \"读取语言邮件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"com.android.launcher.permission.INSTALL_SHORTCUT\": {\n" +
      "\"desc\": \"允许应用程序在桌面中创建快捷方式。\",\n" +
      "\"title\": \"安装快捷方式\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"com.android.launcher.permission.UNINSTALL_SHORTCUT\": {\n" +
      "\"desc\": \"允许删除快捷方式。\",\n" +
      "\"title\": \"卸载快捷方式\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"com.android.voicemail.permission.ADD_VOICEMAIL\": {\n" +
      "\"desc\": \"允许该应用向您的语音信箱中添加邮件。\",\n" +
      "\"title\": \"添加语音邮件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"com.android.email.permission.READ_ATTACHMENT\": {\n" +
      "\"desc\": \"允许该应用读取您的电子邮件附件。\",\n" +
      "\"title\": \"读取电子邮件附件\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"com.android.browser.permission.WRITE_HISTORY_BOOKMARKS\": {\n" +
      "\"desc\": \"允许该应用修改浏览器的历史记录或手机上存储的书签。\",\n" +
      "\"title\": \"写入网络书签和历史记录\",\n" +
      "\"level\": 0\n" +
      "},\n" +
      "\"com.android.browser.permission.READ_HISTORY_BOOKMARKS\": {\n" +
      "\"desc\": \"允许该应用读取浏览器访问过的所有URL的历史记录，以及浏览器的所有书签的历史记录。\",\n" +
      "\"title\": \"读取您的网络书签和历史记录\",\n" +
      "\"level\": 0\n" +
      "}\n" +
      "}";

  static {
    try {
      PERMISSIONS_MAP_JSON = new JSONObject(PERMISSIONS_MAP_JSON_STR);
    } catch (JSONException e) {
      e.printStackTrace();
    }
  }
}

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:openhab_client/models/EnrichedItemDTO.dart';
import 'package:openhab_client/models/rule.dart';
import 'package:openhab_client/models/thing.dart';
import 'package:openhab_client/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as conv;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemGroupsProvider extends ChangeNotifier {
  String? auth;
  String? apiToken;
  final SplayTreeMap<String, List<EnrichedItemDTO>> _switchesGroups =
      SplayTreeMap();
  final SplayTreeMap<String, List<EnrichedItemDTO>> _sensorGroups =
      SplayTreeMap();
  final Map<String, String> _sysInfo = {};
  final List<Rule> _rules = [];
  final List<Thing> _things = [];
  SplayTreeMap<String, List<EnrichedItemDTO>> get sensorGroups => _sensorGroups;
  SplayTreeMap<String, List<EnrichedItemDTO>> get switchGroups =>
      _switchesGroups;
  UnmodifiableMapView<String, String> get sysInfo =>
      UnmodifiableMapView(_sysInfo);
  UnmodifiableListView<Rule> get rules => UnmodifiableListView(_rules);
  UnmodifiableListView<Thing> get things => UnmodifiableListView(_things);

  addSwitches(List<EnrichedItemDTO> switchList) {
    for (EnrichedItemDTO item in switchList) {
      String? group = item.groupName.isNotEmpty ? item.groupName : 'All';
      if (_switchesGroups.containsKey(group)) {
        _switchesGroups[group]!.add(item);
      } else {
        _switchesGroups[group] = [];
        _switchesGroups[group]!.add(item);
      }
    }
    notifyListeners();
  }

  Future<bool> dummyData(BuildContext context) async {
    return Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String itemsResponse =
          '[  {    "link": "http://openhabian:8080/rest/items/DrawingSwitchBoard_FanSwitch",    "state": "NULL",    "type": "Switch",    "name": "DrawingSwitchBoard_FanSwitch",    "label": "FanSwitch",    "groupNames": [      "DrawingSwitchBoard"    ]  },  {    "link": "http://openhabian:8080/rest/items/GSMModule_GSMSignalStrength",    "state": "NULL",    "type": "String",    "name": "GSMModule_GSMSignalStrength",    "label": "GSM Signal Strength",    "groupNames": [      "GSMModule"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Storage_Used",    "state": "6546",    "type": "Number",    "name": "SystemInformation_Storage_Used",    "label": "Storage Used",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/GSMModule_GSMNetworkRegisterStatus",    "state": "NULL",    "type": "String",    "name": "GSMModule_GSMNetworkRegisterStatus",    "label": "GSM Network Register Status",    "groupNames": [      "GSMModule"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Process_Name",    "state": "UNDEF",    "type": "String",    "name": "SystemInformation_Process_Name",    "label": "Process Name",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/DiningSwitchBoard_LightSwitch",    "state": "OFF",    "type": "Switch",    "name": "DiningSwitchBoard_LightSwitch",    "label": "Light Switch",    "groupNames": [      "DiningSwitchBoard"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Path",    "state": "UNDEF",    "type": "String",    "name": "SystemInformation_Path",    "label": "Process Path",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Drive_Name",    "state": "/dev/mmcblk0",    "type": "String",    "name": "SystemInformation_Drive_Name",    "label": "Drive Name",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Storage_UsedPercent",    "state": "44.6",    "type": "Number",    "name": "SystemInformation_Storage_UsedPercent",    "label": "Storage Used (%)",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SensorsHub_AtmosphericPressure",    "state": "1013.08",    "type": "Number",    "name": "SensorsHub_AtmosphericPressure",    "label": "Atmospheric Pressure",    "groupNames": [      "SensorsHub"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Memory_UsedPercent",    "state": "17.4",    "type": "Number",    "name": "SystemInformation_Memory_UsedPercent",    "label": "Memory Used (%)",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/DrawingSwitchBoard_LightSwitch",    "state": "NULL",    "type": "Switch",    "name": "DrawingSwitchBoard_LightSwitch",    "label": "Light Switch",    "groupNames": [      "DrawingSwitchBoard"    ]  },  {    "link": "http://openhabian:8080/rest/items/GSMModule_GSMHandShake",    "state": "NULL",    "type": "String",    "name": "GSMModule_GSMHandShake",    "label": "GSM Hand Shake",    "groupNames": [      "GSMModule"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_IPAddress",    "state": "192.168.100.106",    "type": "String",    "name": "SystemInformation_IPAddress",    "label": "IP Address",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_NetworkDisplayName",    "state": "eth0",    "type": "String",    "name": "SystemInformation_NetworkDisplayName",    "label": "Network Display Name",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_RemainingTime",    "state": "UNDEF",    "type": "Number",    "name": "SystemInformation_RemainingTime",    "label": "Battery Remaining Time",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/TurnOnMotionItem",    "state": "OFF",    "type": "Switch",    "name": "TurnOnMotionItem",    "label": "Turn On Motion",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/TVSwitchBoard",    "state": "NULL",    "type": "Group",    "name": "TVSwitchBoard",    "label": "TV Switch Board",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Memory_Total",    "state": "3888",    "type": "Number",    "name": "SystemInformation_Memory_Total",    "label": "Memory Total",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Memory_AvailablePercent",    "state": "82.6",    "type": "Number",    "name": "SystemInformation_Memory_AvailablePercent",    "label": "Memory Available (%)",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Memory_Used",    "state": "675",    "type": "Number",    "name": "SystemInformation_Memory_Used",    "label": "Memory Used",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Cpu_Name",    "state": "ARMv7 Processor rev 3 (v7l)",    "type": "String",    "name": "SystemInformation_Cpu_Name",    "label": "Cpu Name",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/MotionTriggeredTime",    "state": "1644668625958",    "type": "Number",    "name": "MotionTriggeredTime",    "label": "MotionTriggeredTime",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/ONUStatus_TXPower",    "state": "NULL",    "type": "Number",    "name": "ONUStatus_TXPower",    "label": "TX Power",    "groupNames": [      "ONUModem"    ]  },  {    "link": "http://openhabian:8080/rest/items/TVSwitchBoard_TVSwitch",    "state": "OFF",    "type": "Switch",    "name": "TVSwitchBoard_TVSwitch",    "label": "TV Switch",    "groupNames": [      "TVSwitchBoard"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Storage_Available",    "state": "8123",    "type": "Number",    "name": "SystemInformation_Storage_Available",    "label": "Storage Available",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Battery_Name",    "state": "UNDEF",    "type": "String",    "name": "SystemInformation_Battery_Name",    "label": "Battery Name",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SpeedTest_Execute",    "state": "OFF",    "type": "Switch",    "name": "SpeedTest_Execute",    "label": "SpeedTest_Execute",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/TVSwitchBoard_LightSwitch",    "state": "OFF",    "type": "Switch",    "name": "TVSwitchBoard_LightSwitch",    "label": "Light Switch",    "groupNames": [      "TVSwitchBoard"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Storage_Total",    "state": "14669",    "type": "Number",    "name": "SystemInformation_Storage_Total",    "label": "Storage Total",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/GSMModule_GSMNetworkName",    "state": "NULL",    "type": "String",    "name": "GSMModule_GSMNetworkName",    "label": "GSM Network Name",    "groupNames": [      "GSMModule"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Swap_Total",    "state": "2498",    "type": "Number",    "name": "SystemInformation_Swap_Total",    "label": "Swap Total",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/ONUStatus_DisconnectionReason",    "state": "NULL",    "type": "String",    "name": "ONUStatus_DisconnectionReason",    "label": "Disconnection Reason",    "groupNames": [      "ONUModem"    ]  },  {    "link": "http://openhabian:8080/rest/items/LogReader_LastWarningEvent",    "state": "NULL",    "type": "String",    "name": "LogReader_LastWarningEvent",    "label": "Last Warning Event",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Storage_Name",    "state": "/",    "type": "String",    "name": "SystemInformation_Storage_Name",    "label": "Storage Name",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Load",    "state": "UNDEF",    "type": "Number",    "name": "SystemInformation_Load",    "label": "Process Load",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation",    "state": "NULL",    "type": "String",    "name": "SystemInformation",    "label": "System Information",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Process_Used",    "state": "UNDEF",    "type": "Number",    "name": "SystemInformation_Process_Used",    "label": "Process Used",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Swap_Used",    "state": "0",    "type": "Number",    "name": "SystemInformation_Swap_Used",    "label": "Swap Used",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Swap_UsedPercent",    "state": "0.0",    "type": "Number",    "name": "SystemInformation_Swap_UsedPercent",    "label": "Swap Used (%)",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SensorsHub_Temperature",    "state": "18.80",    "type": "Number",    "name": "SensorsHub_Temperature",    "label": "Temperature",    "groupNames": [      "SensorsHub"    ]  },  {    "link": "http://openhabian:8080/rest/items/SensorsHub_Humidity",    "state": "93",    "type": "Number",    "name": "SensorsHub_Humidity",    "label": "Humidity",    "groupNames": [      "SensorsHub"    ]  },  {    "link": "http://openhabian:8080/rest/items/ONUStatus_ConnectionStatus",    "state": "NULL",    "type": "String",    "name": "ONUStatus_ConnectionStatus",    "label": "Connection Status",    "groupNames": [      "ONUModem"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Storage_AvailablePercent",    "state": "55.4",    "type": "Number",    "name": "SystemInformation_Storage_AvailablePercent",    "label": "Storage Available (%)",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/TelegramBot_LastMessageText",    "state": "/motionoff",    "type": "String",    "name": "TelegramBot_LastMessageText",    "label": "Last Message Text",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Memory_Available",    "state": "3213",    "type": "Number",    "name": "SystemInformation_Memory_Available",    "label": "Memory Available",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Swap_Available",    "state": "2498",    "type": "Number",    "name": "SystemInformation_Swap_Available",    "label": "Swap Available",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/GSMStatusTime",    "state": "NULL",    "type": "String",    "name": "GSMStatusTime",    "label": "GSM Status Time",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/GSMModule_GSMLastCommandStatus",    "state": "NULL",    "type": "String",    "name": "GSMModule_GSMLastCommandStatus",    "label": "GSM Last Command Status",    "groupNames": [      "GSMModule"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_NetworkName",    "state": "eth0",    "type": "String",    "name": "SystemInformation_NetworkName",    "label": "Network Name",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/DiningSwitchBoard_FanSwitch",    "state": "OFF",    "type": "Switch",    "name": "DiningSwitchBoard_FanSwitch",    "label": "Fan Switch",    "groupNames": [      "DiningSwitchBoard"    ]  },  {    "link": "http://openhabian:8080/rest/items/ONUStatus_RXPower",    "state": "NULL",    "type": "Number",    "name": "ONUStatus_RXPower",    "label": "RX Power",    "groupNames": [      "ONUModem"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_Swap_AvailablePercent",    "state": "100.0",    "type": "Number",    "name": "SystemInformation_Swap_AvailablePercent",    "label": "Swap Available (%)",    "groupNames": [      "SystemInformation"    ]  },  {    "link": "http://openhabian:8080/rest/items/ONUStatus_LastExecution",    "state": "NULL",    "type": "String",    "name": "ONUStatus_LastExecution",    "label": "Last Execution",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/LogReader_LastErrorEvent",    "state": "NULL",    "type": "String",    "name": "LogReader_LastErrorEvent",    "label": "Last Error Event",    "groupNames": []  },  {    "link": "http://openhabian:8080/rest/items/GSMModule_GSMATCommand",    "state": "AT",    "type": "String",    "name": "GSMModule_GSMATCommand",    "label": "GSM AT Command",    "groupNames": [      "GSMModule"    ]  },  {    "link": "http://openhabian:8080/rest/items/SystemInformation_RemainingCapacity",    "state": "UNDEF",    "type": "Number",    "name": "SystemInformation_RemainingCapacity",    "label": "Battery Remaining Capacity",    "groupNames": [      "SystemInformation"    ]  }]';
      String sysInfoResponse =
          '{  "systemInfo": {    "configFolder": "/etc/openhab",    "userdataFolder": "/var/lib/openhab",    "logFolder": "/var/log/openhab",    "javaVersion": "11.0.12",    "javaVendor": "Azul Systems, Inc.",    "javaVendorVersion": "Zulu11.50+19-CA",    "osName": "Linux",    "osVersion": "5.10.52-v7l+",    "osArchitecture": "arm",    "availableProcessors": 4,    "freeMemory": 58739080,    "totalMemory": 194904064  }}';
      String rulesResponse =
          '[  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "ONUStatusToTelegram",    "name": "ONU Status To Telegram",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "83a046c078",    "name": "Drawing Room Restore State",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "f24491a75e",    "name": "GSM Network Name Get",    "tags": [],    "visibility": "VISIBLE",    "description": "GSMNetworkName"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "a75e427210",    "name": "Dining Room State Restore",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "50d71fa285",    "name": "Sensors to telegram",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "fbb2e994dc",    "name": "GSM Status Get",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "UNINITIALIZED",      "statusDetail": "DISABLED"    },    "editable": true,    "uid": "47c48b8aa1",    "name": "Monitor GSM Status",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "cdefbc439a",    "name": "TriggerSpeedTest",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "9a04c914e7",    "name": "Telegram Command Help",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "086dbf731b",    "name": "EnableDisableTelegram",    "tags": [      "Script"    ],    "visibility": "VISIBLE",    "description": ""  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "2ff3cf205c",    "name": "MonitorSensorsOffline",    "tags": [],    "visibility": "VISIBLE",    "description": "Monitors sensor and raise an alarm if sensors are offline"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "03e1cf8cb3",    "name": "MonitorSensorsOnline",    "tags": [],    "visibility": "VISIBLE",    "description": "Monitor if sensors are online"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "238a1c7a71",    "name": "EnableDisableTelegram",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "UNINITIALIZED",      "statusDetail": "DISABLED"    },    "editable": true,    "uid": "ea93bbc6d8",    "name": "Motion Stop",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "05fff34841",    "name": "EnableMotionSensor",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "baaccfd81d",    "name": "GSM Register Get",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "UNINITIALIZED",      "statusDetail": "DISABLED"    },    "editable": true,    "uid": "737348c046",    "name": "TestMemoryRule",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "7db2071f47",    "name": "GSM Signal Get",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "16c619cd35",    "name": "Run Motion Sensor Rule",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "f4e5bd693b",    "name": "DisableMotionSensor",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "8ba4868ccf",    "name": "GSM Status To Telegram",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "6a82d04a2e",    "name": "SendSpeedTestResult",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "IDLE",      "statusDetail": "NONE"    },    "editable": true,    "uid": "79512574a6",    "name": "GSM Time Update",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "UNINITIALIZED",      "statusDetail": "DISABLED"    },    "editable": true,    "uid": "0238dd2392",    "name": "MotionSensorToTelegram",    "tags": [],    "visibility": "VISIBLE"  },  {    "status": {      "status": "UNINITIALIZED",      "statusDetail": "DISABLED"    },    "editable": true,    "uid": "SystemRebootNotification",    "name": "SystemRebootNotification",    "tags": [],    "visibility": "VISIBLE"  }]';
      String thingsResponse =
          '[  {    "statusInfo": {      "status": "ONLINE",      "statusDetail": "NONE"    },    "editable": true,    "label": "Dining Switch Board",    "bridgeUID": "mqtt:broker:6e6c7e954e",    "UID": "mqtt:topic:6e6c7e954e:3357b4e261",    "thingTypeUID": "mqtt:topic",    "location": "Dining Room"  },  {    "statusInfo": {      "status": "UNINITIALIZED",      "statusDetail": "DISABLED"    },    "editable": true,    "label": "Systeminfo",    "UID": "systeminfo:computer:607690676a",    "thingTypeUID": "systeminfo:computer"  },  {    "statusInfo": {      "status": "UNINITIALIZED",      "statusDetail": "DISABLED"    },    "editable": true,    "label": "ONU Status",    "UID": "exec:command:ONUStatus",    "thingTypeUID": "exec:command"  },  {    "statusInfo": {      "status": "ONLINE",      "statusDetail": "NONE"    },    "editable": true,    "label": "TV Switch Board",    "bridgeUID": "mqtt:broker:6e6c7e954e",    "UID": "mqtt:topic:6e6c7e954e:a6fb5b24d0",    "thingTypeUID": "mqtt:topic",    "location": "Hall"  },  {    "statusInfo": {      "status": "ONLINE",      "statusDetail": "NONE"    },    "editable": true,    "label": "SpeedTest",    "UID": "exec:command:561208e95a",    "thingTypeUID": "exec:command"  },  {    "statusInfo": {      "status": "UNINITIALIZED",      "statusDetail": "NONE"    },    "editable": true,    "label": "LogReader",    "UID": "logreader:reader:7ecd4545b9",    "thingTypeUID": "logreader:reader"  },  {    "statusInfo": {      "status": "ONLINE",      "statusDetail": "NONE"    },    "editable": true,    "label": "Drawing Switch Board",    "bridgeUID": "mqtt:broker:6e6c7e954e",    "UID": "mqtt:topic:cb6ee14785",    "thingTypeUID": "mqtt:topic",    "location": "Drawing Room"  },  {    "statusInfo": {      "status": "ONLINE",      "statusDetail": "NONE"    },    "editable": true,    "label": "Sensors Hub",    "bridgeUID": "mqtt:broker:6e6c7e954e",    "UID": "mqtt:topic:d64802d4b2",    "thingTypeUID": "mqtt:topic",    "location": "Home"  },  {    "statusInfo": {      "status": "ONLINE",      "statusDetail": "NONE"    },    "editable": true,    "label": "Telegram Bot",    "UID": "telegram:telegramBot:2d7f172239",    "thingTypeUID": "telegram:telegramBot"  },  {    "statusInfo": {      "status": "ONLINE",      "statusDetail": "NONE"    },    "editable": true,    "label": "MQTT Broker",    "UID": "mqtt:broker:6e6c7e954e",    "thingTypeUID": "mqtt:broker"  },  {    "statusInfo": {      "status": "ONLINE",      "statusDetail": "NONE"    },    "editable": true,    "label": "GSM Module",    "bridgeUID": "mqtt:broker:6e6c7e954e",    "UID": "mqtt:topic:6e6c7e954e:d01d433c74",    "thingTypeUID": "mqtt:topic",    "location": "Main Hall"  }]';
      _parseItems(itemsResponse, prefs);
      _parseSysInfo(sysInfoResponse);
      _parseRules(rulesResponse, prefs);
      _parseThings(thingsResponse, prefs);
      return true;
    });
  }

  Future<bool> refresh(BuildContext context) async {
    AppLocalizations loc = AppLocalizations.of(context)!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.get('username')?.toString();
    String? password = prefs.get('password')?.toString();
    String? _apitoken = prefs.get('apitoken')?.toString();
    if (userName != null && password != null) {
      String basicAuth =
          'Basic ' + conv.base64Encode(conv.utf8.encode('$userName:$password'));
      var hdrs = <String, String>{
        'authorization': basicAuth,
        'accept': 'application/json',
      };
      auth = basicAuth;
      var itemsUri = Uri.parse(Utils.itemsUrl);
      var sysInfoUri = Uri.parse(Utils.systeminfoUrl);
      var rulesUri = Uri.parse(Utils.rulesUrl);
      var thingsUri = Uri.parse(Utils.thingsUrl);
      try {
        var value = await http.get(itemsUri, headers: hdrs);
        _parseItems(value.body, prefs);
        if (_apitoken != null && _apitoken.isNotEmpty) {
          apiToken = _apitoken;
          hdrs['X-OPENHAB-TOKEN'] = _apitoken;
          var sysInfo = await http.get(sysInfoUri, headers: hdrs);
          _parseSysInfo(sysInfo.body);
          var rulesResp = await http.get(rulesUri, headers: hdrs);
          _parseRules(rulesResp.body, prefs);
          var thingsResp = await http.get(thingsUri, headers: hdrs);
          _parseThings(thingsResp.body, prefs);
        }
        notifyListeners();
      } on Exception catch (e) {
        return false;
      }
    } else {
      Utils.makeToast(context, loc.noCredentialsMsg);
      return false;
    }
    return true;
  }

  void _parseThings(String response, SharedPreferences prefs) {
    _things.clear();
    for (var element in (conv.jsonDecode(response) as List)) {
      Thing t = Thing();
      t.name = element['label'] ?? element['UID'];
      t.uuid = element['UID'];
      if (element['statusInfo']['status'] == 'UNINITIALIZED') {
        t.state = false;
      } else {
        t.state = true;
      }
      _things.add(t);
    }
    _things.sort((a, b) => a.name!.compareTo(b.name!));
    prefs.setString(
        'things', conv.jsonEncode(_things.map((e) => e.toJson()).toList()));
  }

  void _parseRules(String response, SharedPreferences prefs) {
    _rules.clear();
    for (var element in (conv.jsonDecode(response) as List)) {
      Rule r = Rule();
      r.name = element['name'] ?? element['uid'];
      r.uuid = element['uid'];
      r.description = element['description'];
      if (element['status']['status'] == 'UNINITIALIZED') {
        r.state = false;
      } else {
        r.state = true;
      }
      _rules.add(r);
    }
    _rules.sort((a, b) => a.name!.compareTo(b.name!));
    prefs.setString(
        'rules', conv.jsonEncode(_rules.map((e) => e.toJson()).toList()));
  }

  void _parseSysInfo(String response) {
    _sysInfo.clear();
    for (var element
        in (conv.jsonDecode(response)['systemInfo'] as Map).entries) {
      _sysInfo[element.key] = element.value.toString();
    }
  }

  void _parseItems(String response, SharedPreferences prefs) {
    final List<EnrichedItemDTO> _switches = [];
    final List<EnrichedItemDTO> sensors = [];
    List<EnrichedItemDTO> items = (conv.jsonDecode(response) as List).map((e) {
      String label = e['label'] ?? '';
      String name = e['name'] ?? '';
      String type = e['type'] ?? '';
      String state = e['state'] ?? '';
      String link = e['link'] ?? '';
      List groups = (e['groupNames'] as List);
      String group = groups.length > 0 ? groups[0] : '';
      return EnrichedItemDTO(
          label: label,
          link: link,
          name: name,
          state: state,
          type: type,
          groupName: group);
    }).toList();
    for (EnrichedItemDTO item in items) {
      if (item.type == 'Switch') {
        if (!_switches.any((element) => element.link == item.link)) {
          _switches.add(item);
        }
      } else if (item.type == 'String' || item.type == 'Number') {
        if (!sensors.any((element) => element.link == item.link)) {
          sensors.add(item);
        }
      }
    }
    prefs.setString(
        'switches', conv.jsonEncode(_switches.map((e) => e.toJson()).toList()));
    _switchesGroups.clear();
    for (EnrichedItemDTO item in _switches) {
      String? group = item.groupName.isNotEmpty ? item.groupName : 'All';
      if (_switchesGroups.containsKey(group)) {
        _switchesGroups[group]!.add(item);
      } else {
        _switchesGroups[group] = [];
        _switchesGroups[group]!.add(item);
      }
    }
    _sensorGroups.clear();
    for (EnrichedItemDTO item in sensors) {
      String? group = item.groupName.isNotEmpty ? item.groupName : 'All';
      if (_sensorGroups.containsKey(group)) {
        _sensorGroups[group]!.add(item);
      } else {
        _sensorGroups[group] = [];
        _sensorGroups[group]!.add(item);
      }
    }
  }

  void addRules(List<Rule> ruleList) {
    _rules.addAll(ruleList);
    notifyListeners();
  }

  void addThings(List<Thing> thingList) {
    _things.addAll(thingList);
    notifyListeners();
  }
}

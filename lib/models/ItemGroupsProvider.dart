import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:openhab_client/models/EnrichedItemDTO.dart';
import 'package:openhab_client/models/rule.dart';
import 'package:openhab_client/models/thing.dart';
import 'package:openhab_client/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as conv;

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

  Future<bool> refresh() async {
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
        final List<EnrichedItemDTO> _switches = [];
        List<EnrichedItemDTO> sensors = [];
        List<EnrichedItemDTO> items =
            (conv.jsonDecode(value.body) as List).map((e) {
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
        prefs.setString('switches',
            conv.jsonEncode(_switches.map((e) => e.toJson()).toList()));
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
        if (_apitoken != null && _apitoken.isNotEmpty) {
          apiToken = _apitoken;
          hdrs['X-OPENHAB-TOKEN'] = _apitoken;
          var sysInfo = await http.get(sysInfoUri, headers: hdrs);
          _sysInfo.clear();
          for (var element
              in (conv.jsonDecode(sysInfo.body)['systemInfo'] as Map).entries) {
            _sysInfo[element.key] = element.value.toString();
          }
          var rulesResp = await http.get(rulesUri, headers: hdrs);
          _rules.clear();
          for (var element in (conv.jsonDecode(rulesResp.body) as List)) {
            Rule r = Rule();
            r.name = element['name'] ?? element['uid'];
            r.uuid = element['uid'];
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
          var thingsResp = await http.get(thingsUri, headers: hdrs);
          _things.clear();
          for (var element in (conv.jsonDecode(thingsResp.body) as List)) {
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
          prefs.setString('things',
              conv.jsonEncode(_things.map((e) => e.toJson()).toList()));
        }
        notifyListeners();
      } on Exception catch (e) {
        return false;
      }
    }
    return true;
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

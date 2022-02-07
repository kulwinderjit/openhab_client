import 'package:openhab_client/models/CommandOption.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CommandDescription.g.dart';

@JsonSerializable(explicitToJson: true)
class CommandDescription {
  CommandDescription({this.commandOptions});
  List<CommandOption>? commandOptions;
  factory CommandDescription.fromJson(Map<String, dynamic> json) =>
      _$CommandDescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$CommandDescriptionToJson(this);
}

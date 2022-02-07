import 'package:json_annotation/json_annotation.dart';

part 'CommandOption.g.dart';

@JsonSerializable(explicitToJson: true)
class CommandOption {
  CommandOption({this.command, this.label});
  String? command;
  String? label;
  factory CommandOption.fromJson(Map<String, dynamic> json) =>
      _$CommandOptionFromJson(json);
  Map<String, dynamic> toJson() => _$CommandOptionToJson(this);
}

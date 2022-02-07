import 'package:json_annotation/json_annotation.dart';

part 'StateOption.g.dart';

@JsonSerializable(explicitToJson: true)
class StateOption {
  StateOption(this.value, this.label);
  String? value;
  String? label;
  factory StateOption.fromJson(Map<String, dynamic> json) =>
      _$StateOptionFromJson(json);
  Map<String, dynamic> toJson() => _$StateOptionToJson(this);
}

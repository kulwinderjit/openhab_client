import 'package:json_annotation/json_annotation.dart';
import 'package:openhab_client/models/StateOption.dart';

part 'StateDescription.g.dart';

@JsonSerializable(explicitToJson: true)
class StateDescription {
  StateDescription(
      {this.maximum,
      this.minimum,
      this.step,
      this.pattern,
      this.readOnly,
      this.options});
  double? minimum;
  double? maximum;
  double? step;
  String? pattern;
  bool? readOnly;
  List<StateOption>? options;
  factory StateDescription.fromJson(Map<String, dynamic> json) =>
      _$StateDescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$StateDescriptionToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StateDescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateDescription _$StateDescriptionFromJson(Map<String, dynamic> json) =>
    StateDescription(
      maximum: (json['maximum'] as num?)?.toDouble(),
      minimum: (json['minimum'] as num?)?.toDouble(),
      step: (json['step'] as num?)?.toDouble(),
      pattern: json['pattern'] as String?,
      readOnly: json['readOnly'] as bool?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => StateOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StateDescriptionToJson(StateDescription instance) =>
    <String, dynamic>{
      'minimum': instance.minimum,
      'maximum': instance.maximum,
      'step': instance.step,
      'pattern': instance.pattern,
      'readOnly': instance.readOnly,
      'options': instance.options?.map((e) => e.toJson()).toList(),
    };

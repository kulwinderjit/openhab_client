// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommandDescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommandDescription _$CommandDescriptionFromJson(Map<String, dynamic> json) =>
    CommandDescription(
      commandOptions: (json['commandOptions'] as List<dynamic>?)
          ?.map((e) => CommandOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommandDescriptionToJson(CommandDescription instance) =>
    <String, dynamic>{
      'commandOptions':
          instance.commandOptions?.map((e) => e.toJson()).toList(),
    };

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_model.freezed.dart';
part 'base_model.g.dart';

@freezed
class BaseModel with _$BaseModel {
  const factory BaseModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BaseModel;

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$BaseModelFromJson(json);
}

mixin BaseEntity {
  String get id;
  DateTime get createdAt;
  DateTime get updatedAt;
}

abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

class Initial extends BaseState {}

class Loading extends BaseState {}

class Loaded<T> extends BaseState {
  final T data;

  const Loaded(this.data);

  @override
  List<Object?> get props => [data];
}

class Error extends BaseState {
  final String message;

  const Error(this.message);

  @override
  List<Object?> get props => [message];
}

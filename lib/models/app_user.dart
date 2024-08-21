import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser extends Equatable {
  String name;
  @JsonKey(defaultValue: false)
  bool isAdmin;
  String lastName;
  String email;
  String password;

  AppUser({
    required this.name,
    required this.lastName,
    required this.email,
    required this.password,
    this.isAdmin = false,
  });

  @override
  List<Object?> get props => [name, lastName, email, password, isAdmin];

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}

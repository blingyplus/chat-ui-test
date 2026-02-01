import 'package:equatable/equatable.dart';

class Contact extends Equatable {
  const Contact({
    required this.id,
    required this.name,
    this.avatarAsset,
  });

  final int id;
  final String name;
  final String? avatarAsset;

  @override
  List<Object?> get props => [id, name, avatarAsset];
}

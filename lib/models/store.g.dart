// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreAdapter extends TypeAdapter<Store> {
  @override
  final int typeId = 0;

  @override
  Store read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Store(
      authToken: fields[0] == null ? '' : fields[0] as String,
      onboardingCompleted: fields[1] == null ? false : fields[1] as bool,
      showUpdateProfilePopup: fields[2] == null ? false : fields[2] as bool,
      username: fields[3] == null ? '' : fields[3] as String,
      savedAddresses:
          fields[4] == null ? [] : (fields[4] as List).cast<dynamic>(),
      userEmail: fields[5] == null ? '' : fields[5] as String,
      preferredPaymentMode: fields[6] == null ? 0 : fields[6] as int,
      fcmTokenStored: fields[7] == null ? false : fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Store obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.authToken)
      ..writeByte(1)
      ..write(obj.onboardingCompleted)
      ..writeByte(2)
      ..write(obj.showUpdateProfilePopup)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.savedAddresses)
      ..writeByte(5)
      ..write(obj.userEmail)
      ..writeByte(6)
      ..write(obj.preferredPaymentMode)
      ..writeByte(7)
      ..write(obj.fcmTokenStored);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

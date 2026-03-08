/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'billet.dart' as _i2;
import 'cinema.dart' as _i3;
import 'code_promo.dart' as _i4;
import 'demande_support.dart' as _i5;
import 'faq.dart' as _i6;
import 'favori.dart' as _i7;
import 'film.dart' as _i8;
import 'greetings/greeting.dart' as _i9;
import 'paiement.dart' as _i10;
import 'reservation.dart' as _i11;
import 'reservation_siege.dart' as _i12;
import 'salle.dart' as _i13;
import 'seance.dart' as _i14;
import 'siege.dart' as _i15;
import 'utilisateur.dart' as _i16;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i17;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i18;
export 'billet.dart';
export 'cinema.dart';
export 'code_promo.dart';
export 'demande_support.dart';
export 'faq.dart';
export 'favori.dart';
export 'film.dart';
export 'greetings/greeting.dart';
export 'paiement.dart';
export 'reservation.dart';
export 'reservation_siege.dart';
export 'salle.dart';
export 'seance.dart';
export 'siege.dart';
export 'utilisateur.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Billet) {
      return _i2.Billet.fromJson(data) as T;
    }
    if (t == _i3.Cinema) {
      return _i3.Cinema.fromJson(data) as T;
    }
    if (t == _i4.CodePromo) {
      return _i4.CodePromo.fromJson(data) as T;
    }
    if (t == _i5.DemandeSupport) {
      return _i5.DemandeSupport.fromJson(data) as T;
    }
    if (t == _i6.Faq) {
      return _i6.Faq.fromJson(data) as T;
    }
    if (t == _i7.Favori) {
      return _i7.Favori.fromJson(data) as T;
    }
    if (t == _i8.Film) {
      return _i8.Film.fromJson(data) as T;
    }
    if (t == _i9.Greeting) {
      return _i9.Greeting.fromJson(data) as T;
    }
    if (t == _i10.Paiement) {
      return _i10.Paiement.fromJson(data) as T;
    }
    if (t == _i11.Reservation) {
      return _i11.Reservation.fromJson(data) as T;
    }
    if (t == _i12.ReservationSiege) {
      return _i12.ReservationSiege.fromJson(data) as T;
    }
    if (t == _i13.Salle) {
      return _i13.Salle.fromJson(data) as T;
    }
    if (t == _i14.Seance) {
      return _i14.Seance.fromJson(data) as T;
    }
    if (t == _i15.Siege) {
      return _i15.Siege.fromJson(data) as T;
    }
    if (t == _i16.Utilisateur) {
      return _i16.Utilisateur.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Billet?>()) {
      return (data != null ? _i2.Billet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Cinema?>()) {
      return (data != null ? _i3.Cinema.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CodePromo?>()) {
      return (data != null ? _i4.CodePromo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.DemandeSupport?>()) {
      return (data != null ? _i5.DemandeSupport.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Faq?>()) {
      return (data != null ? _i6.Faq.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Favori?>()) {
      return (data != null ? _i7.Favori.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Film?>()) {
      return (data != null ? _i8.Film.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Greeting?>()) {
      return (data != null ? _i9.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Paiement?>()) {
      return (data != null ? _i10.Paiement.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Reservation?>()) {
      return (data != null ? _i11.Reservation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ReservationSiege?>()) {
      return (data != null ? _i12.ReservationSiege.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Salle?>()) {
      return (data != null ? _i13.Salle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Seance?>()) {
      return (data != null ? _i14.Seance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Siege?>()) {
      return (data != null ? _i15.Siege.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Utilisateur?>()) {
      return (data != null ? _i16.Utilisateur.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    try {
      return _i17.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i18.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Billet => 'Billet',
      _i3.Cinema => 'Cinema',
      _i4.CodePromo => 'CodePromo',
      _i5.DemandeSupport => 'DemandeSupport',
      _i6.Faq => 'Faq',
      _i7.Favori => 'Favori',
      _i8.Film => 'Film',
      _i9.Greeting => 'Greeting',
      _i10.Paiement => 'Paiement',
      _i11.Reservation => 'Reservation',
      _i12.ReservationSiege => 'ReservationSiege',
      _i13.Salle => 'Salle',
      _i14.Seance => 'Seance',
      _i15.Siege => 'Siege',
      _i16.Utilisateur => 'Utilisateur',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'cine_reservation.',
        '',
      );
    }

    switch (data) {
      case _i2.Billet():
        return 'Billet';
      case _i3.Cinema():
        return 'Cinema';
      case _i4.CodePromo():
        return 'CodePromo';
      case _i5.DemandeSupport():
        return 'DemandeSupport';
      case _i6.Faq():
        return 'Faq';
      case _i7.Favori():
        return 'Favori';
      case _i8.Film():
        return 'Film';
      case _i9.Greeting():
        return 'Greeting';
      case _i10.Paiement():
        return 'Paiement';
      case _i11.Reservation():
        return 'Reservation';
      case _i12.ReservationSiege():
        return 'ReservationSiege';
      case _i13.Salle():
        return 'Salle';
      case _i14.Seance():
        return 'Seance';
      case _i15.Siege():
        return 'Siege';
      case _i16.Utilisateur():
        return 'Utilisateur';
    }
    className = _i17.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i18.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Billet') {
      return deserialize<_i2.Billet>(data['data']);
    }
    if (dataClassName == 'Cinema') {
      return deserialize<_i3.Cinema>(data['data']);
    }
    if (dataClassName == 'CodePromo') {
      return deserialize<_i4.CodePromo>(data['data']);
    }
    if (dataClassName == 'DemandeSupport') {
      return deserialize<_i5.DemandeSupport>(data['data']);
    }
    if (dataClassName == 'Faq') {
      return deserialize<_i6.Faq>(data['data']);
    }
    if (dataClassName == 'Favori') {
      return deserialize<_i7.Favori>(data['data']);
    }
    if (dataClassName == 'Film') {
      return deserialize<_i8.Film>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i9.Greeting>(data['data']);
    }
    if (dataClassName == 'Paiement') {
      return deserialize<_i10.Paiement>(data['data']);
    }
    if (dataClassName == 'Reservation') {
      return deserialize<_i11.Reservation>(data['data']);
    }
    if (dataClassName == 'ReservationSiege') {
      return deserialize<_i12.ReservationSiege>(data['data']);
    }
    if (dataClassName == 'Salle') {
      return deserialize<_i13.Salle>(data['data']);
    }
    if (dataClassName == 'Seance') {
      return deserialize<_i14.Seance>(data['data']);
    }
    if (dataClassName == 'Siege') {
      return deserialize<_i15.Siege>(data['data']);
    }
    if (dataClassName == 'Utilisateur') {
      return deserialize<_i16.Utilisateur>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i17.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i18.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i17.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i18.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

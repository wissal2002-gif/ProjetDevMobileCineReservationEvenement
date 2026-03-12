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
import 'avis.dart' as _i2;
import 'billet.dart' as _i3;
import 'cinema.dart' as _i4;
import 'code_promo.dart' as _i5;
import 'demande_support.dart' as _i6;
import 'evenement.dart' as _i7;
import 'faq.dart' as _i8;
import 'favori.dart' as _i9;
import 'fidelite.dart' as _i10;
import 'film.dart' as _i11;
import 'greetings/greeting.dart' as _i12;
import 'option supplementaire.dart' as _i13;
import 'paiement.dart' as _i14;
import 'remboursement.dart' as _i15;
import 'reservation option.dart' as _i16;
import 'reservation.dart' as _i17;
import 'reservation_siege.dart' as _i18;
import 'salle.dart' as _i19;
import 'seance.dart' as _i20;
import 'siege.dart' as _i21;
import 'utilisateur.dart' as _i22;
import 'package:cine_reservation_client/src/protocol/film.dart' as _i23;
import 'package:cine_reservation_client/src/protocol/cinema.dart' as _i24;
import 'package:cine_reservation_client/src/protocol/salle.dart' as _i25;
import 'package:cine_reservation_client/src/protocol/siege.dart' as _i26;
import 'package:cine_reservation_client/src/protocol/seance.dart' as _i27;
import 'package:cine_reservation_client/src/protocol/utilisateur.dart' as _i28;
import 'package:cine_reservation_client/src/protocol/reservation.dart' as _i29;
import 'package:cine_reservation_client/src/protocol/evenement.dart' as _i30;
import 'package:cine_reservation_client/src/protocol/demande_support.dart'
    as _i31;
import 'package:cine_reservation_client/src/protocol/option%20supplementaire.dart'
    as _i32;
import 'package:cine_reservation_client/src/protocol/code_promo.dart' as _i33;
import 'package:cine_reservation_client/src/protocol/faq.dart' as _i34;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i35;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i36;
export 'avis.dart';
export 'billet.dart';
export 'cinema.dart';
export 'code_promo.dart';
export 'demande_support.dart';
export 'evenement.dart';
export 'faq.dart';
export 'favori.dart';
export 'fidelite.dart';
export 'film.dart';
export 'greetings/greeting.dart';
export 'option supplementaire.dart';
export 'paiement.dart';
export 'remboursement.dart';
export 'reservation option.dart';
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

    if (t == _i2.Avis) {
      return _i2.Avis.fromJson(data) as T;
    }
    if (t == _i3.Billet) {
      return _i3.Billet.fromJson(data) as T;
    }
    if (t == _i4.Cinema) {
      return _i4.Cinema.fromJson(data) as T;
    }
    if (t == _i5.CodePromo) {
      return _i5.CodePromo.fromJson(data) as T;
    }
    if (t == _i6.DemandeSupport) {
      return _i6.DemandeSupport.fromJson(data) as T;
    }
    if (t == _i7.Evenement) {
      return _i7.Evenement.fromJson(data) as T;
    }
    if (t == _i8.Faq) {
      return _i8.Faq.fromJson(data) as T;
    }
    if (t == _i9.Favori) {
      return _i9.Favori.fromJson(data) as T;
    }
    if (t == _i10.Fidelite) {
      return _i10.Fidelite.fromJson(data) as T;
    }
    if (t == _i11.Film) {
      return _i11.Film.fromJson(data) as T;
    }
    if (t == _i12.Greeting) {
      return _i12.Greeting.fromJson(data) as T;
    }
    if (t == _i13.OptionSupplementaire) {
      return _i13.OptionSupplementaire.fromJson(data) as T;
    }
    if (t == _i14.Paiement) {
      return _i14.Paiement.fromJson(data) as T;
    }
    if (t == _i15.Remboursement) {
      return _i15.Remboursement.fromJson(data) as T;
    }
    if (t == _i16.ReservationOption) {
      return _i16.ReservationOption.fromJson(data) as T;
    }
    if (t == _i17.Reservation) {
      return _i17.Reservation.fromJson(data) as T;
    }
    if (t == _i18.ReservationSiege) {
      return _i18.ReservationSiege.fromJson(data) as T;
    }
    if (t == _i19.Salle) {
      return _i19.Salle.fromJson(data) as T;
    }
    if (t == _i20.Seance) {
      return _i20.Seance.fromJson(data) as T;
    }
    if (t == _i21.Siege) {
      return _i21.Siege.fromJson(data) as T;
    }
    if (t == _i22.Utilisateur) {
      return _i22.Utilisateur.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Avis?>()) {
      return (data != null ? _i2.Avis.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Billet?>()) {
      return (data != null ? _i3.Billet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Cinema?>()) {
      return (data != null ? _i4.Cinema.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CodePromo?>()) {
      return (data != null ? _i5.CodePromo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.DemandeSupport?>()) {
      return (data != null ? _i6.DemandeSupport.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Evenement?>()) {
      return (data != null ? _i7.Evenement.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Faq?>()) {
      return (data != null ? _i8.Faq.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Favori?>()) {
      return (data != null ? _i9.Favori.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Fidelite?>()) {
      return (data != null ? _i10.Fidelite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Film?>()) {
      return (data != null ? _i11.Film.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Greeting?>()) {
      return (data != null ? _i12.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.OptionSupplementaire?>()) {
      return (data != null ? _i13.OptionSupplementaire.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.Paiement?>()) {
      return (data != null ? _i14.Paiement.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Remboursement?>()) {
      return (data != null ? _i15.Remboursement.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.ReservationOption?>()) {
      return (data != null ? _i16.ReservationOption.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Reservation?>()) {
      return (data != null ? _i17.Reservation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ReservationSiege?>()) {
      return (data != null ? _i18.ReservationSiege.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Salle?>()) {
      return (data != null ? _i19.Salle.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Seance?>()) {
      return (data != null ? _i20.Seance.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.Siege?>()) {
      return (data != null ? _i21.Siege.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Utilisateur?>()) {
      return (data != null ? _i22.Utilisateur.fromJson(data) : null) as T;
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
    if (t == List<_i23.Film>) {
      return (data as List).map((e) => deserialize<_i23.Film>(e)).toList() as T;
    }
    if (t == List<_i24.Cinema>) {
      return (data as List).map((e) => deserialize<_i24.Cinema>(e)).toList()
          as T;
    }
    if (t == List<_i25.Salle>) {
      return (data as List).map((e) => deserialize<_i25.Salle>(e)).toList()
          as T;
    }
    if (t == List<_i26.Siege>) {
      return (data as List).map((e) => deserialize<_i26.Siege>(e)).toList()
          as T;
    }
    if (t == List<_i27.Seance>) {
      return (data as List).map((e) => deserialize<_i27.Seance>(e)).toList()
          as T;
    }
    if (t == List<_i28.Utilisateur>) {
      return (data as List)
              .map((e) => deserialize<_i28.Utilisateur>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.Reservation>) {
      return (data as List)
              .map((e) => deserialize<_i29.Reservation>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.Evenement>) {
      return (data as List).map((e) => deserialize<_i30.Evenement>(e)).toList()
          as T;
    }
    if (t == List<_i31.DemandeSupport>) {
      return (data as List)
              .map((e) => deserialize<_i31.DemandeSupport>(e))
              .toList()
          as T;
    }
    if (t == List<_i32.OptionSupplementaire>) {
      return (data as List)
              .map((e) => deserialize<_i32.OptionSupplementaire>(e))
              .toList()
          as T;
    }
    if (t == List<_i33.CodePromo>) {
      return (data as List).map((e) => deserialize<_i33.CodePromo>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_i34.Faq>) {
      return (data as List).map((e) => deserialize<_i34.Faq>(e)).toList() as T;
    }
    try {
      return _i35.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i36.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Avis => 'Avis',
      _i3.Billet => 'Billet',
      _i4.Cinema => 'Cinema',
      _i5.CodePromo => 'CodePromo',
      _i6.DemandeSupport => 'DemandeSupport',
      _i7.Evenement => 'Evenement',
      _i8.Faq => 'Faq',
      _i9.Favori => 'Favori',
      _i10.Fidelite => 'Fidelite',
      _i11.Film => 'Film',
      _i12.Greeting => 'Greeting',
      _i13.OptionSupplementaire => 'OptionSupplementaire',
      _i14.Paiement => 'Paiement',
      _i15.Remboursement => 'Remboursement',
      _i16.ReservationOption => 'ReservationOption',
      _i17.Reservation => 'Reservation',
      _i18.ReservationSiege => 'ReservationSiege',
      _i19.Salle => 'Salle',
      _i20.Seance => 'Seance',
      _i21.Siege => 'Siege',
      _i22.Utilisateur => 'Utilisateur',
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
      case _i2.Avis():
        return 'Avis';
      case _i3.Billet():
        return 'Billet';
      case _i4.Cinema():
        return 'Cinema';
      case _i5.CodePromo():
        return 'CodePromo';
      case _i6.DemandeSupport():
        return 'DemandeSupport';
      case _i7.Evenement():
        return 'Evenement';
      case _i8.Faq():
        return 'Faq';
      case _i9.Favori():
        return 'Favori';
      case _i10.Fidelite():
        return 'Fidelite';
      case _i11.Film():
        return 'Film';
      case _i12.Greeting():
        return 'Greeting';
      case _i13.OptionSupplementaire():
        return 'OptionSupplementaire';
      case _i14.Paiement():
        return 'Paiement';
      case _i15.Remboursement():
        return 'Remboursement';
      case _i16.ReservationOption():
        return 'ReservationOption';
      case _i17.Reservation():
        return 'Reservation';
      case _i18.ReservationSiege():
        return 'ReservationSiege';
      case _i19.Salle():
        return 'Salle';
      case _i20.Seance():
        return 'Seance';
      case _i21.Siege():
        return 'Siege';
      case _i22.Utilisateur():
        return 'Utilisateur';
    }
    className = _i35.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i36.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Avis') {
      return deserialize<_i2.Avis>(data['data']);
    }
    if (dataClassName == 'Billet') {
      return deserialize<_i3.Billet>(data['data']);
    }
    if (dataClassName == 'Cinema') {
      return deserialize<_i4.Cinema>(data['data']);
    }
    if (dataClassName == 'CodePromo') {
      return deserialize<_i5.CodePromo>(data['data']);
    }
    if (dataClassName == 'DemandeSupport') {
      return deserialize<_i6.DemandeSupport>(data['data']);
    }
    if (dataClassName == 'Evenement') {
      return deserialize<_i7.Evenement>(data['data']);
    }
    if (dataClassName == 'Faq') {
      return deserialize<_i8.Faq>(data['data']);
    }
    if (dataClassName == 'Favori') {
      return deserialize<_i9.Favori>(data['data']);
    }
    if (dataClassName == 'Fidelite') {
      return deserialize<_i10.Fidelite>(data['data']);
    }
    if (dataClassName == 'Film') {
      return deserialize<_i11.Film>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i12.Greeting>(data['data']);
    }
    if (dataClassName == 'OptionSupplementaire') {
      return deserialize<_i13.OptionSupplementaire>(data['data']);
    }
    if (dataClassName == 'Paiement') {
      return deserialize<_i14.Paiement>(data['data']);
    }
    if (dataClassName == 'Remboursement') {
      return deserialize<_i15.Remboursement>(data['data']);
    }
    if (dataClassName == 'ReservationOption') {
      return deserialize<_i16.ReservationOption>(data['data']);
    }
    if (dataClassName == 'Reservation') {
      return deserialize<_i17.Reservation>(data['data']);
    }
    if (dataClassName == 'ReservationSiege') {
      return deserialize<_i18.ReservationSiege>(data['data']);
    }
    if (dataClassName == 'Salle') {
      return deserialize<_i19.Salle>(data['data']);
    }
    if (dataClassName == 'Seance') {
      return deserialize<_i20.Seance>(data['data']);
    }
    if (dataClassName == 'Siege') {
      return deserialize<_i21.Siege>(data['data']);
    }
    if (dataClassName == 'Utilisateur') {
      return deserialize<_i22.Utilisateur>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i35.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i36.Protocol().deserializeByClassName(data);
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
      return _i35.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i36.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

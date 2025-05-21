// part of 'location_cubit.dart';

// class LocationState extends Equatable {
//   final String? name;
//   final String? street;
//   final String? subLocality;
//   final String? postalCode;
//   final String? locality;
//   final String? administrativeArea;
//   final String? lattitude;
//   final String? longitude;
//   bool serviceEnabled;
//   bool permission;
//   LocationState(
//       {this.name,
//       this.street,
//       this.subLocality,
//       this.postalCode,
//       this.locality,
//       this.administrativeArea,
//       this.lattitude,
//       this.longitude,
//       this.serviceEnabled = false,
//       this.permission = false});

//   factory LocationState.initial() {
//     return LocationState();
//   }

//   LocationState copyWith(
//       {String? name,
//       String? street,
//       String? subLocality,
//       String? postalCode,
//       String? locality,
//       String? administrativeArea,
//       String? lattitude,
//       String? longitude,
//       bool? serviceEnabled,
//       bool? permission}) {
//     return LocationState(
//         name: name ?? this.name,
//         street: street ?? this.street,
//         subLocality: subLocality ?? this.subLocality,
//         postalCode: postalCode ?? this.postalCode,
//         locality: locality ?? this.locality,
//         administrativeArea: administrativeArea ?? this.administrativeArea,
//         lattitude: lattitude ?? this.lattitude,
//         longitude: longitude ?? this.longitude,
//         serviceEnabled: serviceEnabled ?? this.serviceEnabled,
//         permission: permission ?? this.permission);
//   }

//   @override
//   List<Object?> get props => [
//         name,
//         street,
//         subLocality,
//         postalCode,
//         locality,
//         administrativeArea,
//         lattitude,
//         longitude,
//         serviceEnabled,
//         permission
//       ];

//   @override
//   String toString() {
//     return 'LocationState{'
//         'name: $name, '
//         'street: $street, '
//         'subLocality: $subLocality, '
//         'postalCode: $postalCode, '
//         'locality: $locality, '
//         'administrativeArea: $administrativeArea, '
//         'lattitude: $lattitude, '
//         'longitude: $longitude, '
//         'serviceEnabled: $serviceEnabled, '
//         'permission: $permission'
//         '}';
//   }
// }

import 'package:football_ticket/models/match_model.dart';
import 'package:football_ticket/models/stand_model.dart';
import 'package:football_ticket/models/accessory_model.dart';

class MatchDetailsModel {
  final String idMatch;
  final MatchModel match;
  final List<StandModel> stand;
  final String? mapImageUrl; // ảnh sơ đồ từ BE
  final String? mapUrl; // url mở Google Maps
  final List<AccessoryModel> accessories;

  MatchDetailsModel({
    required this.idMatch,
    required this.match,
    required this.stand,
    this.mapImageUrl,
    this.mapUrl,
    this.accessories = const [],
  });

  factory MatchDetailsModel.mock(MatchModel match) {
    return MatchDetailsModel(
      idMatch: match.matchId.toString(),
      match: match,
      stand: const [],
      mapImageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Football_pitch.svg/640px-Football_pitch.svg.png',
      mapUrl: 'https://maps.google.com/?q=10.806,106.664',
      accessories: const [
        AccessoryModel(
          id: '1',
          name: 'Drinking water',
          price: 20000,
          imageUrl:
              'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=640',
          categoryId: "1",
        ),
        AccessoryModel(
          id: '2',
          name: 'Drinking water',
          price: 20000,
          imageUrl:
              'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=640',
          categoryId: "1",
        ),
        AccessoryModel(
          id: '3',
          name: 'Drinking water',
          price: 20000,
          imageUrl:
              'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=640',
          categoryId: "1",
        ),
        AccessoryModel(
          id: '4',
          name: 'Drinking water',
          price: 20000,
          imageUrl:
              'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=640',
          categoryId: "1",
        ),
      ],
    );
  }
}

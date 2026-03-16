import 'package:domain/domain.dart';
import 'collection_view_model.dart';

class StaticCollections {
  static final List<CollectionViewModel> collections = [
    const CollectionViewModel(
      id: '1',
      name: LocalizedName(
        ru: 'Рядом с Ташкентом',
        en: 'Near Tashkent',
        uz: 'Toshkent yaqinida',
      ),
      locations: [
        Location(
          id: '6892ea1d-1e24-4656-8bcf-1762bb8042ae',
          name: LocalizedName(
            en: 'Greater Chimgan',
            ru: 'Большой Чимган',
            uz: 'Katta chimyon',
          ),
          type: LocationType.peak,
          description: LocationDescription(
            en: 'Is a mountain of the Western Tien Shan. This large dome-shaped mountain range is part of the Chatkal Range. It is located in the Ugam-Chatkal National Nature Park of Uzbekistan.',
            ru: 'Является горой Западного Тянь-Шаня. Этот крупный куполообразный горный массив входит в состав Чаткальского хребта. Располагается в Угам-Чаткальском национальном природном парке Узбекистана.(Истинный пик)',
            uz: 'G\'arbiy Tyan-Shan tog\'idir. Bu katta gumbaz shaklidagi togʻtizmasi Chotqol tizmasining bir qismidir. U Oʻzbekistonning Ugom-Chotqol milliy tabiat bogʻida joylashgan.',
          ),
          elevation: 3309.0,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 70.0586718, lat: 41.49519),
          gallery: [
            '0dd924af-4588-42f2-aebe-493c668a2c23',
            '5a573db5-e530-4cb0-80c8-09c5bfe6ed1d',
            '5d11e262-64d6-42c6-94b0-405d870f2cc7',
          ],
        ),
        Location(
          id: '8412ac7b-6562-4066-93fc-56586b198d37',
          name: LocalizedName(en: 'Obzornaya', ru: 'Обзорная', uz: 'Obzornaya'),
          type: LocationType.peak,
          description: LocationDescription(),
          elevation: 2169.0,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 69.8982168, lat: 41.3194618),
        ),
        Location(
          id: '17f61328-24db-4ebf-be52-5bc427af923a',
          name: LocalizedName(
            en: 'Shahkurkan',
            ru: 'Шахкурган',
            uz: 'Shakhkurgan',
          ),
          type: LocationType.peak,
          description: LocationDescription(),
          elevation: 2025.2,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 69.8394328, lat: 41.2548458),
        ),
        Location(
          id: 'b5d9dade-8ed9-4343-b127-6a9bf9f96a2d',
          name: LocalizedName(
            en: 'Paltau',
            ru: 'Пальтау',
            uz: 'Vodopad Paltau',
          ),
          type: LocationType.waterfall,
          description: LocationDescription(),
          geometryType: 'Point',
          coordinates: PointCoords(lng: 70.1466954, lat: 41.571394),
          gallery: [
            'e8524547-f3a7-4729-ac96-0d30ff70b424',
            'a3d3073f-e721-485e-823a-6aa071693de1',
            'c68bbf68-f9ae-4fc3-851b-cd3a16ec7d0d',
          ],
        ),
        Location(
          id: '26618166-59e9-462a-af18-5610a71adc3d',
          name: LocalizedName(
            en: 'Big Tavaksay',
            ru: 'Большой Таваксай',
            uz: 'Katta Tovoqsoy',
          ),
          type: LocationType.waterfall,
          description: LocationDescription(),
          geometryType: 'Point',
          coordinates: PointCoords(lng: 69.6416912, lat: 41.614236),
        ),
      ],
    ),
    const CollectionViewModel(
      id: '2',
      name: LocalizedName(
        ru: 'Рядом с Самаркандом',
        en: 'Near Samarkand',
        uz: 'Samarkand yaqinida',
      ),
      locations: [
        Location(
          id: 'b1b05f4b-ac01-49de-a163-d4c0e7ce48ab',
          name: LocalizedName(
            en: 'Hoja Gur-Gur Ota',
            ru: 'Ходжа Гур-Гур Ота',
            uz: 'Xo\'ja Gur-Gur Ota',
          ),
          type: LocationType.peak,
          description: LocationDescription(),
          elevation: 3797.0,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 67.3440061, lat: 38.4366758),
        ),
        Location(
          id: 'f3925c36-bb50-44f8-9fcc-d56f128e39c7',
          name: LocalizedName(
            en: 'The Cave of David',
            ru: 'Хазрат Дауд',
            uz: 'Hazrati Dovud g\'ori',
          ),
          type: LocationType.cave,
          description: LocationDescription(),
          elevation: 1269.0,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 66.6138055, lat: 39.4987454),
        ),
        Location(
          id: '19ec332a-1d70-4d59-af52-acd1174a1240',
          name: LocalizedName(
            en: 'Kanbesh-bulak',
            ru: 'Канбеш-булак',
            uz: 'Qanbesh-buloq',
          ),
          type: LocationType.lake,
          description: LocationDescription(),
          geometryType: 'Polygon',
          coordinates: PolygonCoords(
            rings: [
              [
                [67.1639309, 39.7067894],
                [67.1639738, 39.7068072],
                [67.1640167, 39.7068072],
                [67.1641669, 39.7067361],
                [67.1642955, 39.7066117],
                [67.1643813, 39.7064517],
              ],
            ],
          ),
        ),
        Location(
          id: 'b6f7da85-4da7-4249-ab3a-43bc42adaf72',
          name: LocalizedName(en: 'Kattakul', ru: 'Катакуль', uz: 'Kattako\'l'),
          type: LocationType.lake,
          description: LocationDescription(),
          geometryType: 'Polygon',
          coordinates: PolygonCoords(
            rings: [
              [
                [67.1344994, 39.342065],
                [67.1346474, 39.3418711],
                [67.1347847, 39.3416878],
                [67.1349113, 39.3414939],
              ],
            ],
          ),
        ),
      ],
    ),
    const CollectionViewModel(
      id: '3',
      name: LocalizedName(ru: 'В облаках', en: 'Top Peak', uz: 'Bulutlarda'),
      locations: [
        Location(
          id: 'a754d6d4-81a1-4d53-bc71-3503ae0bb887',
          name: LocalizedName(en: 'Karakush', ru: 'Каракуш', uz: 'Karakush'),
          type: LocationType.peak,
          description: LocationDescription(),
          elevation: 3864.3,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 70.3391467, lat: 41.247789),
        ),
        Location(
          id: 'b1b05f4b-ac01-49de-a163-d4c0e7ce48ab',
          name: LocalizedName(
            en: 'Hoja Gur-Gur Ota',
            ru: 'Ходжа Гур-Гур Ота',
            uz: 'Xo\'ja Gur-Gur Ota',
          ),
          type: LocationType.peak,
          description: LocationDescription(),
          elevation: 3797.0,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 67.3440061, lat: 38.4366758),
        ),
        Location(
          id: 'ccb64b46-2941-4314-8500-529ad73d70b3',
          name: LocalizedName(en: 'Babaytag', ru: 'Бабайтаг', uz: 'Babaytag'),
          type: LocationType.peak,
          description: LocationDescription(),
          elevation: 3555.7,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 70.223266, lat: 41.154965),
        ),
        Location(
          id: '17e0c5b2-a7c3-440b-bf73-4ef31dea3016',
          name: LocalizedName(en: 'Chadak', ru: 'Чадак', uz: 'Chadak'),
          type: LocationType.peak,
          description: LocationDescription(),
          elevation: 3539.4,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 70.2478312, lat: 41.7029237),
        ),
      ],
    ),
    const CollectionViewModel(
      id: '4',
      name: LocalizedName(
        ru: 'Для новичков',
        en: 'Newbie',
        uz: 'Yangi boshlovchi',
      ),
      locations: [
        Location(
          id: '26618166-59e9-462a-af18-5610a71adc3d',
          name: LocalizedName(
            en: 'Big Tavaksay',
            ru: 'Большой Таваксай',
            uz: 'Katta Tovoqsoy',
          ),
          type: LocationType.waterfall,
          description: LocationDescription(),
          geometryType: 'Point',
          coordinates: PointCoords(lng: 69.6416912, lat: 41.614236),
        ),
        Location(
          id: '75fcd0e1-8324-4d3d-b096-ec7184dd9b3a',
          name: LocalizedName(
            en: 'Lettle Chimgan',
            ru: 'Малый Чимган',
            uz: 'Kichik Chimgan',
          ),
          type: LocationType.peak,
          description: LocationDescription(),
          elevation: 2097.6,
          geometryType: 'Point',
          coordinates: PointCoords(lng: 70.0405609, lat: 41.5525032),
        ),
        Location(
          id: '19ec332a-1d70-4d59-af52-acd1174a1240',
          name: LocalizedName(
            en: 'Kanbesh-bulak',
            ru: 'Канбеш-булак',
            uz: 'Qanbesh-buloq',
          ),
          type: LocationType.lake,
          description: LocationDescription(),
          geometryType: 'Polygon',
          coordinates: PolygonCoords(
            rings: [
              [
                [67.1639309, 39.7067894],
                [67.1639738, 39.7068072],
                [67.1640167, 39.7068072],
                [67.1641669, 39.7067361],
                [67.1642955, 39.7066117],
                [67.1643813, 39.7064517],
              ],
            ],
          ),
        ),
        Location(
          id: '4e324347-76dd-48d2-b202-4bd08fcdcfaf',
          name: LocalizedName(en: 'Obipar', ru: 'Обипар', uz: 'Obipar'),
          type: LocationType.waterfall,
          description: LocationDescription(),
          geometryType: 'Point',
          coordinates: PointCoords(lng: 70.1786713, lat: 41.7876461),
        ),
      ],
    ),
  ];
}

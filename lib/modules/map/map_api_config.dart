enum MapProvider {
  openStreetMap,
  openStreetMapDE,
  openStreetMapFrance,
  openStreetMapHot,
  openCycleMap,
  thunderforestCycle,
  thunderforestOutdoors,
  openTopoMap,
  cartoDbLight,
  cartoDbDark,
  cartoDbVoyager,
  esriSatellite,
  esriTopo,
  stamenTerrain,
  stamenWatercolor,
  stamenToner,
  mapboxStreets,
  mapboxSatellite,
  mapboxOutdoors,
}

class MapApiConfig {
  static const String thunderforestApiKey =
      String.fromEnvironment('THUNDERFOREST_API_KEY');
  static const String stadiaMapApiKey =
      String.fromEnvironment('STADIA_MAP_API_KEY');
  static const String mapboxApiKey =
      String.fromEnvironment('MAPBOX_API_KEY');

  static const MapProvider defaultMapProvider = MapProvider.mapboxOutdoors;

  /// Получить URL для тайлов по типу карты
  static String getTileUrl(MapProvider provider) {
    switch (provider) {
      case MapProvider.openStreetMap:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case MapProvider.openStreetMapDE:
        return 'https://tile.openstreetmap.de/{z}/{x}/{y}.png';
      case MapProvider.openStreetMapFrance:
        return 'https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png';
      case MapProvider.openStreetMapHot:
        return 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png';
      case MapProvider.openCycleMap:
        return 'https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png';
      case MapProvider.thunderforestCycle:
        return 'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=$thunderforestApiKey';
      case MapProvider.thunderforestOutdoors:
        return 'https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=$thunderforestApiKey';
      case MapProvider.openTopoMap:
        return 'https://tile.opentopomap.org/{z}/{x}/{y}.png';
      case MapProvider.cartoDbLight:
        return 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png';
      case MapProvider.cartoDbDark:
        return 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';
      case MapProvider.cartoDbVoyager:
        return 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png';
      case MapProvider.esriSatellite:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case MapProvider.esriTopo:
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}';
      case MapProvider.stamenTerrain:
        return 'https://tiles.stadiamaps.com/tiles/stamen_terrain/{z}/{x}/{y}.png?api_key=$stadiaMapApiKey';
      case MapProvider.stamenWatercolor:
        return 'https://tiles.stadiamaps.com/tiles/stamen_watercolor/{z}/{x}/{y}.png?api_key=$stadiaMapApiKey';
      case MapProvider.stamenToner:
        return 'https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}.png?api_key=$stadiaMapApiKey';
      case MapProvider.mapboxStreets:
        return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=$mapboxApiKey';
      case MapProvider.mapboxSatellite:
        return 'https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/{z}/{x}/{y}?access_token=$mapboxApiKey';
      case MapProvider.mapboxOutdoors:
        return 'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/{z}/{x}/{y}?access_token=$mapboxApiKey';
    }
  }

  /// Названия провайдеров карт
  static const Map<MapProvider, String> mapProviderNames = {
    MapProvider.openStreetMap: 'OpenStreetMap',
    MapProvider.openStreetMapDE: 'OpenStreetMap DE',
    MapProvider.openStreetMapFrance: 'OpenStreetMap France',
    MapProvider.openStreetMapHot: 'OpenStreetMap HOT',
    MapProvider.openCycleMap: 'CyclOSM (OpenStreetMap)',
    MapProvider.thunderforestCycle: 'Cycle Map (Thunderforest)',
    MapProvider.thunderforestOutdoors: 'Outdoors (Thunderforest)',
    MapProvider.openTopoMap: 'OpenTopoMap',
    MapProvider.cartoDbLight: 'CartoDB Light',
    MapProvider.cartoDbDark: 'CartoDB Dark',
    MapProvider.cartoDbVoyager: 'CartoDB Voyager',
    MapProvider.esriSatellite: 'Esri Satellite',
    MapProvider.esriTopo: 'Esri Topographic',
    MapProvider.stamenTerrain: 'Stamen Terrain',
    MapProvider.stamenWatercolor: 'Stamen Watercolor',
    MapProvider.stamenToner: 'Stamen Toner',
    MapProvider.mapboxStreets: 'Mapbox Streets',
    MapProvider.mapboxSatellite: 'Mapbox Satellite',
    MapProvider.mapboxOutdoors: 'Mapbox Outdoors',
  };
}

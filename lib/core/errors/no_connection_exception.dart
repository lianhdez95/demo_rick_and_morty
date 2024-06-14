class NoConnectionException implements Exception {
  final String message;

  NoConnectionException([this.message = "No hay conexión a internet"]);

  @override
  String toString() => message;
}
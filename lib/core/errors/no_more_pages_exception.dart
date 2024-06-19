class NoMorePagesException implements Exception{
  final String message;

  NoMorePagesException([this.message = "No hay más páginas disponibles"]);

  @override
  String toString() => message;
}
///
/// Vyjimka: chyba syntaxe
///
class SyntaxException implements Exception
{
  final dynamic message;

  SyntaxException([this.message]);

  @override
  String toString()
  {
    return (message == null) ? 'SyntaxException' : 'SyntaxException: $message';
  }
}
import 'WordParser.dart';

class MatchWord
{
  String text;
  int type;
  late MatchWord prev, next;

  MatchWord(this.text, this.type)
  {
    prev = this;
    next = this;
  }

  void add(MatchWord word)
  {
    word.prev = this;
    word.next = this.next;
    this.next.prev = word;
    this.next = word;
  }

  void remove()
  {
    this.next.prev = this.prev;
    this.prev.next = this.next;
    this.prev = this;
    this.next = this;
  }

  @override
  String toString()
  {
    var buffer = StringBuffer();
    var word = this;

    do
    {
      if (word.type != WordParser.ROOT)
      {
        if (buffer.length > 0)
        {
          buffer.write(' ');
        }
        buffer.write(word.text);
      }
      word = word.next;
    }
    while (word != this);

    return buffer.toString();
  }
}
import 'package:dart_prep/MatchWord.dart';

/// WordParser - trida pro rozdeleni radku na klicova slova
///
class WordParser
{
    final _regExTypes = <int>[];
    final _regularBuffer = StringBuffer();

    var defines = <String>{};
    // ignore: avoid_init_to_null
    RegExp? _regularExpression = null;

    static const int ROOT = 0;
    static const int DISABLED_LINE_COMMENT = 1;
    static const int LINE_COMMENT = 2;
    static const int IF_STATEMENT = 3;
    static const int ELSE_STATEMENT = 4;
    static const int ELIF_STATEMENT = 5;
    static const int END_STATEMENT = 6;
    static const int DEFINE_STATEMENT = 7;
    static const int WORD = 8;
    static const int DEFINE_TRUE = 9;
    static const int NEG_OPERATOR = 10;
    static const int OR_OPERATOR = 11;
    static const int AND_OPERATOR = 12;
    static const int OPEN_BRACKET = 13;
    static const int CLOSE_BRACKET = 14;
    static const int DEBUG_STATEMENT = 15;
    static const int RELEASE_STATEMENT = 16;
    static const int VERBOSE_STATEMENT = 17;

    static final wordNames =
    {
        ROOT: '[ROOT]',
        DISABLED_LINE_COMMENT: '//##',
        LINE_COMMENT: '//',
        IF_STATEMENT: '#if',
        ELSE_STATEMENT: '#else',
        ELIF_STATEMENT: '#elif',
        END_STATEMENT: '#end',
        DEFINE_STATEMENT: '#define',
        NEG_OPERATOR: '!',
        WORD: '[WORD]',
        DEFINE_TRUE: '[TRUE]',
        OR_OPERATOR: '||',
        AND_OPERATOR: '&&',
        OPEN_BRACKET: '(',
        CLOSE_BRACKET: ')',
        DEBUG_STATEMENT: '#debug',
        RELEASE_STATEMENT: '#release',
        VERBOSE_STATEMENT: '#verbose',
    };


    RegExp get regularExpression
    {
        if (_regularExpression == null)
        {
            _makeRegular();
        }

        return _regularExpression ?? RegExp('');
    }

    void _makeRegularExp(String text,int type)
    {
        if (_regularBuffer.length > 0)
        {
          _regularBuffer.write('|');
        }

        _regularBuffer.write('($text)');
        _regExTypes.add(type);
    }

    void _makeRegular()
    {
        _regExTypes.clear();
        _regularBuffer.clear();


        _makeRegularExp(r'\/\/##', DISABLED_LINE_COMMENT);
        _makeRegularExp(r'//#if\b', IF_STATEMENT);
        _makeRegularExp(r'//#debug\b', DEBUG_STATEMENT);
        _makeRegularExp(r'//#release\b', RELEASE_STATEMENT);
        _makeRegularExp(r'//#verbose\b', VERBOSE_STATEMENT);
        _makeRegularExp(r'//#elif\b', ELIF_STATEMENT);
        _makeRegularExp(r'//#else\b', ELSE_STATEMENT);
        _makeRegularExp(r'//#end\b', END_STATEMENT);
        _makeRegularExp(r'//#define\b|#def\b', DEFINE_STATEMENT);
        _makeRegularExp(r'\/\/', LINE_COMMENT);
        _makeRegularExp(r'\-|\!', NEG_OPERATOR);
        _makeRegularExp(r'\(', OPEN_BRACKET);
        _makeRegularExp(r'\)', CLOSE_BRACKET);
        _makeRegularExp(r'\||\|\|', OR_OPERATOR);
        _makeRegularExp(r'\&|\&\&', AND_OPERATOR);
        _makeRegularExp(r'0', WORD);
        _makeRegularExp(r'false', WORD);
        _makeRegularExp(r'1', DEFINE_TRUE);
        _makeRegularExp(r'true', DEFINE_TRUE);

        for (var def in this.defines)
        {
            _makeRegularExp(def, DEFINE_TRUE);
        }

        _makeRegularExp(r'\b\w+\b', WORD);

        _regularExpression =  RegExp(_regularBuffer.toString());
    }

    void removeDef(String word)
    {
        if (defines.contains(word))
        {
            defines.remove(word);
            _regularExpression = null;
        }
    }

    void addDef(String word)
    {
        if (!defines.contains(word))
        {
            defines.add(word);
            _regularExpression = null;
        }
    }

    Set<String> getDefs()
    {
        var result = <String>{};

        for (var def in defines)
        {
            result.add(def);
        }

        return result;
    }

    WordParser copyDefs(WordParser dest)
    {
        for (var def in defines)
        {
            dest.addDef(def);
        }

        return dest;
    }


    MatchWord parseLine(String line)
    {
      var result = MatchWord('',ROOT);

      var matches = regularExpression.allMatches(line).toList();

      for(var match in matches)
      {
        for(var group=0; group<match.groupCount; group++)
        {
            var text = match.group(group+1);
            if (text != null)
            {
//#debug
                print("Parse Word: ${_regExTypes[group]}:'$text'");
//#end debug line:167
                result.prev.add(MatchWord(text, _regExTypes[group]));
                break;
            }
        }
      }

      result= result.next;

      return result.type == WordParser.DISABLED_LINE_COMMENT ?  result.next : result;

    }


}
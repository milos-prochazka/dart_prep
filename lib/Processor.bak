

import 'dart:convert';

import 'package:dart_prep/Expression.dart';
import 'package:dart_prep/MatchWord.dart';
import 'package:dart_prep/SyntaxException.dart';

import 'WordParser.dart';

/// Hlavni trida Dart preprocesoru
/// Zpracovava vstupni text a konvertuje je jej podle definovanych maker.
class Processor
{
    late List<String> _lines;
    int _aLine = 0;
    var wordParser = WordParser();
    final expression = Expression();

    /// Processor
    ///
    /// Konstruktor
    Processor({String text='',Processor? globals=null})
    {
        if (globals != null)
        {
            wordParser.defines.addAll(globals.wordParser.defines);
        }

        _lines = LineSplitter().convert(text);
    }

    bool process([String text='',bool enableAll=false])
    {
        var result = false;

        try
        {
          if (text != '')
          {
              _lines = LineSplitter().convert(text);
          }

          enableLines();

          if (!enableAll)
          {
            _aLine = 0;
            processLevel(true,0);
          }

          result = true;
        }
        on SyntaxException catch(e)
        {
            print ('Error ${e.message} at line ${_aLine+1}:${(_aLine<_lines.length)?_lines[_aLine]:''}');
        }

        return result;
    }

    void enableLines()
    {
      for (var iline=0; iline<_lines.length; iline++)
      {
          var line = _lines[iline].trimRight();

          if (line.trimLeft().startsWith('//##'))
          {
              line = line.replaceFirst('//##', '');
          }

          _lines[iline] = line;
      }
    }

    void processLevel(bool enabled,int level)
    {
        int iflevel = 0;

        while (_aLine<_lines.length)
        {
            var line = _lines[_aLine];
            var word = wordParser.parseLine(line);


            if (enabled)
            {   // Povolene radky

                switch (word.type)
                {
                    case WordParser.DEFINE_STATEMENT:
                        _define(word);
                        break;

                    case WordParser.END_STATEMENT:
                    case WordParser.ELIF_STATEMENT:
                    case WordParser.ELSE_STATEMENT:
                        if (level == 0)
                        {
                            throw SyntaxException('${word.text} does not follow if');
                        }
                        return;

                    case WordParser.DEBUG_STATEMENT:
                    case WordParser.RELEASE_STATEMENT:
                    case WordParser.VERBOSE_STATEMENT:
                        {
                            var ifWord = word.text.substring(3);
                            var ifLine = _aLine+1;

                            bool result = wordParser.defines.contains(ifWord);
                            _aLine++;

                            processLevel(result,level+1);

                            line = _lines[_aLine];
                            word = wordParser.parseLine(line);

                            if (word.type != WordParser.END_STATEMENT)
                            {
                                throw SyntaxException("#end expression not found");
                            }

                            _lines[_aLine] = '//#end $ifWord line:$ifLine';
                        }
                        break;

                    case WordParser.IF_STATEMENT:
                        {
                            var ifLine = _aLine+1;

                            bool result = expression.decodeExpression(word.next);
                            bool ifTrue = result;

                            _aLine++;
                            processLevel(result,level+1);

                            while (true)
                            {
                                if (_aLine >= _lines.length)
                                {
                                    throw SyntaxException("#end expression not found");
                                }

                                line = _lines[_aLine];
                                word = wordParser.parseLine(line);

                                if (word.type == WordParser.ELIF_STATEMENT)
                                {
                                    _aLine++;
                                    result = !ifTrue & expression.decodeExpression(word.next);
                                    ifTrue |= result;

                                    processLevel(result,level+1);
                                }
                                else
                                {
                                    break;
                                }
                            }

                            if (word.type == WordParser.ELSE_STATEMENT)
                            {
                                _aLine++;
                                processLevel(!ifTrue,level+1);

                                if (_aLine >= _lines.length)
                                {
                                    throw SyntaxException("#end expression not found");
                                }

                                line = _lines[_aLine];
                                word = wordParser.parseLine(line);
                            }

                            if (word.type != WordParser.END_STATEMENT)
                            {
                                throw SyntaxException("#end expression not found");
                            }

                            _lines[_aLine] = '//#end if line:$ifLine';

                        }
                        break;
                }
            }
            else
            {   // Zakazane radky

                _lines[_aLine] = '//##' + line;

                switch (word.type)
                {
                    case WordParser.IF_STATEMENT:
                        iflevel++;
                        break;

                    case WordParser.ELIF_STATEMENT:
                    case WordParser.ELSE_STATEMENT:
                        if (iflevel<=0)
                        {
                            return;
                        }
                        break;


                    case WordParser.END_STATEMENT:
                        if (iflevel<=0)
                        {
                            return;
                        }
                        else
                        {
                            iflevel--;
                        }
                        break;
                }
            }
            _aLine++;
        }
    }

    ///
    ///
    @override
    String toString()
    {
        StringBuffer buffer = StringBuffer();
        buffer.writeAll(_lines,'\r\n');
        return buffer.toString();
    }

    void _define(MatchWord word)
    {
        bool allDone = false;
        bool remove = false;

        while (!allDone)
        {
            word = word.next;

            switch (word.type)
            {
                case WordParser.DEFINE_TRUE:
                case WordParser.WORD:
                    if (remove)
                    {
                        remove = false;
                        wordParser.removeDef(word.text);
                    }
                    else
                    {
                        wordParser.addDef(word.text);
                    }
                    remove = false;
                    break;

                case WordParser.NEG_OPERATOR:
                    remove = !remove;
                    break;

                case WordParser.ROOT:
                    allDone = true;
                    break;
            }


        }
    }

    bool _if(MatchWord word)
    {
        bool allDone = false;
        bool result = false;
        String op = "";
        bool firstValue = false;

        while (!allDone)
        {
            bool neg = false;

            while (word.type == WordParser.NEG_OPERATOR)
            {
                neg = !neg;
                word = word.next;
            }

            bool value;
            switch(word.type)
            {
                case WordParser.DEFINE_STATEMENT:
                case WordParser.WORD:
                    value = (word.type == WordParser.DEFINE_STATEMENT) ? neg : !neg;

                    break;

                default:
                    throw SyntaxException("${word.text} can't be here");
            }
        }

        return result;
    }

}
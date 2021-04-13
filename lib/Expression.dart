
import 'dart:collection';
import 'package:dart_prep/MatchWord.dart';
import 'package:dart_prep/SyntaxException.dart';

import 'WordParser.dart';

class Expression
{
    final Queue<bool> _valueStack = Queue<bool>();
    final Queue<int> _operatorStack = Queue<int>();
    bool _needOperator = false;

    final __priority =
    {
        WordParser.ROOT : 0,
        WordParser.OPEN_BRACKET : 5,
        WordParser.OR_OPERATOR : 10,
        WordParser.AND_OPERATOR : 20,
        WordParser.NEG_OPERATOR: 100,
    };


    Expression()
    {
        reset();
    }

    void reset()
    {
        _valueStack.clear();
        _operatorStack.clear();
        _needOperator = false;
    }

    int _priority(int op)
    {
        return __priority.containsKey(op) ? (__priority[op] ?? 0) : 0;
    }


    bool decodeExpression(MatchWord word)
    {
        reset();
        while (word.type != WordParser.ROOT)
        {
            writeWord(word);
            word = word.next;
        }

        _pushOperator(WordParser.ROOT);
//#if DEBUG
//##        print('FINAL STACK: ${toString()}');
//#end if line:52

        return  (_valueStack.length == 1) ? _valueStack.last : false;
    }

    void writeWord(MatchWord word)
    {
//#if DEBUG
//##        print("Write Word: ${WordParser.wordNames[word.type]} '${word.text}'");
//#end if line:61
        if (_needOperator)
        {
            if (!__priority.containsKey(word.type))
            {
                throw SyntaxException("${word.text} can't be here");
            }
            else
            {
                _pushOperator(word.type);
            }
        }
        else
        {

            switch(word.type)
            {
                case WordParser.DEFINE_TRUE:
                    _pushValue(true);
                    break;
                case WordParser.WORD:
                    _pushValue(false);
                    break;
                case WordParser.NEG_OPERATOR:
                    _operatorStack.addLast(word.type);
                    break;
                default:
                    throw SyntaxException("${word.text} can't be here");
            }
        }

//#if DEBUG
//##        print('STACK: ${toString()}');
//#end if line:94
    }



    void _pushOperator(int op)
    {
//#if DEBUG
//##      print("Push Operator: ${WordParser.wordNames[op]}'");
//#end if line:103

        if (op == WordParser.CLOSE_BRACKET)
        {
            _needOperator = true;
            while (_operatorStack.isNotEmpty)
            {
                if (_topOp() == WordParser.OPEN_BRACKET)
                {
                    _operatorStack.removeLast();
                    break;
                }
                else
                {
                    _doOp();
                }
            }
        }
        else
        {
            int prio = _priority(op);

            while (_operatorStack.isNotEmpty)
            {
                int topOp = _topOp();
                int topPrio = _priority(topOp);

                if (topPrio>=prio)
                {
                    _doOp();
                }
                else
                {
                  break;
                }

            }

            if (op != WordParser.ROOT)
            {
              _operatorStack.addLast(op);
              _needOperator = false;
            }
        }


    }

    int _topOp()
    {
        return _operatorStack.isEmpty ? WordParser.ROOT : _operatorStack.last;
    }

    int _popOp()
    {
        return _operatorStack.isEmpty ? WordParser.ROOT : _operatorStack.removeLast();
    }


    void _doOp()
    {
        bool value;



        switch(_popOp())
        {
            case WordParser.AND_OPERATOR:
                _valueStack.addLast(_valueStack.removeLast() & _valueStack.removeLast());
                break;
            case WordParser.OR_OPERATOR:
                _valueStack.addLast(_valueStack.removeLast() | _valueStack.removeLast());
                break;
            case WordParser.NEG_OPERATOR:
                _valueStack.addLast(!_valueStack.removeLast());
                break;

        }

//#if DEBUG
//##        print('DO OP STACK: ${toString()}');
//#end if line:184
    }

    void _pushValue(bool value)
    {
        _valueStack.addLast(value);
        _needOperator = true;
    }

    String toString()
    {
        return "need operator:$_needOperator operator stack:${_operatorStack.toString()} value stack:${_valueStack.toString()}";
    }
}
// ignore_for_file: unnecessary_this
// ignore_for_file: omit_local_variable_types

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:dart_prep/Processor.dart';

final _codec = Utf8Codec(allowMalformed: true);

const String info = '''
dart_prep v1.1.0
Syntax: dart_prep <argument list>

arguments:
     [directory name]  - directory to be preprocessed (all dart files in all subdirectories).
     [file_name]       - dart file to be preprocessed
     @[file_name]      - configuration file with the defines
     +[definition]     - add definition
     -[definition]     - remove the existing definition
     #[extension]      - set file extension (for searching in directories). Default extension is .dart
     --enable-all      - all definitions are assumed to be true (eg. for github export)
''';
void main(List<String> arguments) async
{
  var args = arguments;
//#debug
    if (args.isEmpty)
    {
        args = ['+DEBUG','test.cfg'];
    }
//#end DEBUG line:29

  if (args.isEmpty)
  {
    print(info);
    exit(2);
  }
  else
  {
    exit(await cmd_main(args));
  }
  // komentart
}

Future<int> cmd_main(List<String> args) async
{
  var defines = Processor();
  bool enableAll = false;
  String ext = '.dart';

  for (var arg in args)
  {
    if (arg.startsWith('@'))
    {
      if (!await processFile(arg.substring(1), defines, enableAll, !enableAll))
      {
        return 1;
      }
    }
    else if (arg == '--enable-all')
    {
      enableAll = true;
    }
    else if (arg.startsWith('#'))
    {
      ext = arg.substring(1);
    }
    else if (arg.startsWith('-'))
    {
      defines.wordParser.removeDef(arg.substring(1));
    }
    else if (arg.startsWith('+'))
    {
      defines.wordParser.addDef(arg.substring(1));
    }
    else
    {
      if (await FileSystemEntity.isDirectory(arg))
      {
        if (!await processDirectory(arg, defines, enableAll, ext))
        {
          return 1;
        }
      }
      else if (await FileSystemEntity.isFile(arg))
      {
        if (!await processFile(arg, Processor(globals: defines), enableAll, false))
        {
          return 1;
        }
      }
      else
      {
        print("File '$arg' does not exist");
        return 1;
      }
    }
  }

  return 0;
}

Future<bool> processDirectory(String dirName, Processor defines, bool enableAll, String ext) async
{
  Directory dir = Directory(dirName);

  await for (var file in dir.list(recursive: true, followLinks: false))
  {
    if (await FileSystemEntity.isFile(file.path) && file.path.endsWith(ext))
    {
      if (!await processFile(file.path, Processor(globals: defines), enableAll, false))
      {
        return false;
      }
    }
  }

  return true;
}

Future<bool> processFile(String fileName, Processor processor, bool enableAll, bool readOnly) async
{
  bool result = false;

  print("Preprosessing the '$fileName' file");

  String tempFile = path.setExtension(fileName, '.\$TMP\$');
  String bakFile = path.setExtension(fileName, '.bak');

  if (await File(tempFile).exists())
  {
    print("The file '$tempFile' already exists. You must delete it.");
  }
  else
  {
    var text = await loadFileAsString(fileName);

    if (text != null)
    {
      if (processor.process(text, enableAll) && !readOnly)
      {
        if (await writeFileAsString(tempFile, processor.toString()))
        {
          if (await renameFile(fileName, bakFile) && await renameFile(tempFile, fileName))
          {
            result = true;
          }
        }
      }
    }
  }
  return result;
}

Future<bool> renameFile(String oldPath, String newPath) async
{
  bool result = false;

  try
  {
    var oldFile = File(oldPath);
    await oldFile.rename(newPath);
    result = true;
  }
  catch (e)
  {
    print(e);
  }

  return result;
}

Future<bool> copyFile(String oldPath, String newPath) async
{
  bool result = false;

  try
  {
    var oldFile = File(oldPath);
    await oldFile.copy(newPath);
    result = true;
  }
  catch (e)
  {
    print(e);
  }

  return result;
}

Future<String?> loadFileAsString(String fileName) async
{
  String? result = null;

  try
  {
    final file = File(fileName);
    final bytes = await file.readAsBytes();

    result = _codec.decode(bytes);
  }
  catch (e)
  {
    print(e.toString());
  }

  return result;
}

Future<bool> writeFileAsString(String fileName, String text) async
{
  bool result = false;

  try
  {
    final file = File(fileName);
    await file.writeAsString(text, flush: true);
    result = true;
  }
  catch (e)
  {
    print(e.toString());
  }

  return result;
}

void processString(String $text)
{
  var processor = Processor(text: $text);
  processor.process();
  var str = processor.toString();
}
gflagDecode(String gflags) {
  Map<String, dynamic> map = {};
  var lines = gflags.split('\n');
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].startsWith('--') && lines[i].contains('=')) {
      var split = lines[i].split('=');
      var key = split[0].substring(2);

      var value;
      if (int.tryParse(split[1]) != null)
        value = int.parse(split[1]);
      else if (double.tryParse(split[1]) != null)
        value = double.parse(split[1]);
      else if (split[1].toLowerCase() == 'true')
        value = true;
      else if (split[1].toLowerCase() == 'false')
        value = false;
      else
        value = split[1];

      map[key] = value;
    }
  }
  return map;
}

gflagEncode(Map<String, dynamic> map) {
  var gflagString = '';
  for (var key in map.keys) gflagString += '--$key=${map[key]}\n';

  return gflagString;
}

import 'package:gsheets/gsheets.dart';

/// Your google auth credentials
///
/// how to get credentials - https://medium.com/@a.marenkov/how-to-get-credentials-for-google-sheets-456b7e88c430
const _credentials = r'''
{
  "type": "service_account",
  "project_id": "my-projectend-380707",
  "private_key_id": "7311b5ff1eba8e66fb92443f902851b588ef2dda",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCh0LpCvKXsf+0n\nPbHYinrLKS+QeUgJGv9WBQyLBZn3fP6C2miFnY7FlrhFcpnmPYRM2QNMTMTPsWq8\nwryV8upCSGu4Our7iV4CY2dixlDRd8Yx/NZrozWWfAVP+GJIJC3Hy9BOIVFBRdn0\nTQUcqGAffXEHrgDrCVB5vn15O0RtNdevEOt7+2KLS2tmxWlic26wEhzhLhbZZ8mM\nIvO4iXx1YKse02n5FD5VAAw2P2+LCKptZvKQOlfbjsjOXmrhQTB4IDiZLawCSiSA\noS/0ZAn+BOnFN5mEHq0L7JyOQMUoYa2y0v6mDOI0R0zq7JnLqQ1GUKjuytYvg8XE\nTv7fRxn7AgMBAAECggEABkXNmp2ufur8mftRxBemJ+76SYryCGxT/pUmhdMbQ1VE\nlnT5/Uf8y1sK3KJTJfI3iTUWZCRLstNpVFTmM5fdjeE5z8P07PhHvSb2UIVoh54x\ngCmRdE2425MGL7HsuWgxoB+d/RFckX+wMcC0lIZQZ5gYxBfyMCpFxNpmCceK4QLX\n7nGT1jf+NWAiD5H5/1F6bGr0jhrDu7if08O5KBoIscXt+IxoblY9VEzHYTwZB7ji\n1IS1mr6YjtpJ0W9eXrUAvTg8lm1CESum5ko0gIPHpSCdFMISuk42ZlTENIcMxhTB\n6s0ZVjSWzGXjRJ743UK2IW5k8FiHTp7ppM4j0BdFHQKBgQDj+keHRDE7b7PQWqDY\nhJYUpnQPfzBEkxjA/d921Q2kaC3Vxwv4KumhpTFMMBNIeEspK53XpN0+uUKS9UsN\n9nmc/a343YJ4674BlIsfYAUNIFXnnn16IwuWLV/waZ3DZYyejyJLwqT705VnhJWP\nBxdL6ks+657Hf0gqXF2YR+yYhQKBgQC1tIirod1bN8XQYiTpaWE7aio5AlSzCcMD\nEzipzFahgV7+z5qa5NJsdypUZynb0WajU3deyn5FRn0dpCdijW5m9405RHnswm9P\nUPGog9EXRsIVNZMgf/dBvdVsRvkIMm3fkjsJ67oGbFCWmUD5tvVGNQWHKRBhmuX6\ndVEEa5ywfwKBgG/7wKbxGD3Z4Lm3ysqQVihOmzQBhfQpTT9/dQUqIklf4yPfYkHE\n0n5UZqLF+rLeZA0VH7ONiCAHYGxPkU6Kg7JZ6dsU88HyCqM8FBqVT+XivE/Jylj0\nXfymzTmKp7QTbb91D6OnOON6SylONyjKkub3b364voXAP/KO7Gqg6dcBAoGAKuCs\nM5whqQnTMyZFwZKtcCDQT92d8RXHn+0kPOVMOBZYPVbuC8kdYp0ILxydAxM53iav\nD35HJ7/HfHwlExt+xut5tt7SyqzjKVtXe0WHzK9U0z5uNogb57aNK1zgHTARP2W5\natDmd+eNaMxHSeYDoQqYAFoPVIkB5gVTFfDy668CgYEApNKm1Bfvr12Z1n0YR68Y\nxf7vzapcXo8UPJxSNHppU9U7zttV+hWnAxVajGYdoDAckj1lbWxbdIJXx1kKQ7gG\nr0Ytg3F1EwcZxjZJmtv5S4RmYI94j1ZS3gu+3F66UVCqA1joNnpHHavfP5N8I8En\nLz3D/dc1ONDET+z4yy4O3MY=\n-----END PRIVATE KEY-----\n",
  "client_email": "my-project@my-projectend-380707.iam.gserviceaccount.com",
  "client_id": "111156698732872251109",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/my-project%40my-projectend-380707.iam.gserviceaccount.com"
}
''';

/// Your spreadsheet id
///
/// It can be found in the link to your spreadsheet -
/// link looks like so https://docs.google.com/spreadsheets/d/YOUR_SPREADSHEET_ID/edit#gid=0
/// [YOUR_SPREADSHEET_ID] in the path is the id your need
const _spreadsheetId = '1n5UcykgZ5qWCzHtFIi5s-kehVwTK2aMltXbgbtEnqsQ';

void main() async {
  // init GSheets
  final gsheets = GSheets(_credentials);
  // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(_spreadsheetId);

  print(ss.data.namedRanges.byName.values
      .map((e) => {
            'name': e.name,
            'start':
                '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
            'end':
                '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
          })
      .join('\n'));

  // get worksheet by its title
  var sheet = ss.worksheetByTitle('example');
  // create worksheet if it does not exist yet
  sheet ??= await ss.addWorksheet('example');

  // update cell at 'B2' by inserting string 'new'
  await sheet.values.insertValue('new', column: 2, row: 2);
  // prints 'new'
  print(await sheet.values.value(column: 2, row: 2));
  // get cell at 'B2' as Cell object
  final cell = await sheet.cells.cell(column: 2, row: 2);
  // prints 'new'
  print(cell.value);
  // update cell at 'B2' by inserting 'new2'
  await cell.post('new2');
  // prints 'new2'
  print(cell.value);
  // also prints 'new2'
  print(await sheet.values.value(column: 2, row: 2));

  // insert list in row #1
  final firstRow = ['index', 'letter', 'number', 'label'];
  await sheet.values.insertRow(1, firstRow);
  // prints [index, letter, number, label]
  print(await sheet.values.row(1));

  // insert list in column 'A', starting from row #2
  final firstColumn = ['0', '1', '2', '3', '4'];
  await sheet.values.insertColumn(1, firstColumn, fromRow: 2);
  // prints [0, 1, 2, 3, 4, 5]
  print(await sheet.values.column(1, fromRow: 2));

  // insert list into column named 'letter'
  final secondColumn = ['a', 'b', 'c', 'd', 'e'];
  await sheet.values.insertColumnByKey('letter', secondColumn);
  // prints [a, b, c, d, e, f]
  print(await sheet.values.columnByKey('letter'));

  // insert map values into column 'C' mapping their keys to column 'A'
  // order of map entries does not matter
  final thirdColumn = {
    '0': '1',
    '1': '2',
    '2': '3',
    '3': '4',
    '4': '5',
  };
  await sheet.values.map.insertColumn(3, thirdColumn, mapTo: 1);
  // prints {index: number, 0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6}
  print(await sheet.values.map.column(3));

  // insert map values into column named 'label' mapping their keys to column
  // named 'letter'
  // order of map entries does not matter
  final fourthColumn = {
    'a': 'a1',
    'b': 'b2',
    'c': 'c3',
    'd': 'd4',
    'e': 'e5',
  };
  await sheet.values.map.insertColumnByKey(
    'label',
    fourthColumn,
    mapTo: 'letter',
  );
  // prints {a: a1, b: b2, c: c3, d: d4, e: e5, f: f6}
  print(await sheet.values.map.columnByKey('label', mapTo: 'letter'));

  // appends map values as new row at the end mapping their keys to row #1
  // order of map entries does not matter
  final secondRow = {
    'index': '5',
    'letter': 'f',
    'number': '6',
    'label': 'f6',
  };
  await sheet.values.map.appendRow(secondRow);
  // prints {index: 5, letter: f, number: 6, label: f6}
  print(await sheet.values.map.lastRow());

  // get first row as List of Cell objects
  final cellsRow = await sheet.cells.row(1);
  // update each cell's value by adding char '_' at the beginning
  cellsRow.forEach((cell) => cell.value = '_${cell.value}');
  // actually updating sheets cells
  await sheet.cells.insert(cellsRow);
  // prints [_index, _letter, _number, _label]
  print(await sheet.values.row(1));
}
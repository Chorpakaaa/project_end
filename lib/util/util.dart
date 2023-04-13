import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePdf(final PdfPageFormat format) async {
  final doc = pw.Document();
  String formattedDateTime =
      DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
  final font = await PdfGoogleFonts.k2DThin();
  doc.addPage(pw.Page(
    build: (context) {
      return pw.Column(children: [
        pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text('Export Date ' + formattedDateTime)),
        pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text('ยอดขายวันที่ 04/03/2023',
                style: pw.TextStyle(font: font, fontSize: 18))),
        pw.SizedBox(height: 10),
        pw.Table(
            border: pw.TableBorder(
                bottom: pw.BorderSide(
              color: PdfColors.grey,
              width: 1.0,
              style: pw.BorderStyle.solid,
            )),
            children: [
              pw.TableRow(children: [
                pw.Container(
                    width: 50,
                    child: pw.Center(
                        child: pw.Text('เวลาทำรายการ',
                            style: pw.TextStyle(font: font, fontSize: 14)))),
                pw.Container(
                    width: 50,
                    child: pw.Center(
                        child: pw.Text('เลขที่อ้างอิง',
                            style: pw.TextStyle(font: font, fontSize: 14)))),
                pw.Container(
                    width: 50,
                    child: pw.Center(
                        child: pw.Text('ผู้ขาย',
                            style: pw.TextStyle(font: font, fontSize: 14)))),
                pw.Container(
                    width: 80,
                    child: pw.Center(
                        child: pw.Text('ยอดขาย',
                            style: pw.TextStyle(font: font, fontSize: 14)))),
              ]),
            ]),
        pw.SizedBox(height: 5),
        pw.Table(
            border: pw.TableBorder(
                bottom: pw.BorderSide(
              color: PdfColors.grey,
              width: 1.0,
              style: pw.BorderStyle.solid,
            )),
            children: [
              pw.TableRow(children: [
                pw.Container(
                    width: 50,
                    child: pw.Center(
                        child: pw.Text('04/03/2023 02:05:37',
                            style: pw.TextStyle(font: font, fontSize: 10)))),
                pw.Container(
                    width: 50,
                    child: pw.Center(
                        child: pw.Text('0000123123',
                            style: pw.TextStyle(font: font, fontSize: 10)))),
                pw.Container(
                    width: 50,
                    child: pw.Center(
                        child: pw.Text('เจ้าของร้าน',
                            style: pw.TextStyle(font: font, fontSize: 10)))),
                pw.Container(
                    width: 80,
                    child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                            padding: pw.EdgeInsets.only(right: 10),
                            child: pw.Text('100',
                                style:
                                    pw.TextStyle(font: font, fontSize: 10))))),
              ]),
            ]),
        pw.SizedBox(height: 10),
        pw.Container(
          height: 100,
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Container(
                  width: double.infinity,
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  width: double.infinity,
                  child: pw.Column(children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('ยอดขายรวม',
                              style: pw.TextStyle(font: font, fontSize: 14)),
                          pw.Padding(
                              padding: pw.EdgeInsets.only(right: 10),
                              child: pw.Text('100',
                                  style:
                                      pw.TextStyle(font: font, fontSize: 14))),
                        ]),
                    pw.Divider(thickness: 0.5),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Column(children: [
                        pw.Text('ผู้ขาย',
                            style: pw.TextStyle(font: font, fontSize: 14)),
                        pw.Divider(thickness: 0.5),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('เจ้าของร้าน',
                                  style:
                                      pw.TextStyle(font: font, fontSize: 10)),
                          pw.Padding(
                              padding: pw.EdgeInsets.only(right: 10),
                              child: pw.Text('100',
                                  style:
                                      pw.TextStyle(font: font, fontSize: 10))),
                        ]),
                      ]),
                    ),
                  pw.Divider(thickness: 0.5)
                  ]),
                ),
              ),
            ],
          ),
        )
      ]);
    },
  ));
  return doc.save();
}

// Future<Uint8List> generatePdf(final PdfPageFormat format) async {
//   final doc = pw.Document();
// String formattedDateTime =
//     DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
// final font = await PdfGoogleFonts.k2DThin();
//   doc.addPage(pw.Page(
//     build: (context) {
//       return pw.Column(children: [
// pw.Align(
//     alignment: pw.Alignment.centerRight,
//     child: pw.Text('Export Date ' + formattedDateTime)),
// pw.Align(
//     alignment: pw.Alignment.centerLeft,
//     child: pw.Text('รายการสินค้าคงคลัง',
//         style: pw.TextStyle(font: font, fontSize: 18))),
//         pw.Container(
//             child: pw.Row(children: [
//           pw.Expanded(
//             child: pw.Container(
//               width: double.infinity,
//             ),
//           ),
//           pw.Expanded(
//             child: pw.Container(
//                 color: PdfColors.white,
//                 width: double.infinity,
//                 child: pw.Column(children: [
//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text('จำนวนสินค้าคงคลัง:',
//                           style: pw.TextStyle(font: font, fontSize: 12)),
//                       pw.Text('12',
//                           style: pw.TextStyle(font: font, fontSize: 12))
//                     ],
//                   ),
//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text('มูลค่าสินค้าคงคลัง:',
//                           style: pw.TextStyle(font: font, fontSize: 12)),
//                       pw.Text('30000.00',
//                           style: pw.TextStyle(font: font, fontSize: 12))
//                     ],
//                   ),
//                   pw.Row(
//                     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                     children: [
//                       pw.Text('มูลค่าราคาขายสินค้าคงคลัง:',
//                           style: pw.TextStyle(font: font, fontSize: 12)),
//                       pw.Text('30000.00',
//                           style: pw.TextStyle(font: font, fontSize: 12))
//                     ],
//                   ),
//                 ])),
//           ),
//         ])),
//         pw.Divider(thickness: 1),
//         pw.Table(border: pw.TableBorder.all(), children: [
//           pw.TableRow(children: [
//             pw.Container(
//               height: 30,
//               width: 70,
//               child: pw.Center(
//                 child: pw.Text('ชื่อสินค้า',
//                     style: pw.TextStyle(font: font, fontSize: 14)),
//               ),
//             ),
//             pw.Container(
//               height: 30,
//               child: pw.Center(
//                 child: pw.Text('จำนวน',
//                     style: pw.TextStyle(font: font, fontSize: 14)),
//               ),
//             ),
//             pw.Container(
//               height: 30,
//               child: pw.Center(
//                 child: pw.Text('มูลค่าต้นทุน',
//                     style: pw.TextStyle(font: font, fontSize: 14)),
//               ),
//             ),
//             pw.Container(
//               height: 30,
//               child: pw.Center(
//                 child: pw.Text('มูลค่าราคาขาย',
//                     style: pw.TextStyle(font: font, fontSize: 14)),
//               ),
//             ),
//           ]),

//           pw.TableRow(children: [
//             pw.Container(
//               width: 70,
//               child: pw.Align(
//                 alignment: pw.Alignment.centerLeft,
//                 child: pw.Text('',
//                     style: pw.TextStyle(font: font, fontSize: 12)),
//               ),
//             ),
//             pw.Container(
//               child: pw.Center(
//                 child: pw.Text('จำนวน',
//                     style: pw.TextStyle(font: font, fontSize: 12)),
//               ),
//             ),
//             pw.Container(
//               child: pw.Center(
//                 child: pw.Text('มูลค่าต้นทุน',
//                     style: pw.TextStyle(font: font, fontSize: 12)),
//               ),
//             ),
//             pw.Container(
//               child: pw.Center(
//                 child: pw.Text('มูลค่าราคาขาย',
//                     style: pw.TextStyle(font: font, fontSize: 12)),
//               ),
//             ),
//           ])
//         ])
//       ]);
//     },
//   ));
//   return doc.save();
// }

// Future<Uint8List> generatePdf(final PdfPageFormat format) async {
//   final pdf = pw.Document();
// String formattedDateTime =
//     DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
// String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
// final font = await PdfGoogleFonts.k2DThin();
//   pdf.addPage(pw.Page(
//     pageFormat: PdfPageFormat.a4,
//     build: (context) {
//       return pw.Column(children: [
// pw.Align(
//     alignment: pw.Alignment.centerRight,
//     child: pw.Text('Export Date ' + formattedDateTime)),
//         pw.Align(
//             alignment: pw.Alignment.center,
//             child: pw.Text('รายรับรายจ่าย วันที่ ' + formattedDate,
//                 style: pw.TextStyle(font: font, fontSize: 18))),
//         pw.Table(children: [
//           pw.TableRow(children: [
//             pw.SizedBox(
//                 width: 150,
//                 child: pw.Text('รายการซื้อขาย',
//                     style: pw.TextStyle(font: font, fontSize: 18))),
//             pw.SizedBox(
//                 width: 50,
//                 child:
//                     pw.Text('', style: pw.TextStyle(font: font, fontSize: 18))),
//             pw.Container(
//                 child: pw.Text('รายรับ',
//                     style: pw.TextStyle(font: font, fontSize: 18))),
//             pw.Container(
//                 child: pw.Text('รายจ่าย',
//                     style: pw.TextStyle(font: font, fontSize: 18)))
//           ]),
//           pw.TableRow(children: [
//             pw.SizedBox(
//                 width: 150,
//                 child: pw.Text('04/03/2023 02:05:37 ขาย',
//                     style: pw.TextStyle(font: font, fontSize: 12))),
//             pw.SizedBox(
//                 width: 50,
//                 child:
//                     pw.Text('', style: pw.TextStyle(font: font, fontSize: 18))),
//             pw.Container(
//                 child: pw.Text('9,800.00',
//                     style: pw.TextStyle(font: font, fontSize: 12))),
//             pw.Container(
//                 child:
//                     pw.Text('', style: pw.TextStyle(font: font, fontSize: 12)))
//           ]),
//           pw.TableRow(children: [
//             pw.Row(children: [
//               pw.SizedBox(width: 100, height: 40
//                   ),
//             ]),
//             pw.Padding(
//                 padding: pw.EdgeInsets.all(10),
//                 child: pw.Container(
//                     child: pw.Text('ยอดรวม',
//                         style: pw.TextStyle(font: font, fontSize: 12)))),
//             pw.Padding(
//                 padding: pw.EdgeInsets.all(10),
//                 child: pw.Container(
//                     child: pw.Text('9,800.00',
//                         style: pw.TextStyle(font: font, fontSize: 12)))),
//             pw.Container(
//                 child:
//                     pw.Text('', style: pw.TextStyle(font: font, fontSize: 12)))
//           ]),
//           pw.TableRow(children: [
//             pw.Row(children: [
//               pw.SizedBox(width: 100, height: 20),
//             ]),
//             pw.Container(
//                 child: pw.Text('ค่าใช้จ่ายอื่นๆ',
//                     style: pw.TextStyle(font: font, fontSize: 12))),
//             pw.Container(
//                 child: pw.Text('100.00',
//                     style: pw.TextStyle(font: font, fontSize: 12))),
//             pw.Container(
//                 child:
//                     pw.Text('', style: pw.TextStyle(font: font, fontSize: 12)))
//           ]),
//           pw.TableRow(children: [
//             pw.Row(children: [
//               pw.SizedBox(
//                 width: 100,
//               ),
//             ]),
//             pw.Container(
//                 child: pw.Text('กำไรสุทธิ',
//                     style: pw.TextStyle(font: font, fontSize: 12))),
//             pw.Container(
//                 child: pw.Text('30000.00',
//                     style: pw.TextStyle(font: font, fontSize: 12))),
//             pw.Container(
//                 child:
//                     pw.Text('', style: pw.TextStyle(font: font, fontSize: 12)))
//           ]),
//         ])
//       ]);
//     },
//   ));

//   return pdf.save();
// }

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('document print successfully')));
}

void showShareToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('document Share successfully')));
}

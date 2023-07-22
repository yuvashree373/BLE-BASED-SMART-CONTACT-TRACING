import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    required BluetoothDevice device,
    int? rssi,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    bool enabled = true,
  }) : super(
          onTap: onTap,
          onLongPress: onLongPress,
          enabled: enabled,
          // leading:
          //     Icon(Icons.devices), // @TODO . !BluetoothClass! class aware icon
          title: Text(device.name ?? ""),
          subtitle: Text(device.address.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              rssi != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Container(
                        margin: new EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              rssi.toStringAsFixed(2),
                            ),
                            Text(
                              "rssi",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  rssi == null
                      ? Text("-")
                      : StatusWidget(
                          rssi: rssi,
                        ),
                ],
              ),
            ],
          ),
        );

  static TextStyle _computeTextStyle(int rssi) {
    /**/ if (rssi >= -35)
      return TextStyle(color: Colors.greenAccent[700]);
    else if (rssi >= -45)
      return TextStyle(
          color: Color.lerp(
              Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10));
    else if (rssi >= -55)
      return TextStyle(
          color: Color.lerp(
              Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10));
    else if (rssi >= -65)
      return TextStyle(
          color: Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
    else if (rssi >= -75)
      return TextStyle(
          color: Color.lerp(
              Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10));
    else if (rssi >= -85)
      return TextStyle(
          color: Color.lerp(
              Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10));
    else
      /*code symmetry*/
      return TextStyle(color: Colors.redAccent);
  }
}

class StatusWidget extends StatefulWidget {
  const StatusWidget({Key? key, required this.rssi}) : super(key: key);
  final num rssi;

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  bool loading = true;

  String? status;

  Future<void> getStatus() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("miniProj")
        .doc("url")
        .get();
    print(documentSnapshot.get("url"));
    Response response = await Dio()
        .post(documentSnapshot.get("url"), data: {"rssi": widget.rssi});

    int value = response.data["status"];
    print(value);
    if (value == 1) {
      status = "High\nRisk";
    } else {
      status = "Low\nRisk";
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? SizedBox(
            height: 12,
            width: 12,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : Text(
            status!,
            style: TextStyle(
              color: status == "Low\nRisk" ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          );
  }
}

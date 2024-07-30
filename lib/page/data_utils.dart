import 'package:intl/intl.dart';

class DataUtils {
  static Map<String, dynamic> formatLatestData(Map<String, dynamic> data) {
    data['date_server'] = DateFormat('yyyy-MM-dd').format(DateTime.parse(data['date_server']).toLocal());
    data['time_server'] = DateFormat('HH:mm:ss').format(DateTime.parse(data['time_server']).toLocal());
    return data;
  }

  static List<Map<String, dynamic>> formatDateRangeData(List<dynamic> data) {
    return data.map((entry) {
      return {
        'date_server': DateFormat('yyyy-MM-dd').format(DateTime.parse(entry['date_server']).toLocal()),
        'time_server': DateFormat('HH:mm:ss').format(DateTime.parse(entry['time_server']).toLocal()),
        'imei': entry['imei'].toString(),
        'date_device': entry['date_device'].toString(),
        'time_device': entry['time_device'].toString(),
        'latitude': entry['latitude'].toString(),
        'latitude_direction': entry['latitude_direction'].toString(),
        'longitude': entry['longitude'].toString(),
        'longitude_direction': entry['longitude_direction'].toString(),
        'speed': entry['speed'].toString(),
        'course': entry['course'].toString(),
        'alt': entry['alt'].toString(),
        'sats': entry['sats'].toString(),
        'hdop': entry['hdop'].toString(),
        'inputs': entry['inputs'].toString(),
        'outputs': entry['outputs'].toString(),
        'adc': entry['adc'].toString(),
        'ibutton': entry['ibutton'].toString(),
        'params_id': entry['params_id'].toString(),
        'crc16': entry['crc16'].toString()
      };
    }).toList();
  }
}

import 'dart:convert';

import 'package:dio/dio.dart'; // Import Dio
import 'package:lenteracafe/model/pesanan.dart';

class ApiService {
  final String baseUrl = "https://lenteracafee.shop/";
  final Dio dio = Dio(); // Create Dio instance

  ApiService() {
    if (baseUrl.isEmpty) {
      throw Exception('Base URL is not defined in .env file');
    }
  }

  Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final response = await Dio().post(
        '$baseUrl/API/login.php',
        data: {'username': username, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        // dio returns response.data already parsed
        return jsonDecode(response.data);
      } else {
        return {'error': 'Server error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Exception: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> fetchListInventaris() async {
    try {
      final response = await Dio().get('$baseUrl/API/getInventaris.php');
      if (response.statusCode == 200) {
        // Decode the JSON string into a list of maps
        final jsonResponse = jsonDecode(
          response.data,
        ); // Decode the string into a list

        print(jsonResponse);

        // Check if the response is a List
        if (jsonResponse is List) {
          return List<Map<String, dynamic>>.from(jsonResponse);
        } else {
          throw Exception('Unexpected response format: $jsonResponse');
        }
      } else {
        throw Exception('Failed to load menu list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menu list: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchListMenu() async {
    try {
      final response = await Dio().get('$baseUrl/API/getMenu.php');
      if (response.statusCode == 200) {
        // Decode the JSON string into a list of maps
        final jsonResponse = jsonDecode(
          response.data,
        ); // Decode the string into a list

        // Check if the response is a List
        if (jsonResponse is List) {
          return List<Map<String, dynamic>>.from(jsonResponse);
        } else {
          throw Exception('Unexpected response format: $jsonResponse');
        }
      } else {
        throw Exception('Failed to load menu list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menu list: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchListAlatdanBahan() async {
    try {
      final response = await Dio().get('$baseUrl/API/getAlatdanBahan.php');
      if (response.statusCode == 200) {
        // Decode the JSON string into a list of maps
        final jsonResponse = jsonDecode(
          response.data,
        ); // Decode the string into a list

        // Check if the response is a List
        if (jsonResponse is List) {
          return List<Map<String, dynamic>>.from(jsonResponse);
        } else {
          throw Exception('Unexpected response format: $jsonResponse');
        }
      } else {
        throw Exception('Failed to load menu list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching menu list: $e');
    }
  }

  Future<bool> insertPesananList(List<Pesanan> pesananList) async {
    try {
      final dataList =
          pesananList
              .map(
                (pesanan) => {
                  'orderId': pesanan.orderId,
                  'idItem': pesanan.idItem,
                  'jumlah': pesanan.jumlah,
                  'keterangan': pesanan.keterangan,
                  'status':
                      pesanan.status, // atau 'dibayar', sesuai kebutuhanmu
                  'transaksi': pesanan.transaksi,
                  'metodePembayaran': pesanan.metodePembayaran,
                  'mejaID': pesanan.mejaID,
                },
              )
              .toList();

      print(dataList);

      final response = await dio.post(
        '$baseUrl/API/insertTransaksi.php',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({'pesanan': dataList}),
      );

      // Cek respons dari server
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      final jsonResponse =
          response.data is String ? jsonDecode(response.data) : response.data;

      return jsonResponse['status'] == 'success';
    } catch (e) {
      throw Exception('Error inserting pesanan list: $e');
    }
  }

  Future<bool> updateStatusPesananList(
    List<Map<String, dynamic>> pesananList,
    String status,
  ) async {
    try {
      final dataList =
          pesananList.map((pesanan) {
            return {'idPesanan': pesanan['idPesanan'], 'status': status};
          }).toList();

      final response = await dio.post(
        '$baseUrl/API/updateStatusTransaksi.php',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode({'pesanan': dataList}),
      );

      final jsonResponse =
          response.data is String ? jsonDecode(response.data) : response.data;

      return jsonResponse['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchListTransaksi() async {
    try {
      final response = await Dio().get('$baseUrl/API/getTransaksi.php');
      if (response.statusCode == 200) {
        // Decode the JSON string into a list of maps
        final jsonResponse = jsonDecode(
          response.data,
        ); // Decode the string into a list

        // Check if the response is a List
        if (jsonResponse is List) {
          return List<Map<String, dynamic>>.from(jsonResponse);
        } else {
          throw Exception('Unexpected response format: $jsonResponse');
        }
      } else {
        throw Exception('Failed to load pesanan list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching pesanan list: $e');
    }
  }

  Future<bool> updateInventaris({
    required int id,
    required String namaItem,
    required String kategori,
    required int harga,
  }) async {
    try {
      final response = await Dio().post(
        '$baseUrl/API/updateInventaris.php',
        data: jsonEncode({
          'id': id,
          'namaItem': namaItem,
          'kategori': kategori,
          'harga': harga,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final jsonResponse =
          response.data is String ? jsonDecode(response.data) : response.data;

      return jsonResponse['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> insertInventaris({
    required String namaItem,
    required String kategori,
    required int harga,
  }) async {
    try {
      final response = await Dio().post(
        '$baseUrl/API/insertInventaris.php',
        data: jsonEncode({
          'namaItem': namaItem,
          'kategori': kategori,
          'harga': harga,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final jsonResponse =
          response.data is String ? jsonDecode(response.data) : response.data;

      return jsonResponse['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteInventaris({required int id}) async {
    try {
      final response = await Dio().post(
        '$baseUrl/API/deleteInventaris.php',
        data: jsonEncode({'id': id}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final jsonResponse =
          response.data is String ? jsonDecode(response.data) : response.data;

      return jsonResponse['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateToken({
    required String username,
    required String token,
  }) async {
    try {
      final response = await Dio().post(
        '$baseUrl/API/updateToken.php',
        data: jsonEncode({'username': username, 'token': token}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final jsonResponse =
          response.data is String ? jsonDecode(response.data) : response.data;

      print(jsonResponse);

      return jsonResponse['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> cekPesanan(String meja, String tanggal) async {
    try {
      final response = await Dio().post(
        '$baseUrl/API/cekpesanan.php',
        data: jsonEncode({'meja': meja, 'tanggal': tanggal}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;

        if (jsonResponse['status'] == 'found') {
          return {
            'orderId': jsonResponse['orderId'],
            'snaptoken': jsonResponse['snaptoken'],
            'items': List<Map<String, dynamic>>.from(jsonResponse['items']),
          };
        } else {
          return null; // Tidak ditemukan
        }
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  Future<void> sendNotificationToAdmin(String nama, String mejaID) async {
    try {
      // Membuat instance Dio
      Dio dio = Dio();

      // Membuat request POST ke server
      final response = await dio.post(
        "$baseUrl/API/send_notification.php",
        data: {
          "title": "Pesanan Baru dari Web",
          "body": "$nama memesan dari Meja $mejaID",
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      final data = response.data;
      print("Notifikasi terkirim: $data");
    } catch (e) {
      print("Gagal mengirim notifikasi: $e");
    }
  }

  Future<String?> requestSnapToken({
    required String orderId,
    required int grossAmount,
    required Map<String, dynamic> customerDetails,
    required List<Map<String, dynamic>> itemDetails,
  }) async {
    try {
      final data = {
        'order_id': orderId,
        'gross_amount': grossAmount,
        'customer_details': customerDetails,
        'item_details': itemDetails,
      };

      final response = await dio.post(
        '$baseUrl/API/midtrans.php', // Ganti dengan URL PHP kamu
        data: jsonEncode(data),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final jsonResponse =
            response.data is String ? jsonDecode(response.data) : response.data;

        if (jsonResponse['token'] != null) {
          return jsonResponse['token'];
        } else {
          throw Exception('Failed to get Snap Token');
        }
      } else {
        throw Exception('Failed to contact the server: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getTransaksiByOrderId(
    String orderId,
  ) async {
    try {
      final response = await Dio().post(
        '$baseUrl/API/getPesananByOrderId.php',
        data: {"orderId": orderId},
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      if (response.statusCode == 200) {
        // Decode the JSON string into a list of maps
        final jsonResponse = jsonDecode(
          response.data,
        ); // Decode the string into a list

        // Check if the response is a List
        if (jsonResponse is List) {
          return List<Map<String, dynamic>>.from(jsonResponse);
        } else {
          throw Exception('Unexpected response format: $jsonResponse');
        }
      } else {
        throw Exception(
          'Failed to load transaksi list: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching transaksi list: $e');
    }
  }

  Future<bool> updateRatingItem({
    required int id,
    required double rating,
  }) async {
    try {
      final response = await Dio().post(
        '$baseUrl/API/updateRating.php',
        data: jsonEncode({'id': id, 'rating': rating}),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final jsonResponse =
          response.data is String ? jsonDecode(response.data) : response.data;

      print(jsonResponse);

      return jsonResponse['status'] == 'success';
    } catch (e) {
      return false;
    }
  }
}

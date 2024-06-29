import 'dart:convert';
import 'package:cobaauth/models/item_model.dart';
import 'package:http/http.dart' as http;

abstract class ItemRepository {
  Future<List<Item>> fetchItems(String token);
  Future<void> addItem(String token, String name, String description);
  Future<void> updateItem(
      String token, int id, String name, String description);
  Future<void> deleteItem(String token, int id);
}

class ItemRepositoryImpl implements ItemRepository {
  final http.Client client;

  ItemRepositoryImpl({required this.client});

  @override
  Future<List<Item>> fetchItems(String token) async {
    final response = await client.get(
      Uri.parse('http://10.0.2.2:3000/items'),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Item.fromJson(model)).toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  @override
  Future<void> addItem(String token, String name, String description) async {
    final response = await client.post(
      Uri.parse('http://10.0.2.2:3000/items'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add item');
    }
  }

  @override
  Future<void> updateItem(
      String token, int id, String name, String description) async {
    final response = await client.put(
      Uri.parse('http://10.0.2.2:3000/items/$id'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update item');
    }
  }

  @override
  Future<void> deleteItem(String token, int id) async {
    final response = await client.delete(
      Uri.parse('http://10.0.2.2:3000/items/$id'),
      headers: {'Authorization': token},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }
}

// lib/controllers/item_controller.dart

import 'package:cobaauth/models/item_model.dart';
import 'package:cobaauth/services/item_service.dart';

class ItemController {
  final ItemService service;

  ItemController({required this.service});

  Future<List<Item>> fetchItems(String token) async {
    try {
      return await service.fetchItems(token);
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }

  Future<void> addItem(String token, String name, String description) async {
    try {
      await service.addItem(token, name, description);
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  Future<void> updateItem(String token, int id, String name, String description) async {
    try {
      await service.updateItem(token, id, name, description);
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String token, int id) async {
    try {
      await service.deleteItem(token, id);
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }
}

import 'package:cobaauth/models/item_model.dart';
import 'package:cobaauth/repository/item_repository.dart';

class ItemService {
  final ItemRepository repository;

  ItemService({required this.repository});

  Future<List<Item>> fetchItems(String token) async {
    return repository.fetchItems(token);
  }

  Future<void> addItem(String token, String name, String description) async {
    return repository.addItem(token, name, description);
  }

  Future<void> updateItem(String token, int id, String name, String description) async {
    return repository.updateItem(token, id, name, description);
  }

  Future<void> deleteItem(String token, int id) async {
    return repository.deleteItem(token, id);
  }
}

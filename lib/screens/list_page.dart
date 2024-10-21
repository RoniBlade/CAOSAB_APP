import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:supply_sync_app/screens/title_widget.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<bool> _isExpanded = [];
  List<Map<String, dynamic>> items = [];
  bool _isLoading = true;

  // Создаем экземпляр Logger в состоянии
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Метод для загрузки данных с кеша или сервера
  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cachedItems = prefs.getStringList('cachedItems');

    if (cachedItems != null && cachedItems.isNotEmpty) {
      try {
        // Пробуем декодировать данные из кеша
        setState(() {
          items = cachedItems
              .map((item) => json.decode(item) as Map<String, dynamic>)
              .toList();
          _isExpanded.addAll(List.generate(items.length, (_) => false));
          _isLoading = false;
        });
      } catch (e) {
        // Логируем и загружаем данные с сервера, если декодирование не удалось
        logger.e('Ошибка декодирования кешированных данных: $e');
        await _fetchItemsFromApi();
      }
    } else {
      // Если данных в кеше нет, загружаем их с сервера
      await _fetchItemsFromApi();
    }
  }

  // Метод для получения данных из API
  Future<void> _fetchItemsFromApi() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8080/api/items'));

      if (response.statusCode == 200) {
        // Декодируем ответ
        final List<dynamic> fetchedItems = json.decode(response.body);

        // Логируем полученные данные
        logger.d('Полученные данные: $fetchedItems');

        setState(() {
          items = fetchedItems
              .map((item) => {
                    'name': item['name'].toString(),
                    'quantityOnShelves': item['quantityOnShelves'] ?? 0,
                    'quantityInStock': item['quantityInStock'] ?? 0,
                  })
              .toList();
          _isExpanded.addAll(List.generate(items.length, (_) => false));
          _isLoading = false;
        });

        // Сохраняем данные в кеш
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(
            'cachedItems', items.map((item) => json.encode(item)).toList());
      } else {
        logger.e('Ошибка загрузки данных с кодом: ${response.statusCode}');
        throw Exception('Ошибка загрузки данных');
      }
    } catch (e) {
      logger.e('Ошибка: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : items.isEmpty
                ? const Center(
                    child: Text(
                      'Недостаточно данных для отображения',
                      style: TextStyle(
                        fontFamily: 'Jura',
                        fontSize: 20,
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.center, // Центрируем заголовок
                        child: TitleWidget(),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _isExpanded[index] =
                                        !_isExpanded[index];
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  side: const BorderSide(
                                      color: Colors.blue, width: 2),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            items[index]['name'],
                                            style: const TextStyle(
                                              fontFamily: 'Jura',
                                              fontSize: 20,
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          _isExpanded[index]
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.blue,
                                          size: 28,
                                        ),
                                      ],
                                    ),
                                    if (_isExpanded[index])
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          'Количество на полках: ${items[index]['quantityOnShelves']}.\n'
                                          'Количество на складе: ${items[index]['quantityInStock']}.',
                                          style: const TextStyle(
                                            fontFamily: 'Jura',
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  // Храним состояние (раскрыт/свернут) для каждого элемента списка
  final List<bool> _isExpanded = List.generate(4, (_) => false);

  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(4, (index) => 'Свечки');

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30), // Отступ сверху
            const Text(
              'SupplySync',
              style: TextStyle(
                fontFamily: 'Jura',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            con
            
            st SizedBox(height: 30), // Отступ между заголовком и списком
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
                          _isExpanded[index] = !_isExpanded[index];
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        side: const BorderSide(color: Colors.blue, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Добавляем отступ слева от текста
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  items[index],
                                  style: const TextStyle(
                                    fontFamily: 'Jura',
                                    fontSize: 20,
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8), // Отодвигаем стрелку от текста
                              Icon(
                                _isExpanded[index]
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.blue,
                                size: 28,
                              ),
                            ],
                          ),
                          // Показ дополнительной информации при раскрытии
                          if (_isExpanded[index])
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                'Краткая информация о товаре: ${items[index]}.\n'
                                'Описание, цена и наличие на складе.',
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

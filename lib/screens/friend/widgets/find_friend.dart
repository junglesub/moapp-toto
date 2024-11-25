import 'package:flutter/material.dart';

import 'package:search_page/search_page.dart';

class Person implements Comparable<Person> {
  final String name, surname;
  final num age;

  const Person(this.name, this.surname, this.age);

  @override
  int compareTo(Person other) => name.compareTo(other.name);
}

const people = [
  Person('Mike', 'Barron', 64),
  Person('Todd', 'Black', 30),
  Person('Ahmad', 'Edwards', 55),
  Person('Anthony', 'Johnson', 67),
  Person('Annette', 'Brooks', 39),
];

class FindFriend extends StatelessWidget {
  const FindFriend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchPage<Person>(
                items: people,
                searchLabel: 'Search people',
                searchStyle: TextStyle(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                barTheme: Theme.of(context).copyWith(
                  textSelectionTheme:
                      TextSelectionThemeData(cursorColor: Colors.grey[400]),
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle: TextStyle(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ),
                suggestion: const Center(
                  child: Text('Filter people by name, surname or age'),
                ),
                failure: const Center(
                  child: Text('No person found :('),
                ),
                filter: (person) => [
                  person.name,
                  person.surname,
                  person.age.toString(),
                ],
                builder: (person) => ListTile(
                  title: Text(person.name),
                  subtitle: Text(person.surname),
                  trailing: Text('${person.age} yo'),
                ),
              ),
            );
          },
          child: const Text('주변 친구 검색'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

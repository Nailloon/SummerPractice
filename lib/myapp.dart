import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:taskforsummerpractice/contact.dart';
import 'all.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  List<Contact> contacts = [];
  @override
  initState() {
    loadInfoFromJson();
    super.initState();
  }

  Future<void> loadInfoFromJson() async {
    String data = await rootBundle.loadString("assets/bootcamp.json");
    List<dynamic> list = jsonDecode(data)['data'] as List<dynamic>;
    setState(() => contacts = list.map((e) => Contact.fromJson(e)).toList()
      ..sort((a, b) {
        if (a.dateTime == null && b.dateTime == null) {
          return 0;
        } else if (a.dateTime == null) {
          return 1;
        } else if (b.dateTime == null) {
          return -1;
        }
        return b.dateTime!.compareTo(a.dateTime!);
      }));
  }

  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<Contact> searchedContacts = [];

  void searchContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        searchedContacts.clear();
      } else {
        isSearching = true;
        searchedContacts = contacts
            .where((contact) =>
                contact.name.toLowerCase().contains(query.toLowerCase()) ||
                (contact.lastMessage != null &&
                    contact.lastMessage!
                        .toLowerCase()
                        .contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xff0000CD),
          leading: const Icon(Icons.menu, size: 30),
          title: const Text(
            "MeowgChat",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w300, color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, size: 35),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchedContacts.clear();
                  }
                });
              },
            ),
          ],
        ),
        body: isSearching
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) => searchContacts(query),
                      decoration: InputDecoration(
                        hintText: 'Insert nickname or text of message',
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: searchedContacts.length,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = searchedContacts[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ContactChatElement(contact),
                        );
                      },
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = contacts[index];
                  if (contact.lastMessage == null) {
                    return Container();
                  }
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ContactChatElement(contact),
                  );
                },
              ));
  }
}

class ContactChatElement extends StatelessWidget {
  final Contact contact;
  const ContactChatElement(this.contact, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(top: 10, left: 10),
        leading: GradientCircleAvatar(
          avatar: contact.avatar,
          gradient: contact.contactGradient,
          text: contact.name.substring(0, 1),
        ),
        title: Text(contact.name),
        subtitle: contact.lastMessage != null
            ? Text(
                contact.lastMessage!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: contact.dateTime != null
            ? Column(
                children: [
                  Text(formatDate(contact.dateTime!)),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xff0000CD),
                    child: contact.countUnreadMessages > 0
                        ? Text(contact.countUnreadMessages.toString())
                        : null,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

String formatDate(DateTime timestamp) {
  DateTime now = DateTime.now();
  DateTime date = DateTime(timestamp.year, timestamp.month, timestamp.day);
  Duration difference = now.difference(date);

  if (difference.inDays == 0) {
    // Show time if message was sent today
    return DateFormat.Hm().format(timestamp);
  } else if (difference.inDays <= 6) {
    // Show day of week if message was sent within this week
    return DateFormat.E().format(timestamp);
  } else {
    // Show date in format "d MMM" for older messages
    return DateFormat('d MMM').format(timestamp);
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:taskforsummerpractice/contact.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  _HomeState createState()=> _HomeState();
}

class _HomeState extends State<HomePage>{
  List<Contact> contacts = [];
    @override
    initState() {
      loadInfoFromJson();
      super.initState();
  }

  Future<void> loadInfoFromJson() async {
    String data = await rootBundle.loadString("assets/bootcamp.json");
    List<dynamic> list = jsonDecode(data)['data'] as List<dynamic>;
    setState(() => contacts = list.map((e) => Contact.fromJson(e)).toList());
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff0000CD),
        leading: const Icon(Icons.menu, size: 30),
        title: const Text("MeowgChat", style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w300,
          color: Colors.white
        ),),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.search, size: 35))
        ],
      ),
      
      body: ListView(
          children: [
            if (contacts.isNotEmpty)
              ContactChatElement(contacts[17]),
          ]
    ));
  }
}

class ContactChatElement extends StatelessWidget{
  final Contact contact;
  const ContactChatElement(this.contact, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 10, left: 10),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: contact.avatar!=null ? AssetImage('assets/avatars/${contact.avatar!}'): null,
            child: contact.avatar==null ? Container(
              decoration: BoxDecoration(
                gradient: contact.contactGradient
              ),
              child: Text(
                contact.name.substring(0, 1),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ): null,
            ),
      title: Text(contact.name),
      subtitle: contact.lastMessage!=null ? Text(
        contact.lastMessage!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ): null,
      trailing: contact.dateTime!=null ? Column(children: [
         Text(formatDate(contact.dateTime!)),
         CircleAvatar(
          radius: 15, 
          backgroundColor: Color(0xff0000CD),
          child: contact.countUnreadMessages > 0 ? Text(contact.countUnreadMessages.toString()): null,
         )
      ],):null,
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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String preferenceKey; 
  final bool initialValue;

  const NotificationTile({
    required this.title,
    required this.subtitle,
    required this.preferenceKey,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  _NotificationTileState createState() => _NotificationTileState();
}

class _NotificationTileState extends State<NotificationTile> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
  }

  Future<void> _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool(widget.preferenceKey) ?? widget.initialValue;
    });
  }

  Future<void> _saveSwitchState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(widget.preferenceKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      trailing: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
          });
          _saveSwitchState(value);
        },
      ),
    );
  }
}

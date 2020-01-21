import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return ListView(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Update Your Brew Settings',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
                          initialValue: userData.name,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Name'),
                          validator: (val) =>
                              val.isEmpty ? 'Please Enter a Name' : null,
                          onChanged: (value) {
                            setState(() => _currentName = value);
                          }),
                      SizedBox(
                        height: 12.0,
                      ),
                      DropdownButtonFormField(
                          decoration: textInputDecoration,
                          items: sugars.map((sugar) {
                            return DropdownMenuItem(
                                value: sugar, child: Text('$sugar sugars'));
                          }).toList(),
                          value: _currentSugars ?? userData.sugars,
                          onChanged: (val) =>
                              setState(() => _currentSugars = val)),
                      SizedBox(
                        height: 12.0,
                      ),
                      Slider(
                          activeColor: Colors
                              .brown[_currentStrength ?? userData.strength],
                          inactiveColor: Colors
                              .brown[_currentStrength ?? userData.strength],
                          min: 100,
                          max: 900,
                          divisions: 8,
                          value: (_currentStrength ?? userData.strength)
                              .toDouble(),
                          onChanged: (val) =>
                              setState(() => _currentStrength = val.round())),
                      SizedBox(
                        height: 12.0,
                      ),
                      RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await DatabaseService(uid: user.uid).updateUserData(
                                _currentSugars ?? userData.sugars,
                                _currentName ?? userData.name,
                                _currentStrength ?? userData.strength);

                            Navigator.pop(context);
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return Loading();
          }
        });
  }
}

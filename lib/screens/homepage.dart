import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../drawer.dart';

class AbacusHomePage extends StatelessWidget {
  final String username;
  final String email;
  final String photo;

  AbacusHomePage(
      {required this.username, required this.email, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: TrendingSidebar(
        email: email,
        username: username,
        photo: photo,
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 30.0),
              Center(
                child: Text(
                  'Abacus Practice',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 60.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildIconButton(context, FontAwesomeIcons.plus, 'Addition'),
                  _buildIconButton(
                      context, FontAwesomeIcons.minus, 'Subtraction'),
                  _buildIconButton(
                      context, FontAwesomeIcons.divide, 'Division'),
                ],
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildIconButton(
                      context, FontAwesomeIcons.gripVertical, 'Mix'),
                  _buildIconButton(
                      context, FontAwesomeIcons.infoCircle, 'About'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon, String text) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Clicked $text'),
        ));
      },
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            size: 50.0,
            color: Colors.black,
          ),
          SizedBox(height: 10.0),
          Text(
            text,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

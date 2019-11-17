import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torrential_lib/screens/TorrentController.dart';
import 'package:torrential_lib/src/core/contracts/torrent_interface.dart';
import 'package:torrential_lib/src/core/exceptions/exceptions.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey ,
        appBar: AppBar(
          title: Text("Torrential-Lib Demo"),
        ),
        body: HomeComponent());
  }
}

class HomeComponent extends StatefulWidget {
  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {

  TextEditingController usernameController =
  TextEditingController(text: "natesh");

  TextEditingController passwordController =
  TextEditingController(text: "password");

  TextEditingController ipController =
  TextEditingController(text: '192.168.0.100');

  TextEditingController portController = TextEditingController(text: "8080");

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextField(
            controller: ipController,
            decoration: InputDecoration(
                labelText: "IP address",
                hintText: "192.168.0.100",
                prefixIcon: Icon(Icons.computer),
                border: OutlineInputBorder()),
          ),
          TextField(
            controller: portController,
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(
                labelText: "Port",
                hintText: "8080",
                prefixIcon: Icon(Icons.linear_scale),
                border: OutlineInputBorder()),
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
                labelText: "Username",
                hintText: "natesh",
                prefixIcon: Icon(Icons.account_circle),
                border: OutlineInputBorder()),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.computer),
                border: OutlineInputBorder()),
            obscureText: true,
          ),
          RaisedButton(
            child: Text("Connect and Login"),
            onPressed: () {
              String ip = ipController.text , pass = passwordController.text ,
              user = usernameController.text , port = portController.text ;
              QbitTorrentController qbittorrent = QbitTorrentController(ip , int.parse(port));
              qbittorrent .login(user, pass) .then((_) {
               Navigator.push( context, MaterialPageRoute( builder: (context) =>
                   TorrentControllerPage(ip:ip , port: port , password: pass , username: user,)));
              })
                  .catchError((Object e){
                    String error = "Login Failed" ;
                    if(e is InvalidCredentialsException)
                      error = e.response.body ;
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(error),));
              });
            },
          )
        ],
      ),
    );
  }
}


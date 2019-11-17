import 'package:flutter/material.dart';
import 'package:torrential_lib/torrential_lib.dart';
import 'package:torrential_lib/src/core/exceptions/exceptions.dart';

class TorrentControllerPage extends StatefulWidget {
  final String ip , port , username , password ;
  TorrentControllerPage({Key key, this.ip, this.port, this.username, this.password, }) : super(key: key);
  @override
  _TorrentControllerPageState createState() => _TorrentControllerPageState(ip , port , username , password);
}

class _TorrentControllerPageState extends State<TorrentControllerPage> {
  final String ip , port , username , password ;

  QbitTorrentController qbittorrent;

  _TorrentControllerPageState(this.ip, this.port, this.username, this.password);

  @override
  void initState() {
    super.initState();
    qbittorrent = new QbitTorrentController(ip , int.parse(port));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
          FutureBuilder(initialData: null ,
          future : qbittorrent.login(username , password).then((f)=>qbittorrent.getTorrentList()) ,
            builder: (context , snap){
              if(snap.connectionState == ConnectionState.done){
                if(snap.data==null) return CircularProgressIndicator() ;
                return Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    children: List.from(snap.data).map((torrent){
                      print(torrent) ;
                      return ListTile(
                        onTap: (){},
                        leading: Icon(Icons.album),
                        title: Text(torrent['name']),
                      );
                    }).toList()
                  ),
                );
              }
              else return CircularProgressIndicator() ;
            },
          ),
            RaisedButton(
              child: Text("Start All"),
              onPressed: () {
                try {
                  qbittorrent.startAllTorrents();
                } on InvalidParameterException catch (e) {
                  print(e.response.body);
                }
              },
            ),

            RaisedButton(
              child: Text("Stop All"),
              onPressed: () {
                qbittorrent.stopAllTorrents();
              },
            )
          ],
        ),
      ),
    );
  }
}

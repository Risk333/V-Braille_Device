import 'dart:async';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(MyApp());


// STEP1:  Stream setup
class StreamSocket{
  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'DEMO APP';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IO.Socket? _socket;
  final myController = TextEditingController();

  // STEP2:  Stream setup
  StreamSocket streamSocket =StreamSocket();




  @override
  void initState() {
    // TODO: implement initState
    initSocket();
    // initStreamBuilder();
    // initStream();
    super.initState();
  }

  void initSocket() {
    try {
      _socket = IO.io('http://192.168.159.72:3010', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket?.connect();

      _socket?.onConnect((_) {
        print('connect to server succesfully');
        // _socket?.emit("gotoserver",myController.text);
      });

      _socket?.on("goToMobile", (data) {
        streamSocket.addResponse(data);
      });

      _socket?.onDisconnect((_) {
        print('disconnect to server');
      });

      
    } catch (err) {
      print(err);
    }
  }



  void sendText(String msg) {
    _socket?.emit("gotoserver", msg);
    //empty text field
    myController.clear();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
                child: TextField(
              controller: myController,
            )),
            const SizedBox(height: 24),

            // STEP3:  Stream setup
            const Text(" data recieved from pico: ",style: TextStyle(fontSize: 20),),
            const SizedBox(height: 24),
            StreamBuilder<String>(
              stream: streamSocket.getResponse,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!,
                  style: TextStyle(fontSize: 20),
                  );
                } else {
                  return const Text('No data');
                }
              },
            ),
           
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendText(myController.text);
        },
        tooltip: 'Send message',
        
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // void _sendMessage() {
  //   if (_controller.text.isNotEmpty) {
  //     _channel.sink.add(_controller.text);
  //     _controller.text= '';
  //   }
  // }

  @override
  void dispose() {
    // _channel.sink.close();
    // _controller.dispose();
    myController.dispose();
    // _streamController.close();

    super.dispose();
  }
}

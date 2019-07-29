import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(FriendlyChatApp());

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.purple, accentColor: Colors.orangeAccent[400]);

class FriendlyChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendlychat",
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposing = false;

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(children: <Widget>[
              new Flexible(
                  child: new TextField(
                      controller: _textEditingController,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration.collapsed(
                          hintText: "Send a message"),
                      onChanged: (String text) {
                        setState(() {
                          _isComposing = text.length > 0;
                        });
                      })),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Send"),
                          onPressed: _isComposing
                              ? () =>
                                  _handleSubmitted(_textEditingController.text)
                              : null)
                      : new IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _isComposing
                              ? () =>
                                  _handleSubmitted(_textEditingController.text)
                              : null))
            ])));
  }

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    setState(() {
      _isComposing = false;
    });

    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          duration: new Duration(milliseconds: 1000), vsync: this),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friendly-Chat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(top: BorderSide(color: Colors.grey[200])))
              : null,
          child: new Column(children: <Widget>[
            new Flexible(
                child: new ListView.builder(
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                    padding: const EdgeInsets.all(8.0),
                    reverse: true)),
            new Divider(height: 1.0),
            new Container(
                decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _buildTextComposer())
          ]),
        ));
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  static const String _name = "Dung Nguyen";
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
//        sizeFactor: new CurvedAnimation(
//          parent: animationController,
//          curve: Curves.easeOutSine,
//        ),
//        axisAlignment: 0.0,
        opacity: CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn),
        child: new Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      child: new CircleAvatar(child: new Text(_name[0]))),
                  new Expanded(
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        new Text(_name,
                            style: Theme.of(context).textTheme.subhead),
                        new Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: new Text(text))
                      ]))
                ])));
  }
}

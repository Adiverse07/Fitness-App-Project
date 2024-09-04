import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class RecipeView extends StatefulWidget {
  // const RecipeView({super.key});

  String url;
  RecipeView(this.url);

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late final String finalurl;


  final Completer <WebViewController> controller = Completer <WebViewController>();
  @override
  void initState() {

    if(widget.url.toString().contains("http://")){
      finalurl = widget.url.replaceAll("http", "https");
    }
    else{
      finalurl=widget.url;
    }
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe"),

      ),
      body: Container(
        child: WebView(
          initialUrl:finalurl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated:(WebViewController webViewController){
            setState(() {
              controller.complete(webViewController);

            });
          },
        ),
      ),
    );
  }
}

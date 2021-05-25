import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:wmcTest/api.dart';
import 'package:wmc_personalized_plugin/wmc_personalized_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Unknown';
  String session;

  AccountApi _accountApi = AccountApi();

  @override
  void initState() {
    super.initState();
    /*
     Haber solicitado permiso de READ_PHONE_STATE para el caso de 
     Android ya que por default se envia el codigo de identificador en null en 
     ios no es necesario
     */
    // asyncMethod();  
  }

  load() async {
   await _accountApi.getData();
  }

  Future<void> initializeWmc() async {
    String initializeWmc; 
    try {
      initializeWmc = await WmcPersonalizedPlugin.initialize("36f4de87aca77d091a54f388fcfb9a6e");
    } on PlatformException {
      initializeWmc = 'Failed to initialize WMC.';
    }

    setState(() {
      _result = initializeWmc;
    });
  }

  void asyncMethod() async {
    await initializeWmc();
    session = await WmcPersonalizedPlugin.session();

    String json = '{\"rqCliente\": {\"nombre\": \"Daniel\",\"apellido\": \"Valverde\",\"identificacion\": \"0924554264\",\"identificaTipo\": \"C\",\"celular\": \"\"},\"login\": \"0924554264\",\"password\": \"Daniel2021.\"}';

    while (true){
      // await sendPut(session,"https://wallet.elrosado.com:5479/api/Login/Valida",json);
      // await sendGet(session, "https://wallet.elrosado.com:5479/api/Configuracion");


      // await sendGet(session, "https://reqres.in/api/users?page=2");
      // await sendGet(session, "https://wallet.elrosado.com:5479/api/AcercaDe");

      sleep(Duration(seconds: 3));
    } 
  } 

  Future<void> sendPut(String session,String url,String json) async{
    Map result;  
    try {
      result = await WmcPersonalizedPlugin.put(session,
        url,
        { 'content-type': 'application/json' },
        json,
      );
    } on PlatformException {
      print("Ocurrió un error");
    } catch (e) {
      print("Llegó a este error: ${e.toString()}");
    }
 
    print(result);
    setState(() {
      _result = result.toString();
    }); 
  }  

  Future<void> sendGet(String session, String url) async{
    Map result;  
    try {
      result = await WmcPersonalizedPlugin.request(session,
        url,
        "GET",
        { 'content-type': 'application/json' },
        {'abc': '123'},
      );
    } on PlatformException {
      print("Ocurrió un error");
    } catch (e) {
      print("Llegó a este error: ${e.toString()}");
    }
 
    print(result);
    setState(() {
      _result = result.toString();
    }); 
  }  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_result\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: load,
          child: Icon(Icons.get_app_rounded),
        ),
      ),
    );
  }
}

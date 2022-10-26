import 'package:flutter_app_with_package/base_model.dart';
import 'package:flutter_app_with_package/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';

class HomeViewModel extends BaseModel {
 MqttService _mqttService = MqttService();

 var valueWatering;
 var valueLampu;
 var pompa;
 var statusTanah;
 bool lampIndicator = false;

 void initState() async{
   // getWateringMessage();
   // setBusy(false);
   getLampMessage();
   setBusy(false);
 }

 void getWateringMessage() async {
   _mqttService.subscribe('SmartWatering', getDataMessage);
 }

 void getDataMessage() async {
   print('Watering');
   _mqttService.client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
     final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
     final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
     valueWatering = int.parse(message);
     if(valueWatering < 350){
       statusTanah = 'Lembab';
       pompa = 'Off';
     } else if(valueWatering > 700){
       statusTanah = 'Kering';
       pompa = 'On';
     } else if(valueWatering >= 350 && valueWatering <= 700){
       statusTanah = 'Normal';
       pompa = 'Off';
     }
     setBusy(false);
   });
 }

 void sendMessage(String value) async {
   _mqttService.publish('Lampu',value);
 }

 void getLampMessage() async {
   _mqttService.subscribe('Lampu', getDataLampMessage);
 }

 void getDataLampMessage() async {
   _mqttService.client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
     final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
     final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
     valueLampu = message;
     if(valueLampu == '1'){
       lampIndicator = true;
       setBusy(false);
     } else if (valueLampu == '0'){
       lampIndicator = false;
       setBusy(false);
     }
     setBusy(false);
   });
 }

}
// import 'package:flutter/material.dart';
// import 'package:fluttercourse/main.dart';
// import 'package:provider/provider.dart';
//
// class ProviderPage extends StatefulWidget {
//   const ProviderPage({super.key});
//
//   @override
//   State<ProviderPage> createState() => _ProviderPageState();
// }
//
// class _ProviderPageState extends State<ProviderPage> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text("${context.watch <Model> ().name}"),
//         SizedBox(height: 20,),
//         MaterialButton(
//           color : Colors.blue,
//           child: Text("model"),
//           onPressed: (){
//             context.read <Model> ().modifyData("Yasmeen");
//           },
//         ),
//         SizedBox(height: 10,),
//         MaterialButton(
//           color : Colors.blue,
//           child: Text("Another model"),
//           onPressed: (){
//            context.read <AnotherModel>().changeName();
//           },
//         ),
//
//         SizedBox(height: 50,),
//
//         Consumer<Streammodel>(builder: (context , stream , child){
//           return Text("${stream.streamvalue}");
//         }),
//         Consumer<Streammodel>(builder: (context , stream , child){
//           return MaterialButton(
//             color: Colors.blue,
//             child: Text("Change"),
//             onPressed: (){
//               stream.changeValue();
//             },
//           );
//         }),
//
//         SizedBox(height: 50,),
//         Consumer<FutureModel>(builder: (context , fut , child){
//           return Text("${fut.future}");
//         }),
//
//       ],
//     );
//
//
//   }
// }
//
//
//
//
// //provider => access the data from any widget or page without passing process  (provider must be the parent) => in main page
//
//
// // provider of context => listen = true  ->  context.watch
// // provider of context => listen = false  ->  context.read
//
//

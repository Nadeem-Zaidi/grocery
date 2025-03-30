// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_yellow/authentication2/phone_state/phone_auth_cubit.dart';
// import 'package:grocery_yellow/blocs/dashboard/bloc/dashboard_bloc.dart';

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<AuthCubit, AuthState>(
//           listenWhen: (p, c) => p.isLoggedIn != c.isLoggedIn && !c.isLoggedIn,
//           listener: (context, state) {
//             Navigator.of(context).pushReplacementNamed('/signinsignup');
//           },
//         ),
//       ],
//       child: Scaffold(
//         body: BlocProvider<DashboardBloc>(
//           create: (context) =>
//               DashboardBloc()..add(FetchSection(pageNumber: 1)),
//           child: BlocBuilder<DashboardBloc, DashBoardState>(
//             builder: (context, state) {
//               print(state.dashBoardContent);
//               if (state.dashBoardContent.isNotEmpty &&
//                   state.error == null &&
//                   state.isLoading == false) {
//                 var content = state.dashBoardContent;

//                 return CustomScrollView(
//                   slivers: [
//                     SliverAppBar(
//                       floating: true,
//                       title: const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Delivery in',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             '7 minutes',
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 "Home-",
//                                 style: TextStyle(
//                                     fontSize: 20, fontWeight: FontWeight.bold),
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     "Niknampur Road",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.normal),
//                                   ),
//                                   Icon(
//                                     Icons.arrow_drop_down,
//                                     color: Colors.black,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       pinned: true,
//                       toolbarHeight: 100,
//                       snap: true,
//                       backgroundColor: Theme.of(context).primaryColor,
//                       bottom: PreferredSize(
//                         preferredSize: const Size.fromHeight(60.0),
//                         child: Container(
//                           padding: const EdgeInsets.all(5),
//                           margin: const EdgeInsets.only(bottom: 5),
//                           height: 55,
//                           child: TextField(
//                             textAlign: TextAlign.justify,
//                             decoration: InputDecoration(
//                               hintText: "Search",
//                               labelStyle: const TextStyle(fontSize: 18),
//                               prefixIcon: const Icon(
//                                 Icons.search,
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     width: 3, color: Colors.white),
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     width: 3, color: Colors.white),
//                                 borderRadius: BorderRadius.circular(8.0),
//                               ),
//                               filled: true,
//                               fillColor: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     for (var sec in content) ...[
//                       SliverToBoxAdapter(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             sec['type'],
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SliverGrid(
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                           childAspectRatio: 2 / 3,
//                         ),
//                         delegate: SliverChildBuilderDelegate(
//                           (context, index) {
//                             var item = sec['data'];
//                             return Card(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: AspectRatio(
//                                       aspectRatio: 1.2,
//                                       child: item[index]['images'] != null &&
//                                               item[index]['images'].isNotEmpty
//                                           ? Image.network(
//                                               item[index]['images'][0],
//                                               fit: BoxFit.cover,
//                                               width: double.infinity,
//                                             )
//                                           : Container(
//                                               color: Colors.grey,
//                                             ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         item[index]['name'],
//                                         style: const TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w500),

//                                         maxLines:
//                                             2, // Limit the text to 2 lines
//                                         overflow: TextOverflow
//                                             .ellipsis, // Add ellipsis at the end
//                                         softWrap: true,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                           childCount: sec['data'].length,
//                         ),
//                       ),
//                     ],
//                   ],
//                 );
//               }
//               return const Center(child: CircularProgressIndicator());
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

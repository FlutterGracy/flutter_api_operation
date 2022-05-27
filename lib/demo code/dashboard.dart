// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../../theme/Theme.dart';
// import '../../../../theme/responsive.dart';
// import '../../../../web_service/APIDirectory.dart';
// import '../../../../web_service/HTTP.dart' as HTTP;
//
// import '../model/dashboard_table_model.dart';
// import 'dashboard_header.dart';
// import 'filter_criteria.dart';
//
// class DashboardTablePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _DashboardTablePageState();
// }
//
// class _DashboardTablePageState extends State<DashboardTablePage> {
//   final _baseUrl = getDashboardTripList();
//
//   // At the beginning, we fetch the first 20 posts
//   int _page = 1;
//   int _limit = 20;
//   int? _activeMeterIndex;
//   String? driverId = "",
//       status = "",
//       paymentType = "",
//       fromDate = "",
//       toDate = "";
//
//   // There is next page or not
//   bool _hasNextPage = true;
//
//   // Used to display loading indicators when _firstLoad function is running
//   bool _isFirstLoadRunning = false;
//
//   // Used to display loading indicators when _loadMore function is running
//   bool _isLoadMoreRunning = false;
//
//   // This holds the posts fetched from the server
//   List<DashboardTableModel> _posts = [];
//
//   late dynamic summaryData = null;
//
//   late ScrollController _controller;
//
//   FilterCriteria criteria = FilterCriteria.initial();
//
//   void onFilterCriteriaChanged(FilterCriteria changedCriteria) async {
//     criteria = changedCriteria;
//     _page = 1;
//     _hasNextPage = true;
//     driverId = criteria.get(name: "driverId").toString();
//     status = criteria.get(name: "status").toString();
//     paymentType = criteria.get(name: "paymentType").toString();
//     fromDate = criteria.get(name: "fromDate").toString();
//     toDate = criteria.get(name: "toDate").toString();
//     print("fromDate=====>" + fromDate.toString());
//     print("toDate=====>" + toDate.toString());
//     // setState(() {
//     _firstLoad();
//     // });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _firstLoad();
//     _controller = new ScrollController()..addListener(_loadMore);
//   }
//
//   @override
//   void dispose() {
//     _controller.removeListener(_loadMore);
//     super.dispose();
//   }
//
//   // This function will be called when the app launches (see the initState function)
//   void _firstLoad() async {
//     setState(() {
//       _isFirstLoadRunning = true;
//     });
//     try {
//       dynamic res = await HTTP.get(
//         Uri.parse("$_baseUrl?rowsPerPage=$_limit"
//             "&pageNumber=$_page&driverId=$driverId&status=$status&paymentType=$paymentType"
//             "&fromDate=$fromDate&toDate=$toDate"),
//       );
//
//       if (res.statusCode == 200) {
//         // print('To see trip data ${jsonDecode(res.body)}');
//         if (res.body.length > 0) {
//           setState(() {
//             _posts = (jsonDecode(res.body) as List)
//                 .map((i) => DashboardTableModel.fromJson(i))
//                 .toList();
//           });
//         } else {
//           throw "No Trips Available.";
//         }
//       } else {
//         throw "No Trips Available. error";
//       }
//
//       //Summary
//       dynamic resSummary = await HTTP.get(
//         Uri.parse("$_baseUrl?rowsPerPage=$_limit"
//             "&pageNumber=$_page&driverId=$driverId&status=$status&paymentType=$paymentType"
//             "&fromDate=$fromDate&toDate=$toDate&type=summary"),
//       );
//
//       if (resSummary.statusCode == 200) {
//         if (resSummary.body.length > 0) {
//           setState(() {
//             summaryData = jsonDecode(resSummary.body);
//             print('Summary data $summaryData');
//             print('Summary total trip ${summaryData["totalTrips"]}');
//           });
//         } else {
//           throw "No Trips Available.";
//         }
//       } else {
//         throw "No Trips Available. error";
//       }
//     } catch (err) {
//       print(err);
//     }
//
//     setState(() {
//       _isFirstLoadRunning = false;
//     });
//   }
//
//   void _loadMore() async {
//     if (_hasNextPage == true &&
//         _isFirstLoadRunning == false &&
//         _isLoadMoreRunning == false &&
//         _controller.position.extentAfter < 300) {
//       setState(() {
//         _isLoadMoreRunning = true; // Display a progress indicator at the bottom
//       });
//       _page += 1; // Increase _page by 1
//       try {
//         dynamic res = await HTTP.get(
//           Uri.parse("$_baseUrl?rowsPerPage=$_limit"
//               "&pageNumber=$_page&driverId=$driverId&status=$status&paymentType=$paymentType"
//               "&fromDate=$fromDate&toDate=$toDate"),
//         );
//
//         final List<DashboardTableModel> fetchedPosts =
//         (jsonDecode(res.body) as List)
//             .map((i) => DashboardTableModel.fromJson(i))
//             .toList();
//         if (fetchedPosts.length > 0) {
//           setState(() {
//             _posts.addAll(fetchedPosts);
//           });
//         } else {
//           // This means there is no more data
//           // and therefore, we will not send another GET request
//           setState(() {
//             _hasNextPage = false;
//           });
//         }
//       } catch (err) {
//         print("err======>" + err.toString());
//         print('Something went wrong!');
//       }
//
//       setState(() {
//         _isLoadMoreRunning = false;
//       });
//     }
//   }
//
//   // The controller for the ListView
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: _isFirstLoadRunning
//             ? Center(
//           child: CircularProgressIndicator(),
//         )
//             : Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               SummaryPannel(),
//               Container(
//                 child: DashboardHeader(
//                     defaultCriteria: criteria,
//                     onCriteriaChanged: onFilterCriteriaChanged,
//                     onRefresh: pullToRefresh),
//               ),
//
//               Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: () {
//                       return Future.delayed(Duration(seconds: 1), () {
//                         pullToRefresh();
//                       });
//                     },
//                     child: ListView.builder(
//                       controller: _controller,
//                       itemCount: _posts.length,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       itemBuilder: (_, i) => Card(
//                         elevation: 4,
//                         child: new ExpansionPanelList(
//                           expansionCallback: (int index, bool status) {
//                             setState(() {
//                               _activeMeterIndex =
//                               _activeMeterIndex == i ? null : i;
//                             });
//                           },
//                           children: [
//                             TripTableCard(i, context),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )),
//
//               // when the _loadMore function is running
//               if (_isLoadMoreRunning == true)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10, bottom: 40),
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//
//               // When nothing else to load
//               if (_hasNextPage == false)
//                 Container(
//                   padding: const EdgeInsets.only(top: 30, bottom: 40),
//                   color: Colors.green,
//                   child: Center(
//                     child: Text(
//                       'You have fetched all of the content',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ));
//   }
//
//   Container SummaryPannel() {
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           TripSummaryItem("Total", "totalTrips"),
//           TripSummaryItem("OnGoing", "ongoing"),
//           TripSummaryItem("Completed", "completed"),
//           TripSummaryItem("Cancelled", "cancelled"),
//           TripSummaryItem("Missed", "missedTrips"),
//           TripSummaryItem("Collection", "totalAmount"),
//           TripSummaryItem("KM", "totalDistance"),
//         ],
//       ),
//     );
//   }
//
//   Column TripSummaryItem(String title, String ele) {
//     String data = summaryData != null && summaryData[ele] != null
//         ? summaryData[ele].toStringAsFixed(0)
//         : '';
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(data,
//             style: TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
//         Text(title,
//             style: TextStyle(
//                 fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
//       ],
//     );
//   }
//
//   ExpansionPanel TripTableCard(int i, BuildContext context) {
//     return new ExpansionPanel(
//       isExpanded: _activeMeterIndex == i,
//       headerBuilder: (BuildContext context, bool isExpanded) => new Container(
//           padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
//           alignment: Alignment.centerLeft,
//           child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       driverDetails(context, i, false),
//                       vehicleNumber(i),
//                       TripTime(i),
//                       TripEndTime(i),
//                       TripDuration(i)
//                     ],
//                   ),
//                 ),
//                 if (!Responsive.isMobile(context))
//                   Expanded(
//                     flex: 2,
//                     // child: ConstrainedBox(
//                     //   constraints: BoxConstraints(
//                     //       // maxHeight: 300,
//                     //       // minHeight: 200,
//                     //       maxWidth: 500,
//                     //       minWidth: 200),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         fromLocation(i),
//                         toLocation(i),
//                       ],
//                     ),
//                     // ),
//                   ),
//                 Expanded(
//                   flex: 1,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(25.0, 8, 8, 8),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         customerName(i),
//                         paymentMode(i),
//                         Fare(i),
//                         distanceTravelled(context, i),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       TripStatus(context, i),
//                       OTP(i),
//                       // if (!Responsive.isMobile(context))
//                       paymentStatus(i)
//                     ],
//                   ),
//                 ),
//               ])),
//       body: new Container(
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child:
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 driverDetails(context, i, true),
//                 customerDetails(i, true),
//               ],
//             ),
//             vehicleDetails(i),
//             distanceTravelled(context, i),
//             paymentStatus(i),
//             fromLocation(i),
//             toLocation(i),
//           ]),
//         ),
//       ),
//     );
//   }
//
//   Text distanceTravelled(BuildContext context, int i) {
//     String dist = _posts[i].arrivalAtDestination.distanceTravelled.toString();
//     String distDetail = dist != null && dist != 'null' ? '$dist Km' : '';
//     return Text(
//       distDetail,
//       style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//     );
//   }
//
//   Padding fromLocation(int i) {
//     return Padding(
//         padding: EdgeInsets.only(top: 3),
//         child: Row(
//           children: <Widget>[
//             Icon(
//               Icons.location_on,
//             ),
//             Expanded(
//               child: Text(_posts[i].fromAddress.toString(),
//                   style: TextStyle(
//                       fontWeight: FontWeight.normal, color: Colors.black)),
//             )
//           ],
//         ));
//   }
//
//   Padding toLocation(int i) {
//     return Padding(
//         padding: EdgeInsets.only(top: 3),
//         child: Wrap(
//           children: [
//             Row(
//               children: <Widget>[
//                 Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                 ),
//                 Expanded(
//                   child: Text(_posts[i].toAddress.toString(),
//                       style: TextStyle(
//                           fontWeight: FontWeight.normal, color: Colors.black)),
//                 )
//               ],
//             ),
//           ],
//         ));
//   }
//
//   Column driverDetails(BuildContext context, int i, bool details) {
//     String name = _posts[i].driver.name.toString();
//     String truncName =
//     details == false && name.length > 10 ? name.substring(0, 10) : name;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (details)
//           Text('Driver',
//               style:
//               TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
//         Text(getCapitilizedFirstLetterString(truncName),
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
//         if (details)
//           Text(_posts[i].driver.phone.toString(),
//               style: TextStyle(
//                   fontWeight: FontWeight.normal, color: Colors.black)),
//       ],
//     );
//   }
//
//   Text customerName(int i) {
//     String name = _posts[i].customer.name.toString();
//     String truncName = name.length > 10 ? name.substring(0, 10) : name;
//     return Text(getCapitilizedFirstLetterString(truncName),
//         style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color.fromARGB(255, 7, 4, 181)));
//   }
//
//   Column customerDetails(int i, bool details) {
//     String name = _posts[i].customer.name.toString();
//     String truncName =
//     details == false && name.length > 10 ? name.substring(0, 10) : name;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         if (details)
//           Text('Customer',
//               style:
//               TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
//         Text(getCapitilizedFirstLetterString(truncName),
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
//         if (details)
//           Row(children: [
//             Text(_posts[i].customer.phone.toString(),
//                 style: TextStyle(
//                     fontWeight: FontWeight.normal, color: Colors.black)),
//             if (Responsive.isMobile(context))
//               MaterialButton(
//                 minWidth: 35,
//                 height: 35,
//                 onPressed: () {
//                   _launchPhoneURL(_posts[i].customer.phone.toString());
//                 },
//                 child: Icon(
//                   Icons.call,
//                   color: Colors.green,
//                 ),
//               ),
//           ])
//       ],
//     );
//   }
//
//   _launchPhoneURL(String phoneNumber) async {
//     launch('tel://$phoneNumber');
//   }
//
//   Row TripTime(int i) {
//     return Row(children: [
//       Text(convertDateFromString(_posts[i].createdDate.toString()),
//           style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
//       // Text(convertTimeFromString(_posts[i].createdDate.toString()),
//       //     style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
//     ]);
//   }
//
//   Text TripEndTime(int i) {
//     String fmtstart = convertTimeFromString(_posts[i].createdDate.toString());
//     String endTime = _posts[i].tripEndTime.toString();
//     String fmtendTime = endTime == null || endTime == 'null' ? "" : endTime;
//     return Text('$fmtstart-$fmtendTime',
//         style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black));
//   }
//
//   Text TripDuration(int i) {
//     String time = _posts[i].differenceInTripTime.toString();
//     String fmtTime = time == null || time == 'null' ? "" : 'Dur:$time';
//
//     return Text(
//       fmtTime,
//       style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//     );
//   }
//
//   Text paymentMode(int i) {
//     String paymentMode = _posts[i].paymentMode.toString();
//     String paymentModeDetail =
//     paymentMode != null && paymentMode != 'null' ? paymentMode : '';
//     return
//       // if (paymentModeDetail != '')
//       Text(
//         paymentModeDetail,
//         style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//       );
//   }
//
//   Row vehicleNumber(int i) {
//     String vehicle = _posts[i].vehicle.number.toString();
//     String vehicleDetail = vehicle != null && vehicle != 'null' ? vehicle : '';
//     return Row(children: [
//       if (vehicleDetail != '')
//         Text(
//           vehicleDetail,
//           style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//         ),
//     ]);
//   }
//
//   Column vehicleDetails(int i) {
//     String vehicle = _posts[i].vehicle.number.toString();
//     String soc = _posts[i].vehicle.soc.toString();
//     String dte = _posts[i].vehicle.dte.toString();
//
//     return Column(children: [
//       Text(
//         vehicle,
//         style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//       ),
//       Text(
//         'soc:$soc',
//         style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//       ),
//       Text(
//         'DTE:$dte',
//         style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//       ),
//     ]);
//   }
//
//   Text Fare(int i) {
//     String fare = _posts[i].arrivalAtDestination.totalFare.toString();
//     String fareDetail = fare != null && fare != 'null' ? '$fare Rs/-' : '';
//     return Text(
//       fareDetail,
//       style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//     );
//   }
//
//   Text paymentStatus(int i) {
//     String paymentStatus = _posts[i].paymentStatus.toString();
//     String paymentStatusDetail =
//     paymentStatus != null && paymentStatus != 'null' ? paymentStatus : '';
//     return Text(
//       paymentStatusDetail,
//       style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//     );
//   }
//
//   Text OTP(int i) {
//     return Text("OTP:-" + _posts[i].otp.toString(),
//         style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black));
//   }
//
//   Row DriverPhone(int i, bool icon) {
//     return Row(children: [
//       if (icon == true)
//         Icon(
//           Icons.phone_android,
//         ),
//       Text(
//         _posts[i].driver.phone.toString(),
//         style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
//       )
//     ]);
//   }
//
//   SizedBox TripStatus(BuildContext context, int i) {
//     return SizedBox(
//       // height: 35.0,
//         child: RaisedButton(
//           textColor: colorThemeData['primaryColor'],
//           disabledColor:
//           getTripStatusdisabledColor(context, _posts[i].status.toString()),
//           child: Text(getCapitilizedFirstLetterString(_posts[i].status.toString()),
//               style: Theme.of(context).textTheme.caption!.apply(
//                   color: getStatusColor(context, _posts[i].status.toString()),
//                   fontWeightDelta: 6,
//                   fontSizeFactor: 1.1)),
//           onPressed: null,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//         ));
//   }
//
//   Row driverNameWidget(int i, bool icon) {
//     return Row(children: [
//       if (icon == true)
//         Icon(
//           Icons.person,
//         ),
//       Text(
//         getCapitilizedFirstLetterString(_posts[i].driver.name.toString()),
//         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//       )
//     ]);
//   }
//
//   void pullToRefresh() {
//     _page = 1;
//     _hasNextPage = true;
//     driverId = "";
//     status = "";
//     ;
//     paymentType = "";
//     ;
//     fromDate = "";
//     ;
//     toDate = "";
//     ;
//     _firstLoad();
//   }
// }

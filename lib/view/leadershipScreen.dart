import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smile_quiz/view_model/services/authentication.dart';

import '../resources/appcolors.dart';
import '../resources/textStyle.dart';

// ignore: must_be_immutable
class LeaderShipBoard extends StatelessWidget {
  List rankingList = [];

  LeaderShipBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("LeaderShip"),
          centerTitle: true,
          backgroundColor: AppColors.appBar_theme,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .orderBy('TotalScore', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              rankingList = [];
              if (snapshot.hasData) {
                snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map data = document.data() as Map<String, dynamic>;
                  rankingList.add(data);
                }).toList();
                log(rankingList.toString(), name: ' printing firebase doc');

                // return the view widgets
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      // Text(rankingList.length.toString()),
                      Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.app_theme),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ranking     Name",
                                  style: AppTextStyle.leadershipBoard,
                                ),
                                Text(
                                  "Score",
                                  style: AppTextStyle.leadershipBoard,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                              selectedTileColor: rankingList[index]['uid'] ==
                                      Auth().currentUser!.uid
                                  ? AppColors.leadershipSelectedTile
                                  : null,
                              selected: true,
                              leading: CircleAvatar(
                                backgroundColor: AppColors.app_theme,
                                child: Text("${index + 1}"),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    rankingList[index]['name'],
                                    style: AppTextStyle.leadershipBoard,
                                  ),
                                  Container(
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/pictures/star.png'))),
                                  )
                                ],
                              ),
                              trailing: Text(
                                rankingList[index]['TotalScore'].toString(),
                                style: AppTextStyle.leadershipBoard,
                              ));
                        },
                        itemCount: rankingList.length,
                      )),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

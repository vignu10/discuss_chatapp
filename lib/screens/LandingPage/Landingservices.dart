import 'package:discuss/constants/Constantcolors.dart';
import 'package:discuss/screens/HomePage/Homepage.dart';
import 'package:discuss/screens/LandingPage/landingUtils.dart';
import 'package:discuss/services/Authentication.dart';
import 'package:discuss/services/FirebaseOperations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Landingservices with ChangeNotifier {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  ConstantColors constantColors = ConstantColors();
  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(15.0)),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(warning,
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold)),
            ),
          );
        });
  }

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    )),
                CircleAvatar(
                    radius: 80.0,
                    backgroundColor: constantColors.transperant,
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .userAvatar)),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          child: Text(
                            "Reselect",
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: constantColors.whiteColor),
                          ),
                          onPressed: () {
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserAvatar(context, ImageSource.gallery);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            "Confirm Image",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .uploadUserAvatar(context)
                                .whenComplete(() {
                              signInSheet(context);
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(15.0)),
          );
        });
  }

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return new ListView(
                children:
                    snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                trailing: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.trashAlt,
                    color: constantColors.redColor,
                  ),
                  onPressed: () {},
                ),
                leading: CircleAvatar(
                  backgroundImage:
                      NetworkImage(documentSnapshot.data()['userimage']),
                ),
                subtitle: Text(
                  documentSnapshot.data()['useremail'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: constantColors.greenColor,
                      fontSize: 12.0),
                ),
                title: Text(
                  documentSnapshot.data()['username'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: constantColors.greenColor,
                  ),
                ),
              );
            }).toList());
          }
        },
      ),
    );
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: constantColors.blueGreyColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0))),
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 150.0),
                        child: Divider(
                          thickness: 4.0,
                          color: constantColors.whiteColor,
                        )),
                    CircleAvatar(
                      backgroundImage: FileImage(
                          Provider.of<LandingUtils>(context, listen: false)
                              .getUserAvatar),
                      backgroundColor: constantColors.redColor,
                      radius: 60.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter name...',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: userEmailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email...',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: userPasswordController,
                        decoration: InputDecoration(
                          hintText: 'Enter Password...',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: FloatingActionButton(
                          backgroundColor: constantColors.greenColor,
                          child: Icon(FontAwesomeIcons.check,
                              color: constantColors.whiteColor),
                          onPressed: () {
                            if (userEmailController.text.isNotEmpty) {
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .createAccount(userEmailController.text,
                                      userPasswordController.text)
                                  .whenComplete(() {
                                print('Creating collection');
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .createUserCollection(context, {
                                  'useruid': Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserUid,
                                  'useremail': userEmailController.text,
                                  'username': userNameController.text,
                                  'userimage': Provider.of<LandingUtils>(
                                          context,
                                          listen: false)
                                      .getUserAvatarUrl,
                                });
                              }).whenComplete(() {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: Homepage(),
                                        type: PageTransitionType.bottomToTop));
                              });
                            } else {
                              warningText(context, 'Fill all the data');
                            }
                          }),
                    )
                  ],
                ),
              ));
        });
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 150.0),
                        child: Divider(
                          thickness: 4.0,
                          color: constantColors.whiteColor,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: userEmailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email...',
                          hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(FontAwesomeIcons.check,
                            color: constantColors.whiteColor),
                        onPressed: () {
                          if (userEmailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .logIntoAccount(userEmailController.text,
                                    userPasswordController.text)
                                .whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: Homepage(),
                                      type: PageTransitionType.bottomToTop));
                            });
                          } else {
                            warningText(context, 'Fill all the data');
                          }
                        })
                  ],
                ),
                decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0)),
                ),
              ));
        });
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tambola/screens/welcome_screen.dart';

import '../models/user.dart';

class Resources{
  static User? user;

  static ThemeData lightThemeData = ThemeData(
    primaryColor: Colors.white,
    dialogBackgroundColor: const Color(0xff2c282e),
    secondaryHeaderColor: const Color(0xffe2dd30),
    primaryColorDark: const Color(0xff2c382e),
    dividerColor: const Color(0xff7F8068),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.inter()
    )
  );

  //server url
  static String ipPort = "68.183.94.97:8000";

  static Route route(RouteSettings settings){
    switch(settings.name){
      case "/":
        return MaterialPageRoute(builder:(context){
          return const WelcomeScreen();
        });
      default:
        return MaterialPageRoute(builder: (context){
          return const WelcomeScreen();
        });
    }
  }

  static List<String> callouts = [
    "",
    "The beginning",
    "Double trouble",
    "Three's company",
    "Four-leaf clover",
    "High five",
    "Lucky number six",
    "Lucky seven",
    "Great eight",
    "Nine lives",
    "Perfect ten",
    "Eleven stars",
    "Dozen roses",
    "Unlucky thirteen",
    "Fourteen candles",
    "Fifteen minutes of fame",
    "Sweet sixteen",
    "Seventeen wonders",
    "Eighteen holes",
    "Nineteen wishes",
    "Twenty questions",
    "Twenty-one gun salute",
    "Two little ducks",
    "Two and three, twenty-three",
    "Two dozen",
    "Silver anniversary",
    "Half a crown",
    "Lucky twenty-seven",
    "In a pickle, twenty-eight",
    "Twenty-nine ways to win",
    "Flirty thirty",
    "Baskin-Robbins, thirty-one",
    "Thirty-two teeth",
    "All the threes",
    "Ask for more, thirty-four",
    "Jump and jive, thirty-five",
    "Three dozen",
    "Lucky seven, thirty-seven",
    "Christmas cake, thirty-eight",
    "Thirty-nine steps",
    "Life begins at forty",
    "Time for fun, forty-one",
    "Winnie the Pooh, forty-two",
    "Down on your knees, forty-three",
    "Droopy drawers, forty-four",
    "Halfway there, forty-five",
    "Up to tricks, forty-six",
    "Four and seven, forty-seven",
    "Four dozen, forty-eight",
    "49ers, forty-nine",
    "Golden age, fifty",
    "Tweak of the thumb, fifty-one",
    "Chicken vindaloo, fifty-two",
    "Stuck in the tree, fifty-three",
    "Clean the floor, fifty-four",
    "Double nickel, fifty-five",
    "Shotts bus, fifty-six",
    "Heinz varieties, fifty-seven",
    "Make them wait, fifty-eight",
    "The Brighton Line, fifty-nine",
    "Five dozen, sixty",
    "Baker's bun, sixty-one",
    "Turn on the screw, sixty-two",
    "Tickle me, sixty-three",
    "Almost retired, sixty-four",
    "Retirement age, sixty-five",
    "Clickety click, sixty-six",
    "Stairway to heaven, sixty-seven",
    "Pick a mate, sixty-eight",
    "Meal for two, sixty-nine",
    "Three score and ten, seventy",
    "Bang on the drum, seventy-one",
    "Six dozen, seventy-two",
    "Queen bee, seventy-three",
    "Hit the floor, seventy-four",
    "Strive and strive, seventy-five",
    "Trombones, seventy-six",
    "Sunset strip, seventy-seven",
    "39 more steps, seventy-eight",
    "One more time, seventy-nine",
    "Eight and blank, eighty",
    "Stop and run, eighty-one",
    "Straight on through, eighty-two",
    "Time for tea, eighty-three",
    "Seven dozen, eighty-four",
    "Staying alive, eighty-five",
    "Between the sticks, eighty-six",
    "Torquay in Devon, eighty-seven",
    "Two fat ladies, eighty-eight",
    "Nearly there, eighty-nine",
    "Top of the shop, ninety",
  ];

}
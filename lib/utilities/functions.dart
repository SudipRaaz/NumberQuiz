import 'dart:math';

class CustomMethods {
  // create options
  static List<int> getOptions(int value) {
    List<int> availableOptions = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    List<int> Options = [];
    var randomValue = Random();
    availableOptions.shuffle();
    // print("initial options : $availableOptions " + " and solution is ${value}");
    Options.add(value);
    availableOptions.remove(value);
    // print("solution added");
    // print("$availableOptions");

    int newRandom = randomValue.nextInt(availableOptions.length);
    // print(
    //     "random value generated is : $newRandom , ${availableOptions[newRandom]}");
    Options.add(availableOptions[newRandom]);
    availableOptions.remove(availableOptions[newRandom]);
    // print("$availableOptions  remaining options are : ");

    newRandom = randomValue.nextInt(availableOptions.length);
    // print("random value generated is : $newRandom");
    Options.add(availableOptions[newRandom]);
    availableOptions.remove(availableOptions[newRandom]);
    // print("$availableOptions  remaining options are : ");

    newRandom = randomValue.nextInt(availableOptions.length);
    // print("random value generated is : $newRandom");
    Options.add(availableOptions[newRandom]);
    availableOptions.remove(availableOptions[newRandom]);
    // print("$availableOptions  remaining options are : ");
    Options.shuffle();
    return Options;
  }
}

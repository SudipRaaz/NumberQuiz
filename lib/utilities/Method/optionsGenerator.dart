// ignore: file_names
import 'dart:math';

class CustomMethods {
  // create options
  static List<int> getOptions(int value) {
    // list of 10 posible digits
    List<int> availableOptions = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    // setting option to empty for each method call
    // ignore: non_constant_identifier_names
    List<int> Options = [];
    // generating random value and storing at randomValue object
    var randomValue = Random();
    //  suffling available options
    availableOptions.shuffle();
    // adding the correct answer to option which has been received during method call
    Options.add(value);
    // and removing that added value from available options
    availableOptions.remove(value);
    // getting new random value with in the new range of available options
    int newRandom = randomValue.nextInt(availableOptions.length);
    // adding new value of random index from available option
    Options.add(availableOptions[newRandom]);
    // removing added value from available options
    availableOptions.remove(availableOptions[newRandom]);
    // getting new random value with in the new range of available options
    newRandom = randomValue.nextInt(availableOptions.length);
    // adding new value of random index from available option
    Options.add(availableOptions[newRandom]);
    // removing added value from available options
    availableOptions.remove(availableOptions[newRandom]);
    // getting new random value with in the new range of available options
    newRandom = randomValue.nextInt(availableOptions.length);
    // adding new value of random index from available option
    Options.add(availableOptions[newRandom]);
    // removing added value from available options
    availableOptions.remove(availableOptions[newRandom]);
    // suffling the values in the list of options
    Options.shuffle();
    // returing random ordered options
    return Options;
  }
}

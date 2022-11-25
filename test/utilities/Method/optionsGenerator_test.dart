import 'package:flutter_test/flutter_test.dart';
import 'package:smile_quiz/utilities/Method/optionsGenerator.dart';

void main() {
  test('optionsGenerator method testing ...', () {
    const answer = 2;
    // arrange
    final options = CustomMethods.getOptions(answer);

    //expect
    expect(true, options.contains(answer)); // options contains original answer
    expect(true, options.length == 4); // has 4 options
  });
}

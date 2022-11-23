abstract class FirebaseBase {
  // registering user data to database
  Future registerUser(String? uid, String name, String email, int age);

  // saving player's game score to database
  uploadToDatabase(String date, String score, String gameMode);

  // update function to update the total score of player
  updateTotalScore(int totalScored);

  // read user data from database
  readUserData();
}

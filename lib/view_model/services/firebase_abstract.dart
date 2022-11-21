abstract class FirebaseBase {
  Future registerUser(String? uid, String name, String email, int age);

  uploadToDatabase(String date, String score, String gameMode);

  updateTotalScore(int totalScored);
}

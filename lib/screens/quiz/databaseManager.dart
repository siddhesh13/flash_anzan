import 'package:firebase_storage/firebase_storage.dart';

class FireStoreDataBase {
  late String downloadURL;

  Future<String?> getData(String img) async {
    try {
      await downloadURLExample(img);
      //print("URL----------------");
      //print(downloadURL);
      return downloadURL;
    } catch (e) {
      print("Error - $e");
      return null;
    }
  }

  Future<void> downloadURLExample(String imgName) async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child("flashcards/$imgName.png")
        .getDownloadURL();
    //print("get URL");
    //print(downloadURL.toString());
  }
}

/*
Reference get firebaseStorage => FirebaseStorage.instance.ref();

class FirebaseStorageService extends GetxService {
  Future<String> getImage(String imgName) async {
    if (imgName == null) {
      return null;
    }
    try {
      var urlRef = firebaseStorage
          .child("background")
          .child('${imgName.toLowerCase()}.png');
      var imgUrl = await urlRef.getDownloadURL();
      return imgUrl;
    } catch (e) {
      return null;
    }
  }
}
*/


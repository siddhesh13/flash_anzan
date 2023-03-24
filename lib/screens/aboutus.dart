import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  launchURL() async {
    final url = Uri.parse('https://www.abacusplus.in/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 200,
              child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/abacusplusflash.appspot.com/o/asset%2Flogo.png?alt=media&token=6cc8a95a-383a-4a32-a0d6-03c0206b747b'),
            ),
            SizedBox(height: 16.0),
            Text(
              'AbacusPlus Flash',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Powered by The Learners Hub',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Welcome to Abacusplus Flash, a quiz app designed to help students practice abacus. Our app is powered by The Learners Hub organization, which is committed to providing educational resources to students around the world.Our app is designed to make learning abacus fun and engaging. With our quizzes, students can test their knowledge of abacus and practice their skills in a safe and supportive environment. Our goal is to help students build confidence in their abilities and achieve academic success.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: 'Visit our website ',
                style: TextStyle(fontSize: 16),
                children: [
                  TextSpan(
                    text: 'https://www.abacusplus.in',
                    style: TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        launchURL();
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






/*
import 'package:flutter/material.dart';

class FoodRatingScreen extends StatefulWidget {
  @override
  _FoodRatingScreenState createState() => _FoodRatingScreenState();
}

class _FoodRatingScreenState extends State<FoodRatingScreen> {
  List<String> foodItems = [
    'Pizza',
    'Burger',
    'Taco',
    'Sushi',
    'Ramen',
  ];
  List<double> ratings = [0.0, 0.0, 0.0, 0.0, 0.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Ratings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate the following food items:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return FoodRatingTile(
                    foodItem: foodItems[index],
                    rating: ratings[index],
                    onChanged: (value) {
                      setState(() {
                        ratings[index] = value;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: save ratings and show rewards/milestones/badges
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class FoodRatingTile extends StatefulWidget {
  final String foodItem;
  final double rating;
  final Function(double) onChanged;

  const FoodRatingTile({
    Key? key,
    required this.foodItem,
    required this.rating,
    required this.onChanged,
  }) : super(key: key);

  @override
  _FoodRatingTileState createState() => _FoodRatingTileState();
}

class _FoodRatingTileState extends State<FoodRatingTile> {
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.foodItem),
      subtitle: RatingBar(
        rating: _currentRating,
        onRatingChanged: (value) {
          setState(() {
            _currentRating = value;
            widget.onChanged(value);
          });
        },
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;

  const RatingBar({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        IconData iconData =
            index < rating.floor() ? Icons.star : Icons.star_border;
        return IconButton(
          onPressed: () {
            onRatingChanged(index + 1.0);
          },
          icon: Icon(iconData),
          color: Colors.amber,
          iconSize: 32.0,
        );
      }),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<bool> _selectedItems = [false, false, false, false, false];

  void _onItemTapped(int index) {
    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Items'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select the items you want to mark as complete:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: Text(
                'Item 1',
                style: TextStyle(
                  fontSize: 24,
                  color: _selectedItems[0] ? Colors.green : Colors.red,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Text(
                'Item 2',
                style: TextStyle(
                  fontSize: 24,
                  color: _selectedItems[1] ? Colors.green : Colors.red,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Text(
                'Item 3',
                style: TextStyle(
                  fontSize: 24,
                  color: _selectedItems[2] ? Colors.green : Colors.red,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(3),
              child: Text(
                'Item 4',
                style: TextStyle(
                  fontSize: 24,
                  color: _selectedItems[3] ? Colors.green : Colors.red,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(4),
              child: Text(
                'Item 5',
                style: TextStyle(
                  fontSize: 24,
                  color: _selectedItems[4] ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


*/
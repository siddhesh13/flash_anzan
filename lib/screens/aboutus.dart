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
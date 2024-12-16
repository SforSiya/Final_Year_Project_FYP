import 'package:flutter/material.dart';

class ShapeName {
  final String name;
  final Color color;
  final Widget shape;

  ShapeName({required this.name, required this.color, required this.shape});
}

class ShapesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of shapes and their names
    List<ShapeName> shapesList = [
      ShapeName(name: 'Circle', color: Colors.pink[100]!, shape: _buildCircle()),
      ShapeName(name: 'Ellipse', color: Colors.greenAccent[100]!, shape: _buildEllipse()),
      ShapeName(name: 'Oval', color: Colors.blueAccent[100]!, shape: _buildOval()),
      ShapeName(name: 'Square', color: Colors.lightBlue[100]!, shape: _buildSquare()),
      ShapeName(name: 'Rectangle', color: Colors.cyan[100]!, shape: _buildRectangle()),
      ShapeName(name: 'Trapezium', color: Colors.orange[100]!, shape: _buildTrapezium()),
      ShapeName(name: 'Parallelogram', color: Colors.brown[100]!, shape: _buildParallelogram()),
      ShapeName(name: 'Rhombus', color: Colors.red[100]!, shape: _buildRhombus()),
      ShapeName(name: 'Kite', color: Colors.teal[100]!, shape: _buildKite()),
      ShapeName(name: 'Triangle', color: Colors.orangeAccent[100]!, shape: _buildTriangle()),
      ShapeName(name: 'Right triangle', color: Colors.yellow[200]!, shape: _buildRightTriangle()),
      ShapeName(name: 'Scalene triangle', color: Colors.amberAccent[100]!, shape: _buildScaleneTriangle()),
      ShapeName(name: 'Pentagon', color: Colors.purple[100]!, shape: _buildPentagon()),
      ShapeName(name: 'Hexagon', color: Colors.green[100]!, shape: _buildHexagon()),
      ShapeName(name: 'Heptagon', color: Colors.grey[300]!, shape: _buildHeptagon()),
      ShapeName(name: 'Nonagon', color: Colors.cyan[300]!, shape: _buildNonagon()),
      ShapeName(name: 'Decagon', color: Colors.redAccent[100]!, shape: _buildDecagon()),
      ShapeName(name: 'Star', color: Colors.yellow[100]!, shape: _buildStar()),
      ShapeName(name: 'Heart', color: Colors.pink[200]!, shape: _buildHeart()),
      ShapeName(name: 'Crescent', color: Colors.lightBlue[200]!, shape: _buildCrescent()),
      ShapeName(name: 'Cross', color: Colors.orangeAccent[200]!, shape: _buildCross()),
      ShapeName(name: 'Pie', color: Colors.purpleAccent[100]!, shape: _buildPie()),
      ShapeName(name: 'Arrow', color: Colors.green[200]!, shape: _buildArrow()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Shapes and Names'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns: 1 for shape and 1 for name
            childAspectRatio: 2.5,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: shapesList.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: shapesList[index].color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12, width: 2),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Center(child: shapesList[index].shape),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Text(
                    shapesList[index].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Functions to draw each shape
  Widget _buildCircle() => Icon(Icons.circle, size: 60);
  Widget _buildEllipse() => Icon(Icons.egg, size: 60);
  Widget _buildOval() => Container(width: 60, height: 30, decoration: BoxDecoration(shape: BoxShape.circle));
  Widget _buildSquare() => Icon(Icons.square, size: 60);
  Widget _buildRectangle() => Container(width: 80, height: 40, color: Colors.white);
  Widget _buildTrapezium() => Icon(Icons.category, size: 60);
  Widget _buildParallelogram() => Container(width: 60, height: 40, color: Colors.brown);
  Widget _buildRhombus() => Container(width: 60, height: 60, color: Colors.redAccent);
  Widget _buildKite() => Icon(Icons.airplanemode_active, size: 60);
  Widget _buildTriangle() => Icon(Icons.change_history, size: 60);
  Widget _buildRightTriangle() => Icon(Icons.arrow_upward, size: 60);
  Widget _buildScaleneTriangle() => Icon(Icons.format_shapes, size: 60);
  Widget _buildPentagon() => Icon(Icons.star, size: 60);
  Widget _buildHexagon() => Icon(Icons.hexagon, size: 60);
  Widget _buildHeptagon() => Icon(Icons.center_focus_weak, size: 60);
  Widget _buildNonagon() => Icon(Icons.location_city, size: 60);
  Widget _buildDecagon() => Icon(Icons.account_balance, size: 60);
  Widget _buildStar() => Icon(Icons.star, size: 60);
  Widget _buildHeart() => Icon(Icons.favorite, size: 60);
  Widget _buildCrescent() => Icon(Icons.nightlight_round, size: 60);
  Widget _buildCross() => Icon(Icons.add, size: 60);
  Widget _buildPie() => Icon(Icons.pie_chart, size: 60);
  Widget _buildArrow() => Icon(Icons.arrow_forward, size: 60);
}

void main() => runApp(MaterialApp(home: ShapesPage()));

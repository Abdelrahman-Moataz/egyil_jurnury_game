import 'package:flame/components.dart';

class GameManager extends Component {
  int score = 0;
  bool isGameOver = false;
  double gameSpeed = 200;
  double pipeGap = 200;

  void increaseScore() {
    score++;
  }

  void reset() {
    score = 0;
    isGameOver = false;
  }
}

import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame>
    with TickerProviderStateMixin {
  // Game state
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  String winner = '';
  bool gameEnded = false;
  List<int> winningCombination = [];
  
  // Animation controllers
  late AnimationController _gridAnimationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _backgroundAnimationController;
  
  // Animations
  late Animation<double> _gridAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _backgroundAnimation;
  
  // Colors
  static const Color primaryColor = Color(0xFF3A8DFF);
  static const Color secondaryColor = Color(0xFFFF6E7F);
  static const Color accentColor = Color(0xFFFFD166);

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    // Initialize animations
    _gridAnimation = CurvedAnimation(
      parent: _gridAnimationController,
      curve: Curves.elasticOut,
    );
    
    _buttonAnimation = CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.bounceOut,
    );
    
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.linear,
    );
    
    // Start animations
    _gridAnimationController.forward();
    _backgroundAnimationController.repeat();
  }

  @override
  void dispose() {
    _gridAnimationController.dispose();
    _buttonAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  // PUBLIC_INTERFACE
  /// Handles player moves and updates the game state
  void makeMove(int index) {
    if (board[index] != '' || gameEnded) return;
    
    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
      
      // Check for winner
      String result = checkWinner();
      if (result != '') {
        winner = result;
        gameEnded = true;
        _buttonAnimationController.forward();
      } else if (board.every((cell) => cell != '')) {
        winner = 'Draw';
        gameEnded = true;
        _buttonAnimationController.forward();
      }
    });
  }

  // PUBLIC_INTERFACE
  /// Checks for winning combinations and returns the winner
  String checkWinner() {
    // Winning combinations
    List<List<int>> winningCombos = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];
    
    for (List<int> combo in winningCombos) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        winningCombination = combo;
        return board[combo[0]];
      }
    }
    
    return '';
  }

  // PUBLIC_INTERFACE
  /// Resets the game to initial state
  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = '';
      gameEnded = false;
      winningCombination = [];
    });
    
    _buttonAnimationController.reset();
    _gridAnimationController.reset();
    _gridAnimationController.forward();
  }

  // PUBLIC_INTERFACE
  /// Builds a cell in the game grid
  Widget buildCell(int index) {
    bool isWinningCell = winningCombination.contains(index);
    bool isEmpty = board[index] == '';
    
    return GestureDetector(
      onTap: () => makeMove(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isWinningCell
                ? [accentColor.withValues(alpha: 0.8), secondaryColor.withValues(alpha: 0.8)]
                : isEmpty
                    ? [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.1)]
                    : [primaryColor.withValues(alpha: 0.3), secondaryColor.withValues(alpha: 0.3)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isWinningCell
                ? accentColor
                : Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isWinningCell
                  ? accentColor.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: isWinningCell ? 15 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedScale(
            scale: board[index] != '' ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            child: Text(
              board[index],
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: board[index] == 'X' ? primaryColor : secondaryColor,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // PUBLIC_INTERFACE
  /// Builds the animated background gradient
  Widget buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withValues(alpha: 0.1),
                secondaryColor.withValues(alpha: 0.1),
                accentColor.withValues(alpha: 0.1),
                primaryColor.withValues(alpha: 0.2),
              ],
              stops: [
                0.0,
                0.3 + 0.2 * _backgroundAnimation.value,
                0.6 + 0.2 * _backgroundAnimation.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          buildAnimatedBackground(),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Title
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Tic Tac Toe',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: [primaryColor, secondaryColor],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Player turn indicator
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gameEnded
                            ? [accentColor.withValues(alpha: 0.8), secondaryColor.withValues(alpha: 0.8)]
                            : isXTurn
                                ? [primaryColor.withValues(alpha: 0.8), primaryColor.withValues(alpha: 0.6)]
                                : [secondaryColor.withValues(alpha: 0.8), secondaryColor.withValues(alpha: 0.6)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: (gameEnded ? accentColor : (isXTurn ? primaryColor : secondaryColor))
                              .withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      gameEnded
                          ? (winner == 'Draw' ? 'Game Draw!' : 'Player $winner Wins!')
                          : 'Player ${isXTurn ? 'X' : 'O'} Turn',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Game grid
                  ScaleTransition(
                    scale: _gridAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.white.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) => buildCell(index),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Restart button
                  ScaleTransition(
                    scale: _buttonAnimation,
                    child: GestureDetector(
                      onTap: resetGame,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [primaryColor, secondaryColor],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Restart Game',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Footer
                  Text(
                    'Made with Flutter ❤️',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

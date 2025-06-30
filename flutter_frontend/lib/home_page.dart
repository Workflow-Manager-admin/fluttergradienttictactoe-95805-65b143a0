import 'package:flutter/material.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;
  late AnimationController _logoAnimationController;
  late AnimationController _buttonAnimationController;
  
  late Animation<double> _backgroundAnimation;
  late Animation<double> _logoAnimation;
  late Animation<double> _buttonAnimation;
  
  // Colors matching the game theme
  static const Color primaryColor = Color(0xFF3A8DFF);
  static const Color secondaryColor = Color(0xFFFF6E7F);
  static const Color accentColor = Color(0xFFFFD166);

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Initialize animations
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.linear,
    );
    
    _logoAnimation = CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    );
    
    _buttonAnimation = CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.bounceOut,
    );
    
    // Start animations
    _backgroundAnimationController.repeat();
    _logoAnimationController.forward();
    
    // Delay button animation
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _buttonAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    _logoAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  // PUBLIC_INTERFACE
  /// Builds the animated background with flowing gradients
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
                primaryColor.withValues(alpha: 0.8),
                secondaryColor.withValues(alpha: 0.7),
                accentColor.withValues(alpha: 0.6),
                primaryColor.withValues(alpha: 0.9),
              ],
              stops: [
                0.0,
                0.3 + 0.2 * _backgroundAnimation.value,
                0.7 + 0.1 * _backgroundAnimation.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }

  // PUBLIC_INTERFACE
  /// Builds the animated logo/title section
  Widget buildAnimatedLogo() {
    return ScaleTransition(
      scale: _logoAnimation,
      child: Column(
        children: [
          // App Icon/Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, secondaryColor],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'X\nO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // App Title
          Text(
            'Tic Tac Toe',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(3, 3),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 15),
          
          // Subtitle
          Text(
            'Challenge your friend to a classic game!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.9),
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(1, 1),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PUBLIC_INTERFACE
  /// Builds the animated start game button
  Widget buildStartGameButton() {
    return ScaleTransition(
      scale: _buttonAnimation,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TicTacToeGame(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.9),
                Colors.white.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, secondaryColor],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'Start Game',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // PUBLIC_INTERFACE
  /// Builds floating decorative elements
  Widget buildFloatingElements() {
    return Stack(
      children: [
        // Floating X
        Positioned(
          top: 100,
          right: 30,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _backgroundAnimation.value * 6.28,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'X',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Floating O
        Positioned(
          bottom: 150,
          left: 40,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_backgroundAnimation.value * 6.28,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'O',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          buildAnimatedBackground(),
          
          // Floating decorative elements
          buildFloatingElements(),
          
          // Main content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    
                    // Logo and title
                    buildAnimatedLogo(),
                    
                    const Spacer(),
                    
                    // Start game button
                    buildStartGameButton(),
                    
                    const SizedBox(height: 60),
                    
                    // Footer
                    Text(
                      'Made with Flutter ❤️',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

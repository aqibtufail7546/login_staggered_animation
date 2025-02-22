import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _slideAnimations;
  late Animation<double> _buttonFadeAnimation;
  late Animation<double> _buttonSlideAnimation;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimations = List.generate(5, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.15, 1.0, curve: Curves.easeInOut),
        ),
      );
    });

    _slideAnimations = List.generate(5, (index) {
      return Tween<double>(begin: 100.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.15, 1.0, curve: Curves.easeInOut),
        ),
      );
    });

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.6, 1.0, curve: Curves.easeInOut)),
    );

    _buttonSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.6, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();
  }

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.blue.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade900.withOpacity(0.3),
                        Colors.purple.shade900.withOpacity(0.3),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.1),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            isLogin ? 'CYBER ACCESS' : 'NEW IDENTITY',
                            key: ValueKey<bool>(isLogin),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [Colors.cyan, Colors.blueAccent],
                                ).createShader(
                                  const Rect.fromLTWH(0, 0, 200, 70),
                                ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildAnimatedTextField('USER ID', 1,
                          icon: Icons.person_outline),
                      const SizedBox(height: 20),
                      _buildAnimatedTextField('PASSPHRASE', 2,
                          isPassword: true, icon: Icons.lock_outline),
                      if (!isLogin) ...[
                        const SizedBox(height: 20),
                        _buildAnimatedTextField('CONFIRM PASSPHRASE', 3,
                            isPassword: true, icon: Icons.lock_reset),
                      ],
                      const SizedBox(height: 30),
                      Transform.translate(
                        offset: Offset(0, _buttonSlideAnimation.value),
                        child: Opacity(
                          opacity: _buttonFadeAnimation.value,
                          child: SizedBox(
                            width: double.infinity,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan,
                                    Colors.blueAccent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  isLogin ? 'AUTHENTICATE' : 'GENERATE ID',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Transform.translate(
                          offset: Offset(0, _buttonSlideAnimation.value),
                          child: Opacity(
                            opacity: _buttonFadeAnimation.value,
                            child: TextButton(
                              onPressed: toggleAuthMode,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.cyan,
                              ),
                              child: Text(
                                isLogin
                                    ? 'CREATE NEW IDENTITY →'
                                    : '← RETURN TO AUTH PORTAL',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1.1,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.cyan.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField(String hint, int index,
      {bool isPassword = false, IconData? icon}) {
    return Transform.translate(
      offset: Offset(
          isLogin
              ? -_slideAnimations[index].value
              : _slideAnimations[index].value,
          0),
      child: Opacity(
        opacity: _fadeAnimations[index].value,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900.withOpacity(0.3),
                Colors.purple.shade900.withOpacity(0.3),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            obscureText: isPassword,
            style: const TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white54, letterSpacing: 1.2),
              prefixIcon:
                  icon != null ? Icon(icon, color: Colors.white54) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

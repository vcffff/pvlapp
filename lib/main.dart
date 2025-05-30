import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:hackatonparvlodar/firstpage/firstpage.dart';
import 'package:hackatonparvlodar/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: LoginPage()),
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') == true) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyWidget()),
          );
        });
      }
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final password = _passwordController.text.trim();
      print('Sending login request: name=$name, password=$password');

      setState(() {
        _errorMessage = null;
      });

      try {
        final authResponse = await AuthResponse.login(name, password);

        if (authResponse != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userId', authResponse.id);
          await prefs.setString('name', authResponse.name);
          await prefs.setString('role', authResponse.role);
          await prefs.setString('refreshToken', authResponse.refreshToken);
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyWidget()),
            );
          }
        } else {
          setState(() {
            _errorMessage = _mapErrorMessage(null);
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = _mapErrorMessage(e is DioException ? e : null);
        });
      }
    }
  }

  String _mapErrorMessage(DioException? e) {
    if (e?.response?.statusCode == 404) {
      return 'Қолданушы табылмады. Атыңызды тексеріңіз немесе тіркеліңіз.';
    } else if (e?.response?.statusCode == 403) {
      return 'Құпия сөз қате. Қайтадан көріңіз.';
    } else {
      return 'Кіру сәтсіз аяқталды. Кейінірек қайталап көріңіз.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.person_rounded,
                                size: 120,
                                color: Colors.white.withOpacity(0.8),
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Қош Келдіңіз',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Карьера — свайппен басталатын дәуір',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Аты',
                            fillColor: Colors.black,
                            filled: true,
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white70,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Атыңызды енгізіңіз';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            filled: true,
                            labelText: 'Құпия сөз',
                            labelStyle: TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white70,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Құпия сөзіңізді енгізіңіз';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            _errorMessage!,
                            style: GoogleFonts.poppins(
                              color: Colors.red[300],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            backgroundColor: Colors.blue.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Кіру',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Тіркеу әлі жүзеге асырылмады'),
                            ),
                          );
                        },
                        child: Text(
                          'Тіркелу',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign In.',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                leadingIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                leadingIcon: Icons.lock,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AuthGradientButton(
                buttonText: 'Log In',
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                    context.read<AuthCubit>().stream.listen((state) {
                      if (state is AuthSuccess) {
                        // Navigate to Home Page after successful login
                        Navigator.pushReplacementNamed(context, '/home');
                      } else if (state is AuthFailed) {
                        // Show error message if login fails
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.toString())),
                        );
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fix the errors')),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: "Don't have an accout?",
                  style: Theme.of(context).textTheme.titleMedium,
                  children:  [
                    TextSpan(
                      text: 'Sign Up.',
                      style: const TextStyle(
                        color: Pallete.gradient2,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/signup');
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:postman_penugasan1/services/user.dart';
import 'package:postman_penugasan1/widgets/alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool showPass = true;

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 230, 114, 41);

    InputDecoration inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD5DAE3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFD5DAE3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: themeColor, width: 1.5),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 222, 208, 203),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/logo1.png', height: 250, width: 250),
            const SizedBox(height: 97),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(36, 16, 42, 88),
                    blurRadius: 24,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Selamat Datang Kembali!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 33),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          decoration: inputDecoration("Email"),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Email harus diisi'
                              : null,
                        ),
                        const SizedBox(height: 17),
                        TextFormField(
                          controller: password,
                          obscureText: showPass,
                          decoration: inputDecoration("Password").copyWith(
                            suffixIcon: IconButton(
                              padding: EdgeInsets.only(right: 10),
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                showPass
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPass = !showPass;
                                });
                              },
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Password harus diisi'
                              : null,
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                var data = {
                                  "email": email.text,
                                  "password": password.text,
                                };
                                var result = await user.loginUser(data);
                                setState(() {
                                  isLoading = false;
                                });
                                print(result.message);
                                if (result.status == true) {
                                  AlertMessage().showAlert(
                                    context,
                                    result.message,
                                    true,
                                  );
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/dash',
                                    );
                                  });
                                } else {
                                  AlertMessage().showAlert(
                                    context,
                                    result.message,
                                    false,
                                  );
                                }
                              }
                            },
                            child: isLoading == false
                                ? Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2.0,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Belum Punya Akun? ",
                              style: TextStyle(fontSize: 12),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>((
                                      Set<MaterialState> states,
                                    ) {
                                      if (states.contains(
                                        MaterialState.hovered,
                                      )) {
                                        return Colors.transparent;
                                      }
                                      return null;
                                    }),
                                minimumSize: MaterialStateProperty.all(
                                  Size.zero,
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(2),
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(context,'/register',);
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: themeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

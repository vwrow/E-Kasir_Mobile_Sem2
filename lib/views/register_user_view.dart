import 'package:flutter/material.dart';
import 'package:postman_penugasan1/services/user.dart';
import 'package:postman_penugasan1/widgets/alert.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  List roleChoice = ["admin", "user"];
  String? role;
  bool showPass = true;
  bool isLoading = false;

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
            const SizedBox(height: 17),
            Image.asset('assets/logo1.png', height: 250, width: 250),
            const SizedBox(height: 30),
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
                    "Register Akun Anda!",
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
                          controller: name,
                          decoration: inputDecoration("Nama"),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Nama harus diisi'
                              : null,
                        ),
                        const SizedBox(height: 17),
                        TextFormField(
                          controller: email,
                          decoration: inputDecoration("Email"),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Email harus diisi'
                              : null,
                        ),
                        const SizedBox(height: 17),
                        DropdownButtonFormField(
                          isExpanded: true,
                          value: role,
                          items: roleChoice
                              .map(
                                (r) =>
                                    DropdownMenuItem(value: r, child: Text(r)),
                              )
                              .toList(),
                          decoration: inputDecoration("Role"),
                          onChanged: (value) {
                            setState(() {
                              role = value?.toString();
                            });
                          },
                          hint: const Text("Pilih role"),
                          validator: (value) =>
                              value == null || value.toString().isEmpty
                              ? 'Role harus dipilih'
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
                        const SizedBox(height: 30),
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
                                  "name": name.text,
                                  "email": email.text,
                                  "role": role,
                                  "password": password.text,
                                };
                                var result = await user.registerUser(data);
                                if (result.status == true) {
                                  AlertMessage().showAlert(
                                    context,
                                    result.message,
                                    true,
                                  );
                                  data = {
                                    "email": email.text,
                                    "password": password.text,
                                  };
                                  result = await user.loginUser(data);
                                  print(result.message);
                                  setState(() {
                                    isLoading = false;
                                  });
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
                                    "Register & Login",
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
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
                              "Sudah Punya Akun? ",
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
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                              child: Text(
                                "Login",
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sosc/screens/home/home_screen.dart';
import 'package:http/http.dart' as http;
import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conform_password;
  String? Address;
  String? Name;
  List<TextEditingController> _controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  bool remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            onSaved: (newValue) => Name = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              } else {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              } else {
                return null;
              }
            },
            controller: _controller[0],
            decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.person_2_outlined),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => Name = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              } else {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return "";
              } else {
                return null;
              }
            },
            controller: _controller[1],
            decoration: const InputDecoration(
              labelText: "phone",
              hintText: "phone",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kEmailNullError);
              } else if (emailValidatorRegExp.hasMatch(value)) {
                removeError(error: kInvalidEmailError);
              }
              return;
            },
            controller: _controller[2],
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kEmailNullError);
                return "";
              } else if (!emailValidatorRegExp.hasMatch(value)) {
                addError(error: kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          // me
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.streetAddress,
            maxLines: 4,
            onSaved: (newValue) => Address = newValue,
            controller: _controller[3],
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kAddressNullError);
              } else {
                removeError(error: kAddressNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kAddressNullError);
                return "";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
              labelText: "Address",
              hintText: "Address",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.home_max_outlined),
            ),
          ),

          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.name,
            onSaved: (newValue) => Name = newValue,
            controller: _controller[4],
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kNamelNullError);
              } else {
                removeError(error: kNamelNullError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kNamelNullError);
                return "";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
              labelText: "landmark",
              hintText: "landmark",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Icon(Icons.location_city),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            controller: _controller[5],
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),

          const SizedBox(height: 20),

          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                http.Response response =
                    await http.post(Uri.parse(SignUpLink), body: {
                  'username': _controller[2].text,
                  "password": _controller[5].text,
                  "phone": _controller[1].text,
                  "address": _controller[3].text,
                  "landmark": _controller[4].text
                });
                if (response.statusCode != 200) {
                  // error
                }
                if (response.statusCode == 200) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString(
                      'access', jsonDecode(response.body)["access"]);
                  prefs.setString(
                      'refresh', jsonDecode(response.body)["refresh"]);
                  print('Access key:  ${prefs.getString('access')}');
                  Navigator.pushNamed(context, HomeScreen.routeName);
                }
                print(response.body);
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}

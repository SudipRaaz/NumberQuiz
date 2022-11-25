import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/constants/appcolors.dart';
import 'package:smile_quiz/utilities/route/routes_name.dart';
import 'package:validators/validators.dart';
import '../resources/components/button.dart';
import '../utilities/message.dart';
import '../view_model/services/authentication.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final ValueNotifier<bool> _obsecureText = ValueNotifier(true);

  // text controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // focusing pointer
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // initial age for registration
  double _initialAge = 18;
  // check box default value
  bool _checkBoxValue = false;

  @override
  void dispose() {
    super.dispose();
    _obsecureText.dispose();
    // controller disposal
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    // focus node disposal
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: AppColors.appBar_theme,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              // asset app logo display
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30),
                child: Container(
                    width: width * .7,
                    height: height * .1,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/app_logo.png')))),
              ),

              // name form field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  focusNode: _nameFocusNode,
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      "Name",
                    ),
                    prefixIcon: Icon(Icons.face_rounded),
                  ),
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_emailFocusNode),
                ),
              ),

              // email textform field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  focusNode: _emailFocusNode,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Email"),
                    prefixIcon: Icon(Icons.email_rounded),
                  ),
                  // requesting for password field focus
                  onFieldSubmitted: (value) =>
                      FocusScope.of(context).requestFocus(_passwordFocusNode),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Age",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 300,
                      // age slider picker
                      child: Slider(
                        value: _initialAge,
                        min: 18.0, // min age allowed
                        max: 60.0, // max age allowed
                        divisions: 42, // number of divisions allowed
                        // updating age on slider change
                        onChanged: (double newValue) {
                          setState(() {
                            _initialAge = newValue;
                          });
                        },
                        activeColor: AppColors.login_buttonColor,
                        inactiveColor: Colors.black45,
                      ),
                    ),
                    Text(
                      _initialAge.toInt().toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),

              // listining for obsecure icon tap
              ValueListenableBuilder(
                  valueListenable: _obsecureText,
                  builder: (context, obsecureText, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        focusNode: _passwordFocusNode,
                        controller: _passwordController,
                        obscureText: _obsecureText.value,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            label: const Text("Password"),
                            prefixIcon: const Icon(
                              Icons.lock_rounded,
                            ),
                            suffixIcon: InkWell(
                                onTap: () {
                                  // inverting obsecure password ontap
                                  _obsecureText.value = !_obsecureText.value;
                                },
                                child: _obsecureText.value
                                    ? const Icon(Icons.visibility_off_outlined)
                                    : const Icon(Icons.visibility_outlined))),
                      ),
                    );
                  }),

              // agreement to term and conditions
              Row(
                children: [
                  Checkbox(
                      value: _checkBoxValue,
                      onChanged: ((value) {
                        setState(() {
                          _checkBoxValue = !_checkBoxValue;
                        });
                      })),
                  const Text('Agree to'),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RoutesName.termsAndCondition);
                      },
                      child: const Text('Term and Conditions'))
                ],
              ),
              SizedBox(
                height: height * .09,
              ),
              Buttons(
                text: "Register",
                onPress: () async {
                  // checking for name length
                  if (_nameController.text.isEmpty) {
                    Message.flushBarErrorMessage(context, "Enter a valid Name");
                  }

                  // checking for email format and length
                  else if (_emailController.text.isEmpty ||
                      !isEmail(_emailController.text)) {
                    Message.flushBarErrorMessage(
                        context, "Enter a valid Email address");
                  }
                  // checking for password length validation
                  else if (_passwordController.text.length < 6) {
                    Message.flushBarErrorMessage(
                        context, "Password must be at least 6 digits");
                  } else if (!_checkBoxValue) {
                    Message.flushBarErrorMessage(
                        context, "Accept to terms and conditions to proceed");
                  } else {
                    try {
                      // registering user with email and password
                      await Auth().createUserWithEmailAndPassword(
                          context,
                          _emailController.text.toLowerCase().trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim(),
                          _initialAge.toInt());

                      // saving the data onto cloud firestore database

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    } catch (e) {
                      Message.flushBarErrorMessage(context, e.toString());
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

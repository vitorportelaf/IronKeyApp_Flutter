import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironkey/app_theme.dart';
import 'package:ironkey/models/password_complexity.dart';
import 'package:ironkey/password_generator.dart';
import 'package:ironkey/pin_password_generator.dart';
import 'package:ironkey/standard_password_generator.dart';

void main() {
  runApp(IronKeyApp());
}

class IronKeyApp extends StatelessWidget {
  const IronKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      title: "IronKey",
      home: IronKeyScreen(),
    );
  }
}

class IronKeyScreen extends StatefulWidget {
  const IronKeyScreen({super.key});

  @override
  State<IronKeyScreen> createState() => _IronKeyScreenState();
}

class _IronKeyScreenState extends State<IronKeyScreen> {
  final TextEditingController _passwordController = TextEditingController();

  PasswordType passwordSelectedType = PasswordType.pin;
  bool isEditable = false;

  bool includeUppercase = true;
  bool includeLowercase = true;
  bool includeNumbers = false;
  bool includeSymbols = false;
  int passwordLength = 12;

  PasswordComplexity selectedComplexity = PasswordComplexity.medium;

  @override
  initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  void generatePassword() {
    late final PasswordGenerator generator;

    switch (passwordSelectedType) {
      case PasswordType.pin:
        generator = PinPasswordGenerator();
        break;
      case PasswordType.standard:
        generator = StandardPasswordGenerator(
          includeLowercase: includeLowercase,
          includeUppercase: includeUppercase,
          includeNumbers: includeNumbers,
          includeSymbols: includeSymbols,
        );
        break;
    }

    setState(() {
      _passwordController.text = generator.generate(passwordLength);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            "assets/images/ironmanicon.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        "Sua senha segura",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        enabled: isEditable,
                        controller: _passwordController,
                        maxLength: 12,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                          prefix: Icon(Icons.lock),
                          suffix: _passwordController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.copy),
                                )
                              : null,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Tipo de senha"),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              value: PasswordType.pin,
                              groupValue: passwordSelectedType,
                              title: Text("Pin"),
                              onChanged: (value) {
                                setState(() {
                                  passwordSelectedType = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              value: PasswordType.standard,
                              groupValue: passwordSelectedType,
                              title: Text("Senha padrão"),
                              onChanged: (value) {
                                setState(() {
                                  passwordSelectedType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(isEditable ? Icons.lock_open : Icons.lock),
                          SizedBox(width: 8),
                          Expanded(child: Text("Permitir editar a senha?")),
                          Switch(
                            value: isEditable,
                            onChanged: (value) {
                              setState(() {
                                isEditable = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Divider(color: colorScheme.outline),
                      const SizedBox(height: 20),

                      if (isEditable) ...[
                        const SizedBox(height: 20),
                        DropdownButtonFormField<PasswordComplexity>(
                          value: selectedComplexity,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            labelText: 'Complexidade da senha',
                            border: OutlineInputBorder(),
                          ),
                          items: PasswordComplexity.values.map((complexity) {
                            return DropdownMenuItem(
                              value: complexity,
                              child: Text(complexity.title),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedComplexity = value!;
                            });
                          },
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Tamanho da senha $passwordLength"),
                        ),

                        Slider(
                          value: passwordLength.toDouble(),
                          min: 4,
                          max: 12,
                          onChanged: (value) {
                            setState(() {
                              passwordLength = value.toInt();
                            });
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: includeUppercase,
                                onChanged: (value) {
                                  setState(() {
                                    //includeUppercase = value!;
                                    includeUppercase = value ?? false;
                                  });
                                },
                                title: Text("Maiúsculas"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: includeLowercase,
                                onChanged: (value) {
                                  setState(() {
                                    //includeUppercase = value!;
                                    includeLowercase = value ?? false;
                                  });
                                },
                                title: Text("Minúsculas"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: includeNumbers,
                                onChanged: (value) {
                                  setState(() {
                                    //includeUppercase = value!;
                                    includeNumbers = value ?? false;
                                  });
                                },
                                title: Text("Números"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                value: includeSymbols,
                                onChanged: (value) {
                                  setState(() {
                                    //includeUppercase = value!;
                                    includeSymbols = value ?? false;
                                  });
                                },
                                title: Text("Symbols"),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: generatePassword,
                  child: Text(
                    "Gerar senha",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PasswordType { pin, standard }

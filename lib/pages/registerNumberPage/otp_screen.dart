import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa o Firebase Auth
import 'package:portador_diario_client_app/controllers/phoneAuthentication.dart';
import 'package:portador_diario_client_app/pages/mainPage/mainPage.dart';
import 'package:portador_diario_client_app/pages/registerClientPage/registerClientPage.dart';
import 'package:portador_diario_client_app/widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen(
      {super.key, required this.verificationId, required String verification});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  int _timer = 20;

  PhoneAuthentication auth = PhoneAuthentication();

  verifyOTP(BuildContext context) async {
    try {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MainScreen();
        },
      ));
    } catch (e) {
      e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_timer > 0) {
        setState(() {
          _timer--;
        });
        _startTimer();
      }
    });
  }

  void resendCode() {
    setState(() {
      _timer = 20;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.shade50,
                  ),
                  child: Image.asset(
                    height: 180,
                    width: 180,
                    "assets/image3.png",
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Verificação",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Insira o OTP enviado para o seu número de telefone.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: theme.primaryColor,
                      ),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onCompleted: (value) {
                    setState(() {
                      otpCode = value;
                    });
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: CustomButton(
                    text: "Verificar",
                    onPressed: () {
                      if (otpCode != null) {
                        verifyOTP(context);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (_timer > 0)
                  Text.rich(
                    TextSpan(
                      text: 'Reenviar o código em ',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      children: [
                        TextSpan(
                          text: '$_timer s',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )
                else ...[
                  const SizedBox(height: 20),
                  const Text(
                    "Não recebeu nenhum código?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      resendCode();
                    },
                    child: Text(
                      "Reenviar Novo Código",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:portador_diario_client_app/constants/constants.dart';
import 'package:portador_diario_client_app/controllers/phoneAuthentication.dart';
import 'package:portador_diario_client_app/pages/mainPage/mainPage.dart';
import 'package:portador_diario_client_app/pages/registerNumberPage/otp_screen.dart';

class RegisterNumberPage extends StatefulWidget {
  const RegisterNumberPage({super.key});

  @override
  State<RegisterNumberPage> createState() => _RegisterNumberPageState();
}

class _RegisterNumberPageState extends State<RegisterNumberPage> {
  final TextEditingController textEditingController = TextEditingController();
  String initialCountry = 'MZ';
  PhoneNumber number = PhoneNumber(isoCode: 'MZ');
  bool isSelectedWhatsApp = true;
  bool isSelectedSMS = false;
  bool isLoading = false;
  bool _isChecked = false;
  PhoneAuthentication auth = PhoneAuthentication();

  PhoneNumber? phoneNumber;

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isTextFieldEmpty = textEditingController.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Adicione seu número de telefone",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enviaremos um código de verificação",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 70,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InternationalPhoneNumberInput(
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      searchBoxDecoration: const InputDecoration(
                        hintText: 'Pesquisar país ou código',
                      ),
                      selectorConfig: const SelectorConfig(
                        useEmoji: true,
                        useBottomSheetSafeArea: true,
                        trailingSpace: false,
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          phoneNumber = number;
                        });
                      },
                      selectorTextStyle: const TextStyle(color: Colors.black),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      initialValue: PhoneNumber(isoCode: 'MZ'),
                      textFieldController: textEditingController,
                      inputDecoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: " 87 233 9950",
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (!isTextFieldEmpty &&
                      textEditingController.text.length == 11)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ActionChip(
                          onPressed: () {
                            setState(() {
                              isSelectedWhatsApp = !isSelectedWhatsApp;
                              isSelectedSMS = false;
                            });
                          },
                          backgroundColor: isSelectedWhatsApp
                              ? theme.primaryColor
                              : Colors.white,
                          label: Text(
                            "WhatsApp",
                            style: TextStyle(
                                color: isSelectedWhatsApp
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 10),
                          ),
                        ),
                        SizedBox(width: 8),
                        ActionChip(
                          onPressed: () {
                            setState(() {
                              isSelectedSMS = !isSelectedSMS;
                              isSelectedWhatsApp = false;
                            });
                          },
                          backgroundColor:
                              isSelectedSMS ? theme.primaryColor : Colors.white,
                          label: Text(
                            "SMS",
                            style: TextStyle(
                                color:
                                    isSelectedSMS ? Colors.white : Colors.grey,
                                fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                          child: Text(
                              maxLines: 10,
                              "O Portador Diário enviara o codigo de verificao para este numero. ")),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.6),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: ElevatedButton(
            onPressed: isTextFieldEmpty ||
                    !(isSelectedWhatsApp || isSelectedSMS) ||
                    !(textEditingController.text.length == 11) ||
                    _isChecked != true
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OtpScreen(
                          verification: 'p0',
                          verificationId: 'p0',
                        ),
                      ),
                    );

                    await auth.enviarCodigoOTP(
                      number.phoneNumber!,
                      AuthenticationType.sms,
                      context,
                      () {
                        setState(() {
                          isLoading = false;
                        });
                      },
                    );
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor:
                  (isTextFieldEmpty || !(isSelectedWhatsApp || isSelectedSMS))
                      ? Colors.grey
                      : theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

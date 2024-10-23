import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portador_diario_client_app/pages/mainPage/mainPage.dart';

class Registerclientpage extends StatefulWidget {
  final String token;

  const Registerclientpage({super.key, required this.token});

  @override
  State<Registerclientpage> createState() => _RegisterclientpageState();
}

class _RegisterclientpageState extends State<Registerclientpage> {
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _pickImage(ImageSource provider) async {
    final XFile? selectedImage =
        await ImagePicker().pickImage(source: provider);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await user.updateDisplayName(
              '${_nameController.text} ${_lastNameController.text}');

          await user.reload();
          user = FirebaseAuth.instance.currentUser;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('Bem-vindo, ${user?.displayName}!'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar perfil: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Color.fromARGB(255, 202, 202, 202),
                      backgroundImage:
                          _image != null ? FileImage(File(_image!.path)) : null,
                      child: _image == null
                          ? const Icon(
                              Icons.person,
                              size: 100,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    Positioned(
                      left: 110,
                      bottom: 5,
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ModalShooseProviderOfImage(
                              openGallery: () {
                                _pickImage(ImageSource.gallery);
                              },
                              openCamera: () {
                                _pickImage(ImageSource.camera);
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: const Center(
                            child: Icon(
                              size: 30,
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 49),
                  width: 350,
                  height: 270,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira algum texto';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 247, 246, 245),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            labelText: 'Nome',
                            hintText: 'Insira o seu nome',
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira algum texto';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 247, 246, 245),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            labelText: 'Apelido',
                            hintText: 'Insira o seu apelido',
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _updateUserProfile,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: theme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Seguinte',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ModalShooseProviderOfImage extends StatelessWidget {
  final VoidCallback? openCamera;
  final VoidCallback? openGallery;

  const ModalShooseProviderOfImage(
      {super.key, this.openCamera, this.openGallery});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: 180,
        width: 300,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[100], // Fundo claro
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: openCamera,
                child: ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Camera",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.grey[300]),
              GestureDetector(
                onTap: openGallery,
                child: ListTile(
                  leading: Icon(
                    Icons.photo,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    "Gallery",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
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

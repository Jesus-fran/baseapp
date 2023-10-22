import 'package:baseapp/modelos/autenticacion_model.dart';
import 'package:baseapp/modelos/usuario_model.dart';
import 'package:baseapp/vistas/bienvenida.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/controladores/registro.dart';
import 'package:hive/hive.dart';

class RegistrandoUsuario extends StatefulWidget {
  final UserModelo usuario;
  const RegistrandoUsuario({super.key, required this.usuario});
  @override
  State<RegistrandoUsuario> createState() => _RegistrandoUsuarioState();
}

class _RegistrandoUsuarioState extends State<RegistrandoUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: FutureBuilder<AuthModelo>(
              future: registerUser(widget.usuario.email,
                  widget.usuario.password, widget.usuario.username),
              builder: (context, AsyncSnapshot<AuthModelo> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.statusCode == 200 &&
                      snapshot.data!.status) {
                    //Si se registra correctamente
                    return succesMessage(context, snapshot.data!.token);
                  } else if (snapshot.data!.statusCode == 200 &&
                      !snapshot.data!.status) {
                    //Si hubo un fallo al registrar
                    return errorMessage(context);
                  } else if (snapshot.data!.statusCode == 422) {
                    //Si hubo un error de validación
                    return validationMessage(snapshot.data!.message, context);
                  } else {
                    //Si hay un error desconocido
                    return errorMessage(context);
                  }
                } else {
                  return cargandoMessage(context);
                }
              }),
        ),
      ),
    );
  }
}

Widget cargandoMessage(context) {
  return const Column(
    children: [
      SizedBox(height: 200),
      Text('Registrando..', style: TextStyle(fontSize: 30)),
      SizedBox(height: 60),
      LinearProgressIndicator(
        color: Colors.redAccent,
      ),
      SizedBox(height: 60),
      Text(
        'Espere un momento, por favor.',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget validationMessage(String message, context) {
  return Column(
    children: [
      const SizedBox(height: 150),
      const Text('Algo ocurrió..', style: TextStyle(fontSize: 30)),
      const SizedBox(height: 60),
      const Icon(Icons.sentiment_dissatisfied, size: 50),
      const SizedBox(height: 60),
      Text(
        message,
        style: const TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 50),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 255, 156, 98)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: const Text(
          "Intentar de nuevo",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

Widget errorMessage(context) {
  return Column(
    children: [
      const SizedBox(height: 150),
      const Text('Algo ocurrió..', style: TextStyle(fontSize: 30)),
      const SizedBox(height: 60),
      const Icon(
        Icons.error,
        size: 50,
        color: Colors.redAccent,
      ),
      const SizedBox(height: 60),
      const Text(
        'Hubo un error al intentar registrarte',
        style: TextStyle(fontSize: 25),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 50),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 255, 156, 98)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: const Text(
          "Intentar de nuevo",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}

Widget succesMessage(context, token) {
  var box = Hive.box('tokenBox');
  box.put('token', token);
  return Column(
    children: [
      const SizedBox(height: 150),
      const Text(
        'Registrado correctamente..',
        style: TextStyle(fontSize: 30),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 60),
      const Icon(Icons.sentiment_satisfied_alt, size: 50),
      const SizedBox(height: 50),
      ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Bienvenida()));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 255, 239, 98)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: const Text(
          "Continuar",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
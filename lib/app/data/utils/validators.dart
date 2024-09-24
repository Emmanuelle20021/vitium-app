class Validators {
  Validators._();

  static String? validateEmail(String? email) {
    final emailValidator = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
    );
    if (emailValidator.hasMatch(email!)) {
      return null;
    }
    return 'Por favor ingrese un email válido';
  }

  static String? validatePassword(String? password) {
    //Minimo 8 caracteres
    //Maximo 15
    //Al menos una letra mayúscula
    //Al menos una letra minucula
    //Al menos un dígito
    //No espacios en blanco
    //Al menos 1 caracter especial
    final passwordValidator = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])([A-Za-z\d$@$!%*?&]|[^ ]){8,15}$',
    );
    if (passwordValidator.hasMatch(password!)) {
      return null;
    }
    return 'Por favor ingrese una contraseña válida';
  }
}

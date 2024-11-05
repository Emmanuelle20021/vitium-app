import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitium/app/presentation/bloc/vacancys_cubit.dart';

import '../../../../data/utils/constants/constants.dart';
import '../../../../data/utils/injector.dart';
import '../../../bloc/register_cubit.dart';
import '../../../routes/routes.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostulantDrawer extends StatelessWidget {
  const PostulantDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: SizedBox.expand(
              child: Image.asset(
                'assets/images/vitium_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          ExpansionTile(
            title: const Text('Recomendaciones y recursos'),
            expansionAnimationStyle: AnimationStyle(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 500),
            ),
            children: [
              ListTile(
                title: Text("Sesión informativa en video"),
                leading: Icon(Icons.video_library),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisabilityVideosPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Discapacidad Visual"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisualDisabilityPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Discapacidad Auditiva"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuditoryDisabilityPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Discapacidad Motriz"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MotorDisabilityPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Discapacidad Cognitiva"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CognitiveDisabilityPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Discapacidad Psicosocial"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PsychosocialDisabilityPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          ListTile(
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () async {
              final auth = Injector.of(context).accountRepository;
              final response = await auth.logout();

              if (response.data != null && context.mounted) {
                context.read<RegisterCubit>().clearCubit();
                context.read<VacancysCubit>().clearVacancys();
                Navigator.pushReplacementNamed(context, Routes.login);
              }
            },
          ),
        ],
      ),
    );
  }
}

class VisualDisabilityPage extends StatelessWidget {
  const VisualDisabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discapacidad Visual"),
            Text(
              'VITIUM',
              style: TextStyle(
                color: kVitiumNameColor,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/images/HelpingAPartner-amico.png',
              height: 200,
            ),
            Text(
              "Definición",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "Incluye ceguera total, baja visión y sensibilidad a la luz.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Adaptaciones para Reclutamiento",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Asegúrate de que los formularios y documentos en línea sean compatibles con lectores de pantalla.\n"
              "2. Facilita entrevistas telefónicas o a través de videollamadas con herramientas accesibles.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Recursos",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. W3C Accessibility Guidelines (WCAG): Guías para crear contenido web accesible.\n"
              "2. Plugins como flutter_a11y en Flutter, que ayudan a hacer accesibles las aplicaciones móviles.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuditoryDisabilityPage extends StatelessWidget {
  const AuditoryDisabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discapacidad Auditiva"),
            Text(
              'VITIUM',
              style: TextStyle(
                color: kVitiumNameColor,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/images/HelpingAPartner-amico.png',
              height: 200,
            ),
            Text(
              "Definición",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "Incluye pérdida parcial de la audición hasta sordera total.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Adaptaciones para Reclutamiento",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Ofrece entrevistas en texto o por video con un intérprete de lengua de señas o subtitulado.\n"
              "2. Entrena al equipo en comunicación efectiva, usando contacto visual y expresiones faciales.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Recursos",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Intérpretes de Lengua de Señas para entrevistas y reuniones.\n"
              "2. Herramientas de subtitulado automático (YouTube Live, Microsoft Teams).",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class MotorDisabilityPage extends StatelessWidget {
  const MotorDisabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discapacidad Motriz"),
            Text(
              'VITIUM',
              style: TextStyle(
                color: kVitiumNameColor,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/images/HelpingAPartner-amico.png',
              height: 200,
            ),
            Text(
              "Definición",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "Incluye limitaciones de movilidad o dificultades para tareas motoras finas.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Adaptaciones para Reclutamiento",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Entorno accesible: accesos para sillas de ruedas y espacios ergonómicos.\n"
              "2. Ofrece trabajo remoto o tareas sin desplazamiento constante.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Recursos",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Guías de ergonomía para trabajo remoto.\n"
              "2. Software de reconocimiento de voz como Dragon NaturallySpeaking.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class CognitiveDisabilityPage extends StatelessWidget {
  const CognitiveDisabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discapacidad Cognitiva"),
            Text(
              'VITIUM',
              style: TextStyle(
                color: kVitiumNameColor,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/images/HelpingAPartner-amico.png',
              height: 200,
            ),
            Text(
              "Definición",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "Incluye dificultades de aprendizaje, trastornos de atención, o dislexia, TDAH, autismo.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Adaptaciones para Reclutamiento",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Da instrucciones claras y evita jerga técnica, proporcionando material por escrito.\n"
              "2. Permite entrevistas pausadas y evaluaciones sin dependencia de velocidad.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Recursos",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Guías de Neurodiversidad en el Trabajo.\n"
              "2. Herramientas de IA para procesar y organizar información visual o textual.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class PsychosocialDisabilityPage extends StatelessWidget {
  const PsychosocialDisabilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Discapacidad Psicosocial"),
            Text(
              'VITIUM',
              style: TextStyle(
                color: kVitiumNameColor,
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/images/HelpingAPartner-amico.png',
              height: 200,
            ),
            Text(
              "Definición",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "Condiciones que afectan el bienestar emocional, como ansiedad, depresión, trastorno bipolar.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Adaptaciones para Reclutamiento",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Crea un ambiente calmado de entrevista, evita preguntas presionantes y ofrece flexibilidad horaria.\n"
              "2. Ofrece apoyo psicológico como parte del programa de bienestar.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 16),
            Text(
              "Recursos",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: kSecondaryColor,
                  ),
            ),
            Text(
              "1. Capacitación en reconocimiento y apoyo de necesidades psicosociales.\n"
              "2. Políticas de trabajo flexible en función de la salud mental.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisabilityVideosPage extends StatefulWidget {
  const DisabilityVideosPage({super.key});

  @override
  DisabilityVideosPageState createState() => DisabilityVideosPageState();
}

class DisabilityVideosPageState extends State<DisabilityVideosPage> {
  final List<String> videoIds = [
    '0taeMhWEqXI', // Ejemplo de video sobre discapacidad visual
    '8IMI6YfGN_8', // Ejemplo de video sobre discapacidad auditiva
    'QRMZRtUKvnY', // Ejemplo de video sobre discapacidad motriz
    'cEp9QxRZgug', // Ejemplo de video sobre discapacidad cognitiva
    'DFXFkUF_8fQ', // Ejemplo de video sobre discapacidad psicosocial
  ];

  late List<YoutubePlayerController> videoControllers;

  @override
  void initState() {
    super.initState();

    // Inicializamos los controladores solo una vez
    videoControllers = videoIds
        .map((id) => YoutubePlayerController(
              initialVideoId: id,
              flags: YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            ))
        .toList();
  }

  @override
  void dispose() async {
    // Liberamos los recursos de los controladores
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
    await _closePage(context);
  }

  // Método para manejar el cierre de la página
  Future<void> _closePage(context) async {
    // Esperamos un poco antes de cerrar la página
    await Future.delayed(Duration(milliseconds: 500));
    // Cierra la pantalla
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sesión informativa",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              _closePage(context), // Llama al método para cerrar la página
        ),
      ),
      body: ListView.builder(
        itemCount: videoIds.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Video sobre ${names[index]}",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20), // Espacio entre el texto y el video
                YoutubePlayer(
                  controller: videoControllers[index],
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Lista de nombres para los videos
final List<String> names = [
  'Discapacidad Visual',
  'Discapacidad Auditiva',
  'Discapacidad Motriz',
  'Discapacidad Cognitiva',
  'Discapacidad Psicosocial',
];

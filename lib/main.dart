import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_calendar_plus/device_calendar_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vacina_app/screens/check_screen.dart';
import 'package:vacina_app/util/app_logger.dart';
import 'package:vacina_app/util/my_custom_scroll_behavior.dart';
import 'package:firebase_core/firebase_core.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // Mesmo ID configurado no AndroidManifest
  'Notificações Importantes',
  description: 'Este canal é usado para notificações cruciais.',
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Tratamento de mensagens em Background / Com o app fechado
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // O próprio sistema operacional cuida de exibir na barra se o payload tiver "notification"
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp();

    // Define o handler de background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Inicializa o plugin de notificações locais para o Foreground
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    DeviceCalendar.instance.autoPermissions = AutoPermissionMode.full;
    FirebaseMessaging.onMessage.listen((message) {
      AppLogger.log(
        'Notificação titulo: ${message.notification?.title}',
        name: 'main',
        error: '',
      );
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupFcm();
    _setupNotificationClickHandling();
  }

  void _setupFcm() async {
    if (kIsWeb) return;

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 1. Solicita permissão ao usuário (Obrigatório para iOS e Android 13+)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      AppLogger.log('Autorização concedida pelo usuário.');
    }

    // Configuração para iOS exibir notificações em Foreground
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // 2. Escuta mensagens em Foreground (App aberto na tela)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Se houver uma notificação e for Android, força a exibição na barra suspensa
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher', // Ícone padrão do seu app
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });
  }

  void _setupNotificationClickHandling() async {
    // 1. Configurações de inicialização do Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ); // Seu ícone padrão

    // Configurações de inicialização do iOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    // 2. Inicializa o plugin e escuta o clique do usuário na barra suspensa
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // ESTE BLOCO É EXECUTADO QUANDO O USUÁRIO CLICA NA NOTIFICAÇÃO
        AppLogger.log(
          "Usuário clicou na notificação! Payload: ${response.payload}",
        );

        // Se quiser redirecionar o usuário para alguma tela específica (ex: Histórico de Vacinas)
        // você pode usar o seu gerenciador de rotas aqui, por exemplo:
        // Navigator.push(context, MaterialPageRoute(builder: (context) => TelaNotificacoes()));
      },
    );

    // 3. Captura o clique se o aplicativo estava TOTALMENTE FECHADO e foi aberto pelo push
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      AppLogger.log(
        "O app foi aberto a partir de uma notificação com ele fechado!",
      );
      // Execute a lógica de navegação se necessário
    }

    // 4. Captura o clique se o aplicativo estava em SEGUNDO PLANO (suspenso) e voltou para a tela
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.log(
        "O app voltou do segundo plano através do clique na notificação!",
      );
      // Execute a lógica de navegação se necessário
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imune',
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue[800], // Azul principal
        ),
        // Configura o estilo padrão de todos os inputs do app
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // Campos brancos
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blue,
            ), // Remove a borda preta padrão
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
            backgroundColor: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[900],
            // Fundo do botão
            foregroundColor: Colors.white,
            // Cor do texto/ícone do botão
            textStyle: TextStyle(fontSize: 18),
            minimumSize: const Size(double.infinity, 50),
            // Botão largo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      scrollBehavior: MyCustomScrollBehavior(),
      home: const CheckScreen(),
    );
  }
}

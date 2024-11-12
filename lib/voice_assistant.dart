import 'dart:async';
import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'dart:math';
import 'package:medvantage_patient/View/Pages/exercise_tracking_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'Localization/app_localization.dart';
import 'Modal/symptoms_problem_data_modal.dart';
import 'View/Pages/addvital_view.dart';
import 'View/Pages/chat_view.dart';
import 'View/Pages/food_intake.dart';
import 'View/Pages/lifestyle_interventions_view.dart';
import 'View/Pages/pills_reminder_view.dart';
import 'View/Pages/prescription_checklist.dart';
import 'View/Pages/upload_report_view.dart';
import 'View/Pages/supplement_intake_view.dart';
import 'View/Pages/symptom_tracker_view.dart';
import 'View/Pages/urin_output.dart';
import 'View/Pages/water_intake_view.dart';
import 'ViewModal/addvital_view_modal.dart';
import 'ViewModal/dashboard_view_modal.dart';
import 'ViewModal/login_view_modal.dart';
import 'ViewModal/prescription_checklist_viewmodel.dart';
import 'ViewModal/symptoms_tracker_view_modal.dart';
import 'app_manager/alert_toast.dart';
import 'app_manager/app_color.dart';
import 'app_manager/bottomSheet/bottom_sheet.dart';
import 'app_manager/bottomSheet/functional_sheet.dart';
import 'app_manager/navigator.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'app_manager/widgets/coloured_safe_area.dart';
import 'authenticaton/user_repository.dart';

import 'package:http/http.dart' as http;

import 'common_libs.dart';

class VoiceAssistant extends StatefulWidget {
  String? isFrom;
  VoiceAssistant({Key? key, this.isFrom}) : super(key: key);

  @override
  State<VoiceAssistant> createState() => _VoiceAssistantState();
}

final box = GetStorage();

enum TtsState { playing, stopped, paused, continued }

class _VoiceAssistantState extends State<VoiceAssistant> {
  final String defaultLanguage = 'hi_IN';
  var waitingTime = 10;
  TextToSpeech tts = TextToSpeech();
  var timer;
  var timer2;
  String text = '';
  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 0.8; // Range: 0-2
  String? language;
  String? languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String? voice;
  bool _hasSpeech = false;
  bool _logEvents = false;
  bool _onDevice = false;
  final TextEditingController _pauseForController =
      TextEditingController(text: '5');
  final TextEditingController _listenForController =
      TextEditingController(text: '30');
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords =
      'Say the keyword page that you want to visit.(ie:Add Vital or Supplement Checklist)';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  StreamController<SpeechToText> speechController =
      StreamController<SpeechToText>();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    await initTts();

    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: false);
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    await initSpeechState();
    _currentLocaleId = 'en_IN';

    print('${localization.getLanguage}rtyui');
    // timer = Timer(
    //   Duration(seconds: waitingTime),
    //       () {
    //     if (mounted) {
    //     }
    //   },
    // );
    startListening();
    // Future.delayed(const Duration(milliseconds: 999), () {
    //   print('startListening');
    //
    //
    // });
    Future.delayed(const Duration(seconds: 6), () {
      if (lastWords == "") {
        if (mounted) {
          if (addvitalVM.pauseFunc == true) {
          } else {
            Get.back();
          }
          if (widget.isFrom == 'add vitals') {
            aiCommandSheet(context, isFrom: widget.isFrom);
          }
        }
      }
      Future.delayed(const Duration(seconds: 8), () {
        if (mounted) {}
      });
    });
    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (speech.isListening == true) {
      } else {
        startListening();
      }
    });
  }

  Future<void> initSpeechState() async {
    print('oktesting');
    textEditingController.text = text;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLanguages();
    });
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        _localeNames = await speech.locales();
        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
      print('oktesting2');
    } catch (e) {
      print('oktesting');
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  // OrganModal symptomscheckermodal  = OrganModal();

  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String>? displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String? defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
      print('$languageCodes selested lang');
      print('$defaultLangCode selested lang');
    } else {
      languageCode = defaultLanguage;
    }
    language = await tts.getDisplayLanguageByCode(languageCode!);
    voice = await getVoiceByLang(languageCode!);
    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> getVoiceByLang(String lang) async {
    final List<String>? voices = await tts.getVoiceByLang(languageCode!);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: true);

    return ColoredSafeArea(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey,
          body: Container(
            // Below is the code for Linear Gradient.
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.green,
                  Colors.green.shade900,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(children: [
              Expanded(
                  child: speech.isListening
                      ? LoadingAnimationWidget.beat(
                          color: Colors.lightBlueAccent, size: 100)
                      : const SizedBox()),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RecognitionResultsWidget(
                    lastWords: lastWords,
                    level: level,
                    speech: speech,
                    isFrom: widget.isFrom.toString() ?? '',
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
    //     :Container(
    //   color: Colors.black54,
    //   child: Center(child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: LoadingAnimationWidget.discreteCircle(color: Colors.tealAccent, size: 50),
    //   )),
    // );
  }

  /// NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE  NEW STARTS HERE
  late FlutterTts flutterTts;
  String? languageOfSpeech;
  String? engine;
  double volumeOfSpeech = 1.0;
  double pitchOfSpeech = 4.0;
  double rateOfSpeech = 0.6;
  bool isCurrentLanguageInstalled = false;
  String? _newVoiceText;
  int? _inputLength;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  initTts() async {
    flutterTts = FlutterTts();
    //   flutterTts.stop();
    await flutterTts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
    await _setAwaitOptions();

    if (isAndroid) {
      await _getDefaultEngine();
      await _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      // flutterTts.setInitHandler(() {
      //   setState(() {
      //     print("TTS Initialized");
      //   });
      // });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future<dynamic> _getEngines() async => await flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak(spokenText) async {
    DashboardViewModal dashboardVM =
        Provider.of<DashboardViewModal>(context, listen: false);
    LoginViewModal loginVM =
        Provider.of<LoginViewModal>(context, listen: false);
    UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);

    print('step 0');

    await flutterTts.setVolume(volumeOfSpeech);
    await flutterTts.setSpeechRate(rateOfSpeech);
    await flutterTts.setPitch(pitchOfSpeech);

    var page = widget.isFrom ?? 'main dashboard';
    print(widget.isFrom.toString() + '1234567890');

    /// MONTH
    var month;
    var monthNo;
    switch (page) {
      case "main dashboard":
        {
          if (spokenText == 'which page is this' ||
              spokenText.contains('which page') ||
              spokenText.contains('which screen')) {
            flutterTts.speak('ok this is your previous page');
            Get.back();
          } else if (spokenText == 'jarvis' ||
              spokenText.contains('jarvis') ||
              spokenText.contains('ok jarvis') ||
              spokenText.contains('hey jarvis') ||
              spokenText.contains('hello jarvis') ||
              spokenText.contains('hello') ||
              spokenText.contains('shfc') ||
              spokenText.contains('hfc') ||
              spokenText.contains('heart app')) {
            flutterTts
                .speak('HEY , i am Voice assistant , i am here to help you ');
          } else if (spokenText == 'say something' ||
              spokenText.contains('say')) {
            var list = spokenText.split(' ');
            var textToSay = list
                .toString()
                .replaceAll('[', '')
                .replaceAll('say', '')
                .replaceAll(']', '')
                .replaceAll(',', '')
                .replaceAll('can', '')
                .replaceAll('you', '');
            flutterTts.speak(textToSay);
            print(textToSay.toString());
            Get.back();
          } else if (spokenText == 'add vitals' ||
              spokenText.contains('vitals') ||
              spokenText.contains('vital') ||
              spokenText.contains('advertise') ||
              spokenText.contains('adwitter')) {
            Get.back();
            MyNavigator.push(context, const AddVitalView());

            flutterTts.speak("This is your add vitals page");
          } else if (spokenText == 'prescription checklist' ||
              spokenText.contains('prescription') ||
              spokenText.contains('prescription checklist') ||
              spokenText.contains('prescription')) {
            Get.back();
            MyNavigator.push(context, const PillsReminderView());

            flutterTts.speak("This is your prescription page");
          } else if (spokenText == 'symptom' ||
              spokenText.contains('symptoms') ||
              spokenText.contains('symptom tracker') ||
              spokenText.contains('symptoms tracker') ||
              spokenText.contains('track symptom')) {
            Get.back();
            MyNavigator.push(context, const SymptomTracker());
            flutterTts.speak("This is your Symptom page");
          } else if (spokenText == 'food' ||
              spokenText.contains('food intake') ||
              spokenText.contains('diet') ||
              spokenText.contains('food') ||
              spokenText.contains('diet tracking')) {
            Get.back();
            MyNavigator.pushReplacement(context, const FoodIntakeView());
            flutterTts.speak("This is your Diet Checklist Page");
          } else if (spokenText.contains('intake') ||
              spokenText.contains('output') ||
              spokenText.contains('glass') ||
              spokenText.contains('fluid')) {
            Get.back();
            MyNavigator.push(context, const SliderVerticalWidget());
            flutterTts.speak("This is your Fluid Intake Page");
          } else if (spokenText == 'supplement' ||
              spokenText.contains('intake') ||
              spokenText.contains('supplement')) {
            Get.back();
            MyNavigator.push(context, const SupplementIntakeView());
            flutterTts.speak("This is your supplement CheckList page");
          } else if (spokenText == 'upload report' ||
              spokenText.contains('upload report') ||
              spokenText.contains('upload') ||
              spokenText.contains('report') ||
              spokenText.contains('file') ||
              spokenText.contains('photo')) {
            Get.back();
            MyNavigator.push(context, const ReportTrackingView());
            flutterTts.speak("This is your upload Report page");
          }
          // else if(spokenText=='exercise'||spokenText.contains('activity')||spokenText.contains('yoga')||spokenText.contains('running')||spokenText.contains('walking')||spokenText.contains('tired')||spokenText.contains('cardio')||spokenText.contains('gym')){
          //   Get.back();
          //   MyNavigator.push(context, const ExerciseTrackingView());
          //   flutterTts.speak("This is your Exercise page");
          // }

          else if (spokenText == 'go back' ||
              spokenText.contains('back') ||
              spokenText.contains('previous page') ||
              spokenText.contains('dashboard page') ||
              spokenText.contains('main page') ||
              spokenText.contains('dashboard')) {
            flutterTts.speak('ok this is your previous page');
          } else if (spokenText == 'tell me about the app' ||
              spokenText.contains('s h f c') ||
              spokenText.contains('shfc') ||
              spokenText.contains('app')) {
            flutterTts.speak(
                'hi there I am here to help you and make your work easier, this is  SMART HEART FAILURE COMPANION  application');
          } else if (spokenText == 'life style' ||
              spokenText.contains('lifesyle') ||
              spokenText.contains('lifeStyle intervention') ||
              spokenText.contains('lifeStyles') ||
              spokenText.contains('lifeStyle lnterventions') ||
              spokenText.contains('lifeStyles lnterventions')) {
            Get.back();
            MyNavigator.push(context, const LifeStyleInterventions());
            flutterTts.speak("ok this is your LifeStyle Intervention");
          }
          // else if(spokenText=='FAQs'||spokenText.contains('FAQ')||spokenText.contains('Frequently ask question')||spokenText.contains('Frequently question')||spokenText.contains('question')){
          //   MyNavigator.push(context, const LifeStyleInterventions());
          //   flutterTts.speak("LifeStyle Intervention");
          // }
          else if (spokenText == 'chat' || spokenText.contains('chats')) {
            Get.back();
            MyNavigator.push(context, const ChatView());
            flutterTts.speak("ok this is your Chat Page");
          } else if (spokenText == 'urine' ||
              spokenText.contains('urine Output') ||
              spokenText.contains('urine output page')) {
            Get.back();
            MyNavigator.push(context, const UrinOutputView());
            flutterTts.speak("ok this is your Urine Output Page");
          } else if (spokenText == 'exercise tracker' ||
              spokenText.contains('exercise Tracking') ||
              spokenText.contains('exercise tracking Page') ||
              spokenText.contains('exercise') ||
              spokenText.contains('exercise page')) {
            Get.back();
            MyNavigator.push(context, const ExerciseTrackingView());
            flutterTts.speak("ok this is your Exercise Tracker Page");
          } else if (spokenText == 'call' ||
              spokenText.contains('emergency Call')) {
            String morningTime = '';
            morningTime = await dashboardVM.callTiming();
            print('nnnnnnnvnnnv' + morningTime.toString());

            if (int.parse(morningTime.toString()) >= 0 &&
                int.parse(morningTime.toString()) <= 960) {
              // UrlLauncher.launch('tel: ${userRepository.getAppDetails.emergencyContactNumber.toString()}');
            } else {
              // UrlLauncher.launch('tel: ${userRepository.getAppDetails.eraEmergencyContactNumber.toString()}');
            }
          } else if (spokenText == 'change the language to hindi' ||
              spokenText.contains('hindi') ||
              spokenText.contains('indian') ||
              spokenText.contains('india')) {
            print('step 1');
            flutterTts.speak(
                'Ok , your language is being changed to Hindi,अब आप हिंदी में बातचीत कर सकते हैं');
            print('step 2');
            changeLangToHindi(context);
          } else if (spokenText == 'change the language to english' ||
              spokenText.contains('english') ||
              spokenText.contains('angreji')) {
            flutterTts.speak('Ok , your language is being changed to english');
            changeLangToEnglish(context);
          }
          //
          // else if(spokenText=='change the language to marathi'||spokenText.contains('marathi')||spokenText.contains('maratha')){
          //   flutterTts.speak('Ok , your language is being changed to marathi,आता तुम्ही मराठीत संवाद साधू शकता');
          //   toMarathi(context);
          // }

          // else if(spokenText=='change the language to urdu'||spokenText.contains('urdu')){
          //   flutterTts.speak('Ok , your language is being changed to urdu, اب آپ اردو میں بات چیت کرسکتے ہیں۔');
          //   toUrdu(context);
          // }
          else if (spokenText == 'change the language to arabic' ||
              spokenText.contains('arabic') ||
              spokenText.contains('arabi')) {
            flutterTts.speak(
                'Ok , your language is being changed to Arabic, الآن يمكنك التفاعل باللغة العربية');
            toArabic(context);
          }
          //
          // else if(spokenText=='change the language to bengali'||spokenText.contains('bengali')||spokenText.contains('bangla')){
          //   flutterTts.speak('Ok , your language is being changed to bengali,এখন আপনি মারাঠিতে ইন্টারঅ্যাক্ট করতে পারেন');
          //   toBengali(context);
          // }

          else if (spokenText == 'how many languages are there in the app' ||
              spokenText.contains('languages in the app') ||
              spokenText.contains('languages') ||
              spokenText.contains('language') ||
              spokenText.contains('change language') ||
              spokenText.contains('change the language')) {
            flutterTts.speak(
                'there are 6 languages in the app in which you can interact with,  those are , '
                'English , hindi , Marathi , Urdu , Arabic , Bengali , you can change the languages by '
                'selecting the dropdown menu on the screen ');
            changeLang(context);
          } else if (spokenText == 'please help' ||
              spokenText == 'please help me' ||
              spokenText == 'help me') {
            flutterTts.speak(
                'hi there I am here to help you and make your work easier, this is  SMART HEART FAILURE COMPANION  application'
                'You can navigate to pages by calling the names of the page');
          } else if (spokenText == 'who are you' ||
              spokenText.contains(' you ') ||
              spokenText.contains('yourself')) {
            flutterTts.speak('I am Voice assistant what about you');
          } else if (spokenText == 'hi') {
            flutterTts.speak('hey');
          } else if (spokenText == 'hello' || spokenText == 'whatsapp') {
            flutterTts.speak('hey , nothing much! what about you ');
          }

          // else if(spokenText=='qr'||spokenText.contains('qr')){
          //   flutterTts.speak('hey , QR is there so that you can navigate to the website');
          // }

          // else if(spokenText.contains('login')||spokenText.contains('sigh in')||spokenText.contains('sighin')){
          //
          // }

          // else if(spokenText.contains('register')||spokenText.contains('registration')||spokenText.contains('new user')||spokenText.contains('add user')||spokenText.contains('sign up')||spokenText.contains('signup')){
          //   flutterTts.speak('fill the details to register a new user');
          //   // navigateToRegister(context);
          // }

          else if (spokenText.contains('logout') ||
              spokenText.contains('log out')) {
            ApplicationLocalizations localization =
                Provider.of<ApplicationLocalizations>(context, listen: false);
            UserRepository userRepository =
                Provider.of<UserRepository>(context, listen: false);

            LoginViewModal loginVM =
                Provider.of<LoginViewModal>(context, listen: false);

            await CustomBottomSheet.open(context,
                child: FunctionalSheet(
                  message: localization.getLocaleData.areuSureYouWantToLogOut
                      .toString(),
                  buttonName: localization.getLocaleData.yes.toString(),
                  onPressButton: () async {
                    print('nnnnnnnvvvv');
                    await loginVM.logOut(context);
                    // await userRepository.logOutUser(context);
                    print('nnnnnnnvvvv');
                  },
                  cancelBtn: localization.getLocaleData.cancel.toString(),
                ));
          } else if (spokenText.contains('consult doctor') ||
              spokenText.contains('doctor consultation') ||
              spokenText.contains('dr consultation') ||
              spokenText.contains('consult dr') ||
              spokenText.contains('consult') ||
              spokenText.contains('speciality') ||
              spokenText.contains('specialities') ||
              spokenText.contains('specialist') ||
              spokenText.contains('specialists') ||
              spokenText.contains('list of doctor') ||
              spokenText.contains('doctor list') ||
              spokenText.contains('doctors list') ||
              spokenText.contains('show me doctor') ||
              spokenText.contains('show doctor')) {
            // flutterTts.speak('you can find the doctors by symptoms or by specialities');
            // navigateConsultDoctor(context,false);
          } else if (spokenText.contains('find doctors by symptoms') ||
              spokenText.contains('symptom') ||
              spokenText.contains('symptoms') ||
              spokenText.contains('body') ||
              spokenText.contains('body part')) {
            // navigateConsultDoctor(context,true);
          } else if (spokenText.contains('quick health checkup') ||
              spokenText.contains('health checkup') ||
              spokenText.contains('checkup') ||
              spokenText.contains('quick')) {
            // navigateQuickHealthCheckUp(context);
          } else if (spokenText.contains('medical history') ||
              spokenText.contains('appointment history') ||
              spokenText.contains('vital history') ||
              spokenText.contains('history') ||
              spokenText.contains('investigation') ||
              spokenText.contains('appointment') ||
              spokenText.contains('manually report') ||
              spokenText.contains('manual report') ||
              spokenText.contains('investigation') ||
              spokenText.contains('radiology report') ||
              spokenText.contains('microbiology') ||
              spokenText.contains('bmi') ||
              spokenText.contains('vital')) {
            navigateMedicalHistory(context, spokenText);
          }

          // else if(spokenText==('can you find me a doctor')||spokenText.contains('find doctors')||spokenText.contains('find doctor')||spokenText.contains('doctor')){
          //   flutterTts.speak('Of-course,  '
          //       '    I am here to help you and make your work easier, this is a KIOSK application, '
          //       'you can choose doctors according to your needs . '
          //       'For example you can tell your symptoms and get the list of doctors according to your symptoms,'
          //       ' by clicking the green button given below');
          // }

          else if (spokenText == ('get lost') ||
              spokenText.contains('bye') ||
              spokenText.contains('ok') ||
              spokenText.contains('okay')) {
            flutterTts.speak('ok bye');
          }

          ///  registration

          /// registration
          else {
            // flutterTts.speak("This keyword seems unfamiliar please try again");
            //  Get.back();

            // showDialog<String>(
            //   context: context,
            //   builder: (BuildContext context) => AlertDialog(
            //     title: Text('This keyword seems unfamiliar please try again.\n For example: go to Add Vitals page',style: MyTextTheme.veryLargePCB,textAlign: TextAlign.center),
            //     content: SizedBox(
            //       height: 70,
            //       child: Column(
            //         children: [
            //           InkWell(
            //             onTap: (){
            //                Get.back();
            //               aiCommandSheet(context);
            //             },
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 color: AppColor.green,
            //               ),
            //               child:  Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     const Icon(Icons.mic,color: Colors.white,),
            //                     Text('Try again',style: MyTextTheme.largeWCB),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // );
          }
        }

        break;
      case "logout":
        {}
        break;
      case "Top Specialities":
        {}
        break;
      case "slot view":
        {}
        break;

      //

      case "Device View":
        {}
        break;

      case "medical history":
        {
          print("");
        }
        break;

      case "add vitals":
        {
          AddVitalViewModal addvitalVM =
              Provider.of<AddVitalViewModal>(context, listen: false);
          if (spokenText.contains('systolic') ||
              spokenText.contains('solic') ||
              spokenText.contains('scrollet') ||
              spokenText.contains('install it') ||
              spokenText.contains('trolley') ||
              spokenText.contains('historic') ||
              spokenText.contains('strongest') ||
              spokenText.contains('tallest') ||
              spokenText.contains('installing')) {
            int number = getNumber(spokenText);
            addvitalVM.systollicC.text = number.toString();
            flutterTts.speak('added systolic');
          } else if (spokenText.contains('diastolic') ||
              spokenText.contains('that\'s qualification') ||
              spokenText.contains('dastolic')) {
            int number = getNumber(spokenText);
            addvitalVM.diatollicC.text = number.toString();
            flutterTts.speak('added  diastolic');
          } else if (spokenText.contains('pulse') ||
              spokenText.contains('pulse rate')) {
            int number = getNumber(spokenText);
            addvitalVM.pulserateC.text = number.toString();

            flutterTts.speak('added pulse');
          } else if (spokenText.contains('heart') ||
              spokenText.contains('heartbeat') ||
              spokenText.contains('hard')) {
            int number = getNumber(spokenText);
            addvitalVM.heartrateC.text = number.toString();

            flutterTts.speak('added heart rate');
          } else if (spokenText.contains('spo2') ||
              spokenText.contains('s p o 2') ||
              spokenText.contains('sp auto') ||
              spokenText.contains('sq2') ||
              spokenText.contains('po2') ||
              spokenText.contains('o2') ||
              spokenText.contains('you tube')) {
            int number = getNumber(spokenText);
            addvitalVM.spo2C.text = number.toString();
            flutterTts.speak('added  s p o 2');
          } else if (spokenText.contains('temperature') ||
              spokenText.contains('fever')) {
            int number = getNumber(spokenText);
            addvitalVM.temperatureC.text = number.toString();
            flutterTts.speak('added  temperature');
          } else if (spokenText.contains('respiratory rate') ||
              spokenText.contains('respiratory') ||
              spokenText.contains('respiration') ||
              spokenText.contains('battery rate')) {
            int number = getNumber(spokenText);
            addvitalVM.respiratoryC.text = number.toString();
            flutterTts.speak('added  respiratory rate');
          } else if (spokenText.contains('rbs') ||
              spokenText.contains('r b s')) {
            int number = getNumber(spokenText);
            addvitalVM.rbsC.text = number.toString();

            flutterTts.speak('added  R B S');
          } else if (spokenText.contains('weight') ||
              spokenText.contains('wait') ||
              spokenText.contains('kilo') ||
              spokenText.contains(' kg') ||
              spokenText.contains('gram')) {
            int number = getNumber(spokenText);
            addvitalVM.weightC.text = number.toString();
            flutterTts.speak('added weight');
          } else if (spokenText.contains('save') ||
              spokenText.contains('upload')) {
            if (addvitalVM.systollicC.text != '' ||
                addvitalVM.diatollicC.text != '' ||
                addvitalVM.pulserateC.text != '' ||
                addvitalVM.temperatureC.text != '' ||
                addvitalVM.spo2C.text != '' ||
                addvitalVM.respiratoryC.text != '' ||
                addvitalVM.heartrateC.text != '' ||
                addvitalVM.weightC.text != '' ||
                addvitalVM.rbsC.text != '' ||
                addvitalVM.heightC.text != '') {
              await addvitalVM.addVitalsData(isFromMachine: '0');
              flutterTts.speak('OKAY');
            } else {
              flutterTts.speak('please add at least one vital');
            }
          } else {
            Get.back();
            aiCommandSheet(context, isFrom: 'add vitals');
          }

          print("add vitals page");
        }
        break;

      case "investigation":
        {}
        break;
      case "login":
        {}

        break;

      case "registration":
        {}
        break;

      default:
        {
          print("default switch case");
        }
        break;
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    speechController.close();
    timer?.cancel();
    timer2?.cancel();
    // VoiceAssistantProvider listenVM=Provider.of<VoiceAssistantProvider>(context,listen: false);
    // listenVM.updateCurrentPage='main dashboard';
    //  _initPicovoice();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedEnginesDropDownItem(String? selectedEngine) async {
    await flutterTts.setEngine(selectedEngine!);
    language = null;
    setState(() {
      engine = selectedEngine;
    });
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language!);
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    });
  }

  reScheduleAppointment(
    context,
  ) {
    // TimeSlotModal modal = TimeSlotModal();
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  bool weAreListening = true;

  Future<void> postData(text) async {
    print('debouncedhits');

    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    MedicineViewCheckListDataMOdel medicineVm =
        Provider.of<MedicineViewCheckListDataMOdel>(context, listen: false);

    SymptomsTrackerViewModal symptomtrackerVM =
        Provider.of<SymptomsTrackerViewModal>(context, listen: false);
    AddVitalViewModal addvitalVM =
        Provider.of<AddVitalViewModal>(context, listen: false);

    print('yes its working');
    // String url = 'http://172.16.19.162:8002/api/echo/';

    // String url = 'http://172.16.61.15:8007/api/echo/';

    // String url = 'http://182.156.200.178:8007/api/echo/';  /// OLD

    //String url = 'http://182.156.200.178:8005/api/echo/';   /// Live
    String url = 'http://food.shopright.ai:3478/api/echo/';

    /// Live Cloud Url
    // String url = 'http://172.16.20.234:5003/api/echo/';  /// LOCAL

    var requestBody = {
      "text": text,

      /// local
      //   "text": jsonEncode(text),/// live
    };
    print(url.toString());
    print("AnimeshRequest" + requestBody.toString());
    String requestBodyJson = jsonEncode(requestBody);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBodyJson,
      );
      var data = response.body;
      print('data is $data');
      addvitalVM.allData = jsonDecode(data)['echo']['myvital'];
      print('Response: is ${addvitalVM.allData}');
      if (response.statusCode == 200) {
        // Navigator.pop(context);

        if (addvitalVM.allData['vmValueBPSys'].toString() == '0' &&
            addvitalVM.allData['vmValueBPDias'].toString() == '0' &&
            addvitalVM.allData['vmValueRespiratoryRate'].toString() == '0' &&
            addvitalVM.allData['vmValueSPO2'].toString() == '0' &&
            addvitalVM.allData['vmValueTemperature'].toString() == '0.0' &&
            addvitalVM.allData['vmValueHeartRate'].toString() == '0' &&
            addvitalVM.allData['weight'].toString() == '0' &&
            addvitalVM.allData['vmValueRbs'].toString() == '0' &&
            addvitalVM.allData['vmValuePulse'].toString() == '0') {
        } else {
          addvitalVM.pauseFunc = true;
          Get.back();
          Get.to(() => const AddVitalView());
          flutterTts.speak('added');
        }
        if (addvitalVM.allData['fluidValue'].toString() != '{}') {
          addvitalVM.allData['fluidValue'].forEach((key, value) {
            addvitalVM.fluidAdded = double.parse(value.toString() ?? '0');
            addvitalVM.valueFromVoice = key.toString();
            print('Key: $key, Value: $value');
            addvitalVM.notifyListeners();
          });

          Get.back();
          await Get.to(() => SliderVerticalWidget(
                throughVoice: true,
              ));

          //
          // print('setp1');
          //
          //   await addvitalVM.manualFoodAssign(context);
          //   print('setp2');
          //
          //  int index=  addvitalVM.getManualFoodList.indexWhere((item) => item.foodName == addvitalVM.valueFromVoice.toLowerCase());
          //   print('setp3');
          //
          //   addvitalVM.updateSelectedFoodID = addvitalVM.getManualFoodList[index].foodID.toString();
          //   print('setp4');
          //   await CustomBottomSheet.open(context,
          //       child: FunctionalSheet(
          //         message:
          //         localization.getLocaleData.areYouSureYouWantTo.toString()+' ${addvitalVM.valueFromVoice}?',
          //         buttonName:
          //         localization.getLocaleData.confirm.toString(),
          //         onPressButton: () async {
          //           //  Get.back();
          //           await addvitalVM.fluidIntake(context);
          //         },
          //       ));
        }

        if (addvitalVM.allData['symptomsList'].toString() != '[]') {
          symptomtrackerVM.symptomsVoiceList =
              addvitalVM.allData['symptomsList'];
          Get.back();

          // for(){
          //   symptomsAdded.add(SymptomsProblemModal(
          //       problemId: problemMap['id'],
          //       problemName: problemMap['symptoms']));
          // }
          Get.to(() => SymptomTracker(
                throughVoice: true,
              ));
          // for(int i =0;i<symptomtrackerVM.symptomsVoiceList.length;i++){
          //   print('loop working');
          //   symptomtrackerVM.symptomsAdded.add(SymptomsProblemModal(
          //       problemId: symptomtrackerVM.symptomsVoiceList[i]['id'],
          //       problemName: symptomtrackerVM.symptomsVoiceList[i]['symptom']));
          // }
        }

        if (addvitalVM.allData['myMedication'].toString() != '[]') {
          addvitalVM.updatePauseFunc = true;

          var medDetails = addvitalVM.allData['myMedication'][0];
          var medicineName = addvitalVM.allData['myMedication'][0]['drugName'];

          print(box.read('pmid'));
          await compareTimes(addvitalVM);
          await CustomBottomSheet.open(context,
              child: FunctionalSheet(
                message: localization
                        .getLocaleData.areYouSureYouHaveTakenThisMedicine
                        .toString() +
                    "\n $medicineName",
                buttonName: localization.getLocaleData.yes.toString(),
                onPressButton: () async {
                  var pmid = await box.read('pmid');
                  await medicineVm.insertMedication(
                      context,
                      pmid,
                      medDetails['prescriptionRowID'],
                      addvitalVM.time.toString());
                  Get.to(() => PrescriptionCheckListView());
                },
              ));
        }

        print('Response: ${data}  wowwwww');
        // Get.back();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  compareTimes(AddVitalViewModal addvital) {
    DateTime now = DateTime.now();
    // Defining times
    DateTime time8AM = DateTime(now.year, now.month, now.day, 8, 0);
    DateTime time2PM = DateTime(now.year, now.month, now.day, 14, 0);
    DateTime time6PM = DateTime(now.year, now.month, now.day, 18, 0);
    DateTime time10PM = DateTime(now.year, now.month, now.day, 12, 0);

    if (now.isAfter(time8AM) && now.isBefore(time2PM)) {
      addvital.time = "8:00";
      print("8:00");
    } else if (now.isAfter(time2PM) && now.isBefore(time6PM)) {
      print("14:00 PM");
      addvital.time = "14:00";
    } else if (now.isAfter(time6PM) && now.isBefore(time10PM)) {
      print("18:00 PM");
      addvital.time = "18:00";
    } else if (now.isAfter(time10PM)) {
      print("22:00");
      addvital.time = "22:00";
    }
    addvital.notifyListeners();
  }

  changeLang(context) {
    // changeLanguage();
  }
  changeLangToHindi(context) {
    print('step 3');

    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    localization.updateLanguage(Language.hindi);
    //  Get.back();
  }

  changeLangToEnglish(context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    localization.updateLanguage(Language.english);
    //   Get.back();
  }

  toMarathi(context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    localization.updateLanguage(Language.marathi);
    //   Get.back();
  }

  toUrdu(context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    localization.updateLanguage(Language.urdu);
    //   Get.back();
  }

  toArabic(context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    localization.updateLanguage(Language.arabic);
    Get.back();
  }

  toBengali(context) {
    ApplicationLocalizations localization =
        Provider.of<ApplicationLocalizations>(context, listen: false);
    localization.updateLanguage(Language.bengali);
    //  Get.back();
  }
  // navigateToLogin(context){
  //   print('test login 3');
  //
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) =>   LogIn(index: '1')),
  //   );
  //   print('test login 4');
  //
  // }
  // navigateToDashboard(context){
  //   App().replaceNavigate(context, const StartupPage());
  // }
  // navigateToRegister(context){
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) =>   const RegistrationView()),
  //   );
  // }
//  navigateConsultDoctor(context,bool symptom){
  // print('test doctor');
  // if (UserData().getUserData.isNotEmpty) {
  //   if(symptom==false){
  //     flutterTts.speak('you can find the doctors by speciality here');
  //   }else{
  //     flutterTts.speak('you can find the doctors by symptoms here , first select body part given below and then select symptoms to continue');
  //   }
  //
  //   App().navigate(context,  TopSpecialitiesView(isDoctor:symptom==true?1:0,));
  //
  // }else{
  //   flutterTts.speak('you are not logged in , login to continue');
  //   navigateToLogin(context);
  // }
//  }
//   navigateQuickHealthCheckUp(context){
//     if (UserData().getUserData.isNotEmpty) {
//       flutterTts.speak('this is your quick health checkup page ');
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) =>   DeviceView()),
//       );
//     }else{
//       flutterTts.speak('you are not logged in , login to continue');
//       navigateToLogin(context);
//     }
//   }

  navigateMedicalHistory(context, spokenText) async {
    // if (UserData().getUserData.isNotEmpty) {
    var page;
    String? mainHeading;
    if (spokenText.contains('manual report') ||
        spokenText.contains('manually report')) {
      flutterTts.speak('this is your manual report page');
      mainHeading = '2';
      page = 0;
    } else if (spokenText.contains('era,s investigation') ||
        spokenText.contains('investigation')) {
      flutterTts.speak('this is your Era,s investigation page');
      mainHeading = '2';
      page = 1;
    } else if (spokenText.contains('radiology report') ||
        spokenText.contains('radiology')) {
      flutterTts.speak('this is your radiology page');
      mainHeading = '2';
      page = 2;
    } else if (spokenText.contains('microbiology')) {
      flutterTts.speak('this is your microbiology page');
      mainHeading = '2';
      page = 3;
    } else if (spokenText.contains('bmi')) {
      flutterTts.speak('this is your BMI page');
      mainHeading = '2';
      page = 4;
    } else if (spokenText.contains('appointment') ||
        spokenText.contains('appointment history')) {
      flutterTts.speak('this is your appointment history page');
      mainHeading = '0';
    } else if (spokenText.contains('vital history') ||
        spokenText.contains('history') ||
        spokenText.contains('vital')) {
      flutterTts.speak('this is your vital history page');
      mainHeading = '1';
    } else if (spokenText.contains('investigation')) {
      mainHeading = '2';
    } else {
      flutterTts.speak('this is your medical history page');
      mainHeading = '0';
      page = 0;
    }
    // await  Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) =>  MyAppointmentView(page: page,mainHeading:mainHeading)),
    // );
  }

  void startListening() {
    _logEvent('start listening');
    lastWords = '';
    text = '';
    lastError = '';
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);

    speech.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: listenFor ?? 30),
      pauseFor: Duration(seconds: pauseFor ?? 5),
      partialResults: true,
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: _onDevice,
    );
    // setState(() {
    //   if(widget.isFrom=='login'){
    //     waitingTime=20;
    //   }else{
    //     waitingTime=15;
    //   }
    //
    //
    // });
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    // VoiceAssistantProvider listenVM=Provider.of<VoiceAssistantProvider>(context,listen: false);
    // listenVM.listeningPage='main dashboard';
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  getNumber(text) {
    int number = int.parse(RegExp(r'\d+')
        .firstMatch(text.toString().replaceAll('o2', ''))!
        .group(0)!);
    return number ?? 0;
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    MedicineViewCheckListDataMOdel controller =
        Provider.of<MedicineViewCheckListDataMOdel>(context, listen: false);
    if (!mounted) return;
    print(result.recognizedWords);
    print(result.finalResult);
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      String lang;
      var okIAmSearching;

      ApplicationLocalizations localization =
          Provider.of<ApplicationLocalizations>(context, listen: false);
      if (localization.getLanguage.toString() == 'Language.english') {
        lang = 'en_IN';
        okIAmSearching = 'OK I\'m Searching';
      } else if (localization.getLanguage.toString() == 'Language.hindi') {
        lang = 'hi_IN';
        okIAmSearching = 'ठीक है मैं खोज रहा हूँ';
      } else if (localization.getLanguage.toString() == 'Language.urdu') {
        lang = 'ur_IN';
        okIAmSearching = 'ٹھیک ہے میں تلاش کر رہا ہوں۔';
      } else if (localization.getLanguage.toString() == 'Language.bengali') {
        lang = 'bn_IN';
        okIAmSearching = 'ঠিক আছে আমি খুঁজছি';
      } else if (localization.getLanguage.toString() == 'Language.marathi') {
        lang = 'mr_IN';
        okIAmSearching = 'ठीक आहे मी शोधत आहे';
      } else if (localization.getLanguage.toString() == 'Language.arabic') {
        lang = 'ar_SA';
        okIAmSearching = 'حسنا أنا أبحث';
      } else {
        lang = 'en_IN';
        okIAmSearching = 'OK I\'m Searching';
      }
      lastWords = result.recognizedWords;
      // symptomscheckermodal.controller.searchSpeechToText.value.text=result.recognizedWords.toString();
      if (speech.isListening == false) {
        //  var timer = Timer.periodic(const Duration(seconds: 0), (Timer t) {
        lastWords = result.recognizedWords;
        text = result.recognizedWords;

        //  speak(lang,text.toUpperCase().toLowerCase());/// OLD

        _speak(text.toUpperCase().toLowerCase());

        /// NEW
        UserRepository userRepository =
            Provider.of<UserRepository>(context, listen: false);
        DateTime now = DateTime.now();
        var data = {
          "text": text,
          "userid": userRepository.getUser.userId.toString(),
          "uhid": userRepository.getUser.uhID.toString(),
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()).toString(),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()).toString(),
          "clientID": 1,
          "medication":
              // controller.getFullData
              [
            {
              "drugName": controller.medNames,
              // "dosageForm":controller.medDosage,
              //   "medicationNameAndDate":''
              "medicationNameAndDate": controller.medNameandDate
            }
          ]
        };
        Get.log(data.toString());
        Get.log(controller.medNameandDate.toString());
        if (widget.isFrom != 'add vitals') {
          print('hits');
          EasyDebounce.debounce(
              'apihit', Duration(milliseconds: 500), () => postData(data));
        }

        print('${text}08978967954');

        print('${text}08978967954');
        //  Get.back();
        //   });
      }
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    //setState(() {
    lastError = '${error.errorMsg} - ${error.permanent}';
    // });
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      print('$eventTime $eventDescription');
    }
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = 'hi_IN';
      print(selectedVal.toString());
    });
    print(selectedVal);
  }

  void _switchLogging(bool? val) {
    setState(() {
      _logEvents = val ?? false;
    });
  }

  void _switchOnDevice(bool? val) {
    setState(() {
      _onDevice = val ?? false;
    });
  }
}

class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    Key? key,
    this.lastWords = "Say Something like Add vitals/add symptoms",
    required this.level,
    required this.isFrom,
    required this.speech,
  }) : super(key: key);

  final String lastWords;
  final String isFrom;
  final speech;
  final double level;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         Colors.blue,
        //         Colors.black87,
        //         Colors.black87,
        //       ],
        //       begin: Alignment.bottomLeft,
        //       end: Alignment.topRight,
        //     ),
        //   ),
        // ),
        // const Positioned.fill(
        //   bottom: 20,
        //   child: Padding(
        //     padding: EdgeInsets.all(20.0),
        //     child: Blur(
        //       borderRadius: BorderRadius.all(Radius.circular(20)),
        //       blur: 10.5,
        //       blurColor: Colors.transparent,
        //       child:Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: SizedBox(),
        //       ),
        //     ),
        //   ),
        // ),
        Positioned.fill(
          bottom: 10,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Visibility(
              visible: lastWords != '',
              replacement: const Text(
                'Say the keyword page that you want to visit.\n'
                'ie: Add Vital or Supplement Checklist',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
              child: Text(
                lastWords,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
        // Positioned.fill(
        //   bottom: 190,
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: Container(
        //       width: 80,
        //       height: 80,
        //       alignment: Alignment.center,
        //       decoration: BoxDecoration(
        //         boxShadow: [
        //           BoxShadow(
        //             blurRadius: .26,
        //             spreadRadius: level * 1.5,
        //             color: Colors.black.withOpacity(.05),
        //           ),
        //         ],
        //         color:Colors.white54,
        //         borderRadius: const BorderRadius.all(Radius.circular(50)),
        //       ),
        //       child: IconButton(
        //         icon: const Icon(Icons.mic,size: 33,),
        //         onPressed: () => null,
        //       ),
        //     ),
        //   ),
        // ),
        // Positioned.fill(
        //   bottom: 155,
        //   child: Align(
        //     alignment: Alignment.bottomCenter,
        //     child: LoadingAnimationWidget.beat(color: speech.isListening?Colors.white30:Colors.transparent, size: 150),
        //   ),
        // ),
        //   Positioned.fill(
        //     bottom: 50,
        //     child: Align(
        //       alignment: Alignment.bottomCenter,
        //       child: InkWell(
        //         onTap: (){
        // //           VoiceAssistantProvider listenVM=Provider.of<VoiceAssistantProvider>(context,listen: false);
        // //           if (isFrom=='login'){
        // //             listenVM.listeningPage='login';
        // //           }else  if(isFrom=='registration'){
        // //
        // //             listenVM.listeningPage='registration';
        // //
        // //           }else{
        // //             listenVM.listeningPage=isFrom??'main dashboard';
        // //           }
        //            Get.back();
        //         },
        //         child: Container(
        //           height: 70,
        //           width: 150,
        //           decoration:  BoxDecoration(
        //             color: Colors.red,
        //             borderRadius: BorderRadius.circular(50),
        //           ),
        //           child: Center(child:  Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
        //             children: [
        //               const SizedBox(width: 15),
        //               const Icon(Icons.stop_circle_sharp,size: 50,color: Colors.white,),
        //               const SizedBox(width: 15,),
        //               Expanded(child: Text('Stop',style: MyTextTheme.mediumWCB,)),
        //             ],
        //           )),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}

aiCommandSheet(context, {String? isFrom}) {
  AddVitalViewModal addvitalVM =
      Provider.of<AddVitalViewModal>(context, listen: false);
  addvitalVM.pauseFunc = false;

  showModalBottomSheet(
    context: context,
    // color is applied to main screen when modal bottom screen is displayed
    barrierColor: Colors.black54,
    //background color for modal bottom screen
    backgroundColor: Colors.transparent,
    //elevates modal bottom screen
    elevation: 10,
    // gives rounded corner to modal bottom screen
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(height: 350, child: VoiceAssistant(isFrom: isFrom)),
      );
    },
  );
}

// aiCommandSheet(BuildContext? currentContext) {
//   Get.bottomSheet(
//     barrierColor:Colors.transparent,
//     backgroundColor:Colors.transparent,
//     persistent:false,
//     VoiceAssistant(),
//     isDismissible: true,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(35),
//         side: const BorderSide(
//             width: 5,
//             color: Colors.black
//         )
//     ),
//     enableDrag: true,
//   );
// }

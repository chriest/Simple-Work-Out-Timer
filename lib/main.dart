import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart'; // this
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:swot/themes.dart';
import 'package:swot/prefs.dart';
import 'package:swot/colors.dart';
import 'package:audioplayers/audioplayers.dart';


void main() {
  runApp(const MainApp());
}

// MAIN APP
class MainApp extends StatelessWidget {

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Builder(
        builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);     
        return MaterialApp(
                title: 'Simple Work Out Timer',
                //theme: swotLight,
                home: const TimerScreen(),
                themeMode: themeProvider.themeMode,
                theme: swotLight,
                darkTheme: swotDark,
              );}
      ),
    );
        
  }
}

class MainAppState extends ChangeNotifier {
  
  // APP WIDE STATE
  // DARK/Dark MODE
  // FLASHING

}

 // TIMER WIDGET
class TimerScreen extends StatefulWidget {
  
  const TimerScreen({super.key});
  // FONT SIZES
  static const double titleSize = 35;
  static const double timerSize = 116.0;
  static const double buttonTextSize = 37;
  static const double brandText = 14;
  static const double versionText = 10;
  static const double seriesText = 20;
  static const double holdRes = 10;
  static const double seriesNum = 98;
  static const double repsText = 17;
  static const double repsNum = 68;
  static const double vertCard = 34;
  
  

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  
  // Timer Core Managers
  Timer? timerCore;
  Timer? milliTimer;
  Timer? flashTime;
  // Default value TO CHANGE INTO PREFS
  int secs = 60;
  //Timer Durations
  late Duration milliDur = const Duration(milliseconds: 900);
  late Duration flashDuration = const Duration(seconds: 2);
  late Duration timerDuration = Duration(seconds: secs);
  // Utility bools
  bool cheato = false;
  bool cheato2 = false;
  bool visRedd = false;
  bool visY = false;
  bool visG = false;
  bool visGO = false;
  bool yellowVisible = false;
  bool greenishVisible = false;
  bool greenVisible = false;
  bool mute = false;

  // Standard Card
  int numSeries = 1;
  int reps = 20;

  
  // Audio Block, to remake into separate class
  final cache = AudioCache(prefix: 'alarms/alarm_5.mp3');
  final audio = AudioPlayer();
  static const countdownAlarm = "alarms/countdown_alarm_1.mp3";
  static const goAlarm = "alarms/alarm_5.mp3";

  
  
  //WIDGET NO CONTEXT FUNCS

  @override
  void initState() {
    super.initState();

  }
  
  void stopTimer() {
    setState(() => timerCore?.cancel());
    resetTimer();
    setState(() {
      cheato = false;
    });
  }

  void resetTimer() {
    setState(() => timerDuration = Duration(seconds: secs));
  }

  void seriesReset () {
    setState(() {
      numSeries=1;
    });
  }

  void seriesIncrease () {
    setState(() {
      numSeries++;
    });
  }

  void tapDown () {
    setState(() {
      
    });
  }

  void longStart() {
    setState(() {
      cheato2=true;
    });
  }

  void longEnd() {
    setState(() {
      cheato2=false;
    });
  }

  // KEY FOR DRAWER CALL
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) { 
    String padder(int n) => n.toString().padLeft(2, '0');

    //final hours = padder(timerDuration.inHours%24);
    final minutes = padder(timerDuration.inMinutes%60);
    final seconds = padder(timerDuration.inSeconds%60);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    //CONTEXT FUNCS
    void showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 218,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

    void mutePress(){
      setState(() {
        if (mute==true) { 
          mute = false;
          audio.setVolume(1);
        } else { 
          mute = true;
          audio.setVolume(0);
      }});
    }
    
    void resetMilli() {
      setState(() => milliDur = const Duration(milliseconds: 900));
  }

    void setMilliDown() {
      setState(() {
      final millis = milliDur.inMilliseconds - 450;
      if(millis==450){
        visRedd = visY = visG = false; 
      }
      if(millis==0){
        setState(() {
          milliTimer?.cancel();
          resetMilli();
          });
        
       
      } else {
        milliDur = Duration(milliseconds: millis);
      }
     });
    }

    void resetFla() {
    setState(() => flashDuration = const Duration(seconds: 2));
    }
  
    void setFlashes() {
      setState(() {
      final leftovers = flashDuration.inMilliseconds-100;
      if(visGO == true) {
        visGO = false;
      } else {
        visGO=true;
      }

      if(leftovers==0) {
        setState(() {
          flashTime?.cancel();
          resetFla();
          visGO=false;
          });
      } else {
        flashDuration = Duration(milliseconds: leftovers);
      }
      });
    
    }
    // toggles
    void toggleRed() async {
      setState(() {
      visRedd=true;
    });
    
    milliTimer = Timer.periodic(const Duration(milliseconds:450), (_) => setMilliDown());
  }

    void toggleYellow() async {
      setState(() {
      visY=true;
       });
      milliTimer = Timer.periodic(const Duration(milliseconds:450), (_) => setMilliDown());
    }

    void toggleGreenish() async {
      setState(() {
      visG=true;
      });
      milliTimer = Timer.periodic(const Duration(milliseconds:450), (_) => setMilliDown());
    }

    void toggleGo() {
      setState(() {
        visGO = true;
      });

      flashTime = Timer.periodic(const Duration(milliseconds: 100), (_) => setFlashes());

    }

    void playCd(String assetAudio)  async{
     await audio.play(AssetSource(assetAudio));
    }
    // countdown main timer
    void setCountDown() {
      setState(() {
        final seconds = timerDuration.inSeconds - 1;
        //final minutes = timerDuration.inMinutes;
        
        if(seconds==3){
          playCd(countdownAlarm);
          HapticFeedback.heavyImpact();
          toggleRed();
        }

        if(seconds==2){
          playCd(countdownAlarm);
          HapticFeedback.heavyImpact();
          toggleYellow(); 
        }

        if(seconds==1){
          playCd(countdownAlarm);
          HapticFeedback.heavyImpact();
          toggleGreenish();
        }

        if (seconds<1) {
          playCd(goAlarm);
          HapticFeedback.vibrate();
          toggleGo();
          stopTimer();
          seriesIncrease();        
        } else {
          timerDuration = Duration( seconds: seconds);
        }
        
      });
  }

    void startTimer() {
      timerCore = Timer.periodic(const Duration(seconds:1), (_) => setCountDown());
      setState(() {
        cheato = true;
      });
    }
    
    return Stack(
       fit: StackFit.expand,
      children: <Widget>[
        // ACTUAL BACKGROUND
        Visibility(
          visible: true,
          child: SizedBox(
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
            )
          )
        ),
       
        // RED
        Visibility(
          visible: visRedd,
          child: const SizedBox(
            child: Material(
              color: redThree,
            )
          )
        ),
        // YELLOW
        Visibility(
          visible: visY,
          child: const SizedBox(
            child: Material(
              color: ocraTwo,
            )
          )
        ),
        // GREENY
        Visibility(
          visible: visG,
          child: const SizedBox(
            child: Material(
              color: greenishOne,
            )
          )
        ),
        // GREEN
        Visibility(
          visible: visGO,
          child: const SizedBox(
            child: Material(
              color: greenGo,
            )
          )
        ),
        
        // TIMER SCREEN
        Scaffold(
          key: _key,

          drawer: 
          Drawer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: ListView(
                children: [
                  // DRAWER TITLE
                  Container(
                    alignment: Alignment.center,
                    child: const Text('Settings', style:
                    TextStyle(fontFamily:'San Francisco', fontWeight:FontWeight.bold, fontSize:28)),
                  ),
                  const SizedBox(
                    height:20
                  ), 
                  // DRAWER ITEMS
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('N. Reps', style:
                      TextStyle(
                        fontSize: 17.5,
                        fontFamily: 'San Francisco',
                        fontWeight: FontWeight.bold,
                      )),
                      Text('20', style:
                      TextStyle(
                        fontSize: 17.5,
                        fontFamily: 'San Francisco',
                        //fontWeight: FontWeight.bold,
                      )),
                      
                    ],
                  ),
                  const SizedBox(height:200),
                  const Center(child: Text('SALVE SIGNORA.'))
                ],
              ),
            ),
          ),

          backgroundColor: Colors.transparent,
          body: 
          SafeArea(
            child: 
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0, bottom: 10.0, left:22, right: 23),
                    child: 
                      Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: 
                              IconButton(
                                icon: const Icon(CupertinoIcons.settings), 
                                iconSize: 35, 
                                color: Theme.of(context).colorScheme.secondary,
                                onPressed:() => _key.currentState!.openDrawer(),
                              ),
                          ),
                          Expanded(
                            child: 
                              Center(
                                child: 
                                  Text(
                                    'SWOT',
                                    style: 
                                      TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontFamily: 'San Francisco',
                                        fontSize: TimerScreen.titleSize,
                                      ),
                                  ),
                              ),
                          ),
                          IconButton(
                            icon: 
                              const Icon(
                                      CupertinoIcons.brightness
                                    ), 
                            iconSize: 35, 
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () {
                              final provider = Provider.of<ThemeProvider>(context, listen: false);
                              provider.toggleTheme();
                            },
                          ),    
                        ],
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7, right: 20),        
                    child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon:(
                              mute == true ? 
                                const Icon(
                                        CupertinoIcons.speaker_slash
                                      )
                              :
                                const Icon(
                                        CupertinoIcons.speaker_2
                                      )
                            ), 
                            iconSize:35,
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () => mutePress(),
                          ),
                        ],
                      ),
                  ),    
                  const Spacer(
                    flex: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        minutes, 
                        style: 
                          TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: TimerScreen.timerSize,
                            fontFamily: 'San Fransisco Mono',
                            fontWeight: FontWeight.bold
                          )
                      ),
                      Text(
                        ':', 
                        style: 
                          TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: TimerScreen.timerSize,
                            fontFamily: 'San Francisco Reg',
                            fontWeight: FontWeight.bold
                          ),
                      ),
                      Text(
                        seconds, 
                        style: 
                          TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: TimerScreen.timerSize,
                            fontFamily: 'San Fransisco Mono',
                            fontWeight: FontWeight.bold)
                      ),
                        ]
                  ),
                  const Spacer(
                          flex: 2
                  ),
                  Material(
                    color: 
                      cheato == false ? 
                        Theme.of(context).colorScheme.tertiary
                      :
                      Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(100),
                    child: 
                      GestureDetector(
                        onLongPressStart: (details) => longStart(),
                        onLongPressEnd: (details) => longEnd(),
                        child: 
                          InkWell(
                            onLongPress: () { 
                              seriesReset();
                              HapticFeedback.mediumImpact();
                              },
                            onTap: () {
                              if (timerCore?.isActive == null || timerCore?.isActive == false){
                                startTimer();
                              } else {
                                  stopTimer();
                                }
                            /*HapticFeedback.mediumImpact();*/
                            },
                            borderRadius: BorderRadius.circular(100),
                            child: 
                              Padding(
                                padding: 
                                  const EdgeInsets.only(top: 8, bottom: 8, right: 20, left: 20),
                                child: 
                                  cheato2 == false ? 
                                    (cheato==false ? 
                                      Text(
                                        'START', 
                                        style: 
                                          TextStyle(
                                            fontSize: TimerScreen.buttonTextSize, 
                                            fontFamily:'San Francisco Reg',
                                            color: Theme.of(context).colorScheme.primary) 
                                      )
                                    : 
                                    const Text(
                                            'STOP', 
                                            style: 
                                              TextStyle(
                                                fontSize: TimerScreen.buttonTextSize, 
                                                fontFamily:'San Francisco Reg',
                                                color: Color(0xFFFFFFFF)
                                              )
                                          )
                                    )
                                  : 
                                  const Text(
                                          'RESET', 
                                          style: 
                                            TextStyle(
                                              fontSize: TimerScreen.buttonTextSize, 
                                              fontFamily:'San Francisco Reg',
                                              color: Color(0xFFFFFFFF)) 
                                        ),
                              ),
                          ),
                      ),
                  ),
                  Container(
                    margin: 
                      const EdgeInsets.all(20),
                    child: 
                      Column(
                        children: [
                          Container(
                            padding: 
                              const EdgeInsets.only(left: 8.0, right: 8.0, top:13.0, bottom:0),
                            child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Durata Timer:',
                                    style: 
                                      TextStyle(
                                        color: Theme.of(context).colorScheme.scrim,
                                        fontFamily: 'San Francisco',
                                        fontSize: 17.5
                                      ),
                                  ),
                                  CupertinoButton(
                                    padding: 
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    onPressed:() => showDialog(
                                                      CupertinoTimerPicker(
                                                        mode: CupertinoTimerPickerMode.ms,
                                                        initialTimerDuration: timerDuration,
                                                        onTimerDurationChanged: (Duration newDuration) {
                                                          setState(() {
                                                            timerDuration = newDuration;
                                                            secs = newDuration.inSeconds;
                                                            }
                                                          );
                                                        },
                                                      ),
                                                    ),
                                    child: 
                                      Text( 
                                        '${secs~/60}:${secs%60<10 ?'0${secs%60}':secs%60}', 
                                        style: 
                                          TextStyle(
                                            color: Theme.of(context).colorScheme.scrim,
                                            fontFamily: 'San Francisco Mono',
                                            fontSize: 17.5
                                          ),
                                      ),
                                  ),
                                ],
                              ),
                          ),
                        ],
                      ),
                  ),
                  Flexible(
                    flex: 22,
                    child: 
                      Container(
                        margin: 
                          const EdgeInsets.only(left: 28, right: 28),
                        child: 
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 65,
                                child: 
                                  Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SERIE',
                                        style: 
                                          TextStyle(
                                            fontFamily: 'San Francisco',
                                            fontSize: TimerScreen.seriesText,
                                            color: Theme.of(context).colorScheme.primaryContainer
                                          ),
                                      ),
                                      /*InkWell(
                                        onLongPress: () => seriesReset(),
                                        borderRadius: BorderRadius.circular(40),
                                        child: */ 
                                      SizedBox(
                                        height: 130,
                                        width: 300,
                                        child: 
                                          Container(
                                            alignment: 
                                              Alignment.center,
                                            padding: 
                                              const EdgeInsets.only(top: 17.0),
                                            child: 
                                              Text(
                                                '$numSeries',
                                                style: 
                                                  TextStyle(
                                                    fontFamily: 'San Francisco Num',
                                                    fontSize: TimerScreen.seriesNum,
                                                    color: Theme.of(context).colorScheme.primaryContainer,
                                                  ),
                                              ),
                                          ),
                                      /*),*/
                                      ),
                                    ],
                                  ),
                              ),
                              VerticalDivider(
                                indent: TimerScreen.vertCard,
                                endIndent: TimerScreen.vertCard,
                                color: Theme.of(context).colorScheme.scrim
                              ),
                              Expanded(
                                flex:35,
                                child: 
                                  Column(
                                    children: [
                                      Text(
                                        'REPS',
                                        style: 
                                          TextStyle(
                                            fontFamily: 'San Francisco',
                                            fontSize: TimerScreen.repsText,
                                            color: Theme.of(context).colorScheme.scrim
                                          ),
                                      ),
                                      Text(
                                        '$reps',
                                        style: 
                                          TextStyle(
                                            fontFamily: 'San Francisco Light',
                                            fontSize: TimerScreen.repsNum,
                                            color: Theme.of(context).colorScheme.scrim,
                                          ),
                                      ),
                                    ],
                                  ),
                              ),
                            ],
                          ),
                      ),
                  ),
                  const Padding(
                          padding: 
                            EdgeInsets.only(left:8.0, right:8),
                          child: 
                            Placeholder(
                              fallbackHeight: 55
                            ),
                  ),
                  Container(
                    padding: 
                      const EdgeInsets.only(left: 0, right: 0),
                    margin: 
                      const EdgeInsets.only(top:10),
                    child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                                  width: 50,
                          ),
                          Text(
                            'Hericon Ideas © 2023',
                            style: 
                              TextStyle(
                                fontSize: TimerScreen.brandText, 
                                fontFamily: 'San Francisco',
                              color: Theme.of(context).colorScheme.secondary
                              ),
                          ),
                          Text(
                            '0.0.1 alpha', 
                            style: 
                              TextStyle(
                                fontSize: TimerScreen.versionText, 
                                fontFamily: 'San Francisco',
                                color: Theme.of(context).colorScheme.secondary
                              ),
                          ),
                        ],
                      ),
                  ),
                ],
              ),
          ),
        ),
      ],
    );
  }
}

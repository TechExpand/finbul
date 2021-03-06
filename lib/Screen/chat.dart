// import 'package:fixme/Services/Firebase_service.dart';
// import 'package:fixme/Services/network_service.dart';
// import 'package:fixme/Utils/Provider.dart';
// import 'package:fixme/Utils/utils.dart';
// import 'package:fixme/Widgets/messages_widget.dart';
// import 'package:fixme/Widgets/popup_menu.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:file/local.dart';
import 'package:finbul/Service/firebase.dart';
import 'package:finbul/Utils/Provider.dart';
import 'package:finbul/Utils/utils.dart';
import 'package:finbul/Widgets/messages_widget.dart';
import 'package:finbul/Widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';


// import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final user;
  final popData;
  final LocalFileSystem localFileSystem;

  ChatPage({
    this.popData,
    localFileSystem,
    @required this.user,
  }) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //FocusNode textFieldFocus = FocusNode();
  FlutterAudioRecorder _recorder;
  Recording _current;
  final  scaffoldkey = new GlobalKey<ScaffoldState>();
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  final _controller = TextEditingController();

  // final _controller2 = TextEditingController();
  String message = '';

  init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);

        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
        });
      } else {
        scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('You must accept permissions')));
      
      }
    } catch (e) {}
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Start Again';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Utils>(context, listen: false);
    var datas = Provider.of<DataProvider>(context, listen: false);
    var datass = Provider.of<DataProvider>(context, listen: false);
    var network = Provider.of<DataProvider>(context, listen: false);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final picker = ImagePicker();
    void pickImage({@required ImageSource source, context}) async {
      final selectedImage = await picker.getImage(source: source);
      FocusScope.of(context).unfocus();
      // _controller2.clear();
      _controller.clear();
      datas.setWritingTo(false);
      await FirebaseApi.uploadImage(
          widget.user.userid.toString(),
          network.firebaseUserId,
          selectedImage,
          context,
          '${network.firebaseUserId}-${widget.user.userid.toString()}')
          .then((value) {
        Navigator.pop(context);
      });
    }

    pickDoc() async {
      // final selectedImage =
      // await FilePicker.getFile(type: FileType.custom, allowedExtensions: [
      //   '.pdf',
      //   '.doc',
      //   '.docx',
      //   '.csv',
      //   '.xls',
      //   '.xlsx',
      //   '.ods',
      //   '.txt',
      //   '.html',
      //   '.png',
      //   '.jpeg',
      //   '.jpg',
      //   '.gif'
      // ]);

      FocusScope.of(context).unfocus();
      // _controller2.clear();
      _controller.clear();
      datas.setWritingTo(false);
      // await FirebaseApi.uploadImage(
      //     widget.user.idUser,
      //     network.mobileDeviceToken,
      //     selectedImage,
      //     context,
      //     '${network.firstName}-${widget.user.name}');
    }

    void record({record, context}) async {
      FocusScope.of(context).unfocus();
      // _controller2.clear();
      _controller.clear();
      datas.setWritingTo(false);
      await FirebaseApi.uploadRecord(
          widget.user.userid,
          network.firebaseUserId,
          record,
          context,
          '${network.firebaseUserId}-${widget.user.userid.toString()}');
    }

    sendMessage() async {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      _controller.clear();
      datas.setWritingTo(false);
      await FirebaseApi.uploadmessage(
          widget.user.userid.toString(),
          network.firebaseUserId,
          message,
          context,
          '${network.firebaseUserId}-${widget.user.userid.toString()}');
    }

    void _modalBottomSheetRecord(datas) {
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  _start() async {
                    try {
                      await _recorder.start();
                      var recording = await _recorder.current(channel: 0);
                      setState(() {
                        _current = recording;
                      });

                      const tick = const Duration(milliseconds: 50);
                      new Timer.periodic(tick, (Timer t) async {
                        if (_currentStatus == RecordingStatus.Stopped) {
                          t.cancel();
                        }

                        var current = await _recorder.current(channel: 0);
                        // print(current.status);
                        setState(() {
                          _current = current;
                          _currentStatus = _current.status;
                        });
                      });
                    } catch (e) {}
                  }

                  _resume() async {
                    await _recorder.resume();
                    setState(() {});
                  }

                  _pause() async {
                    await _recorder.pause();
                    setState(() {});
                  }

                  _stop() async {
                    var result = await _recorder.stop();
                    // File file = widget.localFileSystem.file(result.path);

                    setState(() {
                      _current = result;
                      _currentStatus = _current.status;
                    });
                  }

                  initilize() async {
                    try {
                      if (await FlutterAudioRecorder.hasPermissions) {
                        String customPath = '/flutter_audio_recorder_';
                        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
                        if (io.Platform.isIOS) {
                          appDocDirectory =
                          await getApplicationDocumentsDirectory();
                        } else {
                          appDocDirectory = await getExternalStorageDirectory();
                        }

                        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
                        customPath = appDocDirectory.path +
                            customPath +
                            DateTime.now().millisecondsSinceEpoch.toString();

                        // .wav <---> AudioFormat.WAV
                        // .mp4 .m4a .aac <---> AudioFormat.AAC
                        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
                        _recorder = FlutterAudioRecorder(customPath,
                            audioFormat: AudioFormat.WAV);

                        await _recorder.initialized;
                        // after initialization
                        var current = await _recorder.current(channel: 0);

                        // should be "Initialized", if all working fine
                        setState(() {
                          _current = current;
                          _currentStatus = current.status;
                        });
                      } else {
                        scaffoldkey.currentState.showSnackBar(SnackBar(content:Text('You must accept permissions')));
                       
                      }
                    } catch (e) {}
                  }

                  return new Container(
                    height: 100.0,
                    color:  Color(0xFF372C6A),
                    //could change this to Color(0xFF737373),
                    //so you don't have to change MaterialApp canvasColor
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4, left: 8, right: 8),
                      child: Column(children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new FlatButton(
                                onPressed: () {
                                  switch (_currentStatus) {
                                    case RecordingStatus.Initialized:
                                      {
                                        _start();
                                        break;
                                      }
                                    case RecordingStatus.Recording:
                                      {
                                        _pause();
                                        break;
                                      }
                                    case RecordingStatus.Paused:
                                      {
                                        _resume();
                                        break;
                                      }
                                    case RecordingStatus.Stopped:
                                      {
                                        initilize();
                                        break;
                                      }
                                    default:
                                      break;
                                  }
                                },
                                child: _buildText(_currentStatus),
                                color: Color( 0xFFFEB904),
                              ),
                            ),
                            new FlatButton(
                              onPressed: _currentStatus != RecordingStatus.Unset
                                  ? _stop
                                  : null,
                              child: new Text("Stop",
                                  style: TextStyle(color: Colors.white)),
                              color: Color( 0xFFFEB904).withOpacity(0.5),
                            ),
                            _currentStatus == RecordingStatus.Stopped
                                ? new InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                record(
                                  context: context,
                                  record: _current,
                                );
                              },
                              child: Icon(Icons.send,
                                  size: 40, color: Colors.white),
                            )
                                : Icon(Icons.send, size: 40, color: Colors.white70),
                          ],
                        ),
                        /*  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text("Status : $_currentStatus"),
                ),*/
                        Text(
                            "Recording Duration : ${_current?.duration.toString()}", style: TextStyle(color: Colors.white),),
                      ]),
                    ),
                  );
                });
          });
    }

    void _modalBottomSheetMenu(datas) {
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return StatefulBuilder(builder: (context, setState) {
              return new Container(
                height: 155.0,
                color: Colors.transparent,
                //could change this to Color(0xFF737373),
                //so you don't have to change MaterialApp canvasColor
                child: Column(
                  children: [
                    Container(
                      height: 65,
                      color: Color(0xFF372C6A), //164, 12, 133, 0.75

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color:  Color( 0xFFFEB904),
                                    shape: BoxShape.circle),
                                child: Icon(Icons.clear,color: Colors.white)),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                                height: 53,
                                width: MediaQuery.of(context).size.width / 1.45,
                                child: TextField(
                                  controller: _controller,
                                  onChanged: (val) {
                                    (val.length > 0 && val.trim() != "")
                                        ? datas.setWritingTo(true)
                                        : datas.setWritingTo(false);

                                    message = val;
                                    setState(() {
                                      print(message);
                                    });
                                  },
                                  textCapitalization:
                                  TextCapitalization.sentences,
                                  autocorrect: true,
                                  // focusNode: textFieldFocus,
                                  enableSuggestions: true,
                                  maxLines: null,

                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.black54),
                                    hintText: 'Send Message...',
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              )),
                          // Selector<DataProvider, bool>(
                          //   selector: (_, model) => model.isWriting,
                          //   builder: (_, mo, __) {
                          //     return
                          datass.isWriting
                              ? IconButton(
                            onPressed: () {
                              sendMessage().then((value) {
                                Navigator.pop(context);
                              });
                            },
                            icon: Icon(Icons.send, color:  Color( 0xFFFEB904),),
                          )
                              : IconButton(
                            onPressed: () {
                              _modalBottomSheetRecord(datas);
                            },
                            icon: Icon(
                              Icons.mic,
                              color:  Color( 0xFFFEB904),
                              size: 30,
                            ),
                          )
                          //;
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xFF372C6A),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              pickImage(
                                  source: ImageSource.gallery,
                                  context: context);
                            },
                            child: Tab(
                                icon: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Color( 0xFFFEB904),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.attachment,
                                      color: Colors.white,
                                    )),
                                child: Text('Attachment', style:TextStyle(color:Colors.white))),
                          ),
                          InkWell(
                            onTap: () {
                              pickImage(
                                  source: ImageSource.camera, context: context);
                            },
                            child: Tab(
                                icon: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color:Color( 0xFFFEB904),
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.camera_alt,
                                        color: Colors.white)),
                                child: Text('Camera', style:TextStyle(color:Colors.white))),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
          });
    }

    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor:Color(0xFF372C6A),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color:  Color( 0xFFFEB904),
          ),
        ),
        centerTitle: false,
        title: Text(
          '${widget.user.name.toString()}',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.phone,
              size: 25,
              color:  Color( 0xFFFEB904),
            ),
            onPressed: () {
              data.makePhoneCall(widget.user.userMobile);
    }
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PopUpMenu(
                idUser: widget.user.userid.toString(),
                user: widget.user,
                scaffoldKey: scaffoldKey,
                popData: 'widget.popData'),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      backgroundColor:Color(0xFF372C6A),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:Color(0xFF372C6A),
              ),
              child: MessagesWidget(
                  idUser:widget.user.userid.toString(),
                  user: widget.user), //network.mobile_device_token
            ),
          ),
          StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 65,
                  color: Color(0xFF372C6A),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _modalBottomSheetMenu(datas);
                        },
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color( 0xFFFEB904), shape: BoxShape.circle),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 35,
                            )),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.white,
                          height: 53,
                          width: MediaQuery.of(context).size.width / 1.45,
                          child: TextField(
                            onTap: () => FirebaseApi.updateUsertoRead(
                                idUser: widget.user.userid.toString(),
                                idArtisan:  network.firebaseUserId),
                            controller: _controller,
                            onChanged: (val) {
                              (val.length > 0 && val.trim() != "")
                                  ? datas.setWritingTo(true)
                                  : datas.setWritingTo(false);
                              message = val;
                              setState((){
                                print(message);
                              });
                            },
                            textCapitalization: TextCapitalization.sentences,
                            autocorrect: true,
                            // focusNode: textFieldFocus,
                            enableSuggestions: true,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Send Message...',
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // Selector<DataProvider, bool>(
                      //   selector: (_, model) => model.isWriting,
                      //   builder: (_, mo, __) {
                      //     return mo
                      //         ?
                      datass.isWriting
                          ? IconButton(
                        onPressed: sendMessage,
                        icon: Icon(Icons.send, color:  Color( 0xFFFEB904),),
                      )
                          : IconButton(
                        onPressed: () {
                          _modalBottomSheetRecord(datas);
                        },
                        icon: Icon(
                          Icons.mic,
                          color:  Color( 0xFFFEB904),
                          size: 30,
                        ),
                      )
                      //;
                      //   },
                      // ),
                    ],
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}

//message.trim().isEmpty
//? null
//:

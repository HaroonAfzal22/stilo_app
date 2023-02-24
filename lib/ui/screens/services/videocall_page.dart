import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/controllers/rtm_token_handler.dart';
import 'package:agora_uikit/controllers/session_controller.dart';

import 'package:contacta_pharmacy/utils/Agora_video_const.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';



// const appId = "8e522f6bbcd2418abfd8ac0eb2d8f396";

enum VideoOn { videoEnable, videoDisable }

enum MicOn { micEnable, micDisable }

class VideoView extends StatefulWidget {
  const VideoView({Key? key}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  var videoEnum = VideoOn.videoEnable;
  var micEnum = MicOn.micEnable;
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  String generatedToken = '';

  @override
  void initState() {
    super.initState();
    
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
    

    //create the engine
    _engine = createAgoraRtcEngine();
    
   

    await _engine.initialize(const RtcEngineContext(
      appId: AgoraViodeoConst.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    // _engine.renewToken(AgoraViodeoConst.chanelToken);
    

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: AgoraViodeoConst.chanelToken,
      channelId: AgoraViodeoConst.chanelName,
      // info: '',
      uid: 5, options: const ChannelMediaOptions(),
    );
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'consultation ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VideoButtonWidgets(
                  color: Colors.green,
                  icon: micEnum == MicOn.micEnable ? Icons.mic_off : Icons.mic,
                  onPreesed: () async {
                    setState(() {});
                    if (micEnum == MicOn.micEnable) {
                      micEnum = MicOn.micDisable;
                      await _engine.pauseAudio();
                    } else {
                      micEnum = MicOn.micEnable;
                      await _engine.resumeAudio();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                VideoButtonWidgets(
                  color: Colors.green,
                  icon: videoEnum == VideoOn.videoDisable
                      ? Icons.video_call_outlined
                      : Icons.videocam_off_outlined,
                  onPreesed: () async {
                    setState(() {});
                    if (videoEnum == VideoOn.videoEnable) {
                      videoEnum = VideoOn.videoDisable;
                      await _engine.disableVideo();
                    } else {
                      videoEnum = VideoOn.videoEnable;
                      await _engine.enableVideo();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                VideoButtonWidgets(
                  color: Colors.green,
                  icon: Icons.switch_camera,
                  onPreesed: () async {
                    await _engine.switchCamera();
                  },
                ),
                const SizedBoxWidget(),
                VideoButtonWidgets(
                  color: Colors.red,
                  icon: Icons.call_end,
                  onPreesed: () async {
                    await _engine.leaveChannel();
                    await _engine.release();

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    var size = MediaQuery.of(context).size;
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection:
              const RtcConnection(channelId: AgoraViodeoConst.chanelName),
        ),
      );
    } else {
      return Container(
          width: size.width * 0.5,
          height: size.height * 0.5,
          child: Image.asset('assets/images/videoBackground.png'));
    }
  }
}

class SizedBoxWidget extends StatelessWidget {
  const SizedBoxWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: SizedBox(
        width: 10,
      ),
    );
  }
}

class VideoButtonWidgets extends StatelessWidget {
  VideoButtonWidgets(
      {Key? key,
      required this.color,
      required this.icon,
      required this.onPreesed})
      : super(key: key);
  Color color;
  var onPreesed;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(25)),
      height: 50,
      width: 50,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: onPreesed,
      ),
    );
  }
}





// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';

// class VideoCallPage extends StatefulWidget {
//   const VideoCallPage({Key? key}) : super(key: key);

//   static const routeName = '/video-call-page';

//   @override
//   State<VideoCallPage> createState() => _VideoCallPageState();
// }

// class _VideoCallPageState extends State<VideoCallPage> {
//   // Instantiate the client
//   final AgoraClient client = AgoraClient(
//     agoraConnectionData: AgoraConnectionData(
//         appId: "36b05f7575a9449daa4d779180ac0950",
//         channelName: "test",
//         tempToken:
//             "007eJxTYNiVdHFdpt6SugWs8lej+cLUXBarqKnJKskKSXc1aP6vM1ZgMDZLMjBNMzc1N020NDGxTElMNEkxN7c0tDBITDawNDU4/XdmckMgI8Pu58uZGRkgEMRnYShJLS5hYAAAJ9Eciw=="),
//   );

// // Initialize the Agora Engine
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }

//   void initAgora() async {
//     await client.initialize();
//   }

// // Build your layout
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [
//               AgoraVideoViewer(client: client),
//               AgoraVideoButtons(client: client),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

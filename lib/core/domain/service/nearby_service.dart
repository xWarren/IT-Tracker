import 'dart:async';
import 'dart:developer';
import 'package:nearby_service/nearby_service.dart' as nearby;

import '../../utils/file_saver.dart';

class NearbyService {

  final nearby.NearbyService _nearby = nearby.NearbyService.getInstance();

  nearby.NearbyDevice? get connectedDevice => _connectedDevice;

  nearby.NearbyDevice? _connectedDevice;
  
  Timer? _connectionCheckTimer;

  List<nearby.NearbyDevice> _peers = [];

  nearby.CommunicationChannelState _communicationChannelState = nearby.CommunicationChannelState.notConnected;

  StreamSubscription? _connectedDeviceSubs;
  StreamSubscription? _peersSubs;
  StreamSubscription? _channelStateSubs;
  
  
  Future<void> init() async {
    await _nearby.initialize();
  }

  Future<bool> isGrantPermission() async {
    final isGranted = await _nearby.android?.requestPermissions();
    final wifiEnabled = await _nearby.android?.checkWifiService();
    return (isGranted ?? false) && (wifiEnabled ?? false);
  }

  Future<nearby.NearbyDeviceInfo?> get localDevice async {
    try {
      final info = await _nearby.android?.getCurrentDeviceInfo();
      if (info != null) {
        log("Local device ID: ${info.id}, Name: ${info.displayName}");
      }
      return info;
    } catch (e) {
      log("Failed to get local device info: $e");
      return null;
    }
  }



  Future<void> startDiscover(Function(List<nearby.NearbyDevice>) peersCallBack) async {
    final result = await _nearby.discover();
    if (result) {
      
      _peersSubs?.cancel();

      _peersSubs = _nearby.getPeersStream().listen((response) {
        _peers = response;
        peersCallBack(response);
      });
    }
  }

  Future<void> connect({
    required nearby.NearbyDevice device,
    required Function(nearby.NearbyMessageTextResponse) onTextResponseCallBack,
    required Function(nearby.NearbyMessageTextRequest) onTextRequestCallBack,
    required Function(nearby.NearbyMessageFilesRequest) onFilesRequestCallBack,
    required Function(nearby.NearbyMessageFilesResponse) onFilesResponseCallBack,
    required Function(String value) savePackCallBack
  }) async {
    final result = await _nearby.connectById(device.info.id);
    log("conect isConnected: ${device.status.isConnected} result: $result _connectedDevice: $_connectedDevice");
    final channelStarting = _tryCommunicate(
      device: device, 
      onTextResponseCallBack: onTextResponseCallBack, 
      onTextRequestCallBack: onTextRequestCallBack, 
      onFilesRequestCallBack: onFilesRequestCallBack, 
      onFilesResponseCallBack: onFilesResponseCallBack, 
      savePackCallBack: savePackCallBack
    );

    if (!channelStarting) {
      _connectionCheckTimer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => _tryCommunicate(
          device: device,
          onTextResponseCallBack: onTextResponseCallBack,
          onTextRequestCallBack: onTextRequestCallBack,
          onFilesRequestCallBack: onFilesRequestCallBack,
          onFilesResponseCallBack: onFilesResponseCallBack,
          savePackCallBack: savePackCallBack,
        ),
      );
    }
  }

  bool _tryCommunicate({
    required nearby.NearbyDevice device,
    required Function(nearby.NearbyMessageTextResponse) onTextResponseCallBack,
    required Function(nearby.NearbyMessageTextRequest) onTextRequestCallBack,
    required Function(nearby.NearbyMessageFilesRequest) onFilesRequestCallBack,
    required Function(nearby.NearbyMessageFilesResponse) onFilesResponseCallBack,
    required Function(String value) savePackCallBack
  }) {
    nearby.NearbyDevice? selectedDevice;

    try {
      selectedDevice = _peers.firstWhere((element) => element.info.id == device.info.id);
    } catch (_) {
      return false;
    }
    if (_communicationChannelState == nearby.CommunicationChannelState.notConnected) {

      _channelStateSubs?.cancel();

      _channelStateSubs = _nearby.getCommunicationChannelStateStream().listen((event) {
        _communicationChannelState = event;

        log("Channel state: $event");

        if (event == nearby.CommunicationChannelState.connected) {
          _connectionCheckTimer?.cancel();
          _connectionCheckTimer = null;
          _connectedDevice = selectedDevice;
          
          log("Communication channel connected");
          log(" isConnected = $isConnected");
        }
      });

      _nearby.startCommunicationChannel(
       nearby.NearbyCommunicationChannelData(
          device.info.id,
          filesListener: nearby.NearbyServiceFilesListener(
            onData: (pack) => _filesListener(pack: pack, savePackCallBack: savePackCallBack),
          ),
          messagesListener: nearby.NearbyServiceMessagesListener(
            onData: (message) => _messagesListener(
              message: message,
              onTextResponseCallBack: onTextResponseCallBack,
              onTextRequestCallBack: onTextRequestCallBack,
              onFilesRequestCallBack: onFilesRequestCallBack,
              onFilesResponseCallBack: onFilesResponseCallBack,
            ),
            onCreated: () {},
            onError: (e, [StackTrace? s]) {
              _connectedDevice = null;
            },
            onDone: () {
              _connectedDevice = null;
            },
          ),
        ),
      );

      return true;
    }

    return false;
  }

  void _messagesListener({
    required nearby.ReceivedNearbyMessage<nearby.NearbyMessageContent> message, 
    required Function(nearby.NearbyMessageTextResponse) onTextResponseCallBack,
    required Function(nearby.NearbyMessageTextRequest) onTextRequestCallBack,
    required Function(nearby.NearbyMessageFilesRequest) onFilesRequestCallBack,
    required Function(nearby.NearbyMessageFilesResponse) onFilesResponseCallBack
  }) {
    if (_connectedDevice == null) return;
    message.content.byType(
      onTextRequest: onTextRequestCallBack,
      onTextResponse: onTextResponseCallBack,
      onFilesResponse: onFilesResponseCallBack,
      onFilesRequest: (request) async {
        await send(
          nearby.NearbyMessageFilesResponse(
            id: request.id,
            isAccepted: true,
          ),
        );

        onFilesRequestCallBack(request);
      },
    );
  }
  
  
  Future<void> _filesListener({required nearby.ReceivedNearbyFilesPack pack, required Function(String value) savePackCallBack}) async {
    await FilesSaver.savePack(pack);
    return savePackCallBack("Files pack was saved");
  }

  Future<void> send(nearby.NearbyMessageContent content) async {
    if (_connectedDevice == null) return;
    await _nearby.send(
      nearby.OutgoingNearbyMessage(
        content: content,
        receiver: _connectedDevice!.info,
      ),
    );
  }


  Future<void> disconnect(Function(List<nearby.NearbyDevice>) peersCallBack) async {
    try {
      final id = _connectedDevice?.info.id;
      if (id != null) {
        await _nearby.disconnectById(id);
      }
    } finally {
      await _nearby.endCommunicationChannel();
      // await _nearby.stopDiscovery();
      _connectedDevice = null;
      await _peersSubs?.cancel();
      _peers = [];
      peersCallBack([]);
    }
  }

  Future<int?> estimateProximity(nearby.NearbyDevice device) async {
    // log("isDeviceInRange: ${!isDeviceInRange(device)}");
    // if (!isDeviceInRange(device)) return null;

    final start = DateTime.now().millisecondsSinceEpoch;

    try {
      await send(nearby.NearbyMessageTextRequest.create(value: "ping"));

      final end = DateTime.now().millisecondsSinceEpoch;
      return end - start;
    } catch (_) {
      return null;
    }
  }

  Stream<int> latencyStream(Duration interval) async* {
    while (isConnected && connectedDevice != null) {
      yield await estimateProximity(connectedDevice!) ?? 0;
      await Future.delayed(interval);
    }
  }


  bool get isConnected {
    return _connectedDevice != null && _communicationChannelState == nearby.CommunicationChannelState.connected;
  }

  Stream<bool> get isConnectedStream =>_nearby.getCommunicationChannelStateStream().map((state) => state == nearby.CommunicationChannelState.connected);


  bool isDeviceInRange(nearby.NearbyDevice device) {
    final foundDevice = _peers.where((d) => d.info.id == device.info.id).firstOrNull;
    return foundDevice?.status.isConnected ?? false;
  }


  void dispose () {
    _connectedDeviceSubs?.cancel();
    _peersSubs?.cancel();
    _channelStateSubs?.cancel();
  }
}

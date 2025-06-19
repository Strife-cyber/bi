import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship/services/camera_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaUploadPage extends ConsumerStatefulWidget {
  const MediaUploadPage({super.key});

  @override
  ConsumerState<MediaUploadPage> createState() => _MediaUploadPageState();
}

class _MediaUploadPageState extends ConsumerState<MediaUploadPage>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final List<MediaFile> _mediaFiles = [];
  int numCameras = 0;

  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  bool _isProcessing = false;
  int _selectedCameraIndex = 0;
  
  Timer? _recordingTimer;
  int _recordingDuration = 0;
  
  late AnimationController _recordingAnimationController;
  late Animation<double> _recordingAnimation;
  
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _recordingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _recordingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(() {
      setState(() {
        _scrollPosition = _scrollController.position.pixels;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cameras = ref.watch(camerasProvider).value;
    if (cameras != null && !_isCameraInitialized) {
      _initializeCamera(cameras);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _recordingTimer?.cancel();
    _recordingAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera(List<CameraDescription> cameras) async {
    if (cameras.isEmpty) {
      debugPrint("No cameras found");
      return;
    }
    
    try {
      debugPrint("We found some cameras");
      _requestPermissions();

      _cameraController = CameraController(
        cameras[_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: true,
      );
      
      await _cameraController!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
          numCameras = cameras.length;
        });
      }
    } catch (e) {
      _showErrorDialog('Camera initialization failed: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final List<Permission> permissionsToRequest = [
      Permission.camera,
      Permission.microphone,
    ];

    /*if (Platform.isAndroid) {
      permissionsToRequest.add(Permission.storage);
    } */
    if (Platform.isIOS) {
      permissionsToRequest.add(Permission.photos);
    }

    final Map<Permission, PermissionStatus> permissions =
      await permissionsToRequest.request();

    final deniedPermissions = permissions.entries
        .where((entry) => entry.value.isDenied)
        .map((entry) => entry.key.toString())
        .toList();

    if (deniedPermissions.isNotEmpty) {
      _showErrorDialog(
        'The following permissions are required: ${deniedPermissions.join(', ')}',
      );
    }
  }

  Future<void> _pickFromGallery(MediaType type) async {
    try {
      setState(() => _isProcessing = true);
      
      List<XFile> files = [];
      
      if (type == MediaType.image) {
        final List<XFile> images = await _picker.pickMultipleMedia();
        files = images.where((file) => 
          file.path.toLowerCase().endsWith('.jpg') ||
          file.path.toLowerCase().endsWith('.jpeg') ||
          file.path.toLowerCase().endsWith('.png') ||
          file.path.toLowerCase().endsWith('.gif')
        ).toList();
      } else {
        final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
        if (video != null) files = [video];
      }

      for (final file in files) {
        final mediaFile = MediaFile(
          file: File(file.path),
          type: _getMediaTypeFromPath(file.path),
          source: MediaSource.gallery,
        );
        
        setState(() {
          _mediaFiles.add(mediaFile);
        });
      }
      
      if (files.isNotEmpty) {
        _showSuccessMessage('${files.length} file(s) added from gallery');
      }
    } catch (e) {
      _showErrorDialog('Failed to pick from gallery: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _capturePhoto() async {
    if (!_isCameraInitialized || _cameraController == null) return;
    
    try {
      setState(() => _isProcessing = true);
      
      final XFile photo = await _cameraController!.takePicture();
      final mediaFile = MediaFile(
        file: File(photo.path),
        type: MediaType.image,
        source: MediaSource.camera,
      );
      
      setState(() {
        _mediaFiles.add(mediaFile);
      });
      
      _showSuccessMessage('Photo captured successfully');
    } catch (e) {
      _showErrorDialog('Failed to capture photo: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _startVideoRecording() async {
    if (!_isCameraInitialized || _cameraController == null || _isRecording) return;
    
    try {
      await _cameraController!.startVideoRecording();
      
      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
      });
      
      _recordingAnimationController.repeat(reverse: true);
      
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration++;
        });
      });
      
      _showSuccessMessage('Video recording started');
    } catch (e) {
      _showErrorDialog('Failed to start recording: $e');
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_isRecording || _cameraController == null) return;
    
    try {
      setState(() => _isProcessing = true);
      
      final XFile video = await _cameraController!.stopVideoRecording();
      
      _recordingTimer?.cancel();
      _recordingAnimationController.stop();
      
      final mediaFile = MediaFile(
        file: File(video.path),
        type: MediaType.video,
        source: MediaSource.camera,
        duration: _recordingDuration,
      );
      
      setState(() {
        _mediaFiles.add(mediaFile);
        _isRecording = false;
        _recordingDuration = 0;
      });
      
      _showSuccessMessage('Video recorded successfully');
    } catch (e) {
      _showErrorDialog('Failed to stop recording: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _switchCamera() async {
    final cameras = ref.read(camerasProvider).value ?? [];
    if (cameras.length < 2) return;
    
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
      _isCameraInitialized = false;
    });
    
    await _cameraController?.dispose();
    await _initializeCamera(cameras);
  }

  void _removeMediaFile(int index) {
    setState(() {
      _mediaFiles.removeAt(index);
    });
    _showSuccessMessage('File removed');
  }

  void _cancelCurrentCapture() {
    if (_isRecording) {
      _stopVideoRecording();
    }
    _showSuccessMessage('Capture cancelled');
  }

  Future<void> _launchAnalysis() async {
    if (_mediaFiles.isEmpty) {
      _showErrorDialog('No media files to analyze');
      return;
    }
    
    setState(() => _isProcessing = true);
    
    // Simulate analysis process
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isProcessing = false);
    
    _showAnalysisResults();
  }

  void _showAnalysisResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Analysis Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total files analyzed: ${_mediaFiles.length}'),
            const SizedBox(height: 8),
            Text('Images: ${_mediaFiles.where((f) => f.type == MediaType.image).length}'),
            Text('Videos: ${_mediaFiles.where((f) => f.type == MediaType.video).length}'),
            const SizedBox(height: 16),
            const Text('Analysis completed successfully!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  MediaType _getMediaTypeFromPath(String path) {
    final extension = path.toLowerCase().split('.').last;
    if (['jpg', 'jpeg', 'png', 'gif'].contains(extension)) {
      return MediaType.image;
    } else if (['mp4', 'mov', 'avi', 'mkv'].contains(extension)) {
      return MediaType.video;
    }
    return MediaType.image;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  static const Color primaryGreen = Color(0xFF00C853);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color accentGreen = Color(0xFF00E676);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBackground,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: primaryGreen,
          secondary: accentGreen,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 4,
          iconTheme: const IconThemeData(color: primaryGreen),
          titleTextStyle: TextStyle(
            color: Colors.grey[200],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: cardDark,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            backgroundColor: Colors.black54,
            foregroundColor: primaryGreen,
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Media Capture'),
          actions: [
            if (_mediaFiles.isNotEmpty)
              IconButton(
                onPressed: _launchAnalysis,
                icon: const Icon(Icons.analytics),
                tooltip: 'Launch Analysis',
              ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // Handle scroll to show/hide camera preview
            if (notification is ScrollUpdateNotification) {
              setState(() {
                _scrollPosition = _scrollController.position.pixels;
              });
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Full-screen camera preview
              SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: MediaQuery.of(context).size.height - 
                          (_scrollPosition > 0 ? 0 : kToolbarHeight),
                  child: _buildCameraPreview(),
                ),
              ),
              
              // Controls and media list
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  _buildCameraControls(),
                  const SizedBox(height: 24),
                  _buildGallerySection(),
                  const SizedBox(height: 24),
                  _buildMediaFilesList(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 40),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(primaryGreen)),
              const SizedBox(height: 20),
              Text(
                'Initializing Camera...',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        
        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
        ),
        
        // Recording indicator
        if (_isRecording)
          Positioned(
            top: 40,
            left: 16,
            child: AnimatedBuilder(
              animation: _recordingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _recordingAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.fiber_manual_record, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'REC ${_formatDuration(_recordingDuration)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        
        // Camera switch button
        if (numCameras > 1)
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              onPressed: _switchCamera,
              icon: const Icon(Icons.flip_camera_ios),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: primaryGreen,
              ),
            ),
          ),
        
        // Pull hint indicator
        if (_scrollPosition == 0)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Icon(Icons.keyboard_arrow_up, color: primaryGreen, size: 32),
                const SizedBox(height: 4),
                Text(
                  'Swipe up for controls',
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCameraControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Photo capture button
              FloatingActionButton(
                onPressed: _isProcessing ? null : _capturePhoto,
                heroTag: "photo",
                backgroundColor: primaryGreen,
                child: const Icon(Icons.camera_alt, color: Colors.black),
              ),
              
              // Video recording button
              FloatingActionButton.large(
                onPressed: _isProcessing ? null : (_isRecording ? _stopVideoRecording : _startVideoRecording),
                heroTag: "video",
                backgroundColor: _isRecording ? Colors.red : primaryGreen,
                child: Icon(
                  _isRecording ? Icons.stop : Icons.videocam,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              
              // Cancel button
              FloatingActionButton(
                onPressed: _cancelCurrentCapture,
                heroTag: "cancel",
                backgroundColor: Colors.grey[800],
                child: const Icon(Icons.cancel, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _isRecording 
                ? 'Recording: ${_formatDuration(_recordingDuration)}' 
                : 'Capture media',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload from Gallery',
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : () => _pickFromGallery(MediaType.image),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Select Images'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : () => _pickFromGallery(MediaType.video),
                  icon: const Icon(Icons.video_library),
                  label: const Text('Select Videos'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaFilesList() {
    if (_mediaFiles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No media files selected',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Capture photos/videos or select from gallery',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Media (${_mediaFiles.length})',
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _mediaFiles.length,
              itemBuilder: (context, index) {
                final mediaFile = _mediaFiles[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    color: cardDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              color: Colors.black26,
                            ),
                            child: Icon(
                              mediaFile.type == MediaType.image 
                                  ? Icons.image 
                                  : Icons.videocam,
                              size: 48,
                              color: primaryGreen,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mediaFile.file.path.split('/').last,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    mediaFile.type.name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 10,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _removeMediaFile(index),
                                    icon: const Icon(Icons.delete, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    color: Colors.red[300],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (_mediaFiles.isNotEmpty)
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _launchAnalysis,
              icon: _isProcessing 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(Icons.analytics),
              label: Text(_isProcessing ? 'Processing...' : 'Analyze Media'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Back to Camera'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryGreen,
              side: BorderSide(color: primaryGreen),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
enum MediaType { image, video }
enum MediaSource { gallery, camera }

class MediaFile {
  final File file;
  final MediaType type;
  final MediaSource source;
  final int? duration; // in seconds for videos

  MediaFile({
    required this.file,
    required this.type,
    required this.source,
    this.duration,
  });
}
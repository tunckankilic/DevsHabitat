import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';
import 'package:image/image.dart' as img;
import 'package:mime/mime.dart';

class FileUploadResult {
  final String downloadUrl;
  final String fileName;
  final String extension;
  final int fileSize;
  final String mimeType;

  const FileUploadResult({
    required this.downloadUrl,
    required this.fileName,
    required this.extension,
    required this.fileSize,
    required this.mimeType,
  });
}

class FileUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final int maxFileSize;

  static const List<String> allowedImageTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp'
  ];

  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt',
    'md',
    'zip',
    'rar'
  ];

  FileUploadService({this.maxFileSize = 10 * 1024 * 1024}); // 10MB default

  Future<FileUploadResult> uploadFile({
    required String filePath,
    required String conversationId,
    required String messageId,
    required String userId,
    required Function(double) onProgress,
  }) async {
    try {
      final file = File(filePath);
      final fileName = path.basename(filePath);
      final extension = path.extension(filePath).toLowerCase();
      final fileSize = await file.length();
      final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';

      // Size validation
      if (fileSize > maxFileSize) {
        throw FileSizeException();
      }

      // Type validation
      if (!_isAllowedFileType(extension)) {
        throw FileTypeException();
      }

      final storageRef = _storage
          .ref()
          .child('conversations')
          .child(conversationId)
          .child('messages')
          .child(messageId)
          .child(fileName);

      final uploadTask = storageRef.putFile(
        file,
        SettableMetadata(
          contentType: mimeType,
          customMetadata: {
            'userId': userId,
            'messageId': messageId,
            'conversationId': conversationId,
          },
        ),
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Generate thumbnail for images
      String? thumbnailUrl;
      if (_isImageFile(extension)) {
        thumbnailUrl = await _generateThumbnail(file,
            path.join('uploads', userId, conversationId, messageId, fileName));
      }

      return FileUploadResult(
        downloadUrl: downloadUrl,
        fileName: fileName,
        extension: extension,
        fileSize: fileSize,
        mimeType: mimeType,
      );
    } catch (e) {
      if (e is FileUploadException) rethrow;
      throw FileUploadException('Yükleme başarısız: ${e.toString()}');
    }
  }

  bool _isAllowedFileType(String extension) {
    return allowedImageTypes.contains(extension) ||
        allowedDocumentTypes.contains(extension);
  }

  bool _isImageFile(String extension) {
    return allowedImageTypes.contains(extension);
  }

  String _generateSecureFileName(String originalPath, String messageId) {
    final extension = path.extension(originalPath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final hash = sha256.convert('$messageId$timestamp'.codeUnits).toString();
    return '${hash.substring(0, 8)}_$timestamp$extension';
  }

  String _getMimeType(String extension) {
    const mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'txt': 'text/plain',
      'md': 'text/markdown',
      'zip': 'application/zip',
      'rar': 'application/x-rar-compressed',
    };
    return mimeTypes[extension] ?? 'application/octet-stream';
  }

  Future<String?> _generateThumbnail(File imageFile, String storagePath) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Resize to thumbnail (150x150)
      final thumbnail = img.copyResize(image, width: 150, height: 150);
      final thumbnailBytes = Uint8List.fromList(img.encodeJpg(thumbnail));

      // Upload thumbnail
      final thumbnailPath = storagePath.replaceAll(
          path.basename(storagePath), 'thumb_${path.basename(storagePath)}');
      final ref = _storage.ref().child(thumbnailPath);
      await ref.putData(thumbnailBytes);

      return await ref.getDownloadURL();
    } catch (e) {
      return null; // Thumbnail generation failed, but file upload succeeded
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }
}

class FileUploadException implements Exception {
  final String message;
  FileUploadException(this.message);

  @override
  String toString() => 'FileUploadException: $message';
}

class FileSizeException extends FileUploadException {
  FileSizeException() : super('Dosya boyutu limiti aşıldı');
}

class FileTypeException extends FileUploadException {
  FileTypeException() : super('Desteklenmeyen dosya tipi');
}

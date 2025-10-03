import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';

class DocumentsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get user's documents
  Future<List<Map<String, dynamic>>> getUserDocuments(String userId) async {
    try {
      print('🔍 Fetching user documents...');

      final response = await _supabase.from('documents').select('''
            *,
            category:document_categories(*)
          ''').eq('user_id', userId).order('created_at', ascending: false);

      print('✅ Found ${response.length} documents');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching user documents: $e');
      rethrow;
    }
  }

  // Get public documents
  Future<List<Map<String, dynamic>>> getPublicDocuments({
    String? categoryId,
    String? fileType,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      print('🔍 Fetching public documents...');

      final from = page * limit;
      final to = from + limit - 1;

      var query = _supabase.from('documents').select('''
            *,
            user:users!documents_user_id_fkey(name, email),
            category:document_categories(*)
          ''').eq('is_public', true);

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      if (fileType != null) {
        query = query.eq('file_type', fileType);
      }

      final finalQuery =
          query.order('created_at', ascending: false).range(from, to);
      final response = await finalQuery;

      print('✅ Found ${response.length} public documents');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching public documents: $e');
      rethrow;
    }
  }

  // Get document categories
  Future<List<Map<String, dynamic>>> getDocumentCategories() async {
    try {
      final response =
          await _supabase.from('document_categories').select('*').order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching document categories: $e');
      rethrow;
    }
  }

  // Upload document
  Future<bool> uploadDocument({
    required String userId,
    required String title,
    required String description,
    required String fileType,
    required String categoryId,
    required PlatformFile file,
    bool isPublic = false,
  }) async {
    try {
      print('📤 Uploading document: ${file.name}');

      // Upload file to Supabase Storage
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final filePath = 'documents/$userId/$fileName';

      await _supabase.storage
          .from('documents')
          .uploadBinary(filePath, file.bytes!);

      // Get public URL
      final fileUrl =
          _supabase.storage.from('documents').getPublicUrl(filePath);

      // Save document metadata to database
      await _supabase.from('documents').insert({
        'user_id': userId,
        'title': title,
        'description': description,
        'file_name': file.name,
        'file_url': fileUrl,
        'file_size': file.size,
        'file_type': fileType,
        'mime_type': file.extension,
        'category_id': categoryId,
        'is_public': isPublic,
      });

      print('✅ Document uploaded successfully');
      return true;
    } catch (e) {
      print('❌ Error uploading document: $e');
      return false;
    }
  }

  // Share document with specific user
  Future<bool> shareDocument({
    required String documentId,
    required String sharedWithUserId,
    required String sharedByUserId,
    String permissionType = 'view',
    DateTime? expiresAt,
  }) async {
    try {
      await _supabase.from('document_shares').insert({
        'document_id': documentId,
        'shared_with_user_id': sharedWithUserId,
        'shared_by_user_id': sharedByUserId,
        'permission_type': permissionType,
        'expires_at': expiresAt?.toIso8601String(),
      });

      return true;
    } catch (e) {
      print('❌ Error sharing document: $e');
      return false;
    }
  }

  // Get shared documents for user
  Future<List<Map<String, dynamic>>> getSharedDocuments(String userId) async {
    try {
      final response = await _supabase
          .from('document_shares')
          .select('''
            *,
            document:documents(
              *,
              user:users!documents_user_id_fkey(name, email),
              category:document_categories(*)
            ),
            shared_by:users!document_shares_shared_by_user_id_fkey(name, email)
          ''')
          .eq('shared_with_user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching shared documents: $e');
      rethrow;
    }
  }

  // Update document
  Future<bool> updateDocument({
    required String documentId,
    required String userId,
    String? title,
    String? description,
    String? categoryId,
    bool? isPublic,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (categoryId != null) updateData['category_id'] = categoryId;
      if (isPublic != null) updateData['is_public'] = isPublic;

      await _supabase
          .from('documents')
          .update(updateData)
          .eq('id', documentId)
          .eq('user_id', userId);

      return true;
    } catch (e) {
      print('❌ Error updating document: $e');
      return false;
    }
  }

  // Delete document
  Future<bool> deleteDocument({
    required String documentId,
    required String userId,
  }) async {
    try {
      // Get document info to delete from storage
      final document = await _supabase
          .from('documents')
          .select('file_url')
          .eq('id', documentId)
          .eq('user_id', userId)
          .single();

      // Delete from database (this will cascade delete shares)
      await _supabase
          .from('documents')
          .delete()
          .eq('id', documentId)
          .eq('user_id', userId);

      // Delete from storage
      try {
        final filePath = document['file_url'].split('/').last;
        await _supabase.storage.from('documents').remove(['$userId/$filePath']);
      } catch (e) {
        print('⚠️ Could not delete file from storage: $e');
      }

      return true;
    } catch (e) {
      print('❌ Error deleting document: $e');
      return false;
    }
  }

  // Increment download count
  Future<void> incrementDownloadCount(String documentId) async {
    try {
      await _supabase.rpc('increment_download_count', params: {
        'doc_id': documentId,
      });
    } catch (e) {
      print('❌ Error incrementing download count: $e');
    }
  }

  // Search documents
  Future<List<Map<String, dynamic>>> searchDocuments({
    required String query,
    String? categoryId,
    String? fileType,
    bool publicOnly = true,
  }) async {
    try {
      var supabaseQuery = _supabase.from('documents').select('''
            *,
            user:users!documents_user_id_fkey(name, email),
            category:document_categories(*)
          ''');

      if (publicOnly) {
        supabaseQuery = supabaseQuery.eq('is_public', true);
      }

      if (categoryId != null) {
        supabaseQuery = supabaseQuery.eq('category_id', categoryId);
      }

      if (fileType != null) {
        supabaseQuery = supabaseQuery.eq('file_type', fileType);
      }

      // Search in title and description
      supabaseQuery =
          supabaseQuery.or('title.ilike.%$query%,description.ilike.%$query%');

      final response =
          await supabaseQuery.order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error searching documents: $e');
      rethrow;
    }
  }
}

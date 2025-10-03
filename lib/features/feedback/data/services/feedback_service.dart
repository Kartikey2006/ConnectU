import 'package:supabase_flutter/supabase_flutter.dart';

class FeedbackService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Submit feedback for a mentorship session
  Future<bool> submitMentorshipFeedback({
    required String sessionId,
    required String mentorId,
    required String menteeId,
    required int rating,
    String? reviewText,
    bool isAnonymous = false,
    Map<String, int>? categoryRatings,
    Map<String, String>? categoryComments,
  }) async {
    try {
      print('📝 Submitting mentorship feedback...');

      // Insert main feedback
      final feedbackResponse = await _supabase
          .from('feedback')
          .insert({
            'session_id': sessionId,
            'mentor_id': mentorId,
            'mentee_id': menteeId,
            'rating': rating,
            'review_text': reviewText,
            'feedback_type': 'mentorship',
            'is_anonymous': isAnonymous,
          })
          .select('id')
          .single();

      final feedbackId = feedbackResponse['id'];

      // Insert category-specific feedback if provided
      if (categoryRatings != null && categoryComments != null) {
        final categories = await _supabase
            .from('feedback_categories')
            .select('id, name')
            .eq('feedback_type', 'mentorship');

        for (final category in categories) {
          final categoryName = category['name'] as String;
          final categoryId = category['id'] as String;

          if (categoryRatings.containsKey(categoryName)) {
            await _supabase.from('feedback_responses').insert({
              'feedback_id': feedbackId,
              'category_id': categoryId,
              'rating': categoryRatings[categoryName],
              'comment': categoryComments[categoryName],
            });
          }
        }
      }

      print('✅ Feedback submitted successfully');
      return true;
    } catch (e) {
      print('❌ Error submitting feedback: $e');
      return false;
    }
  }

  // Submit feedback for an event
  Future<bool> submitEventFeedback({
    required String eventId,
    required String userId,
    required int rating,
    String? reviewText,
    bool isAnonymous = false,
    Map<String, int>? categoryRatings,
    Map<String, String>? categoryComments,
  }) async {
    try {
      print('📝 Submitting event feedback...');

      // Insert main feedback
      final feedbackResponse = await _supabase
          .from('feedback')
          .insert({
            'mentor_id':
                eventId, // Using mentor_id field to store event_id for events
            'mentee_id': userId,
            'rating': rating,
            'review_text': reviewText,
            'feedback_type': 'event',
            'is_anonymous': isAnonymous,
          })
          .select('id')
          .single();

      final feedbackId = feedbackResponse['id'];

      // Insert category-specific feedback if provided
      if (categoryRatings != null && categoryComments != null) {
        final categories = await _supabase
            .from('feedback_categories')
            .select('id, name')
            .eq('feedback_type', 'event');

        for (final category in categories) {
          final categoryName = category['name'] as String;
          final categoryId = category['id'] as String;

          if (categoryRatings.containsKey(categoryName)) {
            await _supabase.from('feedback_responses').insert({
              'feedback_id': feedbackId,
              'category_id': categoryId,
              'rating': categoryRatings[categoryName],
              'comment': categoryComments[categoryName],
            });
          }
        }
      }

      print('✅ Event feedback submitted successfully');
      return true;
    } catch (e) {
      print('❌ Error submitting event feedback: $e');
      return false;
    }
  }

  // Get feedback for a mentor
  Future<List<Map<String, dynamic>>> getMentorFeedback(String mentorId) async {
    try {
      final response = await _supabase
          .from('feedback')
          .select('''
            *,
            mentee:users!feedback_mentee_id_fkey(name, email),
            session:mentorship_sessions(*),
            responses:feedback_responses(
              *,
              category:feedback_categories(*)
            )
          ''')
          .eq('mentor_id', mentorId)
          .eq('feedback_type', 'mentorship')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching mentor feedback: $e');
      rethrow;
    }
  }

  // Get feedback for an event
  Future<List<Map<String, dynamic>>> getEventFeedback(String eventId) async {
    try {
      final response = await _supabase
          .from('feedback')
          .select('''
            *,
            mentee:users!feedback_mentee_id_fkey(name, email),
            responses:feedback_responses(
              *,
              category:feedback_categories(*)
            )
          ''')
          .eq('mentor_id', eventId) // Using mentor_id field to store event_id
          .eq('feedback_type', 'event')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching event feedback: $e');
      rethrow;
    }
  }

  // Get feedback categories for a specific type
  Future<List<Map<String, dynamic>>> getFeedbackCategories(
      String feedbackType) async {
    try {
      final response = await _supabase
          .from('feedback_categories')
          .select('*')
          .eq('feedback_type', feedbackType)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching feedback categories: $e');
      rethrow;
    }
  }

  // Get user's feedback history
  Future<List<Map<String, dynamic>>> getUserFeedbackHistory(
      String userId) async {
    try {
      final response = await _supabase.from('feedback').select('''
            *,
            mentor:users!feedback_mentor_id_fkey(name, email),
            session:mentorship_sessions(*),
            responses:feedback_responses(
              *,
              category:feedback_categories(*)
            )
          ''').eq('mentee_id', userId).order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching user feedback history: $e');
      rethrow;
    }
  }

  // Update feedback
  Future<bool> updateFeedback({
    required String feedbackId,
    required String userId,
    int? rating,
    String? reviewText,
    bool? isAnonymous,
    Map<String, int>? categoryRatings,
    Map<String, String>? categoryComments,
  }) async {
    try {
      // Update main feedback
      final updateData = <String, dynamic>{};
      if (rating != null) updateData['rating'] = rating;
      if (reviewText != null) updateData['review_text'] = reviewText;
      if (isAnonymous != null) updateData['is_anonymous'] = isAnonymous;

      if (updateData.isNotEmpty) {
        await _supabase
            .from('feedback')
            .update(updateData)
            .eq('id', feedbackId)
            .eq('mentee_id', userId);
      }

      // Update category-specific feedback if provided
      if (categoryRatings != null && categoryComments != null) {
        // Delete existing responses
        await _supabase
            .from('feedback_responses')
            .delete()
            .eq('feedback_id', feedbackId);

        // Insert new responses
        final categories = await _supabase
            .from('feedback_categories')
            .select('id, name')
            .eq('feedback_type', 'mentorship');

        for (final category in categories) {
          final categoryName = category['name'] as String;
          final categoryId = category['id'] as String;

          if (categoryRatings.containsKey(categoryName)) {
            await _supabase.from('feedback_responses').insert({
              'feedback_id': feedbackId,
              'category_id': categoryId,
              'rating': categoryRatings[categoryName],
              'comment': categoryComments[categoryName],
            });
          }
        }
      }

      return true;
    } catch (e) {
      print('❌ Error updating feedback: $e');
      return false;
    }
  }

  // Delete feedback
  Future<bool> deleteFeedback({
    required String feedbackId,
    required String userId,
  }) async {
    try {
      await _supabase
          .from('feedback')
          .delete()
          .eq('id', feedbackId)
          .eq('mentee_id', userId);

      return true;
    } catch (e) {
      print('❌ Error deleting feedback: $e');
      return false;
    }
  }

  // Get average rating for a mentor
  Future<double> getMentorAverageRating(String mentorId) async {
    try {
      final response = await _supabase
          .from('feedback')
          .select('rating')
          .eq('mentor_id', mentorId)
          .eq('feedback_type', 'mentorship');

      if (response.isEmpty) return 0.0;

      final totalRating = response.fold<int>(
          0, (sum, feedback) => sum + (feedback['rating'] as int));
      return totalRating / response.length;
    } catch (e) {
      print('❌ Error calculating mentor average rating: $e');
      return 0.0;
    }
  }

  // Get average rating for an event
  Future<double> getEventAverageRating(String eventId) async {
    try {
      final response = await _supabase
          .from('feedback')
          .select('rating')
          .eq('mentor_id', eventId) // Using mentor_id field to store event_id
          .eq('feedback_type', 'event');

      if (response.isEmpty) return 0.0;

      final totalRating = response.fold<int>(
          0, (sum, feedback) => sum + (feedback['rating'] as int));
      return totalRating / response.length;
    } catch (e) {
      print('❌ Error calculating event average rating: $e');
      return 0.0;
    }
  }

  // Get feedback statistics
  Future<Map<String, dynamic>> getFeedbackStatistics(String mentorId) async {
    try {
      final response = await _supabase
          .from('feedback')
          .select('rating')
          .eq('mentor_id', mentorId)
          .eq('feedback_type', 'mentorship');

      if (response.isEmpty) {
        return {
          'total_feedback': 0,
          'average_rating': 0.0,
          'rating_distribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        };
      }

      final ratings = response.map((f) => f['rating'] as int).toList();
      final totalFeedback = ratings.length;
      final averageRating = ratings.reduce((a, b) => a + b) / totalFeedback;

      final ratingDistribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (final rating in ratings) {
        ratingDistribution[rating] = (ratingDistribution[rating] ?? 0) + 1;
      }

      return {
        'total_feedback': totalFeedback,
        'average_rating': averageRating,
        'rating_distribution': ratingDistribution,
      };
    } catch (e) {
      print('❌ Error getting feedback statistics: $e');
      return {
        'total_feedback': 0,
        'average_rating': 0.0,
        'rating_distribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
      };
    }
  }
}

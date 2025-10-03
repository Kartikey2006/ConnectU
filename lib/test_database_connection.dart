import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cudwwhohzfxmflquizhk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1ZHd3aG9oemZ4bWZscXVpemhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY2NzQ4MzAsImV4cCI6MjA1MjI1MDgzMH0.8QZqJqJqJqJqJqJqJqJqJqJqJqJqJqJqJqJqJqJqJq',
  );

  runApp(const DatabaseTestApp());
}

class DatabaseTestApp extends StatelessWidget {
  const DatabaseTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Database Connection Test',
      home: DatabaseTestPage(),
    );
  }
}

class DatabaseTestPage extends StatefulWidget {
  const DatabaseTestPage({super.key});

  @override
  _DatabaseTestPageState createState() => _DatabaseTestPageState();
}

class _DatabaseTestPageState extends State<DatabaseTestPage> {
  String _status = 'Testing database connection...';
  final List<String> _results = [];

  @override
  void initState() {
    super.initState();
    _testDatabase();
  }

  Future<void> _testDatabase() async {
    try {
      setState(() {
        _status = 'Testing database connection...';
        _results.clear();
      });

      // Test 1: Check if users table exists
      _addResult('Test 1: Checking users table...');
      try {
        final response = await Supabase.instance.client
            .from('users')
            .select('count')
            .limit(1);
        _addResult('✅ Users table exists and is accessible');
      } catch (e) {
        _addResult('❌ Users table error: $e');
      }

      // Test 2: Check table structure
      _addResult('\nTest 2: Checking table structure...');
      try {
        final response =
            await Supabase.instance.client.from('users').select('*').limit(1);

        if (response.isNotEmpty) {
          final columns = response.first.keys.toList();
          _addResult('✅ Table columns: ${columns.join(', ')}');

          // Check for specific columns
          if (columns.contains('supabase_auth_id')) {
            _addResult('✅ supabase_auth_id column exists');
          } else {
            _addResult('❌ supabase_auth_id column missing');
          }

          if (columns.contains('email')) {
            _addResult('✅ email column exists');
          } else {
            _addResult('❌ email column missing');
          }

          if (columns.contains('role')) {
            _addResult('✅ role column exists');
          } else {
            _addResult('❌ role column missing');
          }
        } else {
          _addResult('⚠️ Table is empty');
        }
      } catch (e) {
        _addResult('❌ Table structure error: $e');
      }

      // Test 3: Try to insert a test user
      _addResult('\nTest 3: Testing user insertion...');
      try {
        final testEmail =
            'test_${DateTime.now().millisecondsSinceEpoch}@example.com';
        final response = await Supabase.instance.client.from('users').insert({
          'name': 'Test User',
          'email': testEmail,
          'role': 'student',
          'password_hash': 'test_hash',
        }).select();

        _addResult('✅ User insertion successful: ${response.first['name']}');

        // Clean up test user
        await Supabase.instance.client
            .from('users')
            .delete()
            .eq('email', testEmail);
        _addResult('✅ Test user cleaned up');
      } catch (e) {
        _addResult('❌ User insertion error: $e');
      }

      // Test 4: Test authentication
      _addResult('\nTest 4: Testing authentication...');
      try {
        final authUser = Supabase.instance.client.auth.currentUser;
        if (authUser != null) {
          _addResult('✅ User is authenticated: ${authUser.email}');
        } else {
          _addResult('⚠️ No authenticated user');
        }
      } catch (e) {
        _addResult('❌ Authentication error: $e');
      }

      setState(() {
        _status = 'Database test completed';
      });
    } catch (e) {
      setState(() {
        _status = 'Database test failed: $e';
      });
    }
  }

  void _addResult(String result) {
    setState(() {
      _results.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Connection Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _status,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  final isError = result.contains('❌');
                  final isSuccess = result.contains('✅');
                  final isWarning = result.contains('⚠️');

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      result,
                      style: TextStyle(
                        color: isError
                            ? Colors.red
                            : isSuccess
                                ? Colors.green
                                : isWarning
                                    ? Colors.orange
                                    : Colors.black,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testDatabase,
              child: const Text('Run Test Again'),
            ),
          ],
        ),
      ),
    );
  }
}

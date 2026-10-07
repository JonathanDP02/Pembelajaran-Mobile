import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../messaging/push_service.dart'; // Pastikan path import ini sesuai struktur folder kamu

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug FCM & Notifikasi'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD DISPLAY TOKEN TERPOTONG (UNTUK REPORT/JOBSHEET)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.vibration_outlined, color: Colors.indigo),
                        SizedBox(width: 8),
                        Text(
                          'FCM Token (Debug Mode)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Token terpotong (12 karakter awal + ...) demi keamanan sesuai instruksi jobsheet:',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),

                    // Mendengarkan perubahan token secara realtime dari ValueNotifier
                    ValueListenableBuilder<String>(
                      valueListenable: fcmTokenNotifier,
                      builder: (context, tokenValue, child) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.indigo.shade200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: SelectableText(
                                  tokenValue,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                tooltip: 'Salin Token',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: tokenValue),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Token disalin ke clipboard!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // CARD PANDUAN PENGUJIAN JOBSHEET
            const Text(
              'Status Checklist Jobsheet:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildChecklistItem(
              icon: Icons.check_circle_outline,
              color: Colors.green,
              title: '1. Tampilkan Token Terpotong',
              subtitle: 'Screenshot halaman ini untuk bukti laporan.',
            ),
            _buildChecklistItem(
              icon: Icons.refresh,
              color: Colors.orange,
              title: '2. Uji onTokenRefresh',
              subtitle: 'Clear Data / Reinstall app, lalu cek perubahan token di atas.',
            ),
            _buildChecklistItem(
              icon: Icons.send_to_mobile,
              color: Colors.blue,
              title: '3. Kirim via Firebase Console',
              subtitle: 'Tekan Home (App Background) lalu kirim notifikasi dari Console.',
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk item checklist
  Widget _buildChecklistItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      ),
    );
  }
}
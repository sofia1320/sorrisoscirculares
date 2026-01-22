import 'package:flutter/material.dart';
import 'donation_history_page.dart';
import 'services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ScheduleDonationPage extends StatefulWidget {
  final String childName;
  const ScheduleDonationPage({super.key, required this.childName});

  @override
  State<ScheduleDonationPage> createState() => _ScheduleDonationPageState();
}

class _ScheduleDonationPageState extends State<ScheduleDonationPage> {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  int? _selectedDay;
  TimeOfDay? selectedTime;

  Future<void> _submitDonation(String childId, String date, String time) async {
    try {
      final token = await ApiService.getToken();
      if (token == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro: Token de autenticação não encontrado.')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/donations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'childId': childId,
          'date': date,
          'time': time,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doação agendada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao agendar doação: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao agendar doação: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF07167)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Agendar Doação', style: TextStyle(color: Color(0xFFF07167))),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFDFCDC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'DATA DA MARCAÇÃO',
              style: TextStyle(
                fontFamily: 'WildlySans',
                fontSize: 24,
                color: Color(0xFFF07167),
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            _buildCalendar(context),
            const SizedBox(height: 32),
            const Text('Horário:', style: TextStyle(fontSize: 16, color: Color(0xFFF07167))),
            const SizedBox(height: 8),
            DropdownButton<TimeOfDay>(
              value: selectedTime,
              items: [
                const TimeOfDay(hour: 9, minute: 0),
                const TimeOfDay(hour: 10, minute: 0),
                const TimeOfDay(hour: 11, minute: 0),
                const TimeOfDay(hour: 14, minute: 0),
                const TimeOfDay(hour: 15, minute: 0),
                const TimeOfDay(hour: 16, minute: 0),
              ]
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t.format(context)),
                      ))
                  .toList(),
              onChanged: (t) => setState(() => selectedTime = t),
              hint: const Text('Escolher horário'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDE0C3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: (_selectedDay != null && selectedTime != null)
                  ? () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFFFFFFF4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            title: const Text('Confirmar Marcação'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Data: '
                                  '${_selectedDay?.toString().padLeft(2, '0') ?? '--'}/'
                                  '${_focusedMonth.month.toString().padLeft(2, '0')}/${_focusedMonth.year}'),
                                const SizedBox(height: 8),
                                Text('Horário: '
                                  '${selectedTime != null ? selectedTime!.format(context) : '--'}'),
                                const SizedBox(height: 16),
                                const Text('Tem a certeza que pretende agendar esta doação?'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(color: Color(0xFFF07167)),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF07167),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmed == true) {
                        // Format date and time for API
                        final dateStr = '${_focusedMonth.year}-${_focusedMonth.month.toString().padLeft(2, '0')}-${_selectedDay.toString().padLeft(2, '0')}';
                        final timeStr = '${selectedTime?.hour.toString().padLeft(2, '0')}:${selectedTime?.minute.toString().padLeft(2, '0')}';
                        
                        // Submit donation to API
                        await _submitDonation(widget.childName, dateStr, timeStr);
                        
                        // Create local donation and navigate
                        final newDonation = Donation(
                          childName: widget.childName,
                          dateTime: DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month,
                            _selectedDay ?? 1,
                            selectedTime?.hour ?? 0,
                            selectedTime?.minute ?? 0,
                          ),
                          status: DonationStatus.pendente,
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => DonationHistoryPage(donations: [newDonation]),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  : null,
              child: const Text(
                'Confirmar Agendamento',
                style: TextStyle(fontSize: 18, color: Color(0xFFF07167)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final monthName = _monthName(_focusedMonth.month);
    final year = _focusedMonth.year;
    final firstDayOfMonth = DateTime(year, _focusedMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0=Dom, 1=Seg, ...
    final daysInMonth = DateTime(year, _focusedMonth.month + 1, 0).day;
    final daysBefore = firstWeekday;
    final totalCells = daysBefore + daysInMonth;
    final weeks = (totalCells / 7.0).ceil();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF07167), Color(0xFFF3B9A9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(36),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
                    _selectedDay = null;
                  });
                },
              ),
              Text(
                '$monthName de $year',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
                    _selectedDay = null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('Seg', style: TextStyle(color: Colors.white)),
              Text('Ter', style: TextStyle(color: Colors.white)),
              Text('Qua', style: TextStyle(color: Colors.white)),
              Text('Qui', style: TextStyle(color: Colors.white)),
              Text('Sex', style: TextStyle(color: Colors.white)),
              Text('Sab', style: TextStyle(color: Colors.white)),
              Text('Dom', style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          for (int w = 0; w < weeks; w++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (d) {
                final cell = w * 7 + d;
                final dayNum = cell - daysBefore + 1;
                final isValid = dayNum > 0 && dayNum <= daysInMonth;
                final isSelected = isValid && dayNum == _selectedDay;
                return Expanded(
                  child: GestureDetector(
                    onTap: isValid
                        ? () => setState(() => _selectedDay = dayNum)
                        : null,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: isSelected
                          ? BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            )
                          : null,
                      alignment: Alignment.center,
                      height: 36,
                      child: isValid
                          ? Text(
                              '$dayNum',
                              style: TextStyle(
                                color: Colors.white.withOpacity(isSelected ? 1 : 0.9),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 18,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
      'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro'
    ];
    return months[month - 1];
  }
}

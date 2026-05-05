import 'package:flutter/material.dart';
import 'package:postman_penugasan1/models/hisstory.dart';
import 'package:postman_penugasan1/services/history.dart';
import 'package:postman_penugasan1/widgets/navBar.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  static const _themeColor = Color.fromARGB(255, 230, 114, 41);
  static const _washedTheme = Color.fromARGB(255, 222, 208, 203);

  bool _loading = true;
  String? _error;
  List<HistoryTransaction> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final res = await HistoryService().getHistoryTransactions();
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (!res.status) {
        _error = res.message;
        _items = [];
      } else {
        _items = (res.data ?? []).whereType<HistoryTransaction>().toList();
      }
    });
  }

  Widget _headerIcon({
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    return IconButton(
      tooltip: tooltip,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onPressed: onPressed,
      icon: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Icon(icon, size: 18, color: const Color.fromARGB(230, 0, 0, 0)),
      ),
    );
  }

  Widget _historyCard(HistoryTransaction item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _washedTheme, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(18, 0, 0, 0),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: _themeColor.withAlpha((255 * 0.15).round()),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.receipt_long_rounded,
                      color: _themeColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaUser ??
                            'Transaksi #${item.idTransaksi ?? '-'}',
                        style: const TextStyle(
                          fontFamily: 'Popins',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      if (item.tglTransaksi != null &&
                          item.tglTransaksi!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item.tglTransaksi!,
                            style: TextStyle(
                              fontFamily: 'Popins',
                              fontSize: 13,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (item.detail != null && item.detail!.isNotEmpty) ...[
              const Divider(height: 22),
              Text(
                item.detail!,
                style: TextStyle(
                  fontFamily: 'Popins',
                  fontSize: 14,
                  height: 1.45,
                  color: Colors.blueGrey.shade700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeColor,
      bottomNavigationBar: BottomNav(1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Riwayat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Popins',
                    ),
                  ),
                ),
                _headerIcon(
                  tooltip: 'Segarkan',
                  icon: Icons.refresh_rounded,
                  onPressed: _loading ? null : _load,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Riwayat pembelian barang.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.92),
                fontSize: 14,
                height: 1.35,
                fontFamily: 'Popins',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(36, 16, 42, 88),
                    blurRadius: 24,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: _themeColor,
                      ),
                    )
                  : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Popins',
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                      ),
                    )
                  : _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _washedTheme.withAlpha((255 * 0.45).round()),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.timeline_rounded,
                              size: 44,
                              color: Colors.blueGrey.shade400,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Belum ada riwayat transaksi.',
                            style: TextStyle(
                              fontFamily: 'Popins',
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Setelah checkout sukses,\nriwayat akan muncul di sini.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Popins',
                              fontSize: 14,
                              height: 1.45,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: _themeColor,
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _items.length,
                        itemBuilder: (_, i) => _historyCard(_items[i]),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

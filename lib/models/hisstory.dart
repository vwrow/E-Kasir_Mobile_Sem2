class HistoryTransaction {
  int? idTransaksi;
  String? namaUser;
  String? tglTransaksi;
  String? detail;

  HistoryTransaction({
    this.idTransaksi,
    this.namaUser,
    this.tglTransaksi,
    this.detail,
  });

  factory HistoryTransaction.fromJson(Map<String, dynamic> json) {
    return HistoryTransaction(
      idTransaksi: _parseInt(json['id_transaksi']),
      namaUser: json['nama_user']?.toString(),
      tglTransaksi: json['tgl_transaksi']?.toString(),
      detail: json['detail']?.toString(),
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}

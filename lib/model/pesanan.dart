class Pesanan {
  final String idItem, item, harga, kategori, keterangan, transaksi;
  String? metodePembayaran, mejaID, status, orderId;
  int jumlah;

  Pesanan({
    required this.idItem,
    required this.item,
    required this.harga,
    required this.jumlah,
    required this.kategori,
    required this.keterangan,
    required this.transaksi,
    this.metodePembayaran = 'Kasir',
    this.status,
    this.mejaID,
    this.orderId,
  });
}

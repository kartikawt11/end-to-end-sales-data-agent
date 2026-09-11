CREATE OR REPLACE TABLE `indokopi-makmur-sentosa-501004.DATASET.Order_detail` (
  Tanggal DATE,
  ID_Item STRING,
  ID_Customer STRING,
  Harga NUMERIC,
  Jumlah_Sales_Order INT64,
  Subtotal_Sales_Order NUMERIC, 
  Jumlah_Retur INT64, 
  Subtotal_Retur NUMERIC,
  Jumlah_Invoice INT64,
  Subtotal_Invoice NUMERIC
);


CREATE OR REPLACE TABLE `indokopi-makmur-sentosa-501004.DATASET.Customer_detail` (
  ID STRING,
  Nama_Perusahaan STRING,
  Nama_Toko STRING,
  Area STRING,
  Jenis_Outlet STRING,
  Tipe_Pembayaran STRING, 
);


CREATE OR REPLACE TABLE `indokopi-makmur-sentosa-501004.DATASET.Produk_detail` (
  ID STRING,
  Kategori STRING,
  Nama_Barang STRING,
  Harga INT64, 
);

CREATE OR REPLACE TABLE `indokopi-makmur-sentosa-501004.DATASET.Target_detail` (
  Bulan STRING,
  Tahun NUMERIC,
  Target NUMERIC,
);

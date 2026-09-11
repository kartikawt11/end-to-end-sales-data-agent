# end-to-end-sales-data-agent

**1. Perancangan & Penyiapan Database (DDL & Input Data)**
* **Buat dataset** di Google BigQuery dengan nama `DATASET`
* **Jalankan script** `Data Definition Language.sql` untuk membuat tabel staging (`Customer_detail`, `Order_detail`, `Produk_detail`, `Target_detail`)
* **Import Data:**
  1. Buka menu `Create Table` pada dataset `DATASET` di console BigQuery.
  2. Pilih sumber data (`Create table from: Upload`) dan masukkan file dataset sesuai format (CSV).
  3. Tentukan tabel tujuan (`Destination Table`) sesuai nama tabel yang sudah dibuat.
  4. Lakukan proses `Load Data` hingga data berhasil masuk ke masing-masing tabel.
 
**2. Build Agent AI (BigQuery Agents)**
* **Membuat Agent:** Masuk ke menu **BigQuery** di Google Cloud Console, lalu pilih tab **Agents** dan klik `+ New agent`.
* **Koneksi Data:** Hubungkan agent secara langsung ke tabel `DATASET` (BigQuery) sebagai sumber pengetahuan (*Knowledge source*).
* **Konfigurasi Agent:** Beri nama agent (`Sales Agent AI`) dan atur instruksi analisis data penjualan agar AI memahami konteks tabel `Order_detail`, `Produk_detail`, `Customer_detail`, dan `Target_detail`.
* **System Instruction & Guardrails:** Menambahkan aturan ketat agar AI tidak menebak-nebak (halusinasi) saat membuat query SQL, dengan fokus pada:
  * **Aturan JOIN & Relasi:** Mengunci *primary/foreign key* antar 4 tabel utama agar AI tidak salah menyambungkan data (misalnya `Order_detail` ke `Produk_detail` menggunakan `ID_Item`).
  * **Standarisasi Rumus Bisnis:** Mengunci kalkulasi finansial agar konsisten. Contoh: Jika ditanya "omset", AI wajib menggunakan `SUM(Subtotal_Invoice)`, bukan sembarang menjumlahkan kolom `Harga`.
  * **Penerjemahan Bahasa Sehari-hari:** Membantu AI memetakan frasa pengguna ke filter *database* yang tepat. Misalnya, kata "coklat" atau "cokelat" langsung diarahkan ke `WHERE Kategori = 'Coklat'`, atau "online" ke `Jenis_Outlet = 'Online'`.
  * **Ekstraksi Waktu:** Memastikan filter bulan dan tahun menggunakan fungsi `EXTRACT()` BigQuery agar format tanggal tidak meleset.
* **Pengujian (Testing):** Memvalidasi ketepatan AI melalui panel chat dengan pertanyaan kompleks (contoh: *"Berapa total omset cokelat online pada Juni 2025?"*) untuk memastikan query SQL yang dieksekusi 100% akurat.
*  **Verified Queries (Ground Truth Optimization):** Menambahkan pasangan pertanyaan bahasa alami dan query BigQuery SQL tervalidasi sebagai acuan utama (*few-shot examples*) bagi agent untuk menjamin ketepatan sintaks dan logika bisnis.
    * **Contoh Pasangan Query:**
    * **Pertanyaan:** *"Berapa total omset cokelat online di tahun 2025?"*
    * **SQL Reference:**
      ```sql
      SELECT 
        SUM(o.Subtotal_Invoice) AS total_omset
      FROM `DATASET.Order_detail` o
      JOIN `DATASET.Produk_detail` p 
        ON o.ID_Item = p.ID_Item
      JOIN `DATASET.Customer_detail` c 
        ON o.ID_Customer = c.ID_Customer
      WHERE p.Kategori = 'Coklat'
        AND c.Jenis_Outlet = 'Online'
        AND EXTRACT(YEAR FROM o.Tanggal) = 2025;
      ```
* **Custom Terms (Business Glossary / Entity Mapping):** Mendaftarkan istilah bisnis khusus (*glossary*) di BigQuery Agent untuk memetakan bahasa alami pengguna secara presisi ke kolom dan nilai tabel yang sesuai:
  * **Coklat:** Nilai kategori cokelat pada kolom `Kategori` di tabel `Produk_detail`.
  * **Kopi:** Nilai kategori kopi pada kolom `Kategori` di tabel `Produk_detail`.
  * **Cookies:** Nilai kategori cookies pada kolom `Kategori` di tabel `Produk_detail`.
  * **TOP/CASH:** Nilai kategori pembayaran (Top/Cash) pada kolom `Tipe_Pembayaran` di tabel `Customer_detail`.

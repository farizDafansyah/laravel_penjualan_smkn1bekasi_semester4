<div class="row">
    <div class="col-lg-12">
        <div class="form-group">
            <label>Kode Barang</label>
            <input type="hidden" name="id_barang" value="{{ $barangDetil->id_barang }}" />
            <input class="form-control" type="text" name="kodeBarang" id="kodeBarang" value="{{ $barangDetil->kode }}">
        </div>
        <div class="form-group">
            <label>Nama Barang</label>
            <input type="text" name="nama_barang" id="namaBarang" class="form-control" value="{{ $barangDetil->nama_barang }}" />
        </div>
        <div class="form-group">
            <label>Harga Barang</label>
            <input type="number" class="form-control" name="hargaBarang" id="hargaBarang" value="{{ $barangDetil->harga }}">
        </div>
    </div>
</div>
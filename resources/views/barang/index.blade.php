@extends('template.layout')
@section('title','Data Barang')

@section('content')
    <div class="col-md-12">
        <div class="card">
            <div class="card-header">
                <button class="btn btn-success" id="btnTambahBarang" data-bs-target='#modalPopup' data-bs-toggle="modal" attr-href="{{route('barang.tambah')}}">tambah <i class="bi bi-plus"></i></button>
            </div>
            <div class="card-body">
                <table class="table table-hovered table-bordered" id="DataTable">
                    <thead>
                        <tr>
                            <th>Kode Barang</th>
                            <th>Nama Barang</th>
                            <th>Stok</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- berisi data dari database (dibuat dengan datatables) -->
                    </tbody>
                </table>
            </div>
            <div class="card-footer"><!-- kosong --></div>
        </div>
        <div class="modal fade" id="modalPopup" data-bs-backdrop="static" data-bs-keyword="false" tabindex="-1" aria-labelledby="staticBackdropLarge">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <!-- berisi title yang di berikan -->
                        </h5>
                        <button type="button" class="btn btn-close" data-bs-dismiss='modal' aria-label="close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- berisi isi dari barang/popup_modal/tambah -->
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-success" id="btnSimpanBarang"><i class="bi bi-save"></i> Simpan</button>
                        <button class="btn btn-primary" data-bs-dismiss="modal">Batal</button>
                    </div>
                </div>
            </div>
        </div>

    </div>
@endsection

@section('footer')
    <script type="module">
        const table = $('#DataTable').DataTable({
            processing : true,
            serverSide : true,
            ajax : "{!!route('barang.data')!!}",
            columns: [
                {
                    data: 'nama_barang',
                    name: 'nama_barang'
                },
                {
                    data: 'kode',
                    name: 'kode'
                },
                {
                    render: (data,type,row) => row.stok.jumlah,
                    name: 'stok'
                },
                {
                    render: (data,type,row) => {
                        return (`
                            <button class='btn btn-primary' id='btnEditBarang' data-bs-toggle='modal' data-bs-target='#modalPopup' attr-href="{!!url('/barang/edit/${row.id_barang}')!!}">
                                <i class='bi bi-pencil'></i> Edit 
                            </button> 
                            <button class='btn btn-danger'>
                                <i class='bi bi-trash'></i> Hapus 
                            </button>
                        `)
                    },
                    name: 'aksi'
                }
            ]
        })

        // function untuk menambahkan data barang baru ke database
        function tambahBarangBaruKeDatabase(){
            const data = {
                'nama_barang' : $('#namaBarang').val(),
                'kode' : $('#kodeBarang').val(),
                'harga' : $('#hargaBarang').val(),
                '_token' : '{{csrf_token()}}'
            }
            if(![data.nama_barang,data.kode,data.harga].includes('')){
                axios.post(`{{url('barang/simpan')}}`,data).then(({data})=>{
                    if(data.status == 'success'){
                        Swal.fire({
                            'title' : 'Berhasil',
                            'text' : data.pesan,
                            'icon' : 'success'
                        }).then(()=>{
                            // menutup modal ketika mengklik btnsimpan
                            bootstrap.Modal.getOrCreateInstance($('#modalPopup')).hide()
                            table.ajax.reload()
                        })
                    }
                    else {
                        Swal.fire({
                            'title' : 'Opps Data Gagal Ditambahkan',
                            'text' : data.pesan,
                            'icon' : 'error'
                        })
                    }
                })
            }
            else {
                Swal.fire({
                    'title' : 'Opps Gagal',
                    'text' : 'Form harus terisi semua',
                    'icon' : 'error'
                })
            }
        }

        // function untuk menampilkan isi dari modalPopup
        function menampilkanIsiModalPopup(eventClick,title){
            // const link = $(this).closest('.btnEditBarang').attr('attr-href')
            const link = eventClick.relatedTarget.getAttribute('attr-href')

            $('.modal-header .modal-title').html(title)

            // --- contoh menggunakan axios ---
            axios.get(link).then(({data}) => $('#modalPopup .modal-body').html(data))

            // --- contoh menggunakan ajax ---
            // $.ajax({
            //     url:link,
            //     method:'GET',
            //     success: ({data}) => $('#modalPopup .modal-body').html(data),
            // })
        }

        // ketika button edit di klik
        $('#DataTable tbody').on('click','#btnEditBarang', e =>{
            e.preventDefault() 
            e.stopImmediatePropagation()

            // ketika modalPopup tampil
            $('#modalPopup').on('shown.bs.modal', event =>{
                e.preventDefault() 
                e.stopImmediatePropagation()

                menampilkanIsiModalPopup(event,'Edit Data Barang')
            })
        })

        // ketika button edit di klik
        $('#btnTambahBarang').on('click', e =>{
            e.preventDefault() 
            e.stopImmediatePropagation()
            console.log(213)
            
            // ketika modalPopup tampil
            $('#modalPopup').on('shown.bs.modal', event =>{
                e.preventDefault() 
                e.stopImmediatePropagation()

                menampilkanIsiModalPopup(event,'Tambah Data Barang Baru')

                $('#btnSimpanBarang').on('click', e =>{
                    e.preventDefault() 
                    e.stopImmediatePropagation()

                    tambahBarangBaruKeDatabase()
                })
            })
        })
        // ketika modalPopup hilang
        $('#modalPopup').on('hidden.bs.modal', e =>{
            e.preventDefault() 
            e.stopImmediatePropagation()

            $('.modal-header .modal-title').html('')
            $('#modalPopup .modal-body').html('')
        })
    </script>
@endsection
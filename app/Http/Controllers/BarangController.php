<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBarangRequest;
use App\Models\BarangModel;
use Illuminate\Http\Request;
use Yajra\DataTables\DataTables;

class BarangController extends Controller
{
    //
    protected $id_barang;
    protected $nama_barang;
    protected $kode;
    protected $harga;
    protected $keterangan;
    protected $barangModel;

    public function __construct()
    {
        $this->barangModel = new BarangModel();
    }
    public function index(){
        return view('barang.index');
    }
    public function tambah(){
        return view('barang.tambah');
    }
    public function update(Request $request){
        $data = [
            'barangDetil' => BarangModel::where('id_barang',$request->id_barang)->first()  
        ];
        return view('barang.edit',$data);
    }
    
    public function delete(Request $request){
        
    }
    public function simpan(StoreBarangRequest $request){
        $data = $request->validated();
        if($data):
            if(isset($request->id_barang)):
                // proses update
                $perintah = BarangModel::where('id_barang',$request->id_barang)->update($data);
                if($perintah):
                    $pesan = [
                        'status' => 'success',
                        'pesan' => 'Data baru anda berhasil perbarui'
                    ];
                else:
                    $pesan = [
                        'status' => 'error',
                        'pesan' => 'Data baru anda gagal perbarui'
                    ];
                endif;
            else:
                // proses tambah data baru
                $dataBaru = BarangModel::create($data);
                if($dataBaru):
                    $pesan = [
                        'status' => 'success',
                        'pesan' => 'Data baru anda berhasil ditambahkan kedalam Database'
                    ];
                else:
                    $pesan = [
                        'status' => 'error',
                        'pesan' => 'Data baru anda gagal ditambahkan kedalam Database'
                    ];
                endif;
            endif;
        else:
            $pesan = [
                'status' => 'error',
                'pesan' => 'Proses Validasi Gagal'
            ];
        endif;
        return response()->json($pesan);
    }
    public function dataBarang(Request $request){
        if($request->ajax()):
            $data = $this->barangModel->with('stok')->get();
            return DataTables::of($data)->toJson();
        endif;
    }
}

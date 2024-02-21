<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

class BarangModel extends Model
{
    use HasFactory;
    protected $table = 'barang';
    protected $primaryKey = 'id_barang';
    protected $fillable =['nama_barang','kode','harga','keterangan'];
    public $timestamps = false;   

    public function stok():HasOne
    {
        return $this->hasOne(StokModel::class,'id_barang','id_barang');
    }
}

# Clothing System (FiveM)

Repository ini berisi kumpulan resource untuk server FiveM terkait sistem clothing, interaction, polyzone, dan library pendukung.

## Isi Resource

- `exter-lib` → utilitas shared/client/server (RPC, SQL helper, cache, dll)
- `exter-polyzone` → wrapper polyzone untuk kebutuhan area/zone
- `exter-interaction` → sistem interaction + UI
- `exter-clothing` → sistem clothing utama + web UI build
- `outfits` → sistem outfit + NUI build
- `qb-clothing` → resource qb-clothing versi terpisah
- `focusmanager` → pengelolaan focus UI

## Persyaratan

Sebelum instalasi, pastikan server memiliki dependency berikut:

- FiveM artifact yang mendukung `fx_version cerulean`
- `PolyZone`
- `oxmysql` (untuk resource yang membutuhkan query database)
- `qb-core` (untuk resource `qb-clothing`)

## Instalasi Cepat

1. Clone/copy repository ke folder resource server Anda.
2. Import SQL sesuai kondisi server:
   - Fresh install: jalankan `exter-clothing/clothing.sql`
   - Migrasi dari versi lama: jalankan `exter-clothing/clothing-fix.sql`
3. Tambahkan urutan `ensure` pada `server.cfg` (disarankan):

```cfg
ensure exter-lib
ensure exter-polyzone
ensure focusmanager
ensure exter-interaction
ensure exter-clothing
ensure outfits
# optional
ensure qb-clothing
```

4. Restart server.

## Catatan Integrasi Penting

Jika ada script Anda yang memanggil event:

- `qb-clothing:client:loadPlayerClothing`

maka **wajib** mengirim parameter `cid` dan `ped`:

```lua
local PlayerData = QBCore.Functions.GetPlayerData()
local cid = PlayerData.cid
local charPed = PlayerPedId()

TriggerEvent('qb-clothing:client:loadPlayerClothing', cid, charPed)
```

## Validasi yang Disarankan Setelah Instalasi

- Pastikan semua resource status `started` di console.
- Test buka UI clothing di dalam game.
- Test simpan & load outfit.
- Cek server console untuk error event/RPC/SQL.

## Troubleshooting Ringkas

- Jika pakaian gagal diload: verifikasi `cid` terkirim saat trigger event clothing.
- Jika zone tidak aktif: pastikan `PolyZone` ter-install dan `exter-polyzone` sudah `ensure`.
- Jika data pakaian tidak tersimpan: cek koneksi DB dan migrasi SQL sudah benar.

## Lisensi

Mengikuti file lisensi yang ada di repository ini (`LICENSE` dan lisensi per-resource jika tersedia).

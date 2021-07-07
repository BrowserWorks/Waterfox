# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

otr-auth =
    .title = Verifikasi identitas kontak
    .buttonlabelaccept = Verifikasi

# Variables:
#   $name (String) - the screen name of a chat contact person
auth-title = Verifikasi identitas { $name }

# Variables:
#   $own_name (String) - the user's own screen name
auth-your-fp-value = Sidik jari untuk Anda, { $own_name }:

# Variables:
#   $their_name (String) - the screen name of a chat contact
auth-their-fp-value = Sidik jari untuk { $their_name }:

auth-help = Memverifikasi identitas kontak membantu memastikan bahwa percakapan itu benar-benar pribadi, sehingga sangat sulit bagi pihak ketiga untuk menguping atau memanipulasi percakapan.
auth-helpTitle = Bantuan verifikasi

auth-questionReceived = Ini adalah pertanyaan yang diajukan oleh kontak Anda:

auth-yes =
    .label = Ya

auth-no =
    .label = Tidak

auth-verified = Saya telah memverifikasi bahwa ini adalah sidik jari yang benar.

auth-manualVerification = Verifikasi sidik jari manual
auth-questionAndAnswer = Pertanyaan dan jawaban
auth-sharedSecret = Rahasia bersama

auth-manualVerification-label =
    .label = { auth-manualVerification }

auth-questionAndAnswer-label =
    .label = { auth-questionAndAnswer }

auth-sharedSecret-label =
    .label = { auth-sharedSecret }

auth-manualInstruction = Hubungi mitra percakapan yang Anda maksud melalui beberapa kanal terotentikasi lainnya, seperti surel yang ditandatangani OpenPGP atau melalui telepon. Anda harus saling memberi tahu sidik jari Anda. (Sidik jari adalah checksum yang mengidentifikasi kunci enkripsi.) Jika sidik jari cocok, Anda harus menunjukkan dalam dialog di bawah ini bahwa Anda telah memverifikasi sidik jari.

auth-how = Bagaimana Anda ingin memverifikasi identitas kontak Anda?

auth-qaInstruction = Pikirkan pertanyaan yang jawabannya hanya diketahui oleh Anda dan kontak Anda. Masukkan pertanyaan dan jawaban, lalu tunggu kontak Anda memasukkan jawabannya. Jika jawabannya tidak cocok, kanal komunikasi yang Anda gunakan mungkin sedang dalam pengawasan.

auth-secretInstruction = Pikirkan rahasia yang hanya diketahui oleh Anda dan kontak Anda. Jangan gunakan koneksi internet yang sama untuk bertukar rahasia. Masukkan rahasia, lalu tunggu kontak Anda memasukkannya. Jika rahasia tidak cocok, saluran komunikasi yang Anda gunakan mungkin sedang dalam pengawasan.

auth-question = Ajukan pertanyaan:

auth-answer = Masukkan jawabannya (peka huruf besar kecil):

auth-secret = Masukkan rahasia:

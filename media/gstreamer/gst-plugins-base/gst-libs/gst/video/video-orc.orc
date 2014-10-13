.function video_orc_blend_little
.flags 1d
.dest 4 d guint8
.source 4 s guint8
.temp 4 t
.temp 2 tw
.temp 1 tb
.temp 4 a
.temp 8 d_wide
.temp 8 s_wide
.temp 8 a_wide
.const 4 a_alpha 0x000000ff

loadl t, s
convlw tw, t
convwb tb, tw
splatbl a, tb
x4 convubw a_wide, a
x4 shruw a_wide, a_wide, 8
x4 convubw s_wide, t
loadl t, d
x4 convubw d_wide, t
x4 subw s_wide, s_wide, d_wide
x4 mullw s_wide, s_wide, a_wide
x4 div255w s_wide, s_wide
x4 addw d_wide, d_wide, s_wide
x4 convwb t, d_wide
orl t, t, a_alpha
storel d, t

.function video_orc_blend_big
.flags 1d
.dest 4 d guint8
.source 4 s guint8
.temp 4 t
.temp 4 t2
.temp 2 tw
.temp 1 tb
.temp 4 a
.temp 8 d_wide
.temp 8 s_wide
.temp 8 a_wide
.const 4 a_alpha 0xff000000

loadl t, s
shrul t2, t, 24
convlw tw, t2
convwb tb, tw
splatbl a, tb
x4 convubw a_wide, a
x4 shruw a_wide, a_wide, 8
x4 convubw s_wide, t
loadl t, d
x4 convubw d_wide, t
x4 subw s_wide, s_wide, d_wide
x4 mullw s_wide, s_wide, a_wide
x4 div255w s_wide, s_wide
x4 addw d_wide, d_wide, s_wide
x4 convwb t, d_wide
orl t, t, a_alpha
storel d, t

.function video_orc_unpack_I420
.dest 4 d guint8
.source 1 y guint8
.source 1 u guint8
.source 1 v guint8
.const 1 c255 255
.temp 2 uv
.temp 2 ay
.temp 1 tu
.temp 1 tv

loadupdb tu, u
loadupdb tv, v
mergebw uv, tu, tv
mergebw ay, c255, y
mergewl d, ay, uv


.function video_orc_pack_I420
.dest 2 y guint8
.dest 1 u guint8
.dest 1 v guint8
.source 8 ayuv guint8
.temp 4 ay
.temp 4 uv
.temp 2 uu
.temp 2 vv
.temp 1 t1
.temp 1 t2

x2 splitlw uv, ay, ayuv
x2 select1wb y, ay
x2 splitwb vv, uu, uv
select0wb u, uu
select0wb v, vv

.function video_orc_unpack_YUY2
.dest 8 ayuv guint8
.source 4 yuy2 guint8
.const 2 c255 0xff
.temp 2 yy
.temp 2 uv
.temp 4 ayay
.temp 4 uvuv

x2 splitwb uv, yy, yuy2
x2 mergebw ayay, c255, yy
mergewl uvuv, uv, uv
x2 mergewl ayuv, ayay, uvuv


.function video_orc_pack_YUY2
.dest 4 yuy2 guint8
.source 8 ayuv guint8
.temp 2 yy
.temp 2 uv
.temp 4 ayay
.temp 4 uvuv

x2 splitlw uvuv, ayay, ayuv
select0lw uv, uvuv
x2 select1wb yy, ayay
x2 mergebw yuy2, yy, uv


.function video_orc_pack_UYVY
.dest 4 yuy2 guint8
.source 8 ayuv guint8
.temp 2 yy
.temp 2 uv
.temp 4 ayay
.temp 4 uvuv

x2 splitlw uvuv, ayay, ayuv
select0lw uv, uvuv
x2 select1wb yy, ayay
x2 mergebw yuy2, uv, yy


.function video_orc_unpack_UYVY
.dest 8 ayuv guint8
.source 4 uyvy guint8
.const 2 c255 0xff
.temp 2 yy
.temp 2 uv
.temp 4 ayay
.temp 4 uvuv

x2 splitwb yy, uv, uyvy
x2 mergebw ayay, c255, yy
mergewl uvuv, uv, uv
x2 mergewl ayuv, ayay, uvuv


.function video_orc_unpack_YVYU
.dest 8 ayuv guint8
.source 4 uyvy guint8
.const 2 c255 0xff
.temp 2 yy
.temp 2 uv
.temp 4 ayay
.temp 4 uvuv

x2 splitwb uv, yy, uyvy
swapw uv, uv
x2 mergebw ayay, c255, yy
mergewl uvuv, uv, uv
x2 mergewl ayuv, ayay, uvuv


.function video_orc_pack_YVYU
.dest 4 yuy2 guint8
.source 8 ayuv guint8
.temp 2 yy
.temp 2 uv
.temp 4 ayay
.temp 4 uvuv

x2 splitlw uvuv, ayay, ayuv
select0lw uv, uvuv
x2 select1wb yy, ayay
swapw uv, uv
x2 mergebw yuy2, yy, uv


.function video_orc_unpack_YUV9
.dest 8 d guint8
.source 2 y guint8
.source 1 u guint8
.source 1 v guint8
.const 1 c255 255
.temp 2 tuv
.temp 4 ay
.temp 4 uv
.temp 1 tu
.temp 1 tv

loadupdb tu, u
loadupdb tv, v
mergebw tuv, tu, tv
mergewl uv, tuv, tuv
x2 mergebw ay, c255, y
x2 mergewl d, ay, uv


.function video_orc_unpack_Y42B
.dest 8 ayuv guint8
.source 2 yy guint8
.source 1 u guint8
.source 1 v guint8
.const 1 c255 255
.temp 2 uv
.temp 2 ay
.temp 4 uvuv
.temp 4 ayay

mergebw uv, u, v
x2 mergebw ayay, c255, yy
mergewl uvuv, uv, uv
x2 mergewl ayuv, ayay, uvuv

.function video_orc_pack_Y42B
.dest 2 y guint8
.dest 1 u guint8
.dest 1 v guint8
.source 8 ayuv guint8
.temp 4 ayay
.temp 4 uvuv
.temp 2 uv

x2 splitlw uvuv, ayay, ayuv
select0lw uv, uvuv
splitwb v, u, uv
x2 select1wb y, ayay


.function video_orc_unpack_Y444
.dest 4 ayuv guint8
.source 1 y guint8
.source 1 u guint8
.source 1 v guint8
.const 1 c255 255
.temp 2 uv
.temp 2 ay

mergebw uv, u, v
mergebw ay, c255, y
mergewl ayuv, ay, uv


.function video_orc_pack_Y444
.dest 1 y guint8
.dest 1 u guint8
.dest 1 v guint8
.source 4 ayuv guint8
.temp 2 ay
.temp 2 uv

splitlw uv, ay, ayuv
splitwb v, u, uv
select1wb y, ay

.function video_orc_unpack_GRAY8
.dest 4 ayuv guint8
.source 1 y guint8
.const 1 c255 255
.const 2 c0x8080 0x8080
.temp 2 ay

mergebw ay, c255, y
mergewl ayuv, ay, c0x8080


.function video_orc_pack_GRAY8
.dest 1 y guint8
.source 4 ayuv guint8
.temp 2 ay

select0lw ay, ayuv
select1wb y, ay


.function video_orc_unpack_BGRA
.dest 4 argb guint8
.source 4 bgra guint8

swapl argb, bgra

.function video_orc_pack_BGRA
.dest 4 bgra guint8
.source 4 argb guint8

swapl bgra, argb

.function video_orc_pack_RGBA
.dest 4 rgba guint8
.source 4 argb guint8
.temp 1 a
.temp 1 r
.temp 1 g
.temp 1 b
.temp 2 rg
.temp 2 ba
.temp 2 ar
.temp 2 gb

splitlw gb, ar, argb
splitwb b, g, gb
splitwb r, a, ar
mergebw ba, b, a
mergebw rg, r, g
mergewl rgba, rg, ba

.function video_orc_unpack_RGBA
.dest 4 argb guint8
.source 4 rgba guint8
.temp 1 a
.temp 1 r
.temp 1 g
.temp 1 b
.temp 2 rg
.temp 2 ba
.temp 2 ar
.temp 2 gb

splitlw ba, rg, rgba
splitwb g, r, rg
splitwb a, b, ba
mergebw ar, a, r
mergebw gb, g, b
mergewl argb, ar, gb


.function video_orc_unpack_ABGR
.dest 4 argb guint8
.source 4 abgr guint8
.temp 1 a
.temp 1 r
.temp 1 g
.temp 1 b
.temp 2 gr
.temp 2 ab
.temp 2 ar
.temp 2 gb

splitlw gr, ab, abgr
splitwb r, g, gr
splitwb b, a, ab
mergebw ar, a, r
mergebw gb, g, b
mergewl argb, ar, gb


.function video_orc_pack_ABGR
.dest 4 abgr guint8
.source 4 argb guint8
.temp 1 a
.temp 1 r
.temp 1 g
.temp 1 b
.temp 2 gr
.temp 2 ab
.temp 2 ar
.temp 2 gb

splitlw gb, ar, argb
splitwb b, g, gb
splitwb r, a, ar
mergebw ab, a, b
mergebw gr, g, r
mergewl abgr, ab, gr

.function video_orc_unpack_NV12
.dest 8 d guint8
.source 2 y guint8
.source 2 uv guint8
.const 1 c255 255
.temp 4 ay
.temp 4 uvuv

mergewl uvuv, uv, uv
x2 mergebw ay, c255, y
x2 mergewl d, ay, uvuv

.function video_orc_pack_NV12
.dest 2 y guint8
.dest 2 uv guint8
.source 8 ayuv guint8
.temp 4 ay
.temp 4 uvuv

x2 splitlw uvuv, ay, ayuv
x2 select1wb y, ay
select0lw uv, uvuv

.function video_orc_unpack_NV21
.dest 8 d guint8
.source 2 y guint8
.source 2 vu guint8
.const 1 c255 255
.temp 2 uv
.temp 4 ay
.temp 4 uvuv

swapw uv, vu
mergewl uvuv, uv, uv
x2 mergebw ay, c255, y
x2 mergewl d, ay, uvuv


.function video_orc_pack_NV21
.dest 2 y guint8
.dest 2 vu guint8
.source 8 ayuv guint8
.temp 4 ay
.temp 4 uvuv
.temp 2 uv

x2 splitlw uvuv, ay, ayuv
x2 select1wb y, ay
select0lw uv, uvuv
swapw vu, uv

.function video_orc_unpack_NV24
.dest 4 d guint8
.source 1 y guint8
.source 2 uv guint8
.const 1 c255 255
.temp 2 ay

mergebw ay, c255, y
mergewl d, ay, uv

.function video_orc_pack_NV24
.dest 1 y guint8
.dest 2 uv guint8
.source 4 ayuv guint8
.temp 2 ay

splitlw uv, ay, ayuv
select1wb y, ay

.function video_orc_unpack_A420
.dest 4 d guint8
.source 1 y guint8
.source 1 u guint8
.source 1 v guint8
.source 1 a guint8
.temp 2 uv
.temp 2 ay
.temp 1 tu
.temp 1 tv

loadupdb tu, u
loadupdb tv, v
mergebw uv, tu, tv
mergebw ay, a, y
mergewl d, ay, uv

.function video_orc_pack_A420
.dest 2 y guint8
.dest 1 u guint8
.dest 1 v guint8
.dest 2 a guint8
.source 8 ayuv guint8
.temp 4 ay
.temp 4 uv
.temp 2 uu
.temp 2 vv

x2 splitlw uv, ay, ayuv
x2 select1wb y, ay
x2 select0wb a, ay
x2 splitwb vv, uu, uv
select0wb u, uu
select0wb v, vv

.function video_orc_resample_bilinear_u32
.dest 4 d1 guint8
.source 4 s1 guint8
.param 4 p1
.param 4 p2

ldreslinl d1, s1, p1, p2

.function video_orc_merge_linear_u8
.dest 1 d1
.source 1 s1
.source 1 s2
.param 1 p1
.temp 2 t1
.temp 2 t2
.temp 1 a
.temp 1 t

loadb a, s1
convubw t1, s1
convubw t2, s2
subw t2, t2, t1
mullw t2, t2, p1
addw t2, t2, 128
convhwb t, t2
addb d1, t, a

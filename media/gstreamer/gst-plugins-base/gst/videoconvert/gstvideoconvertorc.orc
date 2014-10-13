
.function video_convert_orc_memcpy_2d
.flags 2d
.dest 1 d1 guint8
.source 1 s1 guint8

copyb d1, s1

.function video_convert_orc_convert_I420_UYVY
.dest 4 d1 guint8
.dest 4 d2 guint8
.source 2 y1 guint8
.source 2 y2 guint8
.source 1 u guint8
.source 1 v guint8
.temp 2 uv

mergebw uv, u, v
x2 mergebw d1, uv, y1
x2 mergebw d2, uv, y2


.function video_convert_orc_convert_I420_YUY2
.dest 4 d1 guint8
.dest 4 d2 guint8
.source 2 y1 guint8
.source 2 y2 guint8
.source 1 u guint8
.source 1 v guint8
.temp 2 uv

mergebw uv, u, v
x2 mergebw d1, y1, uv
x2 mergebw d2, y2, uv



.function video_convert_orc_convert_I420_AYUV
.dest 4 d1 guint8
.dest 4 d2 guint8
.source 1 y1 guint8
.source 1 y2 guint8
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
mergebw ay, c255, y1
mergewl d1, ay, uv
mergebw ay, c255, y2
mergewl d2, ay, uv


.function video_convert_orc_convert_YUY2_I420
.dest 2 y1 guint8
.dest 2 y2 guint8
.dest 1 u guint8
.dest 1 v guint8
.source 4 yuv1 guint8
.source 4 yuv2 guint8
.temp 2 t1
.temp 2 t2
.temp 2 ty

x2 splitwb t1, ty, yuv1
storew y1, ty
x2 splitwb t2, ty, yuv2
storew y2, ty
x2 avgub t1, t1, t2
splitwb v, u, t1


.function video_convert_orc_convert_UYVY_YUY2
.flags 2d
.dest 4 yuy2 guint8
.source 4 uyvy guint8

x2 swapw yuy2, uyvy


.function video_convert_orc_planar_chroma_420_422
.flags 2d
.dest 1 d1 guint8
.dest 1 d2 guint8
.source 1 s guint8

copyb d1, s
copyb d2, s


.function video_convert_orc_planar_chroma_420_444
.flags 2d
.dest 2 d1 guint8
.dest 2 d2 guint8
.source 1 s guint8
.temp 2 t

splatbw t, s
storew d1, t
storew d2, t


.function video_convert_orc_planar_chroma_422_444
.flags 2d
.dest 2 d1 guint8
.source 1 s guint8
.temp 2 t

splatbw t, s
storew d1, t


.function video_convert_orc_planar_chroma_444_422
.flags 2d
.dest 1 d guint8
.source 2 s guint8
.temp 1 t1
.temp 1 t2

splitwb t1, t2, s
avgub d, t1, t2


.function video_convert_orc_planar_chroma_444_420
.flags 2d
.dest 1 d guint8
.source 2 s1 guint8
.source 2 s2 guint8
.temp 2 t
.temp 1 t1
.temp 1 t2

x2 avgub t, s1, s2
splitwb t1, t2, t
avgub d, t1, t2


.function video_convert_orc_planar_chroma_422_420
.flags 2d
.dest 1 d guint8
.source 1 s1 guint8
.source 1 s2 guint8

avgub d, s1, s2


.function video_convert_orc_convert_YUY2_AYUV
.flags 2d
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


.function video_convert_orc_convert_UYVY_AYUV
.flags 2d
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


.function video_convert_orc_convert_YUY2_Y42B
.flags 2d
.dest 2 y guint8
.dest 1 u guint8
.dest 1 v guint8
.source 4 yuy2 guint8
.temp 2 uv

x2 splitwb uv, y, yuy2
splitwb v, u, uv


.function video_convert_orc_convert_UYVY_Y42B
.flags 2d
.dest 2 y guint8
.dest 1 u guint8
.dest 1 v guint8
.source 4 uyvy guint8
.temp 2 uv

x2 splitwb y, uv, uyvy
splitwb v, u, uv


.function video_convert_orc_convert_YUY2_Y444
.flags 2d
.dest 2 y guint8
.dest 2 uu guint8
.dest 2 vv guint8
.source 4 yuy2 guint8
.temp 2 uv
.temp 1 u
.temp 1 v

x2 splitwb uv, y, yuy2
splitwb v, u, uv
splatbw uu, u
splatbw vv, v


.function video_convert_orc_convert_UYVY_Y444
.flags 2d
.dest 2 y guint8
.dest 2 uu guint8
.dest 2 vv guint8
.source 4 uyvy guint8
.temp 2 uv
.temp 1 u
.temp 1 v

x2 splitwb y, uv, uyvy
splitwb v, u, uv
splatbw uu, u
splatbw vv, v


.function video_convert_orc_convert_UYVY_I420
.dest 2 y1 guint8
.dest 2 y2 guint8
.dest 1 u guint8
.dest 1 v guint8
.source 4 yuv1 guint8
.source 4 yuv2 guint8
.temp 2 t1
.temp 2 t2
.temp 2 ty

x2 splitwb ty, t1, yuv1
storew y1, ty
x2 splitwb ty, t2, yuv2
storew y2, ty
x2 avgub t1, t1, t2
splitwb v, u, t1



.function video_convert_orc_convert_AYUV_I420
.flags 2d
.dest 2 y1 guint8
.dest 2 y2 guint8
.dest 1 u guint8
.dest 1 v guint8
.source 8 ayuv1 guint8
.source 8 ayuv2 guint8
.temp 4 ay
.temp 4 uv1
.temp 4 uv2
.temp 4 uv
.temp 2 uu
.temp 2 vv
.temp 1 t1
.temp 1 t2

x2 splitlw uv1, ay, ayuv1
x2 select1wb y1, ay
x2 splitlw uv2, ay, ayuv2
x2 select1wb y2, ay
x4 avgub uv, uv1, uv2
x2 splitwb vv, uu, uv
splitwb t1, t2, uu
avgub u, t1, t2
splitwb t1, t2, vv
avgub v, t1, t2



.function video_convert_orc_convert_AYUV_YUY2
.flags 2d
.dest 4 yuy2 guint8
.source 8 ayuv guint8
.temp 2 yy
.temp 2 uv1
.temp 2 uv2
.temp 4 ayay
.temp 4 uvuv

x2 splitlw uvuv, ayay, ayuv
splitlw uv1, uv2, uvuv
x2 avgub uv1, uv1, uv2
x2 select1wb yy, ayay
x2 mergebw yuy2, yy, uv1


.function video_convert_orc_convert_AYUV_UYVY
.flags 2d
.dest 4 yuy2 guint8
.source 8 ayuv guint8
.temp 2 yy
.temp 2 uv1
.temp 2 uv2
.temp 4 ayay
.temp 4 uvuv

x2 splitlw uvuv, ayay, ayuv
splitlw uv1, uv2, uvuv
x2 avgub uv1, uv1, uv2
x2 select1wb yy, ayay
x2 mergebw yuy2, uv1, yy



.function video_convert_orc_convert_AYUV_Y42B
.flags 2d
.dest 2 y guint8
.dest 1 u guint8
.dest 1 v guint8
.source 8 ayuv guint8
.temp 4 ayay
.temp 4 uvuv
.temp 2 uv1
.temp 2 uv2

x2 splitlw uvuv, ayay, ayuv
splitlw uv1, uv2, uvuv
x2 avgub uv1, uv1, uv2
splitwb v, u, uv1
x2 select1wb y, ayay


.function video_convert_orc_convert_AYUV_Y444
.flags 2d
.dest 1 y guint8
.dest 1 u guint8
.dest 1 v guint8
.source 4 ayuv guint8
.temp 2 ay
.temp 2 uv

splitlw uv, ay, ayuv
splitwb v, u, uv
select1wb y, ay


.function video_convert_orc_convert_Y42B_YUY2
.flags 2d
.dest 4 yuy2 guint8
.source 2 y guint8
.source 1 u guint8
.source 1 v guint8
.temp 2 uv

mergebw uv, u, v
x2 mergebw yuy2, y, uv


.function video_convert_orc_convert_Y42B_UYVY
.flags 2d
.dest 4 uyvy guint8
.source 2 y guint8
.source 1 u guint8
.source 1 v guint8
.temp 2 uv

mergebw uv, u, v
x2 mergebw uyvy, uv, y


.function video_convert_orc_convert_Y42B_AYUV
.flags 2d
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


.function video_convert_orc_convert_Y444_YUY2
.flags 2d
.dest 4 yuy2 guint8
.source 2 y guint8
.source 2 u guint8
.source 2 v guint8
.temp 2 uv
.temp 4 uvuv
.temp 2 uv1
.temp 2 uv2

x2 mergebw uvuv, u, v
splitlw uv1, uv2, uvuv
x2 avgub uv, uv1, uv2
x2 mergebw yuy2, y, uv


.function video_convert_orc_convert_Y444_UYVY
.flags 2d
.dest 4 uyvy guint8
.source 2 y guint8
.source 2 u guint8
.source 2 v guint8
.temp 2 uv
.temp 4 uvuv
.temp 2 uv1
.temp 2 uv2

x2 mergebw uvuv, u, v
splitlw uv1, uv2, uvuv
x2 avgub uv, uv1, uv2
x2 mergebw uyvy, uv, y


.function video_convert_orc_convert_Y444_AYUV
.flags 2d
.dest 4 ayuv guint8
.source 1 yy guint8
.source 1 u guint8
.source 1 v guint8
.const 1 c255 255
.temp 2 uv
.temp 2 ay

mergebw uv, u, v
mergebw ay, c255, yy
mergewl ayuv, ay, uv



.function video_convert_orc_convert_AYUV_ARGB
.flags 2d
.dest 4 argb guint8
.source 4 ayuv guint8
.param 2 p1
.param 2 p2
.param 2 p3
.param 2 p4
.param 2 p5
.temp 1 a
.temp 1 y
.temp 1 u
.temp 1 v
.temp 2 wy
.temp 2 wu
.temp 2 wv
.temp 2 wr
.temp 2 wg
.temp 2 wb
.temp 1 r
.temp 1 g
.temp 1 b
.temp 4 x
.const 1 c128 128

x4 subb x, ayuv, c128 
splitlw wv, wy, x
splitwb y, a, wy
splitwb v, u, wv

splatbw wy, y
splatbw wu, u
splatbw wv, v

mulhsw wy, wy, p1

mulhsw wr, wv, p2
addssw wr, wy, wr

mulhsw wb, wu, p3
addssw wb, wy, wb

mulhsw wg, wu, p4
addssw wg, wy, wg
mulhsw wy, wv, p5
addssw wg, wg, wy

convssswb r, wr
convssswb g, wg
convssswb b, wb

mergebw wr, a, r
mergebw wb, g, b
mergewl x, wr, wb
x4 addb argb, x, c128

.function video_convert_orc_convert_AYUV_BGRA
.flags 2d
.dest 4 bgra guint8
.source 4 ayuv guint8
.param 2 p1
.param 2 p2
.param 2 p3
.param 2 p4
.param 2 p5
.temp 1 a
.temp 1 y
.temp 1 u
.temp 1 v
.temp 2 wy
.temp 2 wu
.temp 2 wv
.temp 2 wr
.temp 2 wg
.temp 2 wb
.temp 1 r
.temp 1 g
.temp 1 b
.temp 4 x
.const 1 c128 128

x4 subb x, ayuv, c128 
splitlw wv, wy, x
splitwb y, a, wy
splitwb v, u, wv

splatbw wy, y
splatbw wu, u
splatbw wv, v

mulhsw wy, wy, p1

mulhsw wr, wv, p2
addssw wr, wy, wr

mulhsw wb, wu, p3
addssw wb, wy, wb

mulhsw wg, wu, p4
addssw wg, wy, wg
mulhsw wy, wv, p5
addssw wg, wg, wy

convssswb r, wr
convssswb g, wg
convssswb b, wb

mergebw wb, b, g
mergebw wr, r, a
mergewl x, wb, wr
x4 addb bgra, x, c128


.function video_convert_orc_convert_AYUV_ABGR
.flags 2d
.dest 4 argb guint8
.source 4 ayuv guint8
.param 2 p1
.param 2 p2
.param 2 p3
.param 2 p4
.param 2 p5
.temp 1 a
.temp 1 y
.temp 1 u
.temp 1 v
.temp 2 wy
.temp 2 wu
.temp 2 wv
.temp 2 wr
.temp 2 wg
.temp 2 wb
.temp 1 r
.temp 1 g
.temp 1 b
.temp 4 x
.const 1 c128 128

x4 subb x, ayuv, c128 
splitlw wv, wy, x
splitwb y, a, wy
splitwb v, u, wv

splatbw wy, y
splatbw wu, u
splatbw wv, v

mulhsw wy, wy, p1

mulhsw wr, wv, p2
addssw wr, wy, wr

mulhsw wb, wu, p3
addssw wb, wy, wb

mulhsw wg, wu, p4
addssw wg, wy, wg
mulhsw wy, wv, p5
addssw wg, wg, wy

convssswb r, wr
convssswb g, wg
convssswb b, wb

mergebw wb, a, b
mergebw wr, g, r
mergewl x, wb, wr
x4 addb argb, x, c128

.function video_convert_orc_convert_AYUV_RGBA
.flags 2d
.dest 4 argb guint8
.source 4 ayuv guint8
.param 2 p1
.param 2 p2
.param 2 p3
.param 2 p4
.param 2 p5
.temp 1 a
.temp 1 y
.temp 1 u
.temp 1 v
.temp 2 wy
.temp 2 wu
.temp 2 wv
.temp 2 wr
.temp 2 wg
.temp 2 wb
.temp 1 r
.temp 1 g
.temp 1 b
.temp 4 x
.const 1 c128 128

x4 subb x, ayuv, c128 
splitlw wv, wy, x
splitwb y, a, wy
splitwb v, u, wv

splatbw wy, y
splatbw wu, u
splatbw wv, v

mulhsw wy, wy, p1

mulhsw wr, wv, p2
addssw wr, wy, wr

mulhsw wb, wu, p3
addssw wb, wy, wb

mulhsw wg, wu, p4
addssw wg, wy, wg
mulhsw wy, wv, p5
addssw wg, wg, wy

convssswb r, wr
convssswb g, wg
convssswb b, wb

mergebw wr, r, g
mergebw wb, b, a
mergewl x, wr, wb
x4 addb argb, x, c128



.function video_convert_orc_convert_I420_BGRA
.dest 4 argb guint8
.source 1 y guint8
.source 1 u guint8
.source 1 v guint8
.param 2 p1
.param 2 p2
.param 2 p3
.param 2 p4
.param 2 p5
.temp 2 wy
.temp 2 wu
.temp 2 wv
.temp 2 wr
.temp 2 wg
.temp 2 wb
.temp 1 r
.temp 1 g
.temp 1 b
.temp 4 x
.const 1 c128 128

subb r, y, c128
splatbw wy, r
loadupdb r, u
subb r, r, c128
splatbw wu, r
loadupdb r, v
subb r, r, c128
splatbw wv, r

mulhsw wy, wy, p1

mulhsw wr, wv, p2
addssw wr, wy, wr

mulhsw wb, wu, p3
addssw wb, wy, wb

mulhsw wg, wu, p4
addssw wg, wy, wg
mulhsw wy, wv, p5
addssw wg, wg, wy

convssswb r, wr
convssswb g, wg
convssswb b, wb

mergebw wb, b, g
mergebw wr, r, 127
mergewl x, wb, wr
x4 addb argb, x, c128


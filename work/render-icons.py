import math, struct, zlib
from pathlib import Path

root=Path.cwd()

def cubic(p0,p1,p2,p3,n=60):
    out=[]
    for i in range(1,n+1):
        t=i/n; u=1-t
        out.append((u**3*p0[0]+3*u*u*t*p1[0]+3*u*t*t*p2[0]+t**3*p3[0],u**3*p0[1]+3*u*u*t*p1[1]+3*u*t*t*p2[1]+t**3*p3[1]))
    return out

def path(start, curves):
    pts=[start]; p=start
    for c1,c2,p3 in curves:
        pts.extend(cubic(p,c1,c2,p3)); p=p3
    return pts

outer=path((256,85),[
 ((236,133),(203,154),(167,177)),((133,199),(112,228),(112,268)),
 ((112,351),(173,419),(256,419)),((339,419),(400,351),(400,268)),
 ((400,228),(379,199),(345,177)),((309,154),(276,133),(256,85))])
inner=path((256,309),[
 ((282,330),(293,350),(293,371)),((293,392),(277,408),(256,408)),
 ((235,408),(219,392),(219,371)),((219,350),(230,330),(256,309))])

def inside(poly,x,y):
    c=False; j=len(poly)-1
    for i,(xi,yi) in enumerate(poly):
        xj,yj=poly[j]
        if (yi>y)!=(yj>y) and x < (xj-xi)*(y-yi)/(yj-yi)+xi: c=not c
        j=i
    return c

def png(path,size):
    # Supersample for smooth edges, then average coverage per pixel.
    scale=2; W=H=size*scale
    raw=bytearray()
    bg=(23,63,53); gold=(233,200,126)
    for y in range(size):
        raw.append(0)
        for x in range(size):
            counts=[0,0,0,0]
            for sy in range(scale):
                for sx in range(scale):
                    px=(x+(sx+.5)/scale)*512/size
                    py=(y+(sy+.5)/scale)*512/size
                    in_outer=inside(outer,px,py)
                    in_inner=inside(inner,px,py)
                    k=0 if in_inner else (1 if in_outer else 2)
                    counts[k]+=1
            a=scale*scale
            rgb=tuple((counts[0]*bg[c]+counts[1]*gold[c]+counts[2]*bg[c])//a for c in range(3))
            raw.extend((*rgb,255))
    def chunk(tag,data): return struct.pack('!I',len(data))+tag+data+struct.pack('!I',zlib.crc32(tag+data)&0xffffffff)
    header=struct.pack('!2I5B',size,size,8,6,0,0,0)
    (root/path).write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',header)+chunk(b'IDAT',zlib.compress(bytes(raw),9))+chunk(b'IEND',b''))

for name,size in [('icon-192.png',192),('icon-512.png',512),('apple-touch-icon.png',180),('favicon-32.png',32)]: png(name,size)

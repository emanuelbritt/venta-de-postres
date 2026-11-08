require 'zlib'

def cubic(p0,p1,p2,p3,n=16)
  (1..n).map do |i|
    t=i.to_f/n; u=1-t
    [u**3*p0[0]+3*u*u*t*p1[0]+3*u*t*t*p2[0]+t**3*p3[0],u**3*p0[1]+3*u*u*t*p1[1]+3*u*t*t*p2[1]+t**3*p3[1]]
  end
end
def path(start, curves)
  pts=[start]; p=start
  curves.each { |c1,c2,p3| pts.concat(cubic(p,c1,c2,p3)); p=p3 }
  pts
end
OUTER=path([256,85],[[[236,133],[203,154],[167,177]],[[133,199],[112,228],[112,268]],[[112,351],[173,419],[256,419]],[[339,419],[400,351],[400,268]],[[400,228],[379,199],[345,177]],[[309,154],[276,133],[256,85]]])
INNER=path([256,309],[[[282,330],[293,350],[293,371]],[[293,392],[277,408],[256,408]],[[235,408],[219,392],[219,371]],[[219,350],[230,330],[256,309]]])
def inside(poly,x,y)
  c=false; j=poly.length-1
  poly.each_with_index do |(xi,yi),i|
    xj,yj=poly[j]
    c=!c if ((yi>y)!=(yj>y)) && x < (xj-xi)*(y-yi).to_f/(yj-yi)+xi
    j=i
  end
  c
end
def chunk(tag,data)
  [data.bytesize].pack('N')+tag+data+[Zlib.crc32(tag+data)].pack('N')
end
def render(name,size)
  bg=[23,63,53]; gold=[233,200,126]; scale=1; raw=''.b
  size.times do |y|
    raw << "\0".b
    size.times do |x|
      counts=[0,0,0]
      scale.times do |sy|
        scale.times do |sx|
          px=(x+(sx+0.5)/scale)*512.0/size; py=(y+(sy+0.5)/scale)*512.0/size
          k=inside(INNER,px,py) ? 0 : (inside(OUTER,px,py) ? 1 : 2)
          counts[k]+=1
        end
      end
      3.times { |c| raw << ((counts[0]*bg[c]+counts[1]*gold[c]+counts[2]*bg[c])/(scale*scale)).chr }
      raw << "\xff".b
    end
  end
  ihdr=[size,size,8,6,0,0,0].pack('NNC5')
  png="\x89PNG\r\n\x1a\n".b+chunk('IHDR',ihdr)+chunk('IDAT',Zlib::Deflate.deflate(raw,9))+chunk('IEND',''.b)
  File.binwrite(name,png)
end
[['icon-192.png',192],['icon-512.png',512],['apple-touch-icon.png',180],['favicon-32.png',32]].each { |name,size| render(name,size) }

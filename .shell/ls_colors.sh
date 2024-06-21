# LS COLORS

# di = directories
# fi = files
# ln = symbolic link
# pi = named pipe
# so = socket
# bd = blocked device
# cd = character device
# or = orphan symbolic
# mi = missing file
# ex = executable file
# *.x = extension x
# ...

LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:"

# Archives
for file in .tar .tgz .arc .arj .taz .lha .lz4 .lzh .lzma .tlz .txz .tzo .t7z .zip .z .dz .gz .lrz .lz .lzo .xz .zst .tzst .bz2 .bz .tbz .tbz2 .tz .deb .rpm .jar .war .ear .sar .rar .alz .ace .zoo .cpio .7z .rz .cab .wim .swm .dwm .esd;
do
    LS_COLORS="${LS_COLORS}*${file}=4;${RED}:";
done

# Media
for file in .jpg .jpeg .mjpg .mjpeg .gif .bmp .pbm .pgm .ppm .tga .xbm .xpm .tif .tiff .png .svg .svgz .mng .pcx .mov .mpg .mpeg .m2v .mkv .webm .ogm .mp4 .m4v .mp4v .vob .qt .nuv .wmv .asf .rm .rmvb .flc .avi .fli .flv .gl .dl .xcf .xwd .yuv .cgm .emf .ogv .ogx;
do
    LS_COLORS="${LS_COLORS}*${file}=${L_CYAN}:";
done
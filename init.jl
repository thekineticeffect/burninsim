using Pkg
pkg"activate Burner"
using Revise
using Burner
using Images
using VideoIO

width = 512
height = 288

demodisp = Burner.Display(ones(3, height, width), 0.1)
imageburn = imresize(load("17498.jpg"), (height, width))
imageshow = Float64.(Images.channelview(imresize(load("descargar-images-full-hd-1080p.jpg"), (height, width))))

for i = 1:50
    rotimg = RGB.(Burner.permuteImage(imageburn, 0))
    Burner.evolve(demodisp, channelview(rotimg), 0.1)
end
imagepresented = colorview(RGB, Burner.present(demodisp, imageshow))

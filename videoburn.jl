using Pkg
pkg"activate Burner"
# using Revise
using Burner
using Images
using VideoIO
using BSON

width = 512
height = 288

demodisp = Burner.Display(ones(3, height, width), 0.0015)
video = VideoIO.openvideo("oblivion.mp4")
imageshow = Float64.(Images.channelview(imresize(load("descargar-images-full-hd-1080p.jpg"), (height, width))))

Burner.burnVideo(demodisp, video, 1.0/30.0)
imagepresented = colorview(RGB, Burner.present(demodisp, imageshow))
imagepresented
bson("results.bson", Dict(:display => demodisp, :demoimage => imagepresented))

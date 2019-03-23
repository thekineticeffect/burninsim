module Burner
using Images
using VideoIO

mutable struct Display{V}
   maxEmission::Array{V,3}
   decayRate::Number
end

function evolve(d::Display, img, dt::Number)
    decay = d.decayRate*dt
    @inbounds @views @. d.maxEmission -= decay*d.maxEmission*img
    return
end

function present(d::Display, img)
    imageout = similar(img)
    @inbounds @views @. imageout = d.maxEmission*img
    return imageout
end

function permuteImage(img, index)
    h_mutation = 10*index
    s_mutation = 0.1*index
    v_mutation = 0.1*index
    imghsv = HSV.(img)
    return [HSV((pixel.h + h_mutation) % 360.0, (pixel.s + s_mutation) % 1.0, (pixel.v + v_mutation) % 1.0) for pixel in imghsv]
end

function burnVideo(d::Display, f, frameDt, maxT = 0, transform! = (img, t) -> nothing)
    seekstart(f)
    t = 0.0
    imgFull = read(f)
    dims = size(d.maxEmission)[2:3]
    print(dims)
    imgSmall = imresize(imgFull, dims)
    transform!(imgSmall, t)
    evolve(d, Images.channelview(imgSmall), frameDt)
    while !eof(f)
        t += frameDt
        println(t)
        read!(f, imgFull)
        imgSmall = imresize(imgFull, dims)
        transform!(imgSmall, t)
        evolve(d, Images.channelview(imgSmall), frameDt)
        if maxT > 0 && t >= maxT
            break
        end
    end
end

end # module

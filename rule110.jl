using PyPlot

M = 25
N = 30

state = zeros(Int,N)
state[1]  = 1
state[2]  = 1
state[4]  = 1
state[9]  = 1
state[12] = 1
state[16] = 1
state[22] = 1
state[29] = 1
state[30] = 1

next = zeros(Int,N)
Mat = zeros(Int,M,N)

for it in 1:M
    for i in 2:(N-1)
        s = state[(i-1):(i+1)]
        if (s == [1,1,1] || s == [1,0,0] || s == [0,0,0])
            next[i] = 0
        else
            next[i] = 1
        end
    end

    global state = copy(next)
    
    Mat[it,:] = state
end

imshow(Mat)
show()

using Plots

function critical(board,y,x)
    Ly,Lx = size(board)
    c = false
    
    if (y > 1)
        if (board[y-1,x] == 1)
            c = c | true
        end
    end
    if (y < Ly)
        if (board[y+1,x] == 1)
            c = c | true
        end
    end
    if (x > 1)
        if (board[y,x-1] == 1)
            c = c | true
        end
    end
    if (x < Lx)
        if (board[y,x+1] == 1)
            c = c | true
        end
    end
    
    return c
end

function process!(board,process)
    p1 = 0.40
    p2 = 0.60
    p3 = 0.80
    
    Ly,Lx = size(board)

   while(length(process) > 0)
        i,j = pop!(process)
        board[i,j] -= 1
        place = false
        r = rand()
        if (r < p1)
            if (j < Lx)
                ni = i
                nj = j + 1
                place = true
            end
        elseif (r < p2)
            if (j > 1)
                ni = i
                nj = j - 1
                place = true
            end
        elseif (r < p3)
            if (i < Ly)
                ni = i + 1
                nj = j
                place = true
            end
        else
            if (i > 1)
                ni = i -1
                nj = j
                place = true
            end
        end
        
        if (place == true)
            board[ni,nj] += 1
            c = board[ni,nj] > 1                                                 # Fermionic
            c |= critical(board,ni,nj)                                           # e-e repulsion
            #c |= (((nj > 2 && nj <= 4) || (nj > 6 && nj <= 8)) && ni > 6)       # dot
            c |= ni ≤ 1 || ni ≥ Ly                                               # walls
                       
            if (c)
                push!(process,(ni,nj))
            end
        end
    end
end

function move!(board)
    Ly,Lx = size(board)
    
    list = []
    for j in 1:Lx
        for i in 1:Ly
            if (board[i,j] == 1)
                push!(list,(i,j))
            end
        end
    end
    r = rand(1:length(list))
    i,j = list[r]
    
    process = [(i,j)]
    process!(board,process)
end

function action!(board)
    Ly,Lx = size(board)
    i = Ly÷2
    j = 1
    
    process = [(i,j)]
    board[i,j] += 1

    process!(board,process)
end
    
#=========================================================#
#                          MAIN                           #
#=========================================================#
Lx = 100
Ly = 60
board = zeros(Ly,Lx)



if (false)
    anim = @animate for i = 1:2000
        heatmap(board)
        action!(board)
        
        n = 0
        for j in 1:Lx
            for i in 1:Ly
                if (board[i,j] == 1)
                    n += 1
                end
            end
        end
        for ag in 1:n
            move!(board)
        end
    end

    gif(anim, "test.gif", fps = 30)
end

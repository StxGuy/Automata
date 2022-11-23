# Brian Silverman's Wireworld

using Plots

function initialize(Ny,Nx)
    grid = zeros(Ny,Nx)
    
#     grid[7,1:15] .= 3
#     grid[7,1] = 1
    
    grid[4,1:6] .= 3
    grid[4,9:15] .= 3
    grid[4,7] = 3
    grid[4,1] = 1
    grid[3,7:8] .= 3
    grid[5,7:8] .= 3
        
    grid[10,1:6] .= 3
    grid[10,9:15] .= 3
    grid[10,8] = 3
    grid[10,1] = 1
    grid[9,7:8] .= 3
    grid[11,7:8] .= 3
    
    return grid
end 

# 0: empty
# 1: head
# 2: tail
# 3: conductor

function Nei(M,i,j)
    Ny,Nx = size(M)
   
    n = 0
    periodic = false
    vonNeumann = [(-1,0),(1,0),(0,-1),(0,1)]
    Moore = vonNeumann ∪ [(1,1),(1,-1),(-1,1),(-1,-1)]
    for (ei,ej) in Moore
        ri = i + ei
        rj = j + ej
        
        if (periodic == true)
            if (ri < 1)
                ri = Ny
            end
            if (ri > Ny)
                ri = 1
            end
            if (rj < 1)
                rj = Nx
            end
            if (rj > Nx)
                rj = 1
            end
            
            if (M[ri,rj] == 1)
                n += 1
            end
        elseif (ri ≥ 1 && ri ≤ Ny && rj ≥ 1 && rj ≤ Nx)
        
            if (M[ri,rj] == 1)
                n += 1
            end
        end
    end
    
    return n
end

# Transition rules
function action(grid)
    Ny,Nx = size(grid)
    ngrid = copy(grid)
    
    for j in 1:Nx
        for i in 1:Ny
            if (grid[i,j] == 1) 
                ngrid[i,j] = 2
            elseif (grid[i,j] == 2)
                ngrid[i,j] = 3
            elseif (grid[i,j] == 3)
                n = Nei(grid,i,j)
                if (n == 1 || n == 2)
                    ngrid[i,j] = 1
                end
            end
        end
    end
    
    return ngrid
end

#===============================#
state = initialize(15,15)

anim = @animate for i = 1:15
    global state = action(state)
    heatmap(state)
end

gif(anim, "test.gif", fps = 10)
    
            

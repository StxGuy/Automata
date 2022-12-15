using Plots

function initialize(Ny,Nx)
    C = zeros(Int,Ny,Nx)

    pattern = 2
    if (pattern == 0)
        for j in 1:Nx
            for i in 1:Ny
                r = rand()
                
                if (r < 0.003)
                    C[i,j] = 1
                elseif (r < 0.01)
                    C[i,j] = 2
                end
            end
        end
    elseif (pattern == 1)
        C[Ny÷2,Nx÷2] = 1
        C[Ny÷4,Nx÷3+1] = 1
    else
        for j in (Nx÷4):(3*Nx÷4)
            C[Ny÷2,j] = 1
            C[Ny÷2+1,j] = 2
        end
    end
    
    return C
end

function R(a)
    if (a == 1)
        return 2
    else
        return 0
    end
end

function D(a,v)
    if (a == 0)
        N = false
        for vi in v
            N |= (vi == 1)
        end
    
        return N
    else
        return 0
    end
end

function rule(a,am,v)
    return R(a) + D(a,v) + mod(-am,3)
end

function viz(map,i,j)
    Ny,Nx = size(map)

    vonNeumann = [(-1,0),(1,0),(0,-1),(0,1)]
    Moore = vonNeumann ∪ [(1,1),(1,-1),(-1,1),(-1,-1)]
    
    periodic = true
    v = []
    
    for (ei,ej) in vonNeumann
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
            
            push!(v,map[ri,rj])
            
        elseif (ri ≥ 1 && ri ≤ Ny && rj ≥ 1 && rj ≤ Nx)
            push!(v,map[ri,rj])
        end
    end
    
    return v
end

            
Lx = 150
Ly = 150
new_map = zeros(Int,Ly,Lx)
last_map = zeros(Int,Ly,Lx)
#map = initialize(Ly,Lx)
#new_map = copy(map)
map = zeros(Int,Ly,Lx)
new_map[15,15] = 1
new_map[34,15] = 1
new_map[33,34] = 1

anim = @animate for it in 1:1000
    global last_map = copy(map)
    global map = copy(new_map)

    heatmap(map)    
    
    for j in 1:Lx
        for i in 1:Ly
            global new_map[i,j] = rule(map[i,j],last_map[i,j],viz(map,i,j))
        end
    end
    
end

gif(anim, "test.gif", fps = 10)



        
        


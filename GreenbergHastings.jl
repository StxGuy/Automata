# Greenberg-Hastings Automata

using Plots

function initialize(Ny,Nx)
    C = zeros(Ny,Nx)

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
        

function action(C)
    Ny,Nx = size(C)
    nC = zeros(Ny,Nx)
    
    # 0: Resting
    # 1: Excited
    # 2: Refractory
    
    for j in 1:Nx
        for i in 1:Ny
            if (C[i,j] == 1)
                nC[i,j] = 2
            elseif (C[i,j] == 2)
                nC[i,j] = 0
            elseif (Nei(C,i,j) > 0)
                nC[i,j] = 1
            end
        end
    end
    
    return nC
end

#===============================#
state = initialize(100,100)

anim = @animate for i = 1:200
    global state = action(state)
    heatmap(state)
end

gif(anim, "test.gif", fps = 10)
    
                
        

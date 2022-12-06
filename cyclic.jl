using Plots


function successor(x,n)
    if (x == n)
        return 1
    else
        return x + 1
    end
end    
  

function action(grid)
    L = size(grid,1)
    
    next = copy(grid)
    threshold = 1
    
    for j in 1:L
        for i in 1:L
        
            s = successor(grid[i,j],n)
            c = 0
            for (ri,rj) in [(-1,0),(1,0),(0,1),(0,-1),(-1,-1),(-1,1),(1,-1),(1,1)]
                vi = i + ri
                vj = j + rj
                
                if (vi ≥ 1 && vi ≤ L && vj ≥ 1 && vj ≤ L)
                    if (grid[vi,vj] == s)
                        c += 1
                    end
                end
            end
            
            if (c ≥ threshold)
                next[i,j] = s
            end
        end
    end
    
    return next
end

n = 16
L = 100
grid = rand(1:n,L,L)

anim = @animate for i = 1:1000
    global grid = action(grid)
    heatmap(grid)
end

gif(anim, "test.gif", fps = 50)


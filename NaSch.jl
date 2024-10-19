using PyPlot
using Random

function Nasch!(road::Vector{Int},vmax::Int,p::Float64)
    L = length(road)
    gaps = zeros(Int,L)
    
    for i in 1:L
        if road[i] > 0
            gap = 1
            while road[mod1(i+gap,L)] == 0 && gap < L
                gap += 1
            end
            gaps[i] = gap - 1
        end
    end
        
    new_road = zeros(Int,L)
    for i in 1:L
        if road[i] > 0
            # Acceleration
            v = min(road[i]+1,vmax) 
            # Slow down
            v = min(v,gaps[i]) 
            # Randomization
            if rand() < p
                v = max(v-1,0)  
            end
            new_pos = mod1(i+v,L)
            new_road[new_pos] = v
        end
    end
    
    road .= new_road
end

function simulate(L::Int,N::Int,vmax::Int,p::Float64,steps::Int, equil::Int)
    road = zeros(Int,L)
    road[1:N] .= mod1(vmax,2)
    shuffle!(road)
    
    # Equilibration
    for _ in 1:equil
        Nasch!(road,vmax,p)
    end
    
    # Measurement
    total_flow = 0
    for _ in 1:steps
        previous_road = copy(road)
        Nasch!(road,vmax,p)
        # Count vehicles passing position 0
        total_flow += sum(road[i] > 0 && previous_road[i] == 0 for i in 1:L)
    end
    
    density = N/L
    flow = total_flow/(steps)
    
    return density,flow
end

L = 1000
vmax = 4
p = 0.75
steps = 2000
equil = 2000

densities = 0:0.01:1
flows = Float64[]

for density in densities
    N = round(Int,density*L)
    #p = 0.05 + 0.3*density
    density,flow = simulate(L,N,vmax,p,steps,equil)
    push!(flows,flow)
end

scatter(densities,flows)
xlabel("Density [vehicles/cell]")
ylabel("Flow [vehicles/period]")
show()

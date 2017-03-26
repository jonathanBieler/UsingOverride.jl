using Base.Test
using UsingOverride

data = rand(100)

#load M1 for the first time
module M1

    export T1, x, do_thing

    immutable T1
        x::Int
    end
    x = T1(1)
    
    do_thing(x::Vector) = sum(x.^2)
    do_thing(x::T1) = 1
end

@override M1

old_T1 = T1(1)

@assert x == T1(1)
@assert do_thing(x) == 1
@assert do_thing(data) == sum(data.^2)

# Make some changs to M1
module M1

    export T1, x, do_thing

    immutable T1
        x::Int
        y::Float64
    end
    global const x = T1(2,1.0)
    
    do_thing(x::Vector) = sin(x.^2)
    do_thing(x::T1) = 2
end

@override M1

@assert x == T1(2,1.0)
@assert do_thing(x) == 2
@assert do_thing(data) == sin(data.^2)

@test_throws MethodError do_thing(old_T1)


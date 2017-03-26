module UsingOverride

    export @override

    macro override(m)
        esc(_override(m))
    end

    function _override(m)
        me = eval(Main,m)
        ns = names(me)
        ex = Expr[]
        for n in ns
            n == m && continue
            ov = Expr(:(=),n, Expr(:call,:getfield,m, QuoteNode(n) ) )
            check = Expr(:call,:isdefined,:Main,QuoteNode(n))
            push!(ex,:( $check && $ov ))
        end
        use_ex = :( using $m )
        Expr(:block,use_ex,ex...)
    end

end
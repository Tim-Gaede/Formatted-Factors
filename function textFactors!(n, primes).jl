using Formatting

#-------------------------------------------------------------------------------
function superscript(n::Int)
    if n == 0;    return "⁰"; end

    res = ""
    sups = ["¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰"]
    rem = n
    while rem > 0
        d = rem % 10 # digit
        rem ÷= 10

        d == 0    ?    res *= string(sups[10])    :    res *= string(sups[d])
    end

    reverse(res) # returned
end
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
function textFactors!(n::Int, primes::Array{Int,1})
# Returns a sorted list of all divisors of n.
# Will extend the array of primes if possibly inadequate for factorization
    if n  < 2;    throw("n must be greater than one."); end

    factors = Int64[]
    pwrs  = Int64[]

    # Extend the array of primes if it may be inadequate
    sqrt_n_up = convert(Int64, ceil(√n))
    if sqrt_n_up > last(primes)
        primes′ = primesTo(2sqrt_n_up)
        for i = length(primes) + 1 : length(primes′)
            push!(primes, primes′[i])
        end
    end

    rem = n
    sqrt_rem_down = convert(Int64, floor(√rem))
    i = 1
    while rem ≠ 1    &&    primes[i] ≤ sqrt_rem_down
        if rem % primes[i] == 0

            push!(factors, primes[i])
            pwr = 0
            while rem % primes[i] == 0
                rem ÷= primes[i]
                pwr += 1
            end
            push!(pwrs, pwr)
        end
        sqrt_rem_down = convert(Int64, floor(√rem)) # Speed up or slow down?
        i += 1
    end
    if rem ≠ 1
        push!(factors, rem)
        push!(pwrs, 1)
    end


    res = format(n, commas=true) * " = "
    for i = 1 : length(factors) - 1
        res *= format(factors[i], commas=true) * superscript(pwrs[i]) * " × "
    end


    res *= format(last(factors), commas=true) * superscript(last(pwrs))


    res # returned
end
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
function primesTo(n::Integer)
    if n < 2;    return []; end
    primes = Int64[2]
    sizehint!(primes, convert( Int64, floor( n / log(n) ) ))
    oddsAlive = trues((n-1) ÷ 2) # oddsAlive[i] represents 2i + 1

    i_sqrt = (convert( Int64, floor(√n) ) - 1) ÷ 2
    for i = 1 : i_sqrt
        if oddsAlive[i] # It's prime.  Kill odd multiples of it
            push!(primes, 2i + 1)
            Δᵢ = 2i + 1
            for iₓ = i+Δᵢ : Δᵢ : length(oddsAlive);   oddsAlive[iₓ] = false; end
        end
    end
    for i = i_sqrt + 1 : length(oddsAlive) # Remaining living odds also prime
        if oddsAlive[i];    push!(primes, 2i + 1); end
    end

    primes
end
#-------------------------------------------------------------------------------


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function main()
    primes = primesTo(7)
    println(textFactors!(240051200, primes))
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main()

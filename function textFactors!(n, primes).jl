using Formatting

#-------------------------------------------------------------------------------
function superscript(n::Int)
    if n == 0;    "⁰";    end

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
# Will extend the array of primes if possibly inadequate for factorization
    if n < 2;    throw("n must be greater than one."); end

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
function textFactors!(nums::Array{Int,1}, primes::Array{Int,1})
# Will extend the array of primes if possibly inadequate for factorization

    # Get the maximum width of the formatted number in nums .................
    nDigits_max = 0
    for n in nums
        nDigits = convert(Int, floor(log10(n))) + 1
        if nDigits > nDigits_max
            nDigits_max = nDigits
        end
    end
    nCommas_max = (nDigits_max - 1) ÷ 3
    pad = nDigits_max + nCommas_max
    # .......................................................................

    res = ""
    for n in nums
        n_fmd = lpad(format(n, commas=true), pad)

        if n < 2
            res *= n_fmd * "   has no prime factors"
        end

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


        res *= n_fmd * " = "
        for i = 1 : length(factors) - 1
            f_fmd = format(factors[i], commas=true)
            res *= f_fmd * superscript(pwrs[i]) * " × "
        end
        res *= format(last(factors), commas=true) * superscript(last(pwrs))
        res *= "\n"
    end



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

    primes # returned
end
#-------------------------------------------------------------------------------


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function main()
    println("\n", "-"^50, "\n")
    primes = primesTo(7)


    println(textFactors!(240_051_200, primes))
    nums = [5040, 7680, 10_000, 10_240, 143_496_441, 240_051_200, 1517]
    print(textFactors!(nums, primes)) 
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main()

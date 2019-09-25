# Formatted-Factors
These are functions that return formatted text of the prime factors of a number.  
They use comma separators and superscripts. 

Examples:

julia> println(textFactors!(240051200, primes))

240,051,200 = 2¹⁰ × 5² × 9,377¹


julia> print(textFactors!(nums, primes))
      
143,496,441 = 3⁴ × 11⁶
240,051,200 = 2¹⁰ × 5² × 9,377¹
      1,517 = 37¹ × 41¹


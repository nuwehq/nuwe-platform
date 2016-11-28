module Nu
  class BmiPrimeLookup

    def initialize(prime)
      @prime = prime
    end

    def value
      if      @prime > 0.0  && @prime <= 0.6  then return 4
      elsif   @prime > 0.6  && @prime <= 0.61 then return 10
      elsif   @prime > 0.61 && @prime <= 0.62 then return 15
      elsif   @prime > 0.62 && @prime <= 0.63 then return 21
      elsif   @prime > 0.63 && @prime <= 0.64 then return 27
      elsif   @prime > 0.64 && @prime <= 0.65 then return 33
      elsif   @prime > 0.65 && @prime <= 0.66 then return 39
      elsif   @prime > 0.66 && @prime <= 0.67 then return 44
      elsif   @prime > 0.67 && @prime <= 0.68 then return 50
      elsif   @prime > 0.68 && @prime <= 0.69 then return 56
      elsif   @prime > 0.69 && @prime <= 0.7  then return 62
      elsif   @prime > 0.7  && @prime <= 0.71 then return 68
      elsif   @prime > 0.71 && @prime <= 0.72 then return 73
      elsif   @prime > 0.72 && @prime <= 0.73 then return 79
      elsif   @prime > 0.73 && @prime <= 0.74 then return 85
      elsif   @prime > 0.74 && @prime <= 0.75 then return 86
      elsif   @prime > 0.75 && @prime <= 0.76 then return 87
      elsif   @prime > 0.76 && @prime <= 0.77 then return 88
      elsif   @prime > 0.77 && @prime <= 0.78 then return 89
      elsif   @prime > 0.78 && @prime <= 0.79 then return 90
      elsif   @prime > 0.79 && @prime <= 0.8  then return 91
      elsif   @prime > 0.8  && @prime <= 0.81 then return 92
      elsif   @prime > 0.81 && @prime <= 0.82 then return 93
      elsif   @prime > 0.82 && @prime <= 0.83 then return 94
      elsif   @prime > 0.83 && @prime <= 0.84 then return 95
      elsif   @prime > 0.84 && @prime <= 0.85 then return 96
      elsif   @prime > 0.85 && @prime <= 0.86 then return 97
      elsif   @prime > 0.86 && @prime <= 0.87 then return 98
      elsif   @prime > 0.87 && @prime <= 0.88 then return 99
      elsif   @prime > 0.88 && @prime <= 0.89 then return 100
      elsif   @prime > 0.89 && @prime <= 0.9  then return 99
      elsif   @prime > 0.9  && @prime <= 0.91 then return 98
      elsif   @prime > 0.91 && @prime <= 0.92 then return 97
      elsif   @prime > 0.92 && @prime <= 0.93 then return 96
      elsif   @prime > 0.93 && @prime <= 0.94 then return 95
      elsif   @prime > 0.94 && @prime <= 0.95 then return 94
      elsif   @prime > 0.95 && @prime <= 0.96 then return 93
      elsif   @prime > 0.96 && @prime <= 0.97 then return 92
      elsif   @prime > 0.97 && @prime <= 0.98 then return 91
      elsif   @prime > 0.98 && @prime <= 0.99 then return 90
      elsif   @prime > 0.99 && @prime <= 1.0  then return 89
      elsif   @prime > 1.0  && @prime <= 1.01 then return 88
      elsif   @prime > 1.01 && @prime <= 1.02 then return 86
      elsif   @prime > 1.02 && @prime <= 1.03 then return 85
      elsif   @prime > 1.03 && @prime <= 1.04 then return 83
      elsif   @prime > 1.04 && @prime <= 1.05 then return 82
      elsif   @prime > 1.05 && @prime <= 1.06 then return 81
      elsif   @prime > 1.06 && @prime <= 1.07 then return 79
      elsif   @prime > 1.07 && @prime <= 1.08 then return 78
      elsif   @prime > 1.08 && @prime <= 1.09 then return 76
      elsif   @prime > 1.09 && @prime <= 1.1  then return 75
      elsif   @prime > 1.1  && @prime <= 1.11 then return 74
      elsif   @prime > 1.11 && @prime <= 1.12 then return 72
      elsif   @prime > 1.12 && @prime <= 1.13 then return 70
      elsif   @prime > 1.13 && @prime <= 1.14 then return 69
      elsif   @prime > 1.14 && @prime <= 1.15 then return 68
      elsif   @prime > 1.15 && @prime <= 1.16 then return 67
      elsif   @prime > 1.16 && @prime <= 1.17 then return 65
      elsif   @prime > 1.17 && @prime <= 1.18 then return 64
      elsif   @prime > 1.18 && @prime <= 1.19 then return 63
      elsif   @prime > 1.19 && @prime <= 1.2  then return 61
      elsif   @prime > 1.2  && @prime <= 1.21 then return 60
      elsif   @prime > 1.21 && @prime <= 1.22 then return 58
      elsif   @prime > 1.22 && @prime <= 1.23 then return 57
      elsif   @prime > 1.23 && @prime <= 1.24 then return 55
      elsif   @prime > 1.24 && @prime <= 1.25 then return 54
      elsif   @prime > 1.25 && @prime <= 1.26 then return 53
      elsif   @prime > 1.26 && @prime <= 1.27 then return 51
      elsif   @prime > 1.27 && @prime <= 1.28 then return 50
      elsif   @prime > 1.28 && @prime <= 1.29 then return 48
      elsif   @prime > 1.29 && @prime <= 1.3  then return 47
      elsif   @prime > 1.3  && @prime <= 1.31 then return 46
      elsif   @prime > 1.31 && @prime <= 1.32 then return 44
      elsif   @prime > 1.32 && @prime <= 1.33 then return 43
      elsif   @prime > 1.33 && @prime <= 1.34 then return 41
      elsif   @prime > 1.34 && @prime <= 1.35 then return 40
      elsif   @prime > 1.35 && @prime <= 1.36 then return 39
      elsif   @prime > 1.36 && @prime <= 1.37 then return 37
      elsif   @prime > 1.37 && @prime <= 1.38 then return 36
      elsif   @prime > 1.38 && @prime <= 1.39 then return 34
      elsif   @prime > 1.39 && @prime <= 1.4  then return 33
      elsif   @prime > 1.4  && @prime <= 1.41 then return 32
      elsif   @prime > 1.41 && @prime <= 1.42 then return 30
      elsif   @prime > 1.42 && @prime <= 1.43 then return 29
      elsif   @prime > 1.43 && @prime <= 1.44 then return 27
      elsif   @prime > 1.44 && @prime <= 1.45 then return 26
      elsif   @prime > 1.45 && @prime <= 1.46 then return 25
      elsif   @prime > 1.46 && @prime <= 1.47 then return 23
      elsif   @prime > 1.47 && @prime <= 1.48 then return 22
      elsif   @prime > 1.48 && @prime <= 1.49 then return 20
      elsif   @prime > 1.49 && @prime <= 1.5  then return 19
      elsif   @prime > 1.5  && @prime <= 1.51 then return 18
      elsif   @prime > 1.51 && @prime <= 1.52 then return 16
      elsif   @prime > 1.52 && @prime <= 1.53 then return 15
      elsif   @prime > 1.53 && @prime <= 1.54 then return 13
      elsif   @prime > 1.54 && @prime <= 1.55 then return 12
      elsif   @prime > 1.55 && @prime <= 1.56 then return 11
      elsif   @prime > 1.56 && @prime <= 1.57 then return 9
      elsif   @prime > 1.57 && @prime <= 1.58 then return 8
      elsif   @prime > 1.58 && @prime <= 1.59 then return 6
      elsif   @prime > 1.59 && @prime <= 1.6  then return 5
      elsif   @prime > 1.6  && @prime <= 4.0  then return 4
      end
    end
  end
end

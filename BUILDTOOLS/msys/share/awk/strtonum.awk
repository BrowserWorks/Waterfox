# strtonum --- convert string to number

#
# Arnold Robbins, arnold@skeeve.com, Public Domain
# February, 2004

function mystrtonum(str,        ret, chars, n, i, k, c)
{
    if (str ~ /^0[0-7]*$/) {
        # octal
        n = length(str)
        ret = 0
        for (i = 1; i <= n; i++) {
            c = substr(str, i, 1)
            if ((k = index("01234567", c)) > 0)
                k-- # adjust for 1-basing in awk

            ret = ret * 8 + k
        }
    } else if (str ~ /^0[xX][0-9a-fA-f]+/) {
        # hexadecimal
        str = substr(str, 3)    # lop off leading 0x
        n = length(str)
        ret = 0
        for (i = 1; i <= n; i++) {
            c = substr(str, i, 1)
            c = tolower(c)
            if ((k = index("0123456789", c)) > 0)
                k-- # adjust for 1-basing in awk
            else if ((k = index("abcdef", c)) > 0)
                k += 9

            ret = ret * 16 + k
        }
    } else if (str ~ /^[-+]?([0-9]+([.][0-9]*([Ee][0-9]+)?)?|([.][0-9]+([Ee][-+]?[0-9]+)?))$/) {
        # decimal number, possibly floating point
        ret = str + 0
    } else
        ret = "NOT-A-NUMBER"

    return ret
}

# BEGIN {     # gawk test harness
#     a[1] = "25"
#     a[2] = ".31"
#     a[3] = "0123"
#     a[4] = "0xdeadBEEF"
#     a[5] = "123.45"
#     a[6] = "1.e3"
#     a[7] = "1.32"
#     a[7] = "1.32E2"
# 
#     for (i = 1; i in a; i++)
#         print a[i], strtonum(a[i]), mystrtonum(a[i])
# }

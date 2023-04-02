
def getValue(obj, retKey):
    keys = retKey.split('/')
    for key in keys:
        obj = obj[key]
    return obj


# test 1 
# expected return "d"
print(getValue({"a":{"b":{"c":"d"}}},"a/b/c"))

# test 2
# expected return "a"
print(getValue({"x":{"y":{"z":"a"}}},"x/y/z"))
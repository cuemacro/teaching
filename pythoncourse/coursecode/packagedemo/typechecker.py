def print_is_a_float(x):
    if isinstance(x, float):
        print(str(x) + ' is a float')
    else:
        print(str(x) + ' is not a float')

def print_is_a_string(x):
    if isinstance(x, str):
        print(str(x) + ' is a str')
    else:
        print(str(x) + ' is not a str')
#$language = "Python"
#$interface = "1.0"


def Init(obj):
    global crt
    crt = obj
    return


def test():
    crt.Dialog.MessageBox("Hello World!")
    return "It was the best of times, it was the worst of times"

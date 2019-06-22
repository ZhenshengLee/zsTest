# $language = "Python"
# $interface = "1.0"

# reference: SecureCRT Help Topics


def main():
    zsSend("cd ./LiZhensheng")


def zsSend(cmd):
    crt.Screen.Send("%s\r\n" % (cmd))


main()

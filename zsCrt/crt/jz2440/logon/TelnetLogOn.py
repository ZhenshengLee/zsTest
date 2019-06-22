# $language = "Python"
# $interface = "1.0"

# reference: search secureCRT python
# reference: SecureCRT Help Topics


def main():
    zsShow("\n\n")
    if zsIsRowFind("none"):
        zsShowr("xxx")
        zsShowr("xxx")
        zsShowr("su")
        zsShowr("telnet 0 10000")
        zsShowr("xxx")
        zsShowr("xxx\n\n")
    else:
        zsSend("con t")


def zsSend(cmd):
    crt.Screen.Send(cmd + "\r\n")
    zsSendr()


def zsShow(output):
    crt.Screen.Send(output)


def zsSendr():
    crt.Screen.Send("\r")  # \n


def zsShowr(output):
    crt.Screen.Send(output)
    crt.Screen.Send("\r")


def zsGetRow():
    _crow = crt.Screen.CurrentRow
    _ccol = crt.Screen.CurrentColumn
    _zsstr = crt.Screen.Get(_crow, 1, _crow, _ccol)
    return _zsstr.strip()


def zsIsRowFind(flag):
    _zsstr = zsGetRow()
    _zsflag = _zsstr.find(str(flag))
    if _zsflag > -1:
        return True
    else:
        return False


def zsIsRow(flag):
    _zsstr = zsGetRow()
    return _zsstr == flag


main()

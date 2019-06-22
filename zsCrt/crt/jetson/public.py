#$language = "Python"
#$interface = "1.0"


def Init(obj):
    global crt
    crt = obj
    return

# ******************************************************************************
# ONLY USE ENGLISH IN THIS FILE, CHINESE CHAR LEADS TO ENCODING ISSUES
# ******************************************************************************


def zsBackspace():
    for x in range(20):
        zsShow("\b")


def zsTest(flag):
    if flag == True:
        zsShow("Good-Job~~")
    else:
        zsShow("Oh-No!!")


def zsTestDialog(flag):
    if flag == True:
        crt.Dialog.MessageBox("Good-Job~~", "OK", IDOK)
    else:
        crt.Dialog.MessageBox("Oh-No!!", "NO", IDOK)


def zsTestDialog():
        crt.Dialog.MessageBox("Good-Job~~", "OK")

def zsDialog(msg):
    if msg == "":
        crt.Dialog.MessageBox("Oh-No!!", "NO", IDOK)
    else:
        crt.Dialog.MessageBox(msg, "OK", IDOK)


def zsSleep():
    crt.Sleep(100)


def zsSleepl():
    crt.Sleep(500)


def zsWait():
    crt.Sleep(2000)


def zsSend(cmd):
    crt.Screen.Send(cmd + "\r\n")
    zsSleep()
    zsSendr()


def zsShow(output):
    crt.Screen.Send(output)


def zsSendr():
    zsBackspace()
    crt.Screen.Send("\r")  # \n
    zsSleep()


def zsShowr(output):
    crt.Screen.Send(output)
    crt.Screen.Send("\r")


def zsGetRow():
    _crow = crt.Screen.CurrentRow
    _ccol = crt.Screen.CurrentColumn
    _zsstr = crt.Screen.Get(_crow, 1, _crow, _ccol)
    return _zsstr.strip()


def zsGetRowUp(num):
    _crow = crt.Screen.CurrentRow
    _ccol = crt.Screen.CurrentColumn
    _zsstr = crt.Screen.Get(_crow-num, 1, _crow-num, 50)
    return _zsstr.strip()


def zsIsUpRowFind(num, flag):
    _zsstr = zsGetRowUp(num)
    _zsflag = _zsstr.find(str(flag))
    if _zsflag > -1:
        return True
    else:
        return False


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

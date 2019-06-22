# $language = "Python"
# $interface = "1.0"

import SecureCRT
import sys
import os
import getopt

varPath = os.path.dirname(__file__)
if varPath not in sys.path:
    sys.path.insert(0, varPath)

import crt.test as tst
import crt.jetson.common as jetsoncmn
import crt.jetson.public as jetsonpub
import crt.jz2440.crt as jz2440crt

# ******************************************************************************
# DEFINITIONS
# ******************************************************************************
module_list_jetson = [tst, jetsoncmn, jetsonpub]
module_list_jz2440 = [jz2440crt]
device_list = ["jetson", "jz2440"]
DEFAULT_DEV = "jetson"

for module in module_list_jetson:
    reload(module)
    module.Init(crt)


for module in module_list_jz2440:
    reload(module)
    module.Init(crt)


def runcmd(cmd, dev_type):
    if dev_type not in device_list:
        crt.Dialog.MessageBox(
            "Invalid Device Type!")
        return
    else:
        eval(dev_type+cmd+"()")
        return


def main():
    dev_type = ''
    cmd = ''
    if crt.Arguments.Count not in [1, 2]:
        crt.Dialog.MessageBox(
            "Please input: command, device = jz2440")
        return
    elif crt.Arguments.Count in [1]:
        dev_type = DEFAULT_DEV
    elif crt.Arguments.Count in [2]:
        dev_type = crt.Arguments[1]
    cmd = crt.Arguments[0]
    runcmd(cmd, dev_type)
    # If you want to TEST
    strOut = tst.test()
    crt.Dialog.MessageBox(strOut)
    return


main()

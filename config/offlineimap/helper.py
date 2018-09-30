#!/usr/bin/env python3

import subprocess


def get_pass(account):
    return str(
        subprocess.check_output(
            ['pass', 'mail-{}/mail'.format(account)]
        ).split()[1]
    )


def get_user(account):
    return str(
        subprocess.check_output(
            ['pass', 'mail-{}/mail'.format(account)]
        ).split()[3]
    )

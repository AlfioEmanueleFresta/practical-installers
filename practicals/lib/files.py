import sys
import os
import subprocess


def run_cmd(command, verbose=False, return_output=False):
    print("$ %s" % ' '.join(command))
    proc = subprocess.Popen(command, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    output = ''
    for line in proc.stdout:
        line = line.decode('ascii')
        output += line
        if verbose:
            sys.stdout.write("  %s" % line)
            sys.stdout.flush()
    out, err = proc.communicate()
    if err:
        sys.stdout.write(err.decode('ascii'))
    if return_output:
        return output


def file_copy(src_filename, dst_filename):
    run_cmd(["cp", src_filename, dst_filename])


def file_write(filename, contents):
    with open(filename, "w") as f:
        f.write(contents)


def file_append(filename, contents):
    with open(filename, "a") as f:
        f.write(contents)


def file_read(filename):
    with open(filename, "r") as f:
        x = f.read()
    return x


def file_delete(filename):
    run_cmd(["rm", filename])


def get_tmp_dir():
    return run_cmd(['mktemp', '-d'], return_output=True).strip()


def get_current_user():
    return run_cmd(['whoami'], return_output=True).strip()


def chmod(mode, filename):
    return run_cmd(["chmod", mode, filename])

#!/usr/bin/env python3
import hashlib
import socket
import struct
import subprocess


def generate_iou_license():
    try:
        hostid_str = (
            subprocess.check_output(["hostid"]).decode("utf-8").strip()
        )
        ioukey = int(hostid_str, 16)
    except Exception:
        ioukey = 0

    hostname = socket.gethostname()

    for char in hostname:
        ioukey += ord(char)

    iou_pad1 = (
        b"\x4B\x58\x21\x81\x56\x7B\x0D\xF3\x21\x43\x9B\x7E\xAC\x1D\xE6\x8A"
    )
    iou_pad2 = b"\x80" + 39 * b"\0"

    md5_input = (
        iou_pad1
        + iou_pad2
        + struct.pack("!I", ioukey & 0xFFFFFFFF)
        + iou_pad1
    )
    iou_license = hashlib.md5(md5_input).hexdigest()[:16]

    print("[license]")
    print(f"{hostname} = {iou_license};")


if __name__ == "__main__":
    generate_iou_license()
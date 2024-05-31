#! /vendor/bin/sh

stty -F /dev/ttyS0 115200 -crtscts echo ixon opost icanon icrnl isig iexten

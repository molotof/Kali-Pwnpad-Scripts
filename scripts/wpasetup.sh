#!/bin/bash
su
bootkali
service dbus restart
service wicd restart
wicd-curses
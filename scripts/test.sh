#!/usr/bin/env bash

xcodebuild clean build test -scheme 'PDNetworking' -destination OS=7.1,name='iPhone Retina (4-inch 64-bit)'

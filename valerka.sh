#!/bin/bash

set +x

VALERKA_PATH=${VALERKA_PATH:-/usr/local/etc/valerka/}
    # Auto check valerka update on every execute
    make --no-print-directory -f $VALERKA_PATH/Makefile "check-update"

    make --no-print-directory -f $VALERKA_PATH/Makefile "$@"

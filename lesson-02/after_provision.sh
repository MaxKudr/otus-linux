#!/usr/bin/env bash

/usr/bin/vagrant halt

/usr/bin/vboxmanage storageattach lesson-02 --storagectl 'IDE' --port 0 --device 0 --medium none 2>/dev/null

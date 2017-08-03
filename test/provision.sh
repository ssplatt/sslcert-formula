#!/bin/bash
# create the machines and place initial state on them
kitchen converge

# create the CA on the salt master
kitchen exec -c "sudo salt \* state.highstate"

# sync the CA cert to the minion
kitchen exec -c "sudo salt \* state.highstate"

# create the certificate on the minion
kitchen exec -c "sudo salt \* state.highstate"

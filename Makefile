# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build
test   :; forge test -f ${RPC_URL} --fork-block-number ${BLOCK_NUMBER} -vv
trace   :; forge test -vvv
clean  :; forge clean
snapshot :; forge snapshot
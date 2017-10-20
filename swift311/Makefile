# ------------------------------------------------------------------------------
# Variables
# NAMESPACE is your OpenWhisk namespace. Default to last item in `wsk namespace list`
NAMESPACE = $(shell wsk namespace list | tail -n1)
PACKAGE = WG
# set kind to swift:3.1.1 or swift:3
KIND = swift:3.1.1
BUILD_FLAGS = -v
# You can set it to wsk
WSK_CLI = bx wsk

# ------------------------------------------------------------------------------
# Default target: update all actions into OpenWhisk if swift file changes
.PHONY: update
update: build/WeatherBot.zip
# ------------------------------------------------------------------------------
# Build targets

# build weather bot service
build/WeatherBot.zip: actions/WeatherBot/Sources/main.swift
	cat actions/WeatherBot/Sources/main.swift > build/main.swift
	./compile.sh WeatherBot $(KIND) $(BUILD_FLAGS)
	$(WSK_CLI) action update $(PACKAGE)/WeatherBot build/WeatherBot.zip --kind $(KIND) \
		--timeout 7000 --memory 128 \
		--annotation description 'Weather Bot' \
		--annotation final true --annotation web-export true

# ------------------------------------------------------------------------------
# Run targets
#.PHONY: 

# ------------------------------------------------------------------------------
# Misc targets
.PHONY: lastlog setup clean

lastlog:
	$(WSK_CLI) activation list -l1 | tail -n1 | cut -d ' ' -f1 | xargs $(WSK_CLI) activation logs

setup:
	# Create package
	$(WSK_CLI) package update $(PACKAGE) --param-file parameters.json

test:
	$(WSK_CLI) action invoke $(PACKAGE)/WeatherBot -b

list:
	$(WSK_CLI) package get $(PACKAGE)

clean:
	rm -rf build/*.swift
	rm -rf build/*.zip
	rm -rf build/*.js

default: runEmu

launch:
	flutter emulators --launch Pixel

runEmu:
	flutter run --device-id emulator-5554

.PHONY: default launch runEmu

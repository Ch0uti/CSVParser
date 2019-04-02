bootstrap:
	git submodule update --init --recursive

# Build.
build:
	@swift package update
	@swift build

# Run tests.
test:
	@swift test

# Generate Xcode project and open it.
xcode:
	@osascript -e "tell app \"iPhone Simulator\" to quit"
	@osascript -e "tell app \"Xcode\" to quit"
	@swift package generate-xcodeproj --enable-code-coverage
	@open ./*.xcodeproj

# Run swiftformat.
format:
	@swift run swiftformat . # SPM

# Cleanup.
clean:
	@swift package clean
	@rm -rf .build
	@rm -f ./Package.resolved

# Open Kanban.
kanban:
	@open https://github.com/Ch0uti/Swift-Project-Template/projects

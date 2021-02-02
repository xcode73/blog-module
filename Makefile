CUR_DIR = $(CURDIR)

run:
	swift run Feather

env:
	echo 'BASE_URL="http://0.0.0.0:8080"' > .env.development
	echo 'BASE_PATH="$(CUR_DIR)/"' >> .env.development
	
env.testing:
	echo 'BASE_URL="http://0.0.0.0:8080"' > .env.testing
	echo 'BASE_PATH="$(CUR_DIR)/"' >> .env.testing
	
clean:
	rm -rf ./db.sqlite ./Resources/ ./Public/

test:
	swift test --enable-test-discovery

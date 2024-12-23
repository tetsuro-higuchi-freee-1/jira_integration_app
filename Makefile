bootstrap:
	git submodule update --init
	cp .env.example .env
	asdf install
	bundle install
	npm install --prefix front

build_and_launch:
	VITE_BUILD_OUTDIR=../public npm run build --prefix front
	bin/rails s

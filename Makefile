FILE = resume

.PHONY: build dev validate clean doctor docker-build

build: validate
	pnpm yamlresume build $(FILE).yml
	mkdir -p dist
	mv -f $(FILE).pdf dist/ 2>/dev/null || true
	mv -f $(FILE).tex dist/ 2>/dev/null || true
	mv -f $(FILE).md dist/ 2>/dev/null || true
	mv -f $(FILE).html dist/ 2>/dev/null || true
	rm -f $(FILE).aux $(FILE).log $(FILE).out

dev:
	pnpm yamlresume dev $(FILE).yml

validate:
	pnpm yamlresume validate $(FILE).yml

clean:
	rm -rf dist
	rm -f $(FILE).pdf $(FILE).tex $(FILE).md $(FILE).html
	rm -f $(FILE).aux $(FILE).log $(FILE).out

doctor:
	pnpm yamlresume doctor

docker-build:
	docker run --rm -v "$$(pwd)":/home/yamlresume yamlresume/yamlresume build $(FILE).yml
	mkdir -p dist
	mv -f $(FILE).pdf dist/ 2>/dev/null || true
	mv -f $(FILE).tex dist/ 2>/dev/null || true
	mv -f $(FILE).md dist/ 2>/dev/null || true
	mv -f $(FILE).html dist/ 2>/dev/null || true
	rm -f $(FILE).aux $(FILE).log $(FILE).out

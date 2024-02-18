all:
	love ./

images:
	aseprite -b assets/box.aseprite --save-as assets/box.png
	aseprite -b assets/exit.aseprite --save-as assets/exit.png
	aseprite -b assets/player.aseprite --save-as assets/player.png


serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/2024-winter-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2024-winter-game-jam/"
	python3 -m http.server

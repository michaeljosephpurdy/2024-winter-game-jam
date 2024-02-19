all:
	love ./

images:
	aseprite -b assets/box.aseprite --save-as assets/box.png
	aseprite -b assets/exit.aseprite --save-as assets/exit.png
	aseprite -b assets/player.aseprite --save-as assets/player.png
	aseprite -b assets/altar.aseprite --save-as assets/altar.png
	aseprite -b assets/target.aseprite --save-as assets/target.png
	aseprite -b --layer "alive" assets/cow.aseprite --save-as assets/cow-alive.png
	aseprite -b --layer "dead" assets/cow.aseprite --save-as assets/cow-dead.png
	aseprite -b --layer "inactive" assets/enter.aseprite --save-as assets/enter-inactive.png
	aseprite -b --layer "active" assets/enter.aseprite --save-as assets/enter-active.png
	aseprite -b --layer "completed" assets/enter.aseprite --save-as assets/enter-completed.png
	aseprite -b --layer "open" assets/fence.aseprite --save-as assets/fence-open.png
	aseprite -b --layer "closed" assets/fence.aseprite --save-as assets/fence-closed.png


serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/2024-winter-game-jam-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/2024-winter-game-jam/"
	python3 -m http.server

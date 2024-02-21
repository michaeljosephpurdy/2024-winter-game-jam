all:
	love ./

images:
	aseprite -b assets/box.aseprite --save-as assets/box.png
	aseprite -b assets/exit.aseprite --save-as assets/exit.png
	aseprite -b assets/altar.aseprite --save-as assets/altar.png
	aseprite -b assets/target.aseprite --save-as assets/target.png
	aseprite -b --layer "kill" assets/spotlight.aseprite --save-as assets/spotlight-kill.png
	aseprite -b --layer "dead" assets/spotlight.aseprite --save-as assets/spotlight-dead.png
	aseprite -b --layer "atone" assets/spotlight.aseprite --save-as assets/spotlight-atone.png
	aseprite -b --layer "passable" assets/rock.aseprite --save-as assets/rock-passable.png
	aseprite -b --layer "movable" assets/rock.aseprite --save-as assets/rock-movable.png
	aseprite -b --layer "alive" assets/animal.aseprite --save-as assets/animal-alive.png
	aseprite -b --layer "dead" assets/animal.aseprite --save-as assets/animal-dead.png
	aseprite -b --layer "alive" assets/player.aseprite --save-as assets/player-alive.png
	aseprite -b --layer "dead" assets/player.aseprite --save-as assets/player-dead.png
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

# Automatically launch MangoWM on TTY1
if status is-login
	and test "$XDG_VTNR" = 1
	and test -z "$WAYLAND_DISPLAY"

	exec mango
end

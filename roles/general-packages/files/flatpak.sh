# /etc/profile.d/flatpak.sh - set XDG_DATA_DIRS

flatpak_dirs=$HOME/.local/share/flatpak/exports/share/:/var/lib/flatpak/exports/share/

if [ -z "${XDG_DATA_DIRS}" ]; then
    XDG_DATA_DIRS="$flatpak_dirs:/usr/local/share/:/usr/share/"
else
    XDG_DATA_DIRS="$XDG_DATA_DIRS:$flatpak_dirs"
fi

export XDG_DATA_DIRS

#!/usr/bin/env bash
set -e
for file in "$@"; do
	# Ignore les fichiers dans un dossier vault à tous les niveaux
	if [[ $file =~ /vault/ ]]; then
		echo "Ignoré: $file (dans un dossier vault)"
		continue
	fi

	if [[ $file =~ \.ya?ml$ ]]; then
		# Vérifie si le premier non-commentaire commence par ---
		if ! grep -vE '^\s*#' "$file" | head -n 1 | grep -q '^---'; then
			echo "Ajout de '---' au début de $file"
			sed -i '1i---' "$file"
		fi
	fi
done

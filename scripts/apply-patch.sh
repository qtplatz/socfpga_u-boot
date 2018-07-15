#!/bin/bash

for file in "${@:1}"; do

	if [ ! -f "$file" ]; then
		echo "## requested command 'patch -p1 < "$file"'"
		echo "file "$file" not exist"
		exit 1
	fi

	if ! patch -R -p1 -s -f --dry-run < "$file"; then
		echo "## Patch $file is being applied...."
		patch -p1 < "$file"
	else
		echo "## Patch $file is alrady applied, skip"		
	fi	

done


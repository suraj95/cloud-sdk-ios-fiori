#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2020 SAP SE or an SAP affiliate company and cloud-sdk-ios-fiori contributors
# SPDX-License-Identifier: Apache-2.0

set -eu

# install various git hooks
bash scripts/installGitHooks.sh

# generate xcoce project file
rm -f -r ./FioriSwiftUI.xcodeproj
swift package generate-xcodeproj

# clone/update snapshot reference images
 if [ -d "./Apps/Examples/cloud-sdk-ios-fiori-snapshot-references" ]
 then
     bash scripts/snapshottesting/removeImages.sh
     bash scripts/snapshottesting/cloneImages.sh
 else
     bash scripts/snapshottesting/cloneImages.sh
 fi

# add run script to xcode project file (if python 3.7+ is available)
if ! hash python; then
    echo "WARNING: no run script was added to Xcode project file to execute SwiftLint check because python version of 3.7+ required"
    exit 0
fi

ver=$(python -V 2>&1 | sed 's/.* \([0-9]\).\([0-9]\).*/\1\2/')
if [ "$ver" -lt "37" ]; then
    echo "WARNING: no run script was added to Xcode project file to execute SwiftLint check because python version of 3.7+ required"
    exit 0
fi
python scripts/addSwiftLintRunScriptToXcodeProj.py

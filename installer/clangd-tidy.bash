#!/bin/bash

set -euo pipefail

pipx install clangd-tidy
pipx inject clangd-tidy tqdm

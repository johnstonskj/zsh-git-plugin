# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# Plugin Name: git
# Repository: https://github.com/johnstonskj/zsh-git-plugin
#
# Description:
#
#   Zsh plugin to set the correct path for Git installed via Homebrew.

# Public variables:
#
# * `GIT`; plugin-defined global associative array with the following keys:
#   * \`_FUNCTIONS\`; a list of all functions defined by the plugin.
#   * \`_PLUGIN_DIR\`; the directory the plugin is sourced from.
#

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA GIT
GIT[_PLUGIN_DIR]="${0:h}"
GIT[_FUNCTIONS]=""

# Set the path for any custom directories here.
GIT[_PATH]="$(homebrew_formula_prefix git)/bin"

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `GIT[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
# See https://wiki.zshell.dev/community/zsh_plugin_standard#the-proposed-function-name-prefixes
#
.git_remember_fn() {
    builtin emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${GIT[_FUNCTIONS]}" ]]; then
        GIT[_FUNCTIONS]="${fn_name}"
    elif [[ ",${GIT[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        GIT[_FUNCTIONS]="${GIT[_FUNCTIONS]},${fn_name}"
    fi
}
.git_remember_fn .git_remember_fn

#
# This function does the initialization of variables in the global variable
# `GIT`. It also adds to `path` and `fpath` as necessary.
#
git_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    path+=( "${GIT[_PATH]}" )
}
.git_remember_fn git_plugin_init

############################################################################
# Plugin Unload Function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
git_plugin_unload() {
    builtin emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${GIT[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done

    path=( "${(@)path:#${GIT[_PATH]}}" )

    # Remove the global data variable.
    unset GIT

    # Remove this function.
    unfunction git_plugin_unload
}

############################################################################
# Initialize Plugin
############################################################################

git_plugin_init

true

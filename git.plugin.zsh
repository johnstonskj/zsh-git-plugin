# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name git
# @brief Zsh plugin to set the correct path for Git installed via Homebrew.
# @repository https://github.com/johnstonskj/zsh-git-plugin
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

git_plugin_init() {
    builtin emulate -L zsh

    @zplugins_add_to_path git "$(homebrew_formula_prefix git)/bin"
}
